# Deploy the Bookinfo sample application:
kubectl apply -f bookinfo.yaml

# The application will start. As each pod becomes ready, the Istio sidecar will be deployed along with it.
kubectl get services
kubectl get pods

# Verify everything working
kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -sS productpage:9080/productpage | grep -o "<title>.*</title>"

# Associate application with gateway
kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml

# Ensure that there are no issues with the configuration:
istioctl analyze

# Set the ingress ports and host IP:
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')
export INGRESS_HOST="..........."

# Set GATEWAY_URL:
export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT

# Run the following command to retrieve the external address of the Bookinfo application.
echo "http://$GATEWAY_URL/productpage"

# Install Kiali and the other addons and wait for them to be deployed.
kubectl apply -f samples/addons