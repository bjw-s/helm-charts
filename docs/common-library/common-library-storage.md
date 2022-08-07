# Common library Storage

This page describes the different ways you can attach storage to charts
using the common library.

## Types

These are the types of storage that are supported in the common library.
Of course, other types are possible with the `custom` type.

### Persistent Volume Claim

This is probably the most common storage type, therefore it is also the
default when no `type` is specified.

It can be attached in two ways.

#### Dynamically provisioned

Charts can be configured to create the required persistentVolumeClaim
manifests on the fly.

| Field           | Mandatory | Docs / Description                                                                    |
| --------------- | --------- | ------------------------------------------------------------------------------------- |
| `enabled`       | Yes       |                                                                                       |
| `type`          | Yes       |                                                                                       |
| `accessMode`    | Yes       | [link](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes)  |
| `size`          | Yes       | [link](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#resources)     |
| `mountPath`     | No        | Where to mount the volume in the main container. Defaults to `/<name_of_the_volume>`. |
| `readOnly`      | No        | Specify if the volume should be mounted read-only.                                    |
| `nameOverride`  | No        | Override the name suffix that is used for this volume.                                |
| `storageClass`  | No        | Storage class to use for this volume.                                                 |
| `retain`        | No        | Set to true to retain the PVC upon `helm uninstall`.                                  |

Minimal config:

```yaml
persistence:
  config:
    enabled: true
    type: pvc
    accessMode: ReadWriteOnce
    size: 1Gi
```

This will create a 1Gi RWO PVC named `RELEASE-NAME-config` with the default
storageClass, which will mount to `/config`.

#### Existing claim

Charts can be configured to attach to a pre-existing persistentVolumeClaim.

| Field           | Mandatory | Docs / Description                                                                    |
| --------------- | --------- | ------------------------------------------------------------------------------------- |
| `enabled`       | Yes       |                                                                                       |
| `type`          | Yes       |                                                                                       |
| `existingClaim` | Yes       | Name of the existing PVC                                                              |
| `mountPath`     | No        | Where to mount the volume in the main container. Defaults to `/<name_of_the_volume>`. |
| `subPath`       | No        | Specifies a sub-path inside the referenced volume instead of its root.                |
| `readOnly`      | No        | Specify if the volume should be mounted read-only.                                    |
| `nameOverride`  | No        | Override the name suffix that is used for this volume.                                |

Minimal config:

```yaml
persistence:
  config:
    enabled: true
    type: pvc
    existingClaim: myAppData
```

This will mount an existing PVC named `myAppData` to `/config`.

### Empty Dir

Sometimes you need to share some data between containers, or need some
scratch space. That is where an emptyDir can come in.

See the [Kubernetes docs](https://kubernetes.io/docs/concepts/storage/volumes/#emptydir)
for more information.

| Field           | Mandatory | Docs / Description                                                                                               |
| --------------- | --------- | ---------------------------------------------------------------------------------------------------------------- |
| `enabled`       | Yes       |                                                                                                                  |
| `type`          | Yes       |                                                                                                                  |
| `medium`        | No        | Set this to `Memory` to mount a tmpfs (RAM-backed filesystem) instead of the storage medium that backs the node. |
| `sizeLimit`     | No        | If the `SizeMemoryBackedVolumes` feature gate is enabled, you can specify a size for memory backed volumes.      |
| `mountPath`     | No        | Where to mount the volume in the main container. Defaults to `/<name_of_the_volume>`.                            |
| `nameOverride`  | No        | Override the name suffix that is used for this volume.                                                           |

Minimal config:

```yaml
persistence:
  config:
    enabled: true
    type: emptyDir
```

This will create an ephemeral emptyDir volume and mount it to `/config`.

### Host path

In order to mount a path from the node where the Pod is running you can use a
`hostPath` type persistence item.

This can also be used to mount an attached USB device to a Pod. Note that
this will most likely also require setting an elevated `securityContext`.

See the [Kubernetes docs](https://kubernetes.io/docs/concepts/storage/volumes/#hostpath)
for more information.

| Field           | Mandatory | Docs / Description                                                                                                |
| --------------- | --------- | ----------------------------------------------------------------------------------------------------------------- |
| `enabled`       | Yes       |                                                                                                                   |
| `type`          | Yes       |                                                                                                                   |
| `hostPath`      | Yes       | Which path on the host should be mounted.                                                                         |
| `hostPathType`  | No        | Specifying a hostPathType adds a check before trying to mount the path. See Kubernetes documentation for options. |
| `mountPath`     | No        | Where to mount the volume in the main container. Defaults to the value of `hostPath`.                             |
| `readOnly`      | No        | Specify if the volume should be mounted read-only.                                                                |
| `nameOverride`  | No        | Override the name suffix that is used for this volume.                                                            |

Minimal config:

```yaml
persistence:
  config:
    enabled: true
    type: hostPath
    hostPath: /dev
```

This will mount the `/dev` folder from the underlying host to `/dev` in the container.

### configMap

In order to mount a configMap to a mount point within the Pod you can use the
`configMap` type persistence item.

| Field           | Mandatory | Docs / Description                                                                                                    |
| --------------- | --------- | --------------------------------------------------------------------------------------------------------------------- |
| `enabled`       | Yes       |                                                                                                                       |
| `type`          | Yes       |                                                                                                                       |
| `name`          | Yes       | Which configMap should be mounted. Supports Helm templating.                                                          |
| `defaultMode`   | No        | The default file access permission bit.                                                                               |
| `items`         | No        | Specify item-specific configuration. Will be passed 1:1 to the volumeSpec.                                            |
| `readOnly`      | No        | Explicitly specify if the volume should be mounted read-only. Even if not specified, the configMap will be read-only. |

Minimal config:

```yaml
persistence:
  config:
    enabled: true
    type: configMap
    name: mySettings
```

This will mount the contents of the pre-existing `mySettings` configMap to `/config`.

### Secret

In order to mount a Secret to a mount point within the Pod you can use the
`secret` type persistence item.

| Field           | Mandatory | Docs / Description                                                                                                 |
| --------------- | --------- | ------------------------------------------------------------------------------------------------------------------ |
| `enabled`       | Yes       |                                                                                                                    |
| `type`          | Yes       |                                                                                                                    |
| `name`          | Yes       | Which Secret should be mounted. Supports Helm templating.                                                          |
| `defaultMode`   | No        | The default file access permission bit.                                                                            |
| `items`         | No        | Specify item-specific configuration. Will be passed 1:1 to the volumeSpec.                                         |
| `readOnly`      | No        | Explicitly specify if the volume should be mounted read-only. Even if not specified, the Secret will be read-only. |

Minimal config:

```yaml
persistence:
  config:
    enabled: true
    type: secret
    name: mySecret
```

This will mount the contents of the pre-existing `mySecret` Secret to `/config`.

### NFS Volume

To mount an NFS share to your Pod you can either pre-create a persistentVolumeClaim
referring to it, or you can specify an inline NFS volume:

!!! note
    Mounting an NFS share this way does not allow for specifying mount options.
    If you require these, you must create a PVC to mount the share.

| Field           | Mandatory | Docs / Description                                                                                                 |
| --------------- | --------- | ------------------------------------------------------------------------------------------------------------------ |
| `enabled`       | Yes       |                                                                                                                    |
| `type`          | Yes       |                                                                                                                    |
| `server`        | Yes       | Host name or IP address of the NFS server.                                                                         |
| `path`          | Yes       | The path on the server to mount.                                                                                   |
| `readOnly`      | No        | Explicitly specify if the volume should be mounted read-only. Even if not specified, the Secret will be read-only. |

Minimal config:

```yaml
persistence:
  config:
    enabled: true
    type: nfs
    server: 10.10.0.8
    path: /tank/nas/library
```

This will mount the NFS share `/tank/nas/library` on server `10.10.0.8` to `/config`.

### Custom

When you wish to specify a custom volume, you can use the `custom` type.
This can be used for example to mount configMap or Secret objects.

See the [Kubernetes docs](https://kubernetes.io/docs/concepts/storage/volumes/)
for more information.

| Field           | Mandatory | Docs / Description                                                                    |
| --------------- | --------- | ------------------------------------------------------------------------------------- |
| `enabled`       | Yes       |                                                                                       |
| `type`          | Yes       |                                                                                       |
| `volumeSpec`    | Yes       | Define the raw Volume spec here.                                                      |
| `mountPath`     | No        | Where to mount the volume in the main container. Defaults to the value of `hostPath`. |
| `readOnly`      | No        | Specify if the volume should be mounted read-only.                                    |
| `nameOverride`  | No        | Override the name suffix that is used for this volume.                                |

## Permissions

Charts do not modify file or folder permissions on volumes out of the box.

This means that you will have to make sure that your storage can be written to
by the application.

## Multiple subPaths for 1 volume

It is possible to mount multiple subPaths from the same volume to the main
container. This can be achieved by specifying `subPath` with a list
instead of a string.

!!! note
    It is not possible to define `mountPath` at the top level when using this
    feature

Examples:

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
