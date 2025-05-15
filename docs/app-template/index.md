# App Template

## Background

Since Helm [library charts](https://helm.sh/docs/topics/library_charts/) cannot be
installed directly I have created a companion chart for the [common library](../common-library/index.md).

## Usage

This Helm chart can be used to deploy any application. Knowing the specifics of the application you want to deploy
like the image, ports, env vars, args, and/or any config volumes will be required. You can also use [Kubesearch](https://kubesearch.dev/)
to search for applications people have deployed with this Helm chart.

In order to use this template chart, you would deploy it as you would any other Helm chart.
By setting the desired values, the common library chart will render the desired resources.

Be sure to check out the [common library docs](../common-library/index.md)
and its [`values.yaml`](https://github.com/bjw-s-labs/helm-charts/tree/main/charts/library/common/values.yaml) for
more information about the available configuration options.

#### Examples

This is an example `values.yaml` file that would deploy the [vaultwarden](https://github.com/dani-garcia/vaultwarden)
application. For more deployment examples, check out the [`examples` folder](https://github.com/bjw-s-labs/helm-charts/tree/main/examples/).

```yaml linenums="1"
--8<--
examples/helm/vaultwarden/values.yaml
--8<--
```

## Upgrade instructions

Upgrade instructions for major versions can be found [here](upgrade-instructions.md).

## Source code

The source code for the app template chart can be found
[here](https://github.com/bjw-s-labs/helm-charts/tree/main/charts/other/app-template).
