from fastapi import FastAPI
from routers import recommendation

app = FastAPI()

# Include the recommendation router
app.include_router(recommendation.router)


@app.get("/")
async def root():
    return {"message": "Welcome to the recommendation system!"}
