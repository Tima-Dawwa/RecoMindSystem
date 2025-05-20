from pydantic import BaseModel
from typing import Optional


class Product(BaseModel):
    id: str
    name: Optional[str] = None
    type: Optional[str] = None
    appearance: Optional[str] = None
    color: Optional[str] = None
    department: Optional[str] = None
    gender: Optional[str] = None
    details: Optional[str] = None
    total_interactions: Optional[int] = None
    total_interaction_score: Optional[int] = None
