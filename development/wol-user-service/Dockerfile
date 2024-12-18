# Use the official Python image from the Docker Hub
FROM python:3.10-slim

# Create a directory
RUN mkdir /wol-user-service 

# Set the working directory in the container
WORKDIR /wol-user-service

# Copy app folder 
COPY ./app .
# Copy requirements 
COPY ./requirements.txt .

# Install the dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port that the app runs on
EXPOSE 8000

# Set the entry point to run the FastAPI application
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]