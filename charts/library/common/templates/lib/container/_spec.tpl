{{- /*
The container definition included in the Pod.
*/ -}}
{{- define "bjw-s.common.lib.container.spec" -}}
  {{- $rootContext := .rootContext -}}
  {{- $containerObject := .containerObject -}}
  {{- $ctx := dict "rootContext" $rootContext "containerObject" $containerObject -}}

name: {{ include "bjw-s.common.lib.container.field.name" (dict "ctx" $ctx) | trim }}
image: {{ include "bjw-s.common.lib.container.field.image" (dict "ctx" $ctx) | trim }}
  {{- with $containerObject.image.pullPolicy }}
imagePullPolicy: {{ . | trim }}
  {{- end -}}
  {{- with (include "bjw-s.common.lib.container.field.command" (dict "ctx" $ctx) | trim) }}
command: {{ . | trim | nindent 2 }}
  {{- end -}}
  {{- with (include "bjw-s.common.lib.container.field.args" (dict "ctx" $ctx) | trim) }}
args: {{ . | trim | nindent 2 }}
  {{- end -}}
  {{- with $containerObject.securityContext }}
securityContext: {{ toYaml . | trim | nindent 2 }}
  {{- end -}}
  {{- with $containerObject.lifecycle }}
lifecycle: {{ toYaml . | trim | nindent 2 }}
  {{- end -}}
  {{- with $containerObject.terminationMessagePath }}
terminationMessagePath: {{ . | trim }}
  {{- end -}}
  {{- with $containerObject.terminationMessagePolicy }}
terminationMessagePolicy: {{ . | trim }}
  {{- end -}}
  {{- with (include "bjw-s.common.lib.container.field.env" (dict "ctx" $ctx) | trim) }}
env: {{ . | trim | nindent 2 }}
  {{- end -}}
{{- with $containerObject.envFrom }}
envFrom: {{ toYaml . | trim | nindent 2 }}
  {{- end -}}
  {{- with (include "bjw-s.common.lib.container.field.ports" (dict "ctx" $ctx) | trim) }}
ports: {{- . | trim | nindent 2 }}
  {{- end -}}

  {{- with $containerObject.resources }}
resources: {{ toYaml . | trim | nindent 2 }}
  {{- end -}}
{{- end -}}
