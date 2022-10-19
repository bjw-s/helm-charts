# cAdvisor

A chart for a cAdvisor deployment

Learn more: [https://github.com/google/cadvisor](https://github.com/google/cadvisor)

## TL;DR

```bash
helm install ckotzbauer/cadvisor
```

## Introduction

This chart creates a daemonset on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.10+

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
helm install --name my-release j0sh3rs/cadvisor
```

The command deploys cAdvisor on the Kubernetes cluster using the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Upgrading from v1.x to v2.x

- `metrics.relabelings` was renamed to `metrics.metricsRelabelings` to match the ServiceMonitor CRD naming

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the cAdvisor chart and their default values.

| Parameter                      | Description                                      | Default                    |
| ------------------------------ | ------------------------------------------------ | -------------------------- |
| `image.repository`             | container image repository                       | `gcr.io/cadvisor/cadvisor` |
| `image.tag`                    | container image tag                              | `v0.44.0`                  |
| `image.pullPolicy`             | container image pull policy                      | `IfNotPresent`             |
| `image.pullSecrets`            | container image pull secrets                     | `[]`                       |
| `nodeSelector`                 | node labels for pod assignment                   | `{}`                       |
| `tolerations`                  | node tolerations for pod assignment              | `[]`                       |
| `affinity`                     | node affinity for pod assignment                 | `{}`                       |
| `container.port`               | the container and service port to use            | 8080                       |
| `container.additionalArgs`     | additional container arguments                   | see values.yaml            |
| `container.hostPaths`          | hostPaths to mount in the container              | see values.yaml            |
| `resources`                    | pod resource requests & limits                   | `{}`                       |
| `serviceAccount.create`        | create a own serviceAccount for the pod          | `true`                     |
| `serviceAccount.name`          | name of the serviceAccount to create             | `""`                       |
| `podAnnotations`               | annotations for the daemonset pods               | `{}`                       |
| `priorityClassName`            | priority classes name for the pod                | `{}`                       |
| `podSecurityPolicy.create`     | create a own PodSecurityPolicy for the pod       | `false`                    |
| `podSecurityPolicy.privileged` | create the PodSecurityPolicy as privileged       | `false`                    |
| `podSecurityContext.create`    | create the podSecurityContext in container spec  | `false`                    |
| `podSecurityContext.privileged`| set podSecurityContext privileged to true        | `false`                    |
| `metrics.enabled`              | create ServiceMonitor CR for Prometheus operator | `false`                    |
| `metrics.relabelings`          | add pre-scraping relabeling to ServiceMonitor    | `[]`                       |
| `metrics.interval`             | scraping interval for the ServiceMonitor         | `30s`                       |
| `metrics.scrapeTimeout`        | scraping timeout for the ServiceMonitor          | `30s`                       |
| `metrics.metricsRelabelings`   | add pre-ingestion relabeling to ServiceMonitor   | `[]`                       |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
    --set key_1=value_1,key_2=value_2 \
    ckotzbauer/cadvisor
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
# example for staging
$ helm install --name my-release -f values.yaml ckotzbauer/cadvisor
```

> **Tip**: You can use the default [values.yaml](values.yaml)
