{{- define "k8s-ycl.webhookPort" -}}
9443
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
