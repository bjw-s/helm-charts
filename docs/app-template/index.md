# App Template

## Background

Since Helm [library charts](https://helm.sh/docs/topics/library_charts/) cannot be
installed directly I have created a companion chart for the [common library](../common-library/index.md).

## Usage

In order to use this template chart, you would deploy it as you would any other Helm chart.
By setting the desired values, the common library chart will render the desired resources.

Be sure to check out the [common library docs](../common-library/index.md)
and its [`values.yaml`](https://github.com/bjw-s/helm-charts/tree/main/charts/library/common/values.yaml) for
more information about the available configuration options.

#### Examples

This is an example `values.yaml` file that would deploy the [vaultwarden](https://github.com/dani-garcia/vaultwarden)
application. For more deployment examples, check out the [`examples` folder](https://github.com/bjw-s/helm-charts/tree/main/examples/).

```yaml linenums="1"
--8<--
examples/helm/values.yaml
--8<--
```

## Upgrade instructions

### From 1.x.x to 2.0.x

!!! warning

    **IMPORTANT** Because a new label has been introduced in the controller labelSelector (which is an immutable field), Deployments cannot be upgraded in place!
    [More details](https://www.datree.io/resources/kubernetes-error-codes-field-is-immutable)

!!! info

    Some items (Ingress, ports, persistence items, etc) now default to being enabled by default. However, this is not always the case for some of the `items due to overrides in the default `values.yaml`.
    [More background](https://github.com/bjw-s/helm-charts/issues/205)

Given the following real-life example values.yaml for app-template v1:

<details>
<summary>Expand</summary>

```yaml
image:
  repository: ghcr.io/onedr0p/sabnzbd
  tag: latest
  pullPolicy: IfNotPresent

podSecurityContext:
  runAsUser: 568
  runAsGroup: 568
  fsGroup: 568
  fsGroupChangePolicy: "OnRootMismatch"
  supplementalGroups:
    - 65539

service:
  main:
    ports:
      http:
        port: 8080

ingress:
  media:
    enabled: true
    ingressClassName: "ingress-nginx"
    hosts:
      - host: sabnzbd.bjw-s.dev
        paths:
          - path: /

persistence:
  media:
    enabled: true
    existingClaim: nas-media
    mountPath: /data/nas-media

probes:
  liveness:
    enabled: false
  readiness:
    enabled: false
  startup:
    enabled: false
```

</details>

The values for app-template v2.x would become this:

```yaml
defaultPodOptions:
  securityContext:
    runAsUser: 568
    runAsGroup: 568
    fsGroup: 568
    fsGroupChangePolicy: "OnRootMismatch"
    supplementalGroups:
      - 65539

controllers:
  main:
    containers:
      main:
        image:
          repository: ghcr.io/onedr0p/sabnzbd
          tag: latest
          pullPolicy: IfNotPresent

        probes:
          liveness:
            enabled: false
          readiness:
            enabled: false
          startup:
            enabled: false

service:
  main:
    ports:
      http:
        port: 8080

ingress:
  media:
    enabled: true
    className: "ingress-nginx"
    hosts:
      - host: sabnzbd.bjw-s.dev
        paths:
          - path: /
            service:
              name: main
              port: http

persistence:
  media:
    existingClaim: nas-media
    globalMounts:
      - path: /data/nas-media
```

#### Changes in this example

This is not meant as an exhaustive list of changes, but rather a "most common" example.

- `podSecurityContext` has been moved to `defaultPodOptions.securityContext`. It is also possible to configure this on a controller-specific basis by moving it to `controllers.main.pod.securityContext` instead.
- `image` has been moved to `controllers.main.containers.main.image` so that multiple containers can be configured.
- `ingress.media.ingressClassName` has been renamed to `ingress.main.className`.
- `ingress.media.enabled` can be removed, since items are considered enabled by default (they can still be disabled by adding `enabled: false`).
- `ingress.media.hosts.*.paths.*.service` is now required since there is no more concept of a default "primary" service.
- `persistence.media.mountPath` has been moved to `persistence.media.globalMounts.*.path` to allow multiple mountPaths for the same persistence item.
- `persistence.media.enabled` can be removed, since items are considered enabled by default (they can still be disabled by adding `enabled: false`).
- `probes` has been moved to `controllers.main.containers.main.probes` so that multiple containers can be configured.

## Source code

The source code for the app template chart can be found
[here](https://github.com/bjw-s/helm-charts/tree/main/charts/other/app-template).
