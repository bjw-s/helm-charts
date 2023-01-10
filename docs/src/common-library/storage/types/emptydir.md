# Empty Dir

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

## Minimal configuration:

```yaml
persistence:
  config:
    enabled: true
    type: emptyDir
```

This will create an ephemeral emptyDir volume and mount it to `/config`.
