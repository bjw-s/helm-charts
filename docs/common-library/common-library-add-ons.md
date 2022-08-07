# Common library add-ons

The common library chart supplies a few add-ons which are meant to simplify some features
you might be looking for. These are sidecars that run in the same pod as your
application you configured it with.

## Code Server

The [code-server](https://github.com/cdr/code-server) add-on can be used to
access and modify persistent volume data in your application. This can be
useful when you need to edit the persistent volume data, for example with
Home Assistant.

### Example values

Below is a snippet from a `values.yaml` using the add-on. More configuration
options can be found in our common chart documentation.

!!! note
    This example will mount `/config` into the code-server sidecar.

```yaml
addons:
  codeserver:
    enabled: true
    image:
      repository: codercom/code-server
      tag: 3.9.0
    workingDir: "/config"
    args:
    - --auth
    - "none"
    - --user-data-dir
    - "/config/.vscode"
    - --extensions-dir
    - "/config/.vscode"
    ingress:
      enabled: true
      annotations:
        kubernetes.io/ingress.class: "nginx"
      hosts:
      - host: app-config.domain.tld
        paths:
        - path: /
          pathType: Prefix
      tls:
      - hosts:
        - app-config.domain.tld
    volumeMounts:
    - name: config
      mountPath: /config
```

## Wireguard VPN

The Wireguard add-on enables you to force all (or selected) network traffic
through a VPN.

This example shows how to add a Wireguard sidecar to our
[qBittorrent Helm chart](https://github.com/k8s-at-home/charts/tree/master/charts/stable/qbittorrent).
It does not cover all of the configuration possibilities of the
[Wireguard client image](https://github.com/k8s-at-home/container-images/tree/main/apps/wireguard),
but should give a good starting point for configuring a similar setup.

### Example values

Below is an annotated example `values.yaml` that will result in a qBittorrent
container with **all** its traffic routed through a VPN. In order to have
functioning ingress and/or probes, it might be required to open certain
networks or ports on the VPN firewall. That is beyond the scope of this
document. Please refer to the
[Wireguard client image](https://github.com/k8s-at-home/container-images/tree/main/apps/wireguard)
for more details on these environment variables.

!!! note
    The `WAIT_FOR_VPN` environment variable is specifically implemented by our
    own qBittorrent image, and it will not work with other container images.

```yaml
image:
  repository: k8sathome/qbittorrent
  tag: v4.3.3
  pullPolicy: IfNotPresent

env:
  # Our qBittorrent image has a feature that can wait for the VPN to be connected before actually starting the application.
  # It does this by checking the contents of a file /shared/vpnstatus to contain the string 'connected'.
  WAIT_FOR_VPN: "true"

persistence:
  config:
    enabled: true
    type: emptyDir
    mountPath: /config

  # This should be enabled so that both the qBittorrent and Wireguard container have access to a shared volume mounted to /shared.
  # It will be used to communicate between the two containers.
  shared:
    enabled: true
    type: emptyDir
    mountPath: /shared

addons:
  vpn:
    enabled: true
    # This Should be set to `wireguard`. This will set the add-on to use the default settings for Wireguard based connections.
    type: wireguard

    # If the podSecurityContext is set to run as a different user, make sure to run the Wireguard container as UID/GID 568.
    # This is required for it to be able to read certain configuration files.
    securityContext:
      runAsUser: 568
      runAsGroup: 568

    env:
      # Enable a killswitch that kills all trafic when the VPN is not connected
      KILLSWITCH: "true"

    # The wireguard configuration file provided by your VPN provider goes here.
    #
    # Set AllowedIPs to 0.0.0.0/0 to route all traffic through the VPN.
    #
    # Pay close attention to the PostUp and PreDown lines. They must be added if you wish to run a script when the connection
    # is opened / closed.
    configFile: |-
      [Interface]
      PrivateKey = <my-private-key>
      Address = <interface address>
      DNS = <interface DNS server>
      PostUp = /config/up.sh %i
      PreDown = /config/down.sh %i

      [Peer]
      PublicKey = <my-public-key>
      AllowedIPs = 0.0.0.0/0
      Endpoint = <peer endpoint>

    # The scripts that get run when the VPN connection opens/closes are defined here.
    # The default scripts will write a string to represent the current connection state to a file.
    # Our qBittorrent image has a feature that can wait for this file to contain the word 'connected' before actually starting the application.
    scripts:
      up: |-
        #!/bin/bash
        echo "connected" > /shared/vpnstatus

      down: |-
        #!/bin/bash
        echo "disconnected" > /shared/vpnstatus
```

## OpenVPN

Similar to the Wireguard VPN, the OpenVPN add-on enables you to force all
(or selected) network traffic through a VPN.

This example shows how to add an OpenVPN sidecar to our
[qBittorrent Helm chart](https://github.com/k8s-at-home/charts/tree/master/charts/stable/qbittorrent).
It does not cover all of the configuration possibilities of the
[OpenVPN client image](https://github.com/dperson/openvpn-client) by
[@dperson](https://github.com/dperson), but should give a good starting point
for configuring a similar setup.

### Example values

Below is an annotated example `values.yaml` that will result in a qBittorrent
container with **all** its traffic routed through a VPN. In order to have
functioning ingress and/or probes, it might be required to open certain
networks or ports on the VPN firewall. That is beyond the scope of this
document. Please refer to the
[OpenVPN client image](https://github.com/dperson/openvpn-client) for
more details on these environment variables.

!!! note
    The `WAIT_FOR_VPN` environment variable is specifically implemented by our
    own qBittorrent image, and it will not work with other container images.

```yaml
image:
  repository: k8sathome/qbittorrent
  tag: v4.3.3
  pullPolicy: IfNotPresent

env:
  # Our qBittorrent image has a feature that can wait for the VPN to be
  # connected before actually starting the application.
  # It does this by checking the contents of a file /shared/vpnstatus to
  # contain the string 'connected'.
  WAIT_FOR_VPN: "true"

persistence:
  config:
    enabled: true
    type: emptyDir
    mountPath: /config

  # This should be enabled so that both the qBittorrent and OpenVPN container have access to a shared volume mounted to /shared.
  # It will be used to communicate between the two containers.
  shared:
    enabled: true
    type: emptyDir
    mountPath: /shared

addons:
  vpn:
    enabled: true
    # This Should be set to `openvpn`. This will set the add-on to use the default settings for OpenVPN based connections.
    type: openvpn

    openvpn:
      # This gets read by the Helm chart. The default OpenVPN image reads this and uses it to connect to the VPN provider.
      auth: |
        myuser
        mypassword

    # If the podSecurityContext is set to run as a different user, make sure to run the OpenVPN container as root.
    # This is required for it to be able to read certain configuration files.
    securityContext:
      runAsGroup: 0
      runAsUser: 0

    env:
      # Set this environment variable to 'on' to make sure all traffic gets routed through the VPN container.
      # Make sure to check the other environment variables for the OpenVPN image to see how you can exclude certain
      # traffic from these firewall rules.
      FIREWALL: 'on'

    # The .ovpn file provided by your VPN provider goes here.
    #
    # Any CA / certificate must either be placed inline, or provided through an additionalVolumeMount so that OpenVPN can find it.
    #
    # Pay close attention to the last 3 lines in this file. They must be added if you wish to run a script when the connection
    # is opened / closed.
    configFile: |-
      client
      dev tun
      proto udp
      remote my-awesome-vpn-provider.com 995
      remote-cert-tls server
      resolv-retry infinite
      nobind
      tls-version-min 1.2
      cipher AES-128-GCM
      compress
      ncp-disable
      tun-mtu-extra 32
      auth-user-pass

      <ca>
      -----BEGIN CERTIFICATE-----
      MIIDMTCCAhmgAwIBAgIJAKnGGJK6qLqSMA0GCSqGSIb3DQEBCwUAMBQxEjAQBgNV
      -----END CERTIFICATE-----
      </ca>

      script-security 2
      up /vpn/up.sh
      down /vpn/down.sh

    # The scripts that get run when the VPN connection opens/closes are defined here.
    # The default scripts will write a string to represent the current connection state to a file.
    # Our qBittorrent image has a feature that can wait for this file to contain the word 'connected' before actually starting the application.
    scripts:
      up: |-
        #!/bin/bash
        /etc/openvpn/up.sh
        echo "connected" > /shared/vpnstatus

      down: |-
        #!/bin/bash
        /etc/openvpn/down.sh
        echo "disconnected" > /shared/vpnstatus
```
