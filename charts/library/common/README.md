# common

![Version: 3.0.0](https://img.shields.io/badge/Version-3.0.0-informational?style=flat-square) ![Type: library](https://img.shields.io/badge/Type-library-informational?style=flat-square)

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
    version: 3.0.0
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
| networkpolicies.main.controller | string | `"main"` | Configure which controller this networkPolicy should target |
| networkpolicies.main.enabled | bool | `false` | Enables or disables the networkPolicy item. Defaults to true |
| networkpolicies.main.policyTypes | list | `["Ingress","Egress"]` | The policyTypes for this networkPolicy |
| networkpolicies.main.rules | object | `{"egress":[{}],"ingress":[{}]}` | The rulesets for this networkPolicy [[ref]](https://kubernetes.io/docs/concepts/services-networking/network-policies/#networkpolicy-resource) |
| networkpolicies.main.rules.egress | list | `[{}]` | The egress rules for this networkPolicy. Allows all egress traffic by default. |
| networkpolicies.main.rules.ingress | list | `[{}]` | The ingress rules for this networkPolicy. Allows all ingress traffic by default. |
| persistence | object | See below | Configure persistence for the chart here. Additional items can be added by adding a dictionary key similar to the 'config' key. [[ref]](https://bjw-s.github.io/helm-charts/docs/common-library/common-library-storage) |
| route | object | See below | Configure the gateway routes for the chart here. Additional routes can be added by adding a dictionary key similar to the 'main' route. [[ref]](https://gateway-api.sigs.k8s.io/references/spec/) |
| secrets | object | See below | Use this to populate secrets with the values you specify. Be aware that these values are not encrypted by default, and could therefore visible to anybody with access to the values.yaml file. Additional Secrets can be added by adding a dictionary key similar to the 'secret' object. |
| service | object | See below | Configure the services for the chart here. Additional services can be added by adding a dictionary key similar to the 'main' service. |
| service.main.annotations | object | `{}` | Provide additional annotations which may be required. |
| service.main.controller | string | `"main"` | Configure which controller this service should target |
| service.main.enabled | bool | `true` | Enables or disables the service |
| service.main.externalTrafficPolicy | string | `nil` | [[ref](https://kubernetes.io/docs/tutorials/services/source-ip/)] |
| service.main.extraSelectorLabels | object | `{}` | Allow adding additional match labels |
| service.main.ipFamilies | list | `[]` | The ip families that should be used. Options: IPv4, IPv6 |
| service.main.ipFamilyPolicy | string | `nil` | Specify the ip policy. Options: SingleStack, PreferDualStack, RequireDualStack |
| service.main.labels | object | `{}` | Provide additional labels which may be required. |
| service.main.nameOverride | string | `nil` | Override the name suffix that is used for this service |
| service.main.ports | object | See below | Configure the Service port information here. Additional ports can be added by adding a dictionary key similar to the 'http' service. |
| service.main.ports.http.appProtocol | string | `nil` | Specify the appProtocol value for the Service. [[ref]](https://kubernetes.io/docs/concepts/services-networking/service/#application-protocol) |
| service.main.ports.http.enabled | bool | `true` | Enables or disables the port |
| service.main.ports.http.nodePort | string | `nil` | Specify the nodePort value for the LoadBalancer and NodePort service types. [[ref]](https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport) |
| service.main.ports.http.port | string | `nil` | The port number |
| service.main.ports.http.primary | bool | `true` | Make this the primary port (used in probes, notes, etc...) If there is more than 1 service, make sure that only 1 port is marked as primary. |
| service.main.ports.http.protocol | string | `"HTTP"` | Port protocol. Support values are `HTTP`, `HTTPS`, `TCP` and `UDP`. HTTP and HTTPS spawn a TCP service and get used for internal URL and name generation |
| service.main.ports.http.targetPort | string | `nil` | Specify a service targetPort if you wish to differ the service port from the application port. If `targetPort` is specified, this port number is used in the container definition instead of the `port` value. Therefore named ports are not supported for this field. |
| service.main.primary | bool | `true` | Make this the primary service for this controller (used in probes, notes, etc...). If there is more than 1 service targeting the controller, make sure that only 1 service is marked as primary. |
| service.main.type | string | `"ClusterIP"` | Set the service type |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `false` | Specifies whether a service account should be created |
| serviceAccount.labels | object | `{}` | Labels to add to the service account |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| serviceMonitor | object | See below | Configure the ServiceMonitors for the chart here. Additional ServiceMonitors can be added by adding a dictionary key similar to the 'main' ServiceMonitors. |
| serviceMonitor.main.annotations | object | `{}` | Provide additional annotations which may be required. |
| serviceMonitor.main.enabled | bool | `false` | Enables or disables the serviceMonitor. |
| serviceMonitor.main.endpoints | list | See values.yaml | Configures the endpoints for the serviceMonitor. |
| serviceMonitor.main.labels | object | `{}` | Provide additional labels which may be required. |
| serviceMonitor.main.nameOverride | string | `nil` | Override the name suffix that is used for this serviceMonitor. |
| serviceMonitor.main.selector | object | `{}` | Configures a custom selector for the serviceMonitor, this takes precedence over specifying a service name. Helm templates can be used. |
| serviceMonitor.main.serviceName | string | `"{{ include \"bjw-s.common.lib.chart.names.fullname\" $ }}"` | Configures the target Service for the serviceMonitor. Helm templates can be used. |
| serviceMonitor.main.targetLabels | list | `[]` | Configures custom targetLabels for the serviceMonitor. (All collected meterics will have these labels, taking the value from the target service) [[ref]](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#servicemonitorspec/) |

</details>

## Support

- See the [Docs](http://bjw-s.github.io/helm-charts/docs/)
- Open an [issue](https://github.com/bjw-s/helm-charts/issues/new/choose)
- Join the k8s-at-home [Discord](https://discord.gg/k8s-at-home) community

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.12.0](https://github.com/norwoodj/helm-docs/releases/v1.12.0)
