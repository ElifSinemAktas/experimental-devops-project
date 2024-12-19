import os
from pydantic import BaseSettings
from dotenv import load_dotenv

load_dotenv()

class Settings(BaseSettings):
    SECRET_KEY: str =  os.getenv("SECRET_KEY")
    ALGORITHM: str =  os.getenv("ALGORITHM")
    ACCESS_TOKEN_EXPIRE_MINUTES: int =  int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES"))
    DATABASE_URL : str = os.getenv("DATABASE_URL")

    class Config:
        env_file = "./env"

settings = Settings()
