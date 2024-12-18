from pydantic import BaseModel
from typing import List, Optional


# Schema for Contact
class Contact(BaseModel):
    contact_type: str
    contact_value: str

    class Config:
        orm_mode = True  # Enable ORM compatibility for SQLAlchemy models


# Schema for Address
class Address(BaseModel):
    address_line_1: str
    address_line_2: Optional[str] = None  
    city: str
    state: str
    postal_code: str
    country: str

    class Config:
        orm_mode = True  


# Schema for Role
class Role(BaseModel):
    role_name: str

    class Config:
        orm_mode = True  

# Base schema for User
class UserBase(BaseModel):
    first_name: str
    last_name: str
    email: str


# Schema for User Creation
class UserCreate(UserBase):
    password: str


# Schema for User Response
class UserResponse(UserBase):
    user_id: int
    contacts: List[Contact] = []  
    addresses: List[Address] = []  
    roles: List[Role] = []  

    class Config:
        orm_mode = True  


# Schema for User Login
class UserLogin(BaseModel):
    email: str
    password: str


# Schema for Token Response
class Token(BaseModel):
    access_token: str
    token_type: str
