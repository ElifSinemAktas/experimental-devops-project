from datetime import datetime, timedelta
from jose import jwt, JWTError
from passlib.context import CryptContext
from fastapi.security import OAuth2PasswordBearer
from app.core import config

# Vars
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")

def hash_password(password: str) -> str:
    return pwd_context.hash(password)

def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)

def create_access_token(data: dict, expires_delta: timedelta = None):
    to_encode = data.copy()
    expire = datetime.utcnow() + (expires_delta or timedelta(minutes=config.settings.ACCESS_TOKEN_EXPIRE_MINUTES))
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, config.settings.SECRET_KEY, algorithm=config.settings.ALGORITHM)

def decode_token(token: str, secret_key: str, algorithm: str):
    try:
        # Decode the JWT token
        payload = jwt.decode(token, secret_key, algorithms=[algorithm])
        email: str = payload.get("sub")  # Extract the 'sub' claim
        if email is None:
            return None  # Invalid token, no email found
        return payload  # Return the full payload if valid
    except JWTError:
        return None  # Return None if decoding fails