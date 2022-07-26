{{/*
Default NOTES.txt content.
*/}}
{{- define "common.notes.defaultNotes" -}}

{{- $primaryIngress := get .Values.ingress (include "common.ingress.primary" .) -}}
{{- $primaryService := get .Values.service (include "common.service.primary" .) -}}
{{- $primaryPort := "" -}}
{{- if $primaryService -}}
  {{- $primaryPort = get $primaryService.ports (include "common.classes.service.ports.primary" (dict "serviceName" (include "common.service.primary" .) "values" $primaryService)) -}}
{{- end -}}

{{- $prefix := "http" -}}
{{- if $primaryPort }}
  {{- if hasKey $primaryPort "protocol" }}
  {{- if eq $primaryPort.protocol "HTTPS" }}
    {{- $prefix = "https" }}
  {{- end }}
  {{- end }}
{{- end }}

{{- if $primaryIngress }}
1. Access the application by visiting one of these URL's:
{{ range $primaryIngress.hosts }}
  {{- $protocol := "http" -}}
  {{ if $primaryIngress.tls -}}
    {{- $prefix = "https" -}}
  {{ end -}}
  {{- $host := .host -}}
  {{ if .hostTpl -}}
    {{- $host = tpl .hostTpl $ -}}
  {{ end }}
  {{- $path := (first .paths).path | default "/" -}}
  {{ if (first .paths).pathTpl -}}
    {{- $path = tpl (first .paths).pathTpl $ -}}
  {{ end }}
  - {{ $protocol }}://{{- $host }}{{- $path }}
{{- end }}
{{- else if and $primaryService $primaryPort }}
1. Get the application URL by running these commands:
{{- if contains "NodePort" $primaryService.type }}
  export NODE_PORT=$(kubectl get --namespace {{ .Release.Namespace }} -o jsonpath="{.spec.ports[0].nodePort}" services {{ include "common.names.fullname" . }})
  export NODE_IP=$(kubectl get nodes --namespace {{ .Release.Namespace }} -o jsonpath="{.items[0].status.addresses[0].address}")
  echo {{ $prefix }}://$NODE_IP:$NODE_PORT
{{- else if contains "LoadBalancer" $primaryService.type }}
     NOTE: It may take a few minutes for the LoadBalancer IP to be available.
           You can watch the status of by running 'kubectl get svc -w {{ include "common.names.fullname" . }}'
  export SERVICE_IP=$(kubectl get svc --namespace {{ .Release.Namespace }} {{ include "common.names.fullname" . }} -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
  echo {{ $prefix }}://$SERVICE_IP:{{ $primaryPort.port }}
{{- else if contains "ClusterIP" $primaryService.type }}
  export POD_NAME=$(kubectl get pods --namespace {{ .Release.Namespace }} -l "app.kubernetes.io/name={{ include "common.names.name" . }},app.kubernetes.io/instance={{ .Release.Name }}" -o jsonpath="{.items[0].metadata.name}")
  echo "Visit {{ $prefix }}://127.0.0.1:8080 to use your application"
  kubectl port-forward $POD_NAME 8080:{{ $primaryPort.port }}
{{- end }}
{{- end }}
{{- end -}}
