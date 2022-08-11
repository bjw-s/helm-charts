# Deployment example using Kustomize

### Deployment

#### Build

In order to view the resulting manifest for this example through Kustomize, issue
the following command:

```console
kubectl kustomize --enable-helm .
```

This will print the rendered manifest(s) to your console.

#### Apply

In order to deploy the manifest for this example through Kustomize, issue the
following command:

```console
kubectl kustomize --enable-helm . | kubectl apply -f -
```

This will apply the rendered manifest(s) to your cluster.
