# Multiple subPaths for 1 volume

It is possible to mount multiple subPaths from the same volume to the main
container. This can be achieved by specifying `subPath` with a list
instead of a string.

```admonish note
It is not possible to define `mountPath` at the top level when using this
feature
```

## Examples:

```yaml
persistence:
  config:
    enabled: true
    type: custom
    volumeSpec:
      configMap:
        name: myData
    subPath:
      - path: myFirstScript.sh
        mountPath: /data/myFirstScript.sh
      - path: myCertificate.pem
        mountPath: /certs/myCertificate.pem
        readOnly: true
```

```yaml
persistence:
  config:
    enabled: true
    type: pvc
    existingClaim: myAppData
    subPath:
      - path: .
        mountPath: /my_media
      - path: Series
        mountPath: /series
      - path: Downloads
        mountPath: /downloads
```
