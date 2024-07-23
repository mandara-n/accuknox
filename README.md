# accuknox
Kubernetes Deployment:
Deploy the services to a local Kubernetes cluster (e.g., Minikube or Kind).
Refer the below commands for deployment:

_root@N-20HEPF0Y79B9:/home/mandara/qa-test# kubectl apply -f Deployment/frontend-deployment.yaml_
deployment.apps/frontend-deployment created
service/frontend-service unchanged

_root@N-20HEPF0Y79B9:/home/mandara/qa-test# kubectl apply -f Deployment/backend-deployment.yaml_
deployment.apps/backend-deployment created
service/backend-service unchanged

_root@N-20HEPF0Y79B9:/home/mandara/qa-test# kubectl get pods_
NAME                                   READY   STATUS    RESTARTS   AGE
backend-deployment-6bc7544b64-774qk    1/1     Running   0          92m
backend-deployment-6bc7544b64-78js7    1/1     Running   0          92m
frontend-deployment-6485c5c85c-r8dwp   1/1     Running   0          11s

_root@N-20HEPF0Y79B9:/home/mandara/qa-test# kubectl get service_
NAME               TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
backend-service    ClusterIP      10.99.210.178   <none>        3000/TCP       4h28m
frontend-service   LoadBalancer   10.96.112.25    <pending>     80:31725/TCP   4h28m
kubernetes         ClusterIP      10.96.0.1       <none>        443/TCP        8h

_root@N-20HEPF0Y79B9:/home/mandara/qa-test# kubectl port-forward frontend-deployment-6485c5c85c-r8dwp 8080:8080_
Forwarding from 127.0.0.1:8080 -> 8080
Forwarding from [::1]:8080 -> 8080
Handling connection for 8080
Handling connection for 8080

Verification:
_root@frontend-deployment-677958554-qn54z:/usr/src/app# curl -s http://backend-service:3000/greet_
{"message":"Hello from the Backend!"}

**Automated script to check the connection establishment:**
_root@N-20HEPF0Y79B9:/home/mandara/qa-test# cat test_integration.sh_

#!/bin/bash

#Variables
FRONTEND_POD=$(kubectl get pods -l app=frontend -o jsonpath="{.items[0].metadata.name}")
BACKEND_SERVICE_URL="http://backend-service:3000/greet"

#Function to test connectivity from frontend to backend
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

#Run the test
test_backend_connection

_root@N-20HEPF0Y79B9:/home/mandara/qa-test# ./test_integration.sh_
Testing connection from frontend to backend...
Integration test passed: Frontend can communicate with Backend.

