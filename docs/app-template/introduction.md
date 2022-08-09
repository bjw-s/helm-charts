# App Template

## Background

Since Helm [library charts](https://helm.sh/docs/topics/library_charts/) cannot be
installed directly I have created a companion chart for the [common library](../../common-library/introduction).

## Usage

In order to use this template chart, you would deploy it as you would any other Helm chart.
By setting the desired values, the common library chart will render the desired resources.

Be sure to check out the [common library docs](../../common-library/introduction)
and its [`values.yaml`](https://github.com/bjw-s/helm-charts/tree/main/charts/library/common/values.yaml) for
more information about the available configuration options.

#### Example

This is an example `values.yaml` file that would deploy the [echo-server](https://github.com/jmalloc/echo-server)
application.

```yaml
image:
  repository: docker.io/jmalloc/echo-server
  tag: 0.3.3

service:
  main:
    ports:
      http:
        port: 8080

ingress:
  main:
    enabled: true
    ingressClassName: "nginx"
    hosts:
      - host: &host "echo-server.${INGRESS_DOMAIN}"
        paths:
          - path: /
    tls:
      - hosts:
          - *host

resources:
  requests:
    cpu: 15m
    memory: 64M
  limits:
    memory: 128M
```

## Source code

The source code for the app template chart can be found
[here](https://github.com/bjw-s/helm-charts/tree/main/charts/other/app-template).
