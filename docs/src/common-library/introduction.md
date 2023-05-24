# Common library

```admonish note
The Common library chart is not meant to be installed directly, application
charts use the Common library as a dependency.
See the [app template](../../app-template/introduction.md ) for an example how to
deploy it.
```

## Background

In Helm 3, their team introduced the concept of a
[Library chart](https://helm.sh/docs/topics/library_charts/).

> A library chart is a type of Helm chart that defines chart primitives or
  definitions which can be shared by Helm templates in other charts. This
  allows users to share snippets of code that can be re-used across charts,
  avoiding repetition and keeping charts DRY.

The common library was created because I saw many charts requiring only a
few select configuration options in their Helm charts.

```admonish note
Take one of the many applications like `sonarr` or `nzbget`. Each of these
charts only require setting `service`, `port`, `persistence`, `ingress`
and `image` since state and app configuration is handled by the application
itself.
```

In order to stay somewhat DRY (Don't Repeat Yourself) and keeping with Helm 3
usage for a Library chart, I saw this pattern and decided it was worth it to
create a library. This means each one of these app charts has a
dependency on what we call the `common` library.

## Source code

The source code for the common library chart can be found
[here](https://github.com/TomRoush/helm-charts/tree/main/charts/library/common).
