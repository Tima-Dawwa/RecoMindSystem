from fastapi import FastAPI
from routers import recommendation, chatbot

app = FastAPI()

app.include_router(recommendation.router)
app.include_router(chatbot.router)


@app.get("/")
async def root():
    return {"message": "Welcome to the recommendation system!"}
