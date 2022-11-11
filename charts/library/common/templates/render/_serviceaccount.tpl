{{/*
Renders the serviceAccount object required by the chart.
*/}}
{{- define "bjw-s.common.render.serviceAccount" -}}
  {{- if .Values.serviceAccount.create -}}

    {{- /* Create a service account secret */ -}}
    {{- $_ := set .Values.secrets "sa-token" (dict "enabled" true "type" "kubernetes.io/service-account-token") -}}

    {{- include "bjw-s.common.class.serviceAccount" $ | nindent 0 -}}
  {{- end -}}
{{- end -}}

# serviceAccount:
#   # -- Specifies whether a service account should be created
#   create: false

#   # -- Annotations to add to the service account
#   annotations: {}

#   # -- The name of the service account to use.
#   # If not set and create is true, a name is generated using the fullname template
#   name: ""
