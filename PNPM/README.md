pnpm is a fast, disk space–efficient package manager for JavaScript projects, similar to npm and Yarn—but with a different approach under the hood.

To install

```sh
npm install -g pnpm
pnpm -v
```

From the repo directory. Navigate to `artifacts`, thats the files location is, either api, frontend or so! Navigate to the directory, then run install command and build

```sh
pnpm install
pnpm build
```

So, cp the .env from the root directory and symlink in the artifacts directory.

```sh
cp .env.example .env
ln -sf ${{ env.DEPLOY_DIR }}/.env ${{ env.DEPLOY_DIR }}/artifacts/.env
```

In the .env, ensure `BASE_PATH=/` is set.
