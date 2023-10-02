# Persistent Volume Claim

This is probably the most common storage type, therefore it is also the
default when no `type` is specified.

It can be attached in two ways.

- [Dynamically provisioned](#dynamically-provisioned)
- [Existing claim](#existing-claim)

## Dynamically provisioned

Charts can be configured to create the required persistentVolumeClaim
manifests on the fly.

| Field          | Mandatory | Docs / Description                                                                   |
| -------------- | --------- | ------------------------------------------------------------------------------------ |
| `accessMode`   | Yes       | [link](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes) |
| `size`         | Yes       | [link](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#resources)    |
| `nameOverride` | No        | Override the name suffix that is used for this volume.                               |
| `storageClass` | No        | Storage class to use for this volume.                                                |
| `retain`       | No        | Set to true to retain the PVC upon `helm uninstall`.                                 |

### Minimal configuration

```yaml
persistence:
  config:
    enabled: true
    type: persistentVolumeClaim
    accessMode: ReadWriteOnce
    size: 1Gi
```

This will create a 1Gi RWO PVC named `RELEASE-NAME-config` with the default
storageClass, which will mount to `/config`.

## Existing claim

Charts can be configured to attach to a pre-existing persistentVolumeClaim.

| Field           | Mandatory | Docs / Description                                     |
| --------------- | --------- | ------------------------------------------------------ |
| `existingClaim` | Yes       | Name of the existing PVC                               |
| `nameOverride`  | No        | Override the name suffix that is used for this volume. |

### Minimal configuration

```yaml
persistence:
  config:
    enabled: true
    type: persistentVolumeClaim
    existingClaim: myAppData
```

This will mount an existing PVC named `myAppData` to `/config`.
