{{- /*
Returns the value for initContainers
*/ -}}
{{- define "bjw-s.common.lib.pod.field.initContainers" -}}
  {{- $rootContext := .ctx.rootContext -}}
  {{- $controllerObject := .ctx.controllerObject -}}

  {{- /* Default to empty list */ -}}
  {{- $containers := list -}}

  {{- /* Fetch configured containers for this controller */ -}}
  {{- if not (empty $rootContext.Values.initContainers) -}}
    {{- $controllerID := $controllerObject.identifier -}}
    {{- range $key, $containerValues := $rootContext.Values.initContainers -}}
      {{- if not (empty $containerValues.controller) -}}
        {{- /* Create object from the container values */ -}}
        {{- $containerObject := (include "bjw-s.common.lib.container.valuesToObject" (dict "rootContext" $ "id" $key "values" $containerValues)) | fromYaml -}}

        {{- /* Perform validations on the Container before rendering */ -}}
        {{- include "bjw-s.common.lib.container.validate" (dict "rootContext" $ "object" $containerObject) -}}

        {{- /* Generate the Container spec */ -}}
        {{- $renderedContainer := include "bjw-s.common.lib.container.spec" (dict "rootContext" $rootContext "containerObject" $containerObject) | fromYaml -}}
        {{- $containers = append $containers $renderedContainer -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- if not (empty $containers) -}}
    {{- $containers | toYaml -}}
  {{- end -}}
{{- end -}}
