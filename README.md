<h2>1. Introduction</h2>

Problem statement (chronic disease burden, cost, preventable complications)

Objective of the project (early prediction + care management platform)

Target outcomes (reduce complications, prevent ER visits, improve affordability)

<h2>2. Literature Review</h2>

Techniques used historically (rule-based, SVM, Decision Trees, etc.)

Challenges in existing studies (imbalanced data, non-standardized datasets, signal noise, etc.)

Existing apps (mySugr, Glooko, Heart CV) + their limitations

<h2>3. Proposed System</h2>

Early Risk Prediction (ML models, multi-label prediction)

Personalized Self-Care Plans (tiered: low, medium, high)

Care Team Dashboard (doctor, nurse, paramedical staff coordination)

Localization and affordability focus

Wearable data simulation for vitals tracking

<h2>4. Datasets</h2>

Pima Indians Diabetes

UCI Heart Disease

CDC BRFSS

Fitbit-style simulated wearable data

Final dataset: ~6400 rows, 27 features grouped by demographics, vitals, labs, lifestyle, genetic risk, outcomes

<h2>5. Methodology</h2>

Data preprocessing (cleaning, encoding, balancing, normalization)

Feature selection (Random Forest feature importance + clinical validation)

Final feature set (27 features grouped by categories)

<h2>6. Exploratory Data Analysis (EDA)</h2>

Scatter plots (blood pressure vs hypertension)

Violin plots (cholesterol vs heart disease)

Heatmap (feature correlations)

Insights (alignment with medical knowledge)

<h2>7. Model Development & Evaluation</h2>
<h3>7.1 Models Tried</h3>

1.MLP (multi-output classifier)

2.Random Forest (multi-output)

3.LightGBM

4.XGBoost (multi-label)

5.CatBoost (multi-model setup)

<h3>7.2 Results & Comparison</h3>

Per-disease precision/recall/F1/AUC

Subset accuracy & Hamming loss

CatBoost emerged as most balanced & interpretable

<h3>7.3 Explainability</h3>

SHAP values for feature importance (per-disease insights)

<h2>8. Care Plan Recommendation Engine</h2>

Knowledge base creation (medical guideline PDF → chunking → embeddings → FAISS index)

RAG pipeline with LangChain + LLaMA3 (Ollama)

Risk-aware personalized care plan generation (diet, lifestyle, medication adherence, monitoring, red flags)

Output: API response + formatted PDF report

<h2>9. ER Visit Risk Prediction (NHANES Dataset)</h2>

Dataset & preprocessing (imputation, outlier handling, class imbalance)

CatBoost model (parameters, early stopping, class weights)

Evaluation (confusion matrix, classification report)

SHAP explainability (force plot + summary plot interpretation)

<h2>10. Dashboard & Visualization</h2>

Doctor’s weekly monitoring dashboard

Summary vitals (age, BMI, HbA1c, BP, heart rate)

Trend charts (glucose, BP, HR, cholesterol)

Alerts for abnormal patterns (e.g., rising BP/glucose)

<h2>11. Technology Stack</h2>

Python (preprocessing, ML pipeline)

CatBoost, XGBoost, LightGBM, Random Forest, SHAP

LangChain + FAISS + Ollama (LLaMA3) for care plan generation

Firebase (data storage)

HTML/CSS/JS + Flutter (frontend)

Power BI (visualizations)

<h2>12. Conclusion & Future Work</h2>

Current achievements (multi-label risk prediction, explainability, personalized care plans, dashboards)

Impact (reduce complications, lower ER visits, support doctors)

Limitations (dataset size, real-world integration challenges, cost of wearables)

Future directions:

1. Integration with real wearable APIs (Fitbit, Apple Health)

2. Larger and standardized clinical datasets

3. Clinical trials for validation
