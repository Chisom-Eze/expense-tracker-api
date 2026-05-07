from pydantic import BaseSettings

class Settings(BaseSettings):
    APP_NAME: str = "Expense Tracker"
    DATABASE_URL: str = "sqlite:///./test.db"

    class Config:
        env_file = ".env"

settings = Settings()