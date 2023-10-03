{{/*
Validate container values
*/}}
{{- define "bjw-s.common.lib.container.validate" -}}
  {{- $rootContext := .rootContext -}}
  {{- $controllerObject := .controllerObject -}}
  {{- $containerObject := .containerObject -}}

  {{- if not (kindIs "map" $containerObject.image)  -}}
    {{- fail (printf "Image required to be a dictionary with repository and tag fields. (controller %s, container %s)" $controllerObject.identifier $containerObject.identifier) }}
  {{- end -}}

  {{- if eq (dig "image" "repository" "" $containerObject) ""  -}}
    {{- fail (printf "No image repository specified for container. (controller %s, container %s)" $controllerObject.identifier $containerObject.identifier) }}
  {{- end -}}

  {{- if eq (dig "image" "tag" "" $containerObject) ""  -}}
    {{- fail (printf "No image tag specified for container. (controller %s, container %s)" $controllerObject.identifier $containerObject.identifier) }}
  {{- end -}}
{{- end -}}
