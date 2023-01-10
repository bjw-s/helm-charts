# Custom

When you wish to specify a custom volume, you can use the `custom` type.
This can be used for example to mount configMap or Secret objects.

See the [Kubernetes docs](https://kubernetes.io/docs/concepts/storage/volumes/)
for more information.

| Field           | Mandatory | Docs / Description                                                                    |
| --------------- | --------- | ------------------------------------------------------------------------------------- |
| `enabled`       | Yes       |                                                                                       |
| `type`          | Yes       |                                                                                       |
| `volumeSpec`    | Yes       | Define the raw Volume spec here.                                                      |
| `mountPath`     | No        | Where to mount the volume in the main container. Defaults to the value of `hostPath`. |
| `readOnly`      | No        | Specify if the volume should be mounted read-only.                                    |
| `nameOverride`  | No        | Override the name suffix that is used for this volume.                                |
