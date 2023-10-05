---
hide:
  - toc
---

# Multiple subPaths for 1 volume

It is possible to mount multiple subPaths from the same volume to a
container. This can be achieved by specifying `subPath` with a list
instead of a string.

## Example

```yaml
persistence:
  config:
    type: configMap
    name: my-configMap
    advancedMounts:
      main: # (1)!
        main: # (2)!
          - path: /data/config.yaml
            readOnly: false
            subPath: config.yaml
          - path: /data/secondConfigFile.yaml
            readOnly: false
            subPath: secondConfigFile.yaml
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
