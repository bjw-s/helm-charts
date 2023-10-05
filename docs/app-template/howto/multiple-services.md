# Multiple Services

## With a single controller

It is possible to have multiple Service objects that point to a single controller.

### Example

```yaml
controllers:
  main:
    containers:
      main:
        image:
          repository: ghcr.io/mendhak/http-https-echo
          tag: 30
          pullPolicy: IfNotPresent

service:
  main:
    # The controller for this service is set to
    # "main" by the default app-template values
    # controller: main
    ports:
      http:
        port: 8080
  second:
    controller: main # (1)!
    ports:
      http:
        port: 8081
```

1. Point to the controller with the "main" identifier

## With multiple controllers

It is also possible have multiple Service objects that point to different controllers.

### Example

```yaml
controllers:
  main:
    containers:
      main:
        image:
          repository: ghcr.io/mendhak/http-https-echo
          tag: 30
          pullPolicy: IfNotPresent
  second:
    containers:
      main:
        image:
          repository: ghcr.io/mendhak/http-https-echo
          tag: 30
          pullPolicy: IfNotPresent

service:
  main:
    # The controller for this service is set to
    # "main" by the default app-template values
    # controller: main
    ports:
      http:
        port: 8080
  second:
    controller: main # (1)!
    ports:
      http:
        port: 8081
  third:
    controller: second # (2)!
    ports:
      http:
        port: 8081
```

1. Point to the controller with the "main" identifier
2. Point to the controller with the "second" identifier
