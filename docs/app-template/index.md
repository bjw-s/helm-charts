# App Template

## Background

Since Helm [library charts](https://helm.sh/docs/topics/library_charts/) cannot be
installed directly I have created a companion chart for the [common library](../common-library/index.md).

## Usage

This Helm chart can be used to deploy any application. Knowing the specifics of the application you want to deploy
like the image, ports, env vars, args, and/or any config volumes will be required. You can also use [Kubesearch](https://kubesearch.dev/)
to search for applications people have deployed with this Helm chart.

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
examples/helm/vaultwarden/values.yaml
--8<--
```

## Upgrade instructions

### From 2.x.x to 3.0.x

The main changes from v2.x to v3.x are the removal of the default `main` objects and the introduction of JSON schema validation.

!!! warning

    **IMPORTANT** The introduction of the json schema adds additional validations and restrictions on the contents of your chart values.
    Things may have been missed during the initial schema creation, so if you run in to any unexpected validation errors please [raise an issue](https://github.com/bjw-s/helm-charts/issues/new?assignees=bjw-s&labels=bug&projects=&template=bug-report.md&title=)

Given the following real-life example values.yaml for app-template v2:

<details>
<summary>Expand</summary>

```yaml
---
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

</details>

The values for app-template v3.x would become this:

```yaml
---
# yaml-language-server: $schema=https://raw.githubusercontent.com/bjw-s/helm-charts/common-3.0.1/charts/library/common/values.schema.json
defaultPodOptions:
  enableServiceLinks: true
  securityContext:
    runAsUser: 568
    runAsGroup: 568
    fsGroup: 568
    fsGroupChangePolicy: "OnRootMismatch"
    supplementalGroups:
      - 65539

controllers:
  sabnzbd: # this can now be any name you wish
    containers:
      app: # this can now be any name you wish
        image:
          repository: ghcr.io/onedr0p/sabnzbd
          tag: latest
          pullPolicy: IfNotPresent

        probes:
          liveness:
            enabled: true
          readiness:
            enabled: true
          startup:
            enabled: true
            spec:
              failureThreshold: 30
              periodSeconds: 5

service:
  app: # this can now be any name you wish
    primary: true
    controller: sabnzbd
    ports:
      http:
        port: 8080

ingress:
  media: # this can now be any name you wish
    className: "ingress-nginx"
    hosts:
      - host: sabnzbd.bjw-s.dev
        paths:
          - path: /
            service:
              identifier: app
              port: http

persistence:
  media:
    existingClaim: nas-media
    globalMounts:
      - path: /data/nas-media
```

#### 🚧 Diff view

<details>
<summary>Expand</summary>

```diff
--- old
+++ new
@@ -1,42 +1,55 @@
---
+# yaml-language-server: $schema=https://raw.githubusercontent.com/bjw-s/helm-charts/common-3.0.1/charts/library/common/values.schema.json
 defaultPodOptions:
+  enableServiceLinks: true
   securityContext:
     runAsUser: 568
     runAsGroup: 568
     fsGroup: 568
     fsGroupChangePolicy: "OnRootMismatch"
     supplementalGroups:
       - 65539

 controllers:
-  main:
+  sabnzbd: # this can now be any name you wish
     containers:
-      main:
+      app: # this can now be any name you wish
         image:
           repository: ghcr.io/onedr0p/sabnzbd
           tag: latest
           pullPolicy: IfNotPresent

+        probes:
+          liveness:
+            enabled: true
+          readiness:
+            enabled: true
+          startup:
+            enabled: true
+            spec:
+              failureThreshold: 30
+              periodSeconds: 5
+
 service:
-  main:
+  app: # this can now be any name you wish
+    controller: sabnzbd
     ports:
       http:
         port: 8080

 ingress:
-  media:
-    enabled: true
+  media: # this can now be any name you wish
     className: "ingress-nginx"
     hosts:
       - host: sabnzbd.bjw-s.dev
         paths:
           - path: /
             service:
-              name: main
+              identifier: app
               port: http

 persistence:
   media:
     existingClaim: nas-media
     globalMounts:
       - path: /data/nas-media

```

</details>

#### Changes in this example

This is not meant as an exhaustive list of changes, but rather a "most common" example.

- The `main` object for controllers, containers, services and ingress has been removed from `values.yaml` and will therefore no longer provide any (both expected and unexpected) default values.
- The `config` object for persistence has been removed from `values.yaml` and will therefore no longer provide any (both expected and unexpected) default values.
- `enableServiceLinks` has been disabled by default. In order to explicitly enable serviceLinks, set the value to `true`.
- `ingress.*.hosts.*.paths.*.service` Service references now require either `name` or `identifier` to be set.
- Persistence items of type `configMap` and `secret` object references now allow either `name` or `identifier` to be set.

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
    globalMounts:
      - path: /data/nas-media

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
