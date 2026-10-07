import os
import joblib

from sklearn.ensemble import RandomForestClassifier


# =========================================================
# Model Path
# =========================================================

MODEL_PATH = os.path.join(
    os.path.dirname(__file__),
    "risk_model.pkl"
)


# =========================================================
# Feature Names
# =========================================================

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


# =========================================================
# Create Random Forest Model
# =========================================================

def create_model():

    model = RandomForestClassifier(
        n_estimators=200,
        max_depth=10,
        random_state=42,
        class_weight="balanced"
    )

    return model


# =========================================================
# Save Model
# =========================================================

def save_model(model):

    joblib.dump(
        model,
        MODEL_PATH
    )


# =========================================================
# Load Trained Model
# =========================================================

def load_model():

    if not os.path.exists(MODEL_PATH):
        return None

    return joblib.load(MODEL_PATH)


# =========================================================
# Predict Risk
# =========================================================

def predict_risk(model, features):

    values = [[
        features["flood_exposure"],
        features["landslide_exposure"],
        features["rainfall"],
        features["slope"],
        features["elevation"],
        features["population_density"],
        features["vulnerable_population"],
        features["disaster_history"],
        features["distance_from_river"],
        features["road_access"],
        features["healthcare_access"]
    ]]

    # Predict risk class
    prediction = model.predict(values)[0]

    # Predict probability
    probability = model.predict_proba(values)[0]

    # Highest probability
    confidence = float(max(probability))

    return {
        "prediction": int(prediction),
        "confidence": round(
            confidence * 100,
            2
        )
    }