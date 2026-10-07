from fastapi import FastAPI
from pydantic import BaseModel

from ml.model import load_model, predict_risk


# =========================================================
# FastAPI Application
# =========================================================

app = FastAPI(
    title="SafeZone AI API",
    description="AI-powered disaster risk assessment and relocation decision-support API",
    version="1.0.0"
)


# =========================================================
# Request Models
# =========================================================

class MLRiskRequest(BaseModel):
    flood_exposure: float
    landslide_exposure: float
    rainfall: float
    slope: float
    elevation: float
    population_density: float
    vulnerable_population: float
    disaster_history: float
    distance_from_river: float
    road_access: float
    healthcare_access: float


class FieldReportRequest(BaseModel):
    location: str
    population: int
    road_condition: str
    water_available: str
    shelter_available: str
    infrastructure_condition: str
    observations: str


# =========================================================
# Root
# =========================================================

@app.get("/")
def root():
    return {
        "message": "SafeZone AI Backend is running",
        "version": "1.0.0",
        "status": "online"
    }


# =========================================================
# Health Check
# =========================================================

@app.get("/health")
def health():
    return {
        "status": "healthy",
        "service": "SafeZone AI Backend"
    }


# =========================================================
# Basic Risk Data
# =========================================================

@app.get("/risk")
def get_risk():
    return {
        "area": "Critical Zone",
        "risk_score": 92,
        "risk_level": "Critical",
        "population": 1240,
        "priority": "Immediate Relocation",
        "hazards": [
            "Flood",
            "Landslide",
            "Heavy Rainfall"
        ]
    }


# =========================================================
# Risk Map
# =========================================================

@app.get("/risk-map")
def get_risk_map():
    return {
        "locations": [
            {
                "id": 1,
                "name": "Critical Zone",
                "latitude": 11.4102,
                "longitude": 76.6950,
                "risk_score": 92,
                "risk_level": "Critical",
                "population": 1240,
                "hazards": [
                    "Flood",
                    "Landslide",
                    "Heavy Rainfall"
                ],
                "priority": "Immediate Relocation"
            },
            {
                "id": 2,
                "name": "High Risk Area",
                "latitude": 11.4200,
                "longitude": 76.7100,
                "risk_score": 84,
                "risk_level": "High",
                "population": 980,
                "hazards": [
                    "Landslide",
                    "Heavy Rainfall"
                ],
                "priority": "Prepare for Relocation"
            },
            {
                "id": 3,
                "name": "Mountain Village",
                "latitude": 11.3950,
                "longitude": 76.6800,
                "risk_score": 76,
                "risk_level": "High",
                "population": 720,
                "hazards": [
                    "Heavy Rainfall",
                    "Landslide"
                ],
                "priority": "Monitor Closely"
            }
        ]
    }


# =========================================================
# Relocation Sites
# =========================================================

@app.get("/relocation-sites")
def get_relocation_sites():
    return {
        "sites": [
            {
                "id": 1,
                "name": "Government Higher Secondary School",
                "safety_score": 92,
                "capacity": 2500,
                "distance": 2.4,
                "healthcare_distance": 1.2,
                "road_access": "Good",
                "hazard_level": "Low",
                "water": "Good",
                "electricity": "Available"
            },
            {
                "id": 2,
                "name": "Community Relief Centre",
                "safety_score": 86,
                "capacity": 1800,
                "distance": 3.1,
                "healthcare_distance": 2.0,
                "road_access": "Good",
                "hazard_level": "Low",
                "water": "Good",
                "electricity": "Available"
            },
            {
                "id": 3,
                "name": "District Sports Complex",
                "safety_score": 81,
                "capacity": 4000,
                "distance": 5.2,
                "healthcare_distance": 3.5,
                "road_access": "Good",
                "hazard_level": "Low",
                "water": "Available",
                "electricity": "Available"
            }
        ]
    }


# =========================================================
# Priority Ranking
# =========================================================

@app.get("/priority-ranking")
def get_priority_ranking():
    return {
        "areas": [
            {
                "rank": 1,
                "name": "Critical Zone",
                "risk_score": 92,
                "population": 1240,
                "vulnerability": 95,
                "priority": "Immediate"
            },
            {
                "rank": 2,
                "name": "High Risk Area",
                "risk_score": 84,
                "population": 980,
                "vulnerability": 88,
                "priority": "Very High"
            },
            {
                "rank": 3,
                "name": "Mountain Village",
                "risk_score": 76,
                "population": 720,
                "vulnerability": 82,
                "priority": "High"
            },
            {
                "rank": 4,
                "name": "River Side Habitation",
                "risk_score": 68,
                "population": 650,
                "vulnerability": 72,
                "priority": "Moderate"
            },
            {
                "rank": 5,
                "name": "Valley Settlement",
                "risk_score": 54,
                "population": 480,
                "vulnerability": 60,
                "priority": "Monitor"
            }
        ]
    }


# =========================================================
# Alerts
# =========================================================

@app.get("/alerts")
def get_alerts():
    return {
        "alerts": [
            {
                "id": 1,
                "title": "Critical Zone Alert",
                "area": "Critical Zone",
                "risk_score": 92,
                "hazards": "Flood + Landslide",
                "action": "Immediate Relocation",
                "time": "10 minutes ago",
                "severity": "Critical"
            },
            {
                "id": 2,
                "title": "High Risk Area",
                "area": "High Risk Area",
                "risk_score": 84,
                "hazards": "Heavy Rainfall + Landslide",
                "action": "Prepare for Relocation",
                "time": "35 minutes ago",
                "severity": "High"
            },
            {
                "id": 3,
                "title": "Rainfall Warning",
                "area": "Mountain Village",
                "risk_score": 76,
                "hazards": "Heavy Rainfall",
                "action": "Monitor Situation",
                "time": "1 hour ago",
                "severity": "Moderate"
            },
            {
                "id": 4,
                "title": "Preparedness Alert",
                "area": "River Side Habitation",
                "risk_score": 68,
                "hazards": "Flood Exposure",
                "action": "Maintain Preparedness",
                "time": "2 hours ago",
                "severity": "Moderate"
            }
        ],
        "summary": {
            "critical": 1,
            "high": 2,
            "moderate": 1
        },
        "system_status": "Active"
    }


# =========================================================
# Analytics
# =========================================================

@app.get("/analytics")
def get_analytics():
    return {
        "total_areas": 152,
        "high_risk_areas": 40,
        "population_at_risk": 1240,
        "critical_zones": 12,

        "risk_distribution": {
            "critical": 12,
            "high": 28,
            "moderate": 45,
            "low": 67
        },

        "hazard_analysis": {
            "flood": 72,
            "landslide": 64,
            "heavy_rainfall": 58
        },

        "vulnerability": {
            "children": 280,
            "elderly": 190,
            "persons_with_disabilities": 75,
            "total_vulnerable_population": 545
        },

        "relocation": {
            "candidate_sites": 3
        },

        "status": "Operational"
    }


# =========================================================
# Vulnerability Analysis
# =========================================================

@app.get("/vulnerability")
def get_vulnerability():
    return {
        "area": "Critical Zone",
        "overall_score": 84,
        "vulnerability_level": "Very High",

        "vulnerable_population": {
            "children": 280,
            "elderly": 190,
            "persons_with_disabilities": 75
        },

        "accessibility": {
            "healthcare": "Limited",
            "road": "Moderate",
            "water": "Good",
            "disaster_exposure": "Very High"
        },

        "recommendation": "Immediate priority for disaster preparedness and relocation planning"
    }


# =========================================================
# Explainable Risk Score
# =========================================================

@app.get("/risk-score")
def get_risk_score():
    return {
        "area": "Critical Zone",
        "overall_score": 92,
        "risk_level": "Critical",

        "components": {
            "hazard_exposure": {
                "score": 36,
                "maximum": 40,
                "percentage": 90,
                "description": "Flood, landslide and heavy rainfall exposure"
            },

            "population_exposure": {
                "score": 22,
                "maximum": 25,
                "percentage": 88,
                "description": "Number and density of people exposed to hazards"
            },

            "vulnerability": {
                "score": 19,
                "maximum": 20,
                "percentage": 95,
                "description": "Children, elderly and persons with disabilities"
            },

            "disaster_history": {
                "score": 10,
                "maximum": 10,
                "percentage": 100,
                "description": "Historical disaster events in the area"
            },

            "infrastructure_risk": {
                "score": 5,
                "maximum": 5,
                "percentage": 100,
                "description": "Road access, healthcare and essential services"
            }
        },

        "weights": {
            "hazard_exposure": 40,
            "population_exposure": 25,
            "vulnerability": 20,
            "disaster_history": 10,
            "infrastructure_risk": 5
        },

        "explanation": [
            "High hazard exposure contributes significantly to the overall risk.",
            "A large exposed population increases potential disaster impact.",
            "Vulnerable population groups require additional protection.",
            "Previous disaster events indicate recurring risk.",
            "Limited infrastructure accessibility can increase emergency response difficulty."
        ]
    }


# =========================================================
# Machine Learning Risk Prediction
# =========================================================

@app.post("/ml-risk")
def predict_ml_risk(request: MLRiskRequest):

    # Load trained Random Forest model
    model = load_model()

    if model is None:
        return {
            "success": False,
            "message": "Trained ML model not found.",
            "model_path": "backend/ml/risk_model.pkl"
        }

    # Prepare features
    features = {
        "flood_exposure": request.flood_exposure,
        "landslide_exposure": request.landslide_exposure,
        "rainfall": request.rainfall,
        "slope": request.slope,
        "elevation": request.elevation,
        "population_density": request.population_density,
        "vulnerable_population": request.vulnerable_population,
        "disaster_history": request.disaster_history,
        "distance_from_river": request.distance_from_river,
        "road_access": request.road_access,
        "healthcare_access": request.healthcare_access
    }

    # Get prediction from Random Forest
    result = predict_risk(model, features)

    prediction = result["prediction"]

    # Convert numeric prediction to readable risk level
    risk_names = {
        0: "Low",
        1: "High",
        2: "Critical"
    }

    risk_level = risk_names.get(
        prediction,
        "Unknown"
    )

    return {
        "success": True,
        "prediction": prediction,
        "risk_level": risk_level,
        "confidence": result["confidence"],
        "model": "Random Forest",
        "note": "Prediction is based on the current prototype demonstration model."
    }


# =========================================================
# Field Report
# =========================================================

@app.post("/field-report")
def submit_field_report(report: FieldReportRequest):
    return {
        "success": True,
        "message": "Field report submitted successfully.",
        "report": {
            "location": report.location,
            "population": report.population,
            "road_condition": report.road_condition,
            "water_available": report.water_available,
            "shelter_available": report.shelter_available,
            "infrastructure_condition": report.infrastructure_condition,
            "observations": report.observations
        }
    }


# =========================================================
# System Information
# =========================================================

@app.get("/system-info")
def system_info():

    model = load_model()

    return {
        "application": "SafeZone AI",
        "backend": "FastAPI",
        "machine_learning": "Random Forest",
        "ml_model_available": model is not None,
        "database": "PostgreSQL/PostGIS planned",
        "gis": "GIS spatial analysis",
        "frontend": "Flutter"
    }