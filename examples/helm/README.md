# Deployment example using Helm

### Prerequisites

Makre sure the Helm repository is installed as follows:

```console
helm repo add tomroush https://tomroush.github.io/helm-charts
helm repo update
```

### Deployment

In order to deploy the manifest for this example, issue the
following command:

```console
helm install vaultwarden tomroush/app-template --namespace default --values values.yaml
```

This will apply the rendered manifest(s) to your cluster.
