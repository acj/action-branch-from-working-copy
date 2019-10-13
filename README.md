# action-branch-from-working-copy

GitHub Action that creates a new git branch from your working copy

## Usage

See action.yml For comprehensive list of options.

```yaml
name: "Create branch from working copy"
on: release

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - name: Create branch
      uses: acj/action-branch-from-working-copy@v1
      with:
        BRANCH_NAME: "v3-release"
        COMMIT_MESSAGE: "Bump version number for package"
        COMMIT_AUTHOR_NAME: "Friendly Developer"
        COMMIT_AUTHOR_EMAIL: "dev@example.com"
        FAIL_IF_BRANCH_EXISTS: "false"
```