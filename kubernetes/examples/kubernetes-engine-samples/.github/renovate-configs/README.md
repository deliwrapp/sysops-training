# Renovate configuration

These are presets for [Renovate Bot](renovatebot.com), used in some repositories
across the `GoogleCloudPlatform` organization.

## Extending these configurations

To use these config presets in your own renovate files, you'll need to refer to
them according to [renovate's preset hosting format](https://docs.renovatebot.com/config-presets/#preset-hosting).

For example, a preset defined in the file `purple.json5` would be referenced as
follows (the double slash is intentional!) :

```
{
  "extends": [
    "github>GoogleCloudPlatform/kubernetes-engine-samples//.github/renovate-configs/purple.json5",
  ],
}
```

