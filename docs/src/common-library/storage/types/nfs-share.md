# NFS Share

To mount an NFS share to your Pod you can either pre-create a persistentVolumeClaim
referring to it, or you can specify an inline NFS volume:

```admonish note
Mounting an NFS share this way does not allow for specifying mount options.
If you require these, you must create a PVC to mount the share.
```

| Field           | Mandatory | Docs / Description                                                                                                 |
| --------------- | --------- | ------------------------------------------------------------------------------------------------------------------ |
| `enabled`       | Yes       |                                                                                                                    |
| `type`          | Yes       |                                                                                                                    |
| `server`        | Yes       | Host name or IP address of the NFS server.                                                                         |
| `path`          | Yes       | The path on the server to mount.                                                                                   |
| `mountPath`     | No        | The path on the pod to mount to. Defaults to `/<name-of-the-volume>`                                               |
| `readOnly`      | No        | Explicitly specify if the volume should be mounted read-only. Even if not specified, the Secret will be read-only. |

## Minimal configuration:

```yaml
persistence:
  config:
    enabled: true
    type: nfs
    server: 10.10.0.8
    path: /tank/nas/library
```

This will mount the NFS share `/tank/nas/library` on server `10.10.0.8` to `/config`.
