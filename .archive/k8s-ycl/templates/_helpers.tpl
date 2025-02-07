{{- define "k8s-ycl.init" -}}
  {{/* Make sure all variables are set properly */}}
  {{- include "bjw-s.common.loader.init" . }}

  {{- $_ := include "k8s-ycl.hardcodedValues" . | fromYaml | merge .Values -}}
{{- end -}}

{{- define "k8s-ycl.webhookPort" -}}
9443
{{- end -}}

{{- define "k8s-ycl.webhookPath" -}}
/mutate--v1-pod
{{- end -}}

{{- define "k8s-ycl.ignoredNamespaces" -}}
  {{- $ownNamespace := $.Release.Namespace -}}
  {{- $ignoredNamespaces := list -}}
  {{- if $.Values.webhook.ignoreOwnNamespace -}}
    {{- $ignoredNamespaces = append $ignoredNamespaces $ownNamespace -}}
  {{- end -}}
  {{- with $.Values.webhook.ignoredNamespaces -}}
    {{- range . -}}
      {{- $ignoredNamespaces = append $ignoredNamespaces . -}}
    {{- end -}}
  {{- end -}}
  {{- $ignoredNamespaces | uniq | toYaml -}}
{{- end -}}

{{- define "k8s-ycl.selfSignedIssuer" -}}
{{ printf "%s-webhook-selfsign" (include "bjw-s.common.lib.chart.names.fullname" .) }}
{{- end -}}

{{- define "k8s-ycl.rootCAIssuer" -}}
{{ printf "%s-webhook-ca" (include "bjw-s.common.lib.chart.names.fullname" .) }}
{{- end -}}

{{- define "k8s-ycl.rootCACertificate" -}}
{{ printf "%s-webhook-ca" (include "bjw-s.common.lib.chart.names.fullname" .) }}
{{- end -}}

{{- define "k8s-ycl.servingCertificate" -}}
{{ printf "%s-webhook-tls" (include "bjw-s.common.lib.chart.names.fullname" .) }}
{{- end -}}
