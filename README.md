# docker-3cx-sbc

This repository features code to create 3CX SBC Docker images, as well as automated builds when new versions are published by 3CX.

## Usage

```bash
docker run \
    --rm \
    --net host \
    -e PBX_URL=https://my.3cx.be \ # Provisioning URL
    -e PBX_KEY=MySBCKey \          # Authentication KEY ID
    ghcr.io/apyos/docker-3cx-sbc
```

Both `PBX_URL` and `PBX_KEY` come from the https://apyos.3cx.be/#/app/siptrunks page, after an SBC was added.

## FAQ

### How are these images built?

The images are based on Debian Buster, as it's the most recent Debian version currently supported by 3CX. They are compatible with `amd64` and `armhf` architectures.

All the `systemd` stuff was ripped out, as it does not align with idiomatic Docker images, and does not provide any real benefits. However, this means that the images are created in a somewhat hacky way by unpacking the `3cxsbc` binary, which may be less maintainable.

### Does this image support automatic updates?

No, it doesn't. When trying to update from the Management Console, nothing will happen except a small warning in the logs. Images are static, and the entire container should be replaced by a new version in order to update.

### Does re-provisioning work?

Yes, the configuration is automatically kept in sync with the Management Console, and the `Push Config` also works.

### When will new releases be available?

Assuming new versions remain compatible with this repository's way of installing the SBC, new versions should be published to the registry (https://github.com/apyos/docker-3cx-sbc/pkgs/container/docker-3cx-sbc) in the hour following a new release. This is done automatically using GitHub Actions, and can be seen here: https://github.com/apyos/docker-3cx-sbc/actions.

### What about versioning?

Images are published with the `latest` tag as well as the 3 SemVer versions. For example, assuming version is the `2.3.4` is the most recent one, it can be pulled with any of the following:

- `docker pull ghcr.io/apyos/docker-3cx-sbc:2.3.4`
- `docker pull ghcr.io/apyos/docker-3cx-sbc:2.3`
- `docker pull ghcr.io/apyos/docker-3cx-sbc:2`
- `docker pull ghcr.io/apyos/docker-3cx-sbc`

As suggested by SemVer, `docker pull ghcr.io/apyos/docker-3cx-sbc:2` will always point to the latest `2.*.*` version.

### Can I extend the configuration using `3cxsbc.conf.local`?

Yes, you can simply create a file and mount it as a read-only volume on `/etc/3cxsbc.conf.local`:

```bash
docker run \
    ...
    -v /path/to/3cxsbc.conf.local:/etc/3cxsbc.conf.local:ro
    ghcr.io/apyos/docker-3cx-sbc
```
