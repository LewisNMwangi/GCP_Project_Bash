#!/bin/bash

#lewisnjuguna8@gmail.com

gcloud auth list

gcloud config list project

gcloud services enable run.googleapis.com

gcloud config set compute/region us-central1

LOCATION="us-central1"

mkdir helloworld && cd helloworld

nano package.json

#Insert the following to package.json file

<<package
{
  "name": "helloworld",
  "description": "Simple hello world sample in Node",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "start": "node index.js"
  },
  "author": "Google LLC",
  "license": "Apache-2.0",
  "dependencies": {
    "express": "^4.17.1"
  }
}
package

#Save package.json file

nano index.js

#Insert the following to index.js file

<<index
const express = require('express');
const app = express();
const port = process.env.PORT || 8080;
app.get('/', (req, res) => {
  const name = process.env.NAME || 'World';
  res.send(`Hello ${name}!`);
});
app.listen(port, () => {
  console.log(`helloworld: listening on port ${port}`);
});
index

#Save index,js file

nano Dockerfile

#Insert the following to Dockerfile

<<Dockerfile
# Use the official lightweight Node.js 12 image.
# https://hub.docker.com/_/node
FROM node:12-slim
# Create and change to the app directory.
WORKDIR /usr/src/app
# Copy application dependency manifests to the container image.
# A wildcard is used to ensure copying both package.json AND package-lock.json (when available).
# Copying this first prevents re-running npm install on every code change.
COPY package*.json ./
# Install production dependencies.
# If you add a package-lock.json, speed your build by switching to 'npm ci'.
# RUN npm ci --only=production
RUN npm install --only=production
# Copy local code to the container image.
COPY . ./
# Run the web service on container startup.
CMD [ "npm", "start" ]
Dockerfile

#Save the Dockerfile

gcloud builds submit --tag gcr.io/$GOOGLE_CLOUD_PROJECT/helloworld

gcloud container images list

docker run -d -p 8080:8080 gcr.io/$GOOGLE_CLOUD_PROJECT/helloworld

gcloud run deploy --image gcr.io/$GOOGLE_CLOUD_PROJECT/helloworld --allow-unauthenticated --region=$LOCATION

gcloud container images delete gcr.io/$GOOGLE_CLOUD_PROJECT/helloworld

gcloud run services delete helloworld --region=us-central1