# Use official Python image as base
FROM python:3.9

# Set the working directory inside the container
WORKDIR /app/backend

# Copy only the requirements file first to leverage Docker caching
COPY requirements.txt /app/backend/

# Install system dependencies and application dependencies in a single step
RUN apt-get update && apt-get install -y \
    gcc default-libmysqlclient-dev pkg-config \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application files
COPY . /app/backend/

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    DJANGO_SETTINGS_MODULE=backend.settings \
    DEBUG=False 

# Expose port 8000 (default for Django)
EXPOSE 8000

# Run the Django application
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "backend.wsgi:application"]

