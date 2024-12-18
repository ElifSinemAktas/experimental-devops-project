from fastapi import APIRouter
from app.api.routers import users  # Import user routes

# Create a central API router
api_router = APIRouter()

# Include user routes
api_router.include_router(users.router, prefix="/users", tags=["Users"])
