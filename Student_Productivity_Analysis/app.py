from fastapi import FastAPI
from pydantic import BaseModel
import pickle

app = FastAPI()

from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],   # allow all origins (for development)
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load model
model = pickle.load(open('model.pkl', 'rb'))

# Root endpoint
@app.get("/")
def home():
    return {"message": "API is running"}


# 👇 Input structure
class InputData(BaseModel):
    study_hours_per_day: float
    phone_usage_hours: float
    social_media_hours: float
    youtube_hours: float
    gaming_hours: float
    stress_level: float
    focus_score: float

# 👇 ADD / KEEP THIS HERE
@app.post("/predict")
def predict(data: InputData):
    input_list = [[
        data.study_hours_per_day,
        data.phone_usage_hours,
        data.social_media_hours,
        data.youtube_hours,
        data.gaming_hours,
        data.stress_level,
        data.focus_score
    ]]
    
    prediction = model.predict(input_list)
    return {"prediction": float(prediction[0])}