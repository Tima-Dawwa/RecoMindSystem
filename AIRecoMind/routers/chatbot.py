from fastapi import APIRouter
from pydantic import BaseModel
from typing import Optional

router = APIRouter()


class ChatRequest(BaseModel):
    message: Optional[str] = None
    image: Optional[str] = None
    userId: str


@router.post("/chatbot")
async def chat_endpoint(request: ChatRequest):
    return "Hello! This is a test response from the chatbot."
