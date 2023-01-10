# Persistent Volume Claim

This is probably the most common storage type, therefore it is also the
default when no `type` is specified.

It can be attached in two ways.

- [Dynamically provisioned](#dynamically-provisioned)
- [Existing claim](#existing-claim)

## Dynamically provisioned

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

### Minimal configuration:

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

## Existing claim

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

### Minimal configuration:

```yaml
persistence:
  config:
    enabled: true
    type: pvc
    existingClaim: myAppData
```

This will mount an existing PVC named `myAppData` to `/config`.
