# Create the self signed CA cert with istio

kubectl create secret tls istio-ingressgateway-certs -n istio-system --key helloworld.172.30.73.89:31392.key --cert helloworld.172.30.73.89:31392.crt
kubectl delete secret istio-ingressgateway-certs  -n istio-system
kubectl apply -f bookinfo-gateway.yaml

#ensure the domain name, I am using 172.30.73.89
#create root cert and private and private key with self signed  x509 option
openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -subj '/O=<<domain name>> Inc./CN=<<domain name>>' -keyout <<rootkey name>>.key -out <<rootcert name>>.crt
#private key for subdomain where I am using hellogo
openssl req -out hellogo.alevztest.io.csr -newkey rsa:2048 -nodes -keyout <<subdomainkey name>>.key -subj "/CN=<<subdomain>>.<<domain name>>/O=hello world from <<domain name>>"
#create cert for subdomain
openssl x509 -req -days 365 -CA <<rootcert name>>.crt -CAkey <<rootkey name>>.key -set_serial 0 -in <<subdomainkey name>>.csr -out <<subdomaincert name>>.crt
#put the cert into k8s secret for ingressgateway to read
kubectl create secret tls istio-ingressgateway-certs -n istio-system --key <subdomainkey name>>.key --cert <<subdomaincert name>>.crt

openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -subj '/O=172.30.73.89 Inc./CN=172.30.73.89' -keyout 172.30.73.89:31392.key -out 172.30.73.89:31392.crt
openssl req -out helloworld.172.30.73.89:31392.csr -newkey rsa:2048 -nodes -keyout helloworld.172.30.73.89:31392.key -subj "/CN=172.30.73.89/O=hello world from 172.30.73.89"
openssl x509 -req -days 365 -CA 172.30.73.89:31392.crt -CAkey 172.30.73.89:31392.key -set_serial 0 -in helloworld.172.30.73.89:31392.csr -out helloworld.172.30.73.89:31392.crt
