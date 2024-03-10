---
hide:
  - toc
---

# Secret

In order to mount a Secret to a mount point within the Pod you can use the
`secret` type persistence item.

| Field         | Mandatory | Docs / Description                                                         |
| ------------- | --------- | -------------------------------------------------------------------------- |
| `name`        | No        | Which Secret should be mounted. Supports Helm templating.                  |
| `identifier`  | No        | Reference a Secret from the `secrets` key by its identifier.               |
| `defaultMode` | No        | The default file access permission bit.                                    |
| `items`       | No        | Specify item-specific configuration. Will be passed 1:1 to the volumeSpec. |

Either `name` or `identifier` is required.

!!! note

    Even if not specified, the Secret will be read-only.

## Minimal configuration

```yaml
persistence:
  config:
    enabled: true
    type: secret
    name: mySecret
```

This will mount the contents of the pre-existing `mySecret` Secret to `/config`.
