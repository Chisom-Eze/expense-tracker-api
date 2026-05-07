from pydantic import BaseModel, validator
from datetime import datetime
from typing import Optional


class UserCreate(BaseModel):
    email: str
    password: str

    @validator("password")
    def validate_password_length(cls, v):
        if len(v.encode("utf-8")) > 72:
            raise ValueError("Password too long (max 72 bytes)")
        if len(v) < 6:
            raise ValueError("Password too short (min 6 characters)")
        return v


class ExpenseCreate(BaseModel):
    description: str
    amount: float
    category: Optional[str] = None


class ExpenseResponse(BaseModel):
    id: int
    description: str
    amount: float
    category: Optional[str]
    created_at: datetime
    updated_at: datetime

    class Config:
        orm_mode = True