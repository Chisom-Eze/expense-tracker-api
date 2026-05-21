from fastapi import FastAPI
from app.core.config import settings
from app.db.database import Base, engine

# Import models so tables are created
from app.models import expense, user

# Import routes
from app.api.routes import expense as expense_routes
from app.api.routes import auth

Base.metadata.create_all(bind=engine)

app = FastAPI(title=settings.APP_NAME)

@app.get("/health")
def health():
    return {
        "status": "ok",
        "version": "1.0.0"
    }

app.include_router(expense_routes.router)
app.include_router(auth.router, prefix="/auth", tags=["Auth"])
