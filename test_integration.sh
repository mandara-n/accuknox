#!/bin/bash

# Variables
FRONTEND_POD=$(kubectl get pods -l app=frontend -o jsonpath="{.items[0].metadata.name}")
BACKEND_SERVICE_URL="http://backend-service:3000/greet"

# Function to test connectivity from frontend to backend
test_backend_connection() {
    echo "Testing connection from frontend to backend..."

    # Execute curl command inside the frontend pod
    RESPONSE=$(kubectl exec -it $FRONTEND_POD -- curl -s -o /dev/null -w "%{http_code}" $BACKEND_SERVICE_URL)

    if [ "$RESPONSE" -eq 200 ]; then
        echo "Integration test passed: Frontend can communicate with Backend."
    else
        echo "Integration test failed: Frontend cannot communicate with Backend. HTTP response code: $RESPONSE"
        exit 1
    fi
}

# Run the test
test_backend_connection
