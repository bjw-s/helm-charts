# Code Server

The [code-server](https://github.com/cdr/code-server) add-on can be used to
access and modify persistent volume data in your application. This can be
useful when you need to edit the persistent volume data, for example with
Home Assistant.

## Example values

Below is a snippet from a `values.yaml` using the add-on. More configuration
options can be found in our common chart documentation.

```admonish note
This example will mount `/config` into the code-server sidecar.
```

```yaml
addons:
  codeserver:
    enabled: true
    image:
      repository: codercom/code-server
      tag: 3.9.0
    workingDir: "/config"
    args:
    - --auth
    - "none"
    - --user-data-dir
    - "/config/.vscode"
    - --extensions-dir
    - "/config/.vscode"
    ingress:
      enabled: true
      annotations:
        kubernetes.io/ingress.class: "nginx"
      hosts:
      - host: app-config.domain.tld
        paths:
        - path: /
          pathType: Prefix
      tls:
      - hosts:
        - app-config.domain.tld
    volumeMounts:
    - name: config
      mountPath: /config
```
