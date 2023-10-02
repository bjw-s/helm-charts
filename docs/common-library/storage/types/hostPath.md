---
hide:
  - toc
---

# Host path

In order to mount a path from the node where the Pod is running you can use a
`hostPath` type persistence item.

This can also be used to mount an attached USB device to a Pod. Note that
this will most likely also require setting an elevated `securityContext`.

See the [Kubernetes docs](https://kubernetes.io/docs/concepts/storage/volumes/#hostpath)
for more information.

| Field          | Mandatory | Docs / Description                                                                                                |
| -------------- | --------- | ----------------------------------------------------------------------------------------------------------------- |
| `hostPath`     | Yes       | Which path on the host should be mounted.                                                                         |
| `hostPathType` | No        | Specifying a hostPathType adds a check before trying to mount the path. See Kubernetes documentation for options. |

## Minimal configuration

```yaml
persistence:
  config:
    enabled: true
    type: hostPath
    hostPath: /dev
```

This will mount the `/dev` folder from the underlying host to `/dev` in the container.
