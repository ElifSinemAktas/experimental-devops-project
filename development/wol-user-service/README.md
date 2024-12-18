## wol-backend

Contains the main application logic:

- crud.py: Handles database logic specific to users (e.g., creating, reading, updating, deleting user records).
- database.py: Sets up the database connection and session management.
- main.py: The entry point of the service, initializing FastAPI, and including user-specific routes.
- models.py: Database models (e.g., User table with fields like id, email, password_hash).
- schemas.py: Pydantic models for request/response validation (e.g., UserCreate, UserRead).
- routes: Contains route handlers (APIs)