FROM python:3.9-slim

# Create working folder and install dependencies
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application contents to our working folder
COPY service/ ./service/

# Create a non-root user (theia), give workdir ownership to that user, then switch to new user
RUN useradd --uid 1000 theia && chown -R theia /app
USER theia

# Expose the service on port 8080, and have gunicorn manage input/output
EXPOSE 8080
CMD ["gunicorn", "--bind=0.0.0.0:8080", "--log-level=info", "service:app"]