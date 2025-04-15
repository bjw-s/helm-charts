{{/*
Renders the Secret objects required by the chart.
*/}}
{{- define "bjw-s.common.render.secrets" -}}
  {{- $rootContext := $ -}}

  {{- /* Generate named Secrets as required */ -}}
  {{- $enabledSecrets := (include "bjw-s.common.lib.secret.enabledSecrets" (dict "rootContext" $rootContext) | fromYaml ) -}}

  {{- range $identifier := keys $enabledSecrets -}}
    {{- /* Generate object from the raw secret values */ -}}
    {{- $secretObject := (include "bjw-s.common.lib.secret.getByIdentifier" (dict "rootContext" $rootContext "id" $identifier) | fromYaml) -}}

    {{- /* Include the Secret class */ -}}
    {{- include "bjw-s.common.class.secret" (dict "rootContext" $rootContext "object" $secretObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}
