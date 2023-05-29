{{- /*
The pod definition included in the controller.
*/ -}}
{{- define "bjw-s.common.lib.pod.spec" -}}
  {{- $rootContext := .rootContext -}}
  {{- $controllerObject := .controllerObject -}}
  {{- $ctx := dict "rootContext" $rootContext "controllerObject" $controllerObject -}}

enableServiceLinks: {{ $controllerObject.pod.enableServiceLinks }}
serviceAccountName: {{ include "bjw-s.common.lib.pod.field.serviceAccountName" (dict "ctx" $ctx) | trim }}
automountServiceAccountToken: {{ $controllerObject.pod.automountServiceAccountToken }}
  {{- with ($controllerObject.pod.priorityClassName) }}
priorityClassName: {{ . | trim }}
  {{- end -}}
  {{- with ($controllerObject.pod.runtimeClassName) }}
runtimeClassName: {{ . | trim }}
  {{- end -}}
  {{- with ($controllerObject.pod.schedulerName) }}
schedulerName: {{ . | trim }}
  {{- end -}}
  {{- with ($controllerObject.pod.securityContext) }}
securityContext: {{ . | trim | nindent 2 }}
  {{- end -}}
  {{- with ($controllerObject.pod.hostname) }}
hostname: {{ . | trim }}
  {{- end }}
hostIPC: {{ $controllerObject.pod.hostIPC }}
hostNetwork: {{ $controllerObject.pod.hostNetwork }}
hostPID: {{ $controllerObject.pod.hostPID }}
dnsPolicy: {{ include "bjw-s.common.lib.pod.field.dnsPolicy" (dict "ctx" $ctx) | trim }}
  {{- with $controllerObject.pod.dnsConfig }}
dnsConfig: {{ . | trim | nindent 2 }}
  {{- end -}}
  {{- with $controllerObject.pod.hostAliases }}
hostAliases: {{ . | trim | nindent 2 }}
  {{- end -}}
  {{- with $controllerObject.pod.imagePullSecrets }}
imagePullSecrets: {{ . | trim | nindent 2 }}
  {{- end -}}
  {{- with $controllerObject.pod.terminationGracePeriodSeconds }}
terminationGracePeriodSeconds: {{ . | trim }}
  {{- end -}}
  {{- with $controllerObject.pod.restartPolicy }}
restartPolicy: {{ . | trim }}
  {{- end -}}
  {{- with $controllerObject.pod.nodeSelector }}
nodeSelector: {{ . | trim | nindent 2 }}
  {{- end -}}
  {{- with $controllerObject.pod.affinity }}
affinity: {{ . | trim | nindent 2 }}
  {{- end -}}
  {{- with $controllerObject.pod.topologySpreadConstraints }}
topologySpreadConstraints: {{ . | trim | nindent 2 }}
  {{- end -}}
  {{- with $controllerObject.pod.tolerations }}
tolerations: {{ . | trim | nindent 2 }}
  {{- end }}
  {{- with (include "bjw-s.common.lib.pod.field.initContainers" (dict "ctx" $ctx) | trim) }}
initContainers: {{ . | nindent 2 }}
  {{- end -}}
  {{- with (include "bjw-s.common.lib.pod.field.containers" (dict "ctx" $ctx) | trim) }}
containers: {{ . | nindent 2 }}
  {{- end -}}
  {{- with (include "bjw-s.common.lib.pod.field.volumes" (dict "ctx" $ctx) | trim) }}
volumes: {{ . | nindent 2 }}
  {{- end -}}

{{- /*
  {{- if .Values.initContainers }}
initContainers:
    {{- $initContainers := list }}
    {{- range $index, $key := (keys .Values.initContainers | uniq | sortAlpha) }}
      {{- $container := get $.Values.initContainers $key }}
      {{- if not $container.name -}}
        {{- $_ := set $container "name" $key }}
      {{- end }}
      {{- if $container.env -}}
        {{- $newEnv := fromYaml (include "bjw-s.common.lib.container.envVars" (dict "rootContext" $ "env" $container.env)) -}}
        {{- $_ := set $container "env" $newEnv.env }}
      {{- end }}
      {{- $initContainers = append $initContainers $container }}
    {{- end }}
    {{- tpl (toYaml $initContainers) $ | nindent 2 }}
  {{- end }}
containers:
  {{- include "bjw-s.common.lib.controller.mainContainer" . | nindent 2 }}
  {{- with (merge .Values.sidecars .Values.additionalContainers) }}
    {{- $sidecarContainers := list }}
    {{- range $name, $container := . }}
      {{- if not $container.name -}}
        {{- $_ := set $container "name" $name }}
      {{- end }}
      {{- if $container.env -}}
        {{- $newEnv := fromYaml (include "bjw-s.common.lib.container.envVars" (dict "rootContext" $ "env" $container.env)) -}}
        {{- $_ := set $container "env" $newEnv.env }}
      {{- end }}
      {{- $sidecarContainers = append $sidecarContainers $container }}
    {{- end }}
    {{- tpl (toYaml $sidecarContainers) $ | nindent 2 }}
  {{- end }}
  {{- with (include "bjw-s.common.lib.controller.volumes" . | trim) }}
volumes:
    {{- nindent 2 . }}
  {{- end }}
  */ -}}
{{- end -}}
