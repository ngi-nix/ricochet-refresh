# ricochet-refreshed

- upstream: https://github.com/blueprint-freespeech/ricochet-refresh
- ngi-nix: https://github.com/ngi-nix/ngi/issues/79

`ricochet-refreshed` is a refresh of the older `ricochet` app. It is a instant messaging application backed by the Tor network.

## Using

In order to use this [flake](https://nixos.wiki/wiki/Flakes) you need to have the
[Nix](https://nixos.org/) package manager installed on your system. Then you can simply run this
with:

```
$ nix run github:ngi-nix/ricochet
```

You can also enter a development shell with:

```
$ nix develop github:ngi-nix/ricochet
```

For information on how to automate this process, please take a look at [direnv](https://direnv.net/).
