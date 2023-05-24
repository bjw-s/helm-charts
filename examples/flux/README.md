# Deployment example using a Flux HelmRelease

### Prerequisites

Make sure that the [`tomroush-helm-charts` HelmRepository](helmrepository.yaml) is added to your cluster.

### Deployment

When you add the [HelmRelease](helmrelease.yaml) to your cluster, Flux will automatically render and
apply the rendered manifest(s) to your cluster.
