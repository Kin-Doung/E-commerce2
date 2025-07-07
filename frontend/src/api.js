import axios from 'axios';

const api = axios.create({
  baseURL: 'http://127.0.0.1:8000/api',
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
});

// Add CSRF token for POST/PUT/DELETE requests
api.interceptors.request.use(async (config) => {
  if (['post', 'put', 'delete'].includes(config.method)) {
    try {
      await axios.get('http://127.0.0.1:8000/sanctum/csrf-cookie');
    } catch (error) {
      console.error('Failed to fetch CSRF token:', error);
    }
  }
  const token = localStorage.getItem('auth_token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export default api;