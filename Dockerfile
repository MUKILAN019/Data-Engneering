# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /elt

# Copy the current directory contents into the container
COPY . /elt

# Upgrade pip to the latest version
RUN pip install --upgrade pip

# Install required packages
RUN pip install psycopg2-binary 

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Define environment variables
ENV DB_HOST=my_postgres
ENV DB_NAME=mydatabase
ENV DB_USER=admin
ENV DB_PASSWORD=admin123

# Run the script
CMD ["python", "elt_script.py"]
