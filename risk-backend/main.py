import os
from pathlib import Path
from typing import Dict, Any, Optional, List
from datetime import datetime

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel, Field
import joblib
import numpy as np
import pandas as pd
from catboost import Pool
from fastapi import Request

from langchain_community.document_loaders import PyPDFLoader
from langchain_community.vectorstores import FAISS
from langchain_community.embeddings import HuggingFaceEmbeddings
from langchain_community.llms import Ollama
from reportlab.lib.pagesizes import A4
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle
from reportlab.lib.styles import getSampleStyleSheet
from reportlab.lib import colors

BASE_DIR = Path(__file__).parent.resolve()

DIABETES_MODEL_PATH = Path(os.getenv("DIABETES_MODEL_PATH", BASE_DIR / "models/catboost_diabetes_status.joblib"))
HEART_MODEL_PATH    = Path(os.getenv("HEART_MODEL_PATH",    BASE_DIR / "models/catboost_heart_disease.joblib"))
HYPERT_MODEL_PATH   = Path(os.getenv("HYPERT_MODEL_PATH",   BASE_DIR / "models/catboost_hypertension_status.joblib"))

PDF_FILE_PATH       = Path(os.getenv("PDF_FILE_PATH",       BASE_DIR / "data/final-database.pdf"))
FAISS_INDEX_DIR     = Path(os.getenv("FAISS_INDEX_DIR",     BASE_DIR / "faiss_index"))
REPORTS_DIR         = Path(os.getenv("REPORTS_DIR",         BASE_DIR / "reports"))

EMBED_MODEL         = os.getenv("EMBED_MODEL", "sentence-transformers/all-mpnet-base-v2")
OLLAMA_MODEL        = os.getenv("OLLAMA_MODEL", "llama3.1")

REPORTS_DIR.mkdir(parents=True, exist_ok=True)
app = FastAPI(title="Risk & Care Plan API", version="1.0")
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.mount("/reports", StaticFiles(directory=str(REPORTS_DIR)), name="reports")
def _device():
    try:
        import torch
        return "cuda" if torch.cuda.is_available() else "cpu"
    except Exception:
        return "cpu"

DEVICE = _device()

try:
    clf_diabetes = joblib.load(DIABETES_MODEL_PATH)
    clf_heart    = joblib.load(HEART_MODEL_PATH)
    clf_hyper    = joblib.load(HYPERT_MODEL_PATH)
except Exception as e:
    raise RuntimeError(f"Failed to load CatBoost models: {e}")

emb = HuggingFaceEmbeddings(model_name=EMBED_MODEL, model_kwargs={"device": DEVICE})

def _load_or_build_vectorstore():
    if FAISS_INDEX_DIR.exists() and any(FAISS_INDEX_DIR.iterdir()):
        return FAISS.load_local(FAISS_INDEX_DIR.as_posix(), emb, allow_dangerous_deserialization=True)
    if not PDF_FILE_PATH.exists():
        raise RuntimeError(f"Knowledge PDF not found: {PDF_FILE_PATH}")
    loader = PyPDFLoader(str(PDF_FILE_PATH))
    docs = loader.load()
    if not docs:
        raise RuntimeError("No documents loaded from PDF.")
    vs = FAISS.from_documents(docs, embedding=emb)
    vs.save_local(FAISS_INDEX_DIR.as_posix())
    return vs

vectorstore = _load_or_build_vectorstore()
retriever = vectorstore.as_retriever(search_type="similarity", search_kwargs={"k": 6})

llm = Ollama(
    model="llama3",
    base_url="http://127.0.0.1:11434"
)
FEATURE_NAMES: List[str] = [
    'age','gender','systolic','diastolic','blood_pressure','cholesterol','bmi','glucose','HbA1c',
    'insulin','heart_rate','smoking','alcohol','family_history','physical_activity','sodium_intake','fruit',
    'veggies','stroke','fasting_blood_sugar','diabetes_pedigree','poor_health_days','max_heart_rate'
]
CATEGORICAL_FEATURES: List[str] = [
    'gender','smoking','alcohol','family_history','physical_activity','fruit','veggies',
    'stroke','sodium_intake','fasting_blood_sugar'
]

def prob_to_risk(prob: float):
    if prob >= 0.80:
        return "VERY HIGH", "80-100% (very high risk)"
    elif prob >= 0.60:
        return "HIGH", "60-80% (high risk)"
    elif prob >= 0.30:
        return "MEDIUM", "30-60% (medium risk)"
    else:
        return "LOW", "0-30% (low risk)"

def make_pool_from_patient(patient_record: Dict[str, Any]):
    features = {k: v for k, v in patient_record.items() if k in FEATURE_NAMES}
    missing = [f for f in FEATURE_NAMES if f not in features]
    if missing:
        raise ValueError(f"Missing features: {missing}")
    X = pd.DataFrame([features], columns=FEATURE_NAMES)
    for c in CATEGORICAL_FEATURES:
        if c in X:
            if pd.api.types.is_numeric_dtype(X[c]):
                X[c] = X[c].astype("Int64").astype(str)
            else:
                X[c] = X[c].astype(str)

    return Pool(X, cat_features=CATEGORICAL_FEATURES)

def predict_all_risks(patient_record: Dict[str, Any]) -> Dict[str, Any]:
    pool = make_pool_from_patient(patient_record)
    p_dia   = float(clf_diabetes.predict_proba(pool)[:, 1][0])
    p_heart = float(clf_heart.predict_proba(pool)[:, 1][0])
    p_hyper = float(clf_hyper.predict_proba(pool)[:, 1][0])

    lab_dia,   desc_dia   = prob_to_risk(p_dia)
    lab_heart, desc_heart = prob_to_risk(p_heart)
    lab_hyper, desc_hyper = prob_to_risk(p_hyper)

    return {
        "diabetes_status": {
            "probability": p_dia, "risk_label": lab_dia, "risk_description": desc_dia
        },
        "heart_disease": {
            "probability": p_heart, "risk_label": lab_heart, "risk_description": desc_heart
        },
        "hypertension_status": {
            "probability": p_hyper, "risk_label": lab_hyper, "risk_description": desc_hyper
        },
    }

def get_kb_snippets(retriever, patient_text: str = "", k: int = 6) -> str:
    query = "diabetes, heart disease, hypertension prevention and care. " + (patient_text or "")
    docs = retriever.get_relevant_documents(query)[:k]
    snippets = []
    for d in docs:
        txt = (d.page_content or "").strip().replace("\n"," ")
        snippets.append(txt[:500])
    return "\n\n".join(f"- {s}" for s in snippets)

BASE_PROMPT = """You are a healthcare assistant for chronic disease management and regular patient monitoring.
CRITICAL INSTRUCTIONS (follow strictly):
- You MUST USE ONLY the information contained in the CONTEXT section below to generate your answer.
- Do NOT use any external knowledge, web search, or assumptions.
- If the context does not contain evidence needed to answer a sub-item, explicitly say that evidence was not found in the provided documents and avoid making up facts.
- Keep it clear, concise, evidence-grounded, and non-judgmental.
- Do NOT provide prescriptions or dosage instructions.
- Length target: 500–800 words.

Include these sections:
1) Model predictions (risk summary for each condition)
2) Care plan (disease management, monitoring, and prevention)
   - Diabetes: blood glucose monitoring, HbA1c checks, diet, exercise, lifestyle
   - Heart disease: BP monitoring, cholesterol management, diet, exercise
   - Hypertension: BP monitoring, lifestyle changes, diet
3) Diet recommendations (breakfast / lunch / dinner / snacks)
4) Exercise suggestions (frequency + intensity)
5) Monitoring & tests
6) Red flags requiring urgent medical attention
7) General health plan (lifestyle, habits)

ADAPT TO RISK LEVELS:
- LOW: general care plan, exercise, diet, health plan
- MEDIUM/HIGH: care plans and suggest contacting paramedical support where appropriate (only if present in CONTEXT)
- VERY HIGH: clearly alert to consult a doctor immediately and provide emergency care plans supported by the CONTEXT.

CONTEXT (Supporting documents - brief snippets):
{kb_snippets}

Now produce the personalized plan in bullet sections.
"""

def format_risk_summary(preds: Dict[str, Any]) -> str:
    return (
        f"- diabetes_status: {preds['diabetes_status']['risk_label']} "
        f"(prob={preds['diabetes_status']['probability']:.3f}) -- {preds['diabetes_status']['risk_description']}\n"
        f"- heart_disease: {preds['heart_disease']['risk_label']} "
        f"(prob={preds['heart_disease']['probability']:.3f}) -- {preds['heart_disease']['risk_description']}\n"
        f"- hypertension_status: {preds['hypertension_status']['risk_label']} "
        f"(prob={preds['hypertension_status']['probability']:.3f}) -- {preds['hypertension_status']['risk_description']}"
    )

def generate_care_plan_from_model(preds: Dict[str, Any]) -> str:
    risk_summary = format_risk_summary(preds)
    kb_snippets = get_kb_snippets(retriever, patient_text=risk_summary, k=6)
    prompt = BASE_PROMPT.format(kb_snippets=kb_snippets)
    response = llm.invoke(prompt)
    return response if isinstance(response, str) else getattr(response, "content", str(response))

def save_care_plan_pdf(patient_name: str, patient_id: Any, care_plan_text: str, out_dir: Path) -> Path:
    ts = datetime.now().strftime("%Y%m%d_%H%M%S")
    fn = out_dir / f"care_plan_{patient_id}_{ts}.pdf"

    styles = getSampleStyleSheet()
    doc = SimpleDocTemplate(str(fn), pagesize=A4)
    elements = []

    elements.append(Paragraph("PERSONALISED CARE PLAN", styles['Title']))
    elements.append(Spacer(1, 12))

    patient_table = Table([
        ["Name:", patient_name or "N/A", "Patient ID:", str(patient_id)],
        ["DOB:", "................", "Hosp No:", "................"],
        ["NHS No:", "................", "", ""]
    ], colWidths=[60, 180, 80, 180])
    patient_table.setStyle(TableStyle([
        ('GRID', (0,0), (-1,-1), 0.5, colors.black),
        ('BACKGROUND', (0,0), (-1,0), colors.whitesmoke)
    ]))
    elements.append(patient_table)
    elements.append(Spacer(1, 16))

    elements.append(Paragraph("Generated Care Plan", styles['Heading2']))
    elements.append(Spacer(1, 8))
    elements.append(Paragraph(care_plan_text.replace("\n", "<br/>"), styles['Normal']))

    doc.build(elements)
    return fn

class PatientRecord(BaseModel):
    patient_id: int | str
    name: Optional[str] = None
    age: int
    gender: int  
    systolic: float
    diastolic: float
    blood_pressure: float
    cholesterol: float
    bmi: float
    glucose: float
    HbA1c: float
    insulin: float
    heart_rate: float
    smoking: int
    alcohol: int
    family_history: int
    physical_activity: int
    sodium_intake: int
    fruit: int
    veggies: int
    stroke: int
    fasting_blood_sugar: int
    diabetes_pedigree: float
    poor_health_days: int
    max_heart_rate: int

class PredictResponse(BaseModel):
    predictions: Dict[str, Any]
    care_plan: str
    pdf_url: str

@app.post("/predict", response_model=PredictResponse)
async def predict(record: PatientRecord, request: Request):
    try:
        pr = record.model_dump()
        preds = predict_all_risks(pr)
        care_plan = generate_care_plan_from_model(preds)
        pdf_path = save_care_plan_pdf(
            record.name or "Patient", record.patient_id, care_plan, REPORTS_DIR
        )

        base_url = str(request.base_url).rstrip("/")
        pdf_url = f"{base_url}/reports/{pdf_path.name}"

        return PredictResponse(
            predictions=preds,
            care_plan=care_plan,
            pdf_url=pdf_url
        )
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))
@app.get("/")
def root():
    return {"ok": True, "message": "Risk & Care Plan API", "reports": "/reports/"}
