{{/*
Renders the serviceAccount object required by the chart.
*/}}
{{- define "bjw-s.common.render.serviceAccount" -}}
  {{- if .Values.serviceAccount.create -}}
    {{- $serviceAccountValues := (mustDeepCopy .Values.serviceAccount) -}}

    {{- /* Create object from the raw ServiceAccount values */ -}}
    {{- $serviceAccountObject := (include "bjw-s.common.lib.serviceAccount.valuesToObject" (dict "rootContext" $ "id" "default" "values" $serviceAccountValues)) | fromYaml -}}

    {{- /* Perform validations on the ServiceAccount before rendering */ -}}
    {{- include "bjw-s.common.lib.serviceAccount.validate" (dict "rootContext" $ "object" $serviceAccountObject) -}}

    {{- /* Create a service account secret */ -}}
    {{- $_ := set .Values.secrets (printf "%s-sa-token" $serviceAccountObject.identifier) (dict "enabled" true "annotations" (dict "kubernetes.io/service-account.name" $serviceAccountObject.name) "type" "kubernetes.io/service-account-token") -}}

    {{/* Include the serviceAccount class */}}
    {{- include "bjw-s.common.class.serviceAccount" (dict "rootContext" $ "object" $serviceAccountObject) | nindent 0 -}}

  {{- end -}}

  {{- /* Generate named serviceAccount objects as required */ -}}
  {{- with .Values.serviceAccount.extraServiceAccounts -}}
    {{- range $key, $serviceAccount := . -}}
      {{- $serviceAccountEnabled := true -}}
      {{- if hasKey $serviceAccount "create" -}}
        {{- $serviceAccountEnabled = $serviceAccount.create -}}
      {{- end -}}

      {{- if $serviceAccountEnabled -}}
        {{- $serviceAccountValues := $serviceAccount -}}

        {{- /* Create object from the raw ServiceAccount values */ -}}
        {{- $serviceAccountObject := (include "bjw-s.common.lib.serviceAccount.valuesToObject" (dict "rootContext" $ "id" $key "values" $serviceAccountValues)) | fromYaml -}}

        {{- /* Perform validations on the ServiceAccount before rendering */ -}}
        {{- include "bjw-s.common.lib.serviceAccount.validate" (dict "rootContext" $ "object" $serviceAccountObject) -}}

        {{- /* Create a service account secret */ -}}
        {{- $_ := set $.Values.secrets (printf "%s-sa-token" $serviceAccountObject.identifier) (dict "enabled" true "annotations" (dict "kubernetes.io/service-account.name" $serviceAccountObject.name) "type" "kubernetes.io/service-account-token") -}}

        {{/* Include the serviceAccount class */}}
        {{- include "bjw-s.common.class.serviceAccount" (dict "rootContext" $ "object" $serviceAccountObject) | nindent 0 -}}

      {{- end -}}
    {{- end -}}
  {{- end -}}

{{- end -}}
