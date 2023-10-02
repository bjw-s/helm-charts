---
hide:
  - toc
---

# Custom

When you wish to specify a custom volume, you can use the `custom` type.
This can be used for example to mount configMap or Secret objects.

See the [Kubernetes docs](https://kubernetes.io/docs/concepts/storage/volumes/)
for more information.

| Field        | Mandatory | Docs / Description               |
| ------------ | --------- | -------------------------------- |
| `volumeSpec` | Yes       | Define the raw Volume spec here. |

## Minimal configuration

```yaml
persistence:
  config:
    enabled: true
    type: custom
    volumeSpec:
      downwardAPI:
        items:
          - path: "labels"
            fieldRef:
              fieldPath: metadata.labels
          - path: "annotations"
            fieldRef:
              fieldPath: metadata.annotations
```
