## General informations

Custom Falco image built from official binary releases.

## Falco configuration

This image comes with the [default Falco configuration](https://github.com/falcosecurity/falco/blob/master/falco.yaml) and default empty rule set. 

You can bring your own configuration to the container by mounting custom configuration files and/or rules into the container:

```shell
# Configuration flags
$ docker run [options] ghcr.io/f-bn/falco:0.42.1 [flags]

# Mounting custom configuration
$ docker run [options] -v falco.yaml:/etc/falco/falco.yaml:ro ghcr.io/f-bn/falco:0.42.1

# Mounting custom rules
$ docker run [options] -v custom_rules.yaml:/etc/falco/falco_rules.yaml:ro ghcr.io/f-bn/falco:0.42.1
```
