# Names

### Configuration

Each resource that can be created by the Common library supports the following fields to control the generated resource name, along with the resource identifier.

All of these fields support the use of Helm templates for advanced naming requirements.

#### forceRename

Override the default resource name entirely.

!!! info
    The `forceRename` field is mutually exclusive with the `prefix` and `suffix` fields.

#### prefix

Prefix to prepend to the resource name.

#### suffix

Suffix to append to the resource name. Defaults to the resource identifier if there are multiple enabled items, otherwise it defaults to an empty value.

### Behavior

Assuming a Helm Release with the name `base_name`, the following table gives an overview of how the resource name is generated:

| item key | enabled items | `prefix` | `suffix` | `forceRename`              | Generated name         |
|----------|---------------|----------|----------|----------------------------|------------------------|
| `id`     | 1             |          |          | `random_name`              | `random_name`          |
| `id`     | 1             |          |          | `{{ .Release.Namespace }}` | `default`              |
| `id`     | 1             |          |          |                            | `base_name`            |
| `id`     | 1             | `pfx`    |          |                            | `pfx-base_name`        |
| `id`     | 1             |          | `sfx`    |                            | `base_name-sfx`        |
| `id`     | 2             |          |          |                            | `base_name-id`         |
| `id`     | 1             | `pfx`    | `sfx`    |                            | `pfx-base_name-sfx`    |
| `id`     | 2             | `pfx`    |          |                            | `pfx-base_name-id`     |
| `id`     | 2             |          | `sfx`    |                            | `base_name-id-sfx`     |
| `id`     | 2             | `pfx`    | `sfx`    |                            | `pfx-base_name-id-sfx` |
| `id`     | 1             |          | `sfx`    |                            | `base_name-sfx`        |
| `id`     | 1             | `pfx`    |          |                            | `pfx-base_name`        |
| `id`     | 1             | `pfx`    | `sfx`    |                            | `pfx-base_name-sfx`    |
