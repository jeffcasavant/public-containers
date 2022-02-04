# [halcyon](https://github.com/WesR/Halcyon)

This is just a base image for Halcyon based bots.

You can run it on its own to generate a token for your config files:

```
docker run jeffcasavant/wesr-halcyon -s server.xyz -u @bot-user:server.xyz -p "password"
```

but it's got no bot code in it so it won't run on its own.
