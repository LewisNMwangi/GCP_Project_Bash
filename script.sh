#! /bin/bash

gcloud init < a

gcloud compute networks create mynetwork --subnet-mode=auto --bgp-routing-mode=regional

gcloud compute instances create mynet-us-vm --zone=us-central1-c --machine-type=n1-standard-1 --network=mynetwork
gcloud compute instances create mynet-eu-vm --zone=europe-west1-c --machine-type=n1-standard-1 --network=mynetwork