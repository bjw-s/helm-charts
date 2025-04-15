{{/*
Determine a recourse name based on Helm values
*/}}
{{- define "bjw-s.common.lib.determineResourceNameFromValues" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $objectValues := .values -}}
  {{- $itemCount := .itemCount -}}

  {{- $objectName := (include "bjw-s.common.lib.chart.names.fullname" $rootContext) -}}

  {{- if $objectValues.forceRename -}}
    {{- $objectName = tpl $objectValues.forceRename $rootContext -}}
  {{- end -}}

  {{- if not (empty $objectValues.prefix) -}}
    {{- $renderedPrefix := (tpl $objectValues.prefix $rootContext) -}}
    {{- if not (eq $objectName $renderedPrefix) -}}
      {{- $objectName = printf "%s-%s" $renderedPrefix $objectName -}}
    {{- end -}}
  {{- end -}}

  {{- if not (empty $itemCount) -}}
    {{- if (gt $itemCount 1) -}}
      {{- if not (hasSuffix (printf "-%s" $identifier) $objectName) -}}
        {{- $objectName = printf "%s-%s" $objectName $identifier -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- if not (empty $objectValues.suffix) -}}
    {{- $renderedSuffix := (tpl $objectValues.suffix $rootContext) -}}
    {{- if not (hasSuffix (printf "-%s" $renderedSuffix) $objectName) -}}
      {{- $objectName = printf "%s-%s" $objectName $renderedSuffix -}}
    {{- end -}}
  {{- end -}}

  {{- $objectName | lower -}}
{{- end -}}
