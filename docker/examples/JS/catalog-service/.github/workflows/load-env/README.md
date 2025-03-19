# Load .env Variables

This composite action reads a `.env` file and exports the variables to `GITHUB_ENV`, making them available as environment variables in subsequent steps.

## Inputs

### `env-file-path`

- **Description:** Path to the `.env` file.
- **Default:** `.env`
- **Required:** Yes

## Example Usage

```yaml
- name: Load Environment Variables
  uses: ./.github/actions/load-env
  with:
    env-file-path: gha.env
```
