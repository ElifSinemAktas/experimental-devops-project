from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from datetime import timedelta
from app.core import crud, database, security 
from app.core import database, config
from app.orm import schemas, models

router = APIRouter()

@router.post("/signup", status_code=status.HTTP_201_CREATED, response_model=dict)
def signup(user: schemas.UserCreate, db: Session = Depends(database.get_db)):
    existing_user = crud.get_user_by_email(db, user.email)
    if existing_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    
    # Create the user in the database
    new_user = crud.create_user(db=db, user=user)
    
    return {"message": "User created successfully", "user_id": new_user.user_id}

@router.post("/login", response_model=schemas.Token)
def login(user: schemas.UserLogin, db: Session = Depends(database.get_db)):

    user_obj = crud.get_user_by_email(db, user.email)

    # Correct user is exist and Authenticate the user
    if not user_obj:
        raise HTTPException(status_code=401, detail="User not found")
    
    if not security.verify_password(user.password, user_obj.password_hash):
        raise HTTPException(status_code=401, detail="Invalid credentials")
        
    # Generate the access token
    access_token = security.create_access_token(
        data={"sub": user_obj.email},
        expires_delta=timedelta(minutes=config.settings.ACCESS_TOKEN_EXPIRE_MINUTES),
    )
    
    return {"access_token": access_token, "token_type": "bearer"}

@router.get("/profile", response_model=schemas.UserResponse)
def get_current_user_info(token: str = Depends(security.oauth2_scheme), db: Session = Depends(database.get_db)):
    payload = security.decode_token(token, config.settings.SECRET_KEY, config.settings.ALGORITHM)
    if payload is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication credentials",
        )

    email: str = payload.get("sub")
    user = db.query(models.User).filter(models.User.email == email).first()
    if user is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="User not found",
        )

    response_data = {
    "user_id": user.user_id,
    "first_name": user.first_name,
    "last_name": user.last_name,
    "email": user.email,
    "contacts": user.contacts,
    "addresses": user.addresses,
    "roles": user.roles,
    }
    
    print(response_data)
    return response_data