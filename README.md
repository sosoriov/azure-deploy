# azure-deploy


Testing Azure

## Flux V2

Generating SSH credentials *known_hosts*

```bash
ssh-keygen -q -N "" -f ./identity
ssh-keyscan github.com > ./known_hosts
```