# Istio demo
- My blog: [Openhu](https://openhu.wordpress.com/)
- Istio creates gateway and virtualservice in desired namespace. We can connect externally to cluster pod via istio service in istio-system namespace.
## How to setup
- Install [Istio](https://istio.io/latest/docs/setup/install/)
```yaml
$ istioctl install
```
- Inject proxy

```shell
$ kubectl label namespace default istio-injection=enabled
```

- Install app
```shell
$ kubectl apply -f kubernetes-manifests.yaml
```

- Install Istio addons

```shell
$ kubectl apply -f ./addons
```

- Use Kiali
```shell
$ kubectl port-forward svc/kiali -n istio-system 20001
```

- Use Jaeger
```shell
$ istioctl dashboard jaeger
```
