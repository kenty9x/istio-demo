## Create certificate from intermediate CA and use mtls in istio

In the top-level directory of the Istio installation package, create a directory to hold certificates and keys:

$ mkdir -p certs
$ pushd certs

Generate the root certificate and key:

$ make -f ../tools/certs/Makefile.selfsigned.mk root-ca

This will generate the following files:

- root-cert.pem: the generated root certificate
- root-key.pem: the generated root key
- root-ca.conf: the configuration for openssl to generate the root certificate
- root-cert.csr: the generated CSR for the root certificate

For each cluster, generate an intermediate certificate and key for the Istio CA. The following is an example for cluster1:

$ make -f ../tools/certs/Makefile.selfsigned.mk cluster1-cacerts

This will generate the following files in a directory named cluster1:

- ca-cert.pem: the generated intermediate certificates
- ca-key.pem: the generated intermediate key
- cert-chain.pem: the generated certificate chain which is used by istiod
- root-cert.pem: the root certificate

$ make -f ../tools/certs/Makefile.selfsigned.mk httpbin-cacerts

Create secret for storing tls certs

kubectl create -n istio-system secret generic httpbin-credential --from-file=tls.key=httpbin.example.com.key \
--from-file=tls.crt=httpbin.example.com.crt --from-file=ca.crt=example.com.crt
