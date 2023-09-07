# Helm templates

Some fields in the common library `values.yaml` allow the use of Helm templates for their values.
This is often indicated by a remark similar to `Helm template enabled` in the field description.

This feature allows you to set the value of that key to the output of the given Helm template.

## Example:

Given the following `values.yaml`

```yaml
image:
  repository: k8s.gcr.io/git-sync/git-sync
  tag: v3.6.2

sidecars:
  subcleaner:
    name: subcleaner
    image: |-
      {{ printf "%s:%s" .Values.image.repository (default .Chart.AppVersion .Values.image.tag) | quote }}
    args:
      - --repo=https://github.com/KBlixt/subcleaner.git
      - --branch=master
      - --depth=1
      - --root=/add-ons/subcleaner
```

This would render as follows:

```yaml
image:
  repository: k8s.gcr.io/git-sync/git-sync
  tag: v3.6.2

sidecars:
  subcleaner:
    name: subcleaner
    image: k8s.gcr.io/git-sync/git-sync:v3.6.2
    args:
      - --repo=https://github.com/KBlixt/subcleaner.git
      - --branch=master
      - --depth=1
      - --root=/add-ons/subcleaner
```
