#1. Introduction

Problem statement (chronic disease burden, cost, preventable complications)

Objective of the project (early prediction + care management platform)

Target outcomes (reduce complications, prevent ER visits, improve affordability)

2. Literature Review

Techniques used historically (rule-based, SVM, Decision Trees, etc.)

Challenges in existing studies (imbalanced data, non-standardized datasets, signal noise, etc.)

Existing apps (mySugr, Glooko, Heart CV) + their limitations

3. Proposed System

Early Risk Prediction (ML models, multi-label prediction)

Personalized Self-Care Plans (tiered: low, medium, high)

Care Team Dashboard (doctor, nurse, paramedical staff coordination)

Localization and affordability focus

Wearable data simulation for vitals tracking

4. Datasets

Pima Indians Diabetes

UCI Heart Disease

CDC BRFSS

Fitbit-style simulated wearable data

Final dataset: ~6400 rows, 27 features grouped by demographics, vitals, labs, lifestyle, genetic risk, outcomes

5. Methodology

Data preprocessing (cleaning, encoding, balancing, normalization)

Feature selection (Random Forest feature importance + clinical validation)

Final feature set (27 features grouped by categories)

6. Exploratory Data Analysis (EDA)

Scatter plots (blood pressure vs hypertension)

Violin plots (cholesterol vs heart disease)

Heatmap (feature correlations)

Insights (alignment with medical knowledge)

7. Model Development & Evaluation
7.1 Models Tried

MLP (multi-output classifier)

Random Forest (multi-output)

LightGBM

XGBoost (multi-label)

CatBoost (multi-model setup)

7.2 Results & Comparison

Per-disease precision/recall/F1/AUC

Subset accuracy & Hamming loss

CatBoost emerged as most balanced & interpretable

7.3 Explainability

SHAP values for feature importance (per-disease insights)

8. Care Plan Recommendation Engine

Knowledge base creation (medical guideline PDF → chunking → embeddings → FAISS index)

RAG pipeline with LangChain + LLaMA3 (Ollama)

Risk-aware personalized care plan generation (diet, lifestyle, medication adherence, monitoring, red flags)

Output: API response + formatted PDF report

9. ER Visit Risk Prediction (NHANES Dataset)

Dataset & preprocessing (imputation, outlier handling, class imbalance)

CatBoost model (parameters, early stopping, class weights)

Evaluation (confusion matrix, classification report)

SHAP explainability (force plot + summary plot interpretation)

10. Dashboard & Visualization

Doctor’s weekly monitoring dashboard

Summary vitals (age, BMI, HbA1c, BP, heart rate)

Trend charts (glucose, BP, HR, cholesterol)

Alerts for abnormal patterns (e.g., rising BP/glucose)

11. Technology Stack

Python (preprocessing, ML pipeline)

CatBoost, XGBoost, LightGBM, Random Forest, SHAP

LangChain + FAISS + Ollama (LLaMA3) for care plan generation

Firebase (data storage)

HTML/CSS/JS + Flutter (frontend)

Power BI (visualizations)

12. Conclusion & Future Work

Current achievements (multi-label risk prediction, explainability, personalized care plans, dashboards)

Impact (reduce complications, lower ER visits, support doctors)

Limitations (dataset size, real-world integration challenges, cost of wearables)

Future directions:



Integration with real wearable APIs (Fitbit, Apple Health)

Larger and standardized clinical datasets

Clinical trials for validation
