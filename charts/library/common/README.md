# common

![Version: 3.0.0-beta2](https://img.shields.io/badge/Version-3.0.0--beta2-informational?style=flat-square) ![Type: library](https://img.shields.io/badge/Type-library-informational?style=flat-square)

Function library for Helm charts

## Requirements

Kubernetes: `>=1.22.0-0`

## Dependencies

| Repository | Name | Version |
|------------|------|---------|

## Installing the Chart

This is a [Helm Library Chart](https://helm.sh/docs/topics/library_charts/#helm).

**🚨 WARNING: THIS CHART IS NOT MEANT TO BE INSTALLED DIRECTLY**

## Using this library

Include this chart as a dependency in your `Chart.yaml` e.g.

```yaml
# Chart.yaml
dependencies:
  - name: common
    version: 3.0.0-beta2
    repository: https://bjw-s.github.io/helm-charts/
```

For more information, take a look at the [Docs](http://bjw-s.github.io/helm-charts/docs/common-library/introduction/).

## Configuration

Read through the [values.yaml](./values.yaml) file. It has several commented out suggested values.

## Values

**Important**: When deploying an application Helm chart you can add more values from the common library chart [here](https://github.com/bjw-s/helm-charts/tree/main/charts/library/common)

The following table contains an overview of available values and their descriptions / default values.

<details>
<summary>Expand</summary>

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| configMaps | object | See below | Configure configMaps for the chart here. Additional configMaps can be added by adding a dictionary key similar to the 'config' object. |
| controllers | object | `{}` |  |
| defaultPodOptions | object | `{"affinity":{},"annotations":{},"automountServiceAccountToken":true,"dnsConfig":{},"dnsPolicy":"","enableServiceLinks":false,"hostAliases":[],"hostIPC":false,"hostNetwork":false,"hostPID":false,"hostname":"","imagePullSecrets":[],"labels":{},"nodeSelector":{},"priorityClassName":"","restartPolicy":"","runtimeClassName":"","schedulerName":"","securityContext":{},"terminationGracePeriodSeconds":null,"tolerations":[],"topologySpreadConstraints":[]}` | Set default options for all controllers / pods here Each of these options can be overridden on a Controller level |
| defaultPodOptions.affinity | object | `{}` | Defines affinity constraint rules. [[ref]](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity) |
| defaultPodOptions.annotations | object | `{}` | Set annotations on the Pod. Pod-specific values will be merged with this. |
| defaultPodOptions.automountServiceAccountToken | bool | `true` | Specifies whether a service account token should be automatically mounted. |
| defaultPodOptions.dnsConfig | object | `{}` | Configuring the ndots option may resolve nslookup issues on some Kubernetes setups. |
| defaultPodOptions.dnsPolicy | string | `""` | Defaults to "ClusterFirst" if hostNetwork is false and "ClusterFirstWithHostNet" if hostNetwork is true. |
| defaultPodOptions.enableServiceLinks | bool | `false` | Enable/disable the generation of environment variables for services. [[ref]](https://kubernetes.io/docs/concepts/services-networking/connect-applications-service/#accessing-the-service) |
| defaultPodOptions.hostAliases | list | `[]` | Use hostAliases to add custom entries to /etc/hosts - mapping IP addresses to hostnames. [[ref]](https://kubernetes.io/docs/concepts/services-networking/add-entries-to-pod-etc-hosts-with-host-aliases/) |
| defaultPodOptions.hostIPC | bool | `false` | Use the host's ipc namespace |
| defaultPodOptions.hostNetwork | bool | `false` | When using hostNetwork make sure you set dnsPolicy to `ClusterFirstWithHostNet` |
| defaultPodOptions.hostPID | bool | `false` | Use the host's pid namespace |
| defaultPodOptions.hostname | string | `""` | Allows specifying explicit hostname setting |
| defaultPodOptions.imagePullSecrets | list | `[]` | Set image pull secrets |
| defaultPodOptions.labels | object | `{}` | Set labels on the Pod. Pod-specific values will be merged with this. |
| defaultPodOptions.nodeSelector | object | `{}` | Node selection constraint [[ref]](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) |
| defaultPodOptions.priorityClassName | string | `""` | Custom priority class for different treatment by the scheduler |
| defaultPodOptions.restartPolicy | string | `Always`. When `controller.type` is `cronjob` it defaults to `Never`. | Set Container restart policy. |
| defaultPodOptions.runtimeClassName | string | `""` | Allow specifying a runtimeClassName other than the default one (ie: nvidia) |
| defaultPodOptions.schedulerName | string | `""` | Allows specifying a custom scheduler name |
| defaultPodOptions.securityContext | object | `{}` | Configure the Security Context for the Pod |
| defaultPodOptions.terminationGracePeriodSeconds | string | `nil` | [[ref](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#lifecycle)] |
| defaultPodOptions.tolerations | list | `[]` | Specify taint tolerations [[ref]](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) |
| defaultPodOptions.topologySpreadConstraints | list | `[]` | Defines topologySpreadConstraint rules. [[ref]](https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/) |
| global.annotations | object | `{}` | Set additional global annotations. Helm templates can be used. |
| global.fullnameOverride | string | `nil` | Set the entire name definition |
| global.labels | object | `{}` | Set additional global labels. Helm templates can be used. |
| global.nameOverride | string | `nil` | Set an override for the prefix of the fullname |
| ingress | object | `{}` | Configure the ingresses for the chart here. |
| networkpolicies | object | See below | Configure the networkPolicies for the chart here. Additional networkPolicies can be added by adding a dictionary key similar to the 'main' networkPolicy. |
| persistence | object | See below | Configure persistence for the chart here. Additional items can be added by adding a dictionary key similar to the 'config' key. [[ref]](https://bjw-s.github.io/helm-charts/docs/common-library/common-library-storage) |
| route | object | See below | Configure the gateway routes for the chart here. Additional routes can be added by adding a dictionary key similar to the 'main' route. [[ref]](https://gateway-api.sigs.k8s.io/references/spec/) |
| secrets | object | See below | Use this to populate secrets with the values you specify. Be aware that these values are not encrypted by default, and could therefore visible to anybody with access to the values.yaml file. Additional Secrets can be added by adding a dictionary key similar to the 'secret' object. |
| service | object | See below | Configure the services for the chart here. Additional services can be added by adding a dictionary key similar to the 'main' service. |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `false` | Specifies whether a service account should be created |
| serviceAccount.labels | object | `{}` | Labels to add to the service account |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| serviceMonitor | object | See below | Configure the ServiceMonitors for the chart here. Additional ServiceMonitors can be added by adding a dictionary key similar to the 'main' ServiceMonitors. |

</details>

## Support

- See the [Docs](http://bjw-s.github.io/helm-charts/docs/)
- Open an [issue](https://github.com/bjw-s/helm-charts/issues/new/choose)
- Join the k8s-at-home [Discord](https://discord.gg/k8s-at-home) community

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.12.0](https://github.com/norwoodj/helm-docs/releases/v1.12.0)
