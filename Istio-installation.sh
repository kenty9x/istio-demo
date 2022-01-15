# Download istio package
curl -L https://istio.io/downloadIstio | sh -
# Move to istio directory
cd istio*
# Add the istioctl client to your path
export PATH=$PWD/bin:$PATH
# Install istio
istioctl install --set profile=demo -y
