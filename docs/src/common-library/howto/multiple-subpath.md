# Multiple subPaths for 1 volume

It is possible to mount multiple subPaths from the same volume to a
container. This can be achieved by specifying `subPath` with a list
instead of a string.

## Examples:

```yaml
persistence:
  config:
    type: configMap
    name: my-configMap
    advancedMounts:
      main: # the controller with whe "main" identifier
        main: # the container with whe "main" identifier
          - path: /data/config.yaml
            readOnly: false
            subPath: config.yaml
          - path: /data/secondConfigFile.yaml
            readOnly: false
            subPath: secondConfigFile.yaml
        second-container: # the container with whe "second-container" identifier
          - path: /appdata/config
            readOnly: true
      second-controller: # the controller with whe "second-controller" identifier
        main: # the container with whe "main" identifier
          - path: /data/config.yaml
            readOnly: false
            subPath: config.yaml
```
