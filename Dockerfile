# This is a relatively lightweight debian image that includes Python 3.8
FROM registry.hub.docker.com/library/python:3.8-slim-buster

# Setting the working directory inside the container
WORKDIR /code

# Keep the Python module requirements separate by storing them in a file that we copy to the image
COPY requirements.txt .

# Install the Python modules
RUN pip install -r requirements.txt

# Transfer the code into the container
COPY src/ src/
COPY html/ html/
COPY styles/ styles/
COPY config.json config.json

# Run the service
CMD [ "python", "src/server.py" ]