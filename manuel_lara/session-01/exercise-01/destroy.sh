#!/bin/bash

set -e

echo "Throwing out the blog..."
kubectl delete ns exercise-01

while [[ $(kubectl get ns | grep exercise-01) =~ Terminating ]]; do
    printf '.'
    sleep 5
done

printf '\n'
echo "The blog is gone."