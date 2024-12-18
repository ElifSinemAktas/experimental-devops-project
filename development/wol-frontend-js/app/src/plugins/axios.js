import axios from "axios";

const apiClient = axios.create({
  baseURL: import.meta.env.VITE_FASTAPI_URL, // Replace with your FastAPI backend URL
  headers: {
    "Content-Type": "application/json",
  },
});

export default apiClient;


