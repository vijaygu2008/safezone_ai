import os
import pandas as pd

from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import (
    accuracy_score,
    precision_score,
    recall_score,
    f1_score,
    confusion_matrix,
    classification_report
)

import joblib


# --------------------------------------------------
# Paths
# --------------------------------------------------

BASE_DIR = os.path.dirname(__file__)

DATASET_PATH = os.path.join(
    BASE_DIR,
    "training_data.csv"
)

MODEL_PATH = os.path.join(
    BASE_DIR,
    "risk_model.pkl"
)


# --------------------------------------------------
# Feature columns
# --------------------------------------------------

FEATURES = [
    "flood_exposure",
    "landslide_exposure",
    "rainfall",
    "slope",
    "elevation",
    "population_density",
    "vulnerable_population",
    "disaster_history",
    "distance_from_river",
    "road_access",
    "healthcare_access"
]

TARGET = "risk_class"


# --------------------------------------------------
# Load dataset
# --------------------------------------------------

print("\nLoading training dataset...")

data = pd.read_csv(DATASET_PATH)

print("Dataset loaded successfully.")
print(f"Total records: {len(data)}")


# --------------------------------------------------
# Prepare X and y
# --------------------------------------------------

X = data[FEATURES]
y = data[TARGET]


print("\nFeatures:")
print(FEATURES)

print("\nRisk class distribution:")
print(y.value_counts().sort_index())


# --------------------------------------------------
# Train/Test Split
# --------------------------------------------------

X_train, X_test, y_train, y_test = train_test_split(
    X,
    y,
    test_size=0.20,
    random_state=42,
    stratify=y
)


print("\nTraining records:", len(X_train))
print("Testing records:", len(X_test))


# --------------------------------------------------
# Create Random Forest model
# --------------------------------------------------

print("\nCreating Random Forest model...")

model = RandomForestClassifier(
    n_estimators=200,
    max_depth=10,
    random_state=42,
    class_weight="balanced"
)


# --------------------------------------------------
# Train model
# --------------------------------------------------

print("Training model...")

model.fit(X_train, y_train)

print("Model training completed.")


# --------------------------------------------------
# Predictions
# --------------------------------------------------

y_pred = model.predict(X_test)


# --------------------------------------------------
# Evaluation
# --------------------------------------------------

accuracy = accuracy_score(y_test, y_pred)

precision = precision_score(
    y_test,
    y_pred,
    average="weighted",
    zero_division=0
)

recall = recall_score(
    y_test,
    y_pred,
    average="weighted",
    zero_division=0
)

f1 = f1_score(
    y_test,
    y_pred,
    average="weighted",
    zero_division=0
)


# --------------------------------------------------
# Display results
# --------------------------------------------------

print("\n======================================")
print("        MODEL EVALUATION")
print("======================================")

print(f"Accuracy  : {accuracy * 100:.2f}%")
print(f"Precision : {precision * 100:.2f}%")
print(f"Recall    : {recall * 100:.2f}%")
print(f"F1 Score  : {f1 * 100:.2f}%")


# --------------------------------------------------
# Classification Report
# --------------------------------------------------

print("\n======================================")
print("      CLASSIFICATION REPORT")
print("======================================")

print(
    classification_report(
        y_test,
        y_pred,
        zero_division=0
    )
)


# --------------------------------------------------
# Confusion Matrix
# --------------------------------------------------

print("\n======================================")
print("       CONFUSION MATRIX")
print("======================================")

matrix = confusion_matrix(y_test, y_pred)

print(matrix)


# --------------------------------------------------
# Feature Importance
# --------------------------------------------------

print("\n======================================")
print("       FEATURE IMPORTANCE")
print("======================================")

importance = pd.DataFrame({
    "feature": FEATURES,
    "importance": model.feature_importances_
})

importance = importance.sort_values(
    by="importance",
    ascending=False
)

print(importance.to_string(index=False))


# --------------------------------------------------
# Save trained model
# --------------------------------------------------

joblib.dump(model, MODEL_PATH)

print("\n======================================")
print("MODEL SAVED SUCCESSFULLY")
print("======================================")

print(f"Model path: {MODEL_PATH}")