import os
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session
from typing import Generator
from dotenv import load_dotenv
from app.core.config import settings

# # SQLite database connection string
# DATABASE_URL = "sqlite:///./test.db"

# # Create the database engine
# engine = create_engine(
#     DATABASE_URL, connect_args={"check_same_thread": False}
# )

load_dotenv()

DATABASE_URL = settings.DATABASE_URL

# Base class for defining SQLAlchemy ORM models
Base = declarative_base()

engine = create_engine(DATABASE_URL)

# Create a configured "Session" class
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def get_db() -> Generator[Session, None, None]:
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def create_db():
    print("Creating database...")
    Base.metadata.create_all(bind=engine)
    print("Database created successfully.")
