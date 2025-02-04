# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /elt

# Copy the current directory contents into the container at /app
COPY . /elt

# Upgrade pip to the latest version
RUN pip install --upgrade pip

# Install any needed packages specified in requirements.txt
RUN pip install psycopg2-binary time

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Define environment variables
ENV DB_HOST=localhost
ENV DB_NAME=source_db
ENV DB_USER=postgres
ENV DB_PASSWORD=secret

# Run a script (replace with your actual entrypoint)
CMD ["python", "elt_script.py"]
