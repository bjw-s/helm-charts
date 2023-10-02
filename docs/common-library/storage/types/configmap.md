---
hide:
  - toc
---

# ConfigMap

In order to mount a configMap to a mount point within the Pod you can use the
`configMap` type persistence item.

| Field         | Mandatory | Docs / Description                                                         |
| ------------- | --------- | -------------------------------------------------------------------------- |
| `name`        | Yes       | Which configMap should be mounted. Supports Helm templating.               |
| `defaultMode` | No        | The default file access permission bit.                                    |
| `items`       | No        | Specify item-specific configuration. Will be passed 1:1 to the volumeSpec. |

!!! note

    Even if not specified, the configMap will be read-only.

## Minimal configuration

```yaml
persistence:
  config:
    enabled: true
    type: configMap
    name: mySettings
```

This will mount the contents of the pre-existing `mySettings` configMap to `/config`.
