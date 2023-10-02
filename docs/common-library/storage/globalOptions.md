# Global Options

The following options are available for all persistence types:

## enabled

Enables or disables the persistence item. Defaults to `true`.

## type

Sets the persistence type

Valid options are:

- [`configMap`](types/configmap.md)
- [`custom`](types/custom.md)
- [`emptyDir`](types/emptyDir.md)
- [`hostPath`](types/hostPath.md)
- [`nfs`](types/nfs-share.md)
- [`persistentVolumeClaim`](types/persistentVolumeClaim.md)
- [`secret`](types/secret.md)

## globalMounts

Configure mounts to all controllers and containers. By default the persistence item
will be mounted to `/<name_of_the_peristence_item>`.

**Example**

```yaml
globalMounts:
  - path: /config
    readOnly: false
```

### path

Where to mount the volume in the main container. Defaults to `/<name_of_the_volume>`

### readOnly

Specify if the volume should be mounted read-only

### subPath

Specifies a sub-path inside the referenced volume instead of its root.

## advancedMounts

Explicitly configure mounts for specific controllers and containers.

**Example**

```yaml
advancedMounts:
  main: # (1)!
    main: # (2)!
      - path: /data/config.yaml
        readOnly: true
        subPath: config.yaml
    second-container: # (3)!
      - path: /appdata/config
        readOnly: true

  second-controller: # (4)!
    main: # (5)!
      - path: /data/config.yaml
        readOnly: false
        subPath: config.yaml
```

1.  the controller with the "main" identifier
2.  the container with the "main" identifier
3.  the container with the "second-container" identifier
4.  the controller with the "second-controller" identifier
5.  the container with the "main" identifier

### path

Where to mount the volume in the main container. Defaults to `/<name_of_the_volume>`

### readOnly

Specify if the volume should be mounted read-only

### subPath

Specifies a sub-path inside the referenced volume instead of its root.
