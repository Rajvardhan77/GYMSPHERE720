"""Configuration settings for the GymSphere Flask application."""
import os
from dotenv import load_dotenv

load_dotenv()


class Config:
    """Base configuration."""

    BASE_DIR = os.path.abspath(os.path.dirname(__file__))
    SECRET_KEY = os.getenv("SECRET_KEY", "change-me-in-prod")
    
    # Use DATABASE_URL if available (e.g. on Vercel/Heroku), else fallback to local SQLite
    database_url = os.getenv("DATABASE_URL")
    if database_url and database_url.startswith("postgres://"):
        database_url = database_url.replace("postgres://", "postgresql://", 1)
    
    SQLALCHEMY_DATABASE_URI = database_url or "sqlite:///" + os.path.join(BASE_DIR, "gym.db")
    SQLALCHEMY_TRACK_MODIFICATIONS = False






