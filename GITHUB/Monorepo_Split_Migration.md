# Git Monorepo Split Migration Reference

Use this to split a directory from a Git repository into a separate repository **while preserving its Git history**.

---

## 1. Prepare Migration Workspace

```bash
mkdir -p ~/cruddur-migration
cd ~/cruddur-migration
```

Create a fresh source mirror:

```bash
git clone --mirror --no-local git@github.com:OWNER/ORIGINAL-REPO.git cruddur-source.git
```

If the source repository has changed since the last migration, recreate the mirror:

```bash
rm -rf cruddur-source.git
git clone --mirror --no-local git@github.com:OWNER/ORIGINAL-REPO.git cruddur-source.git
```

> `--no-local` avoids local-clone optimization issues with `git filter-repo`.

---

## 2. Create Migration Repository

```bash
git clone --mirror --no-local cruddur-source.git DESTINATION.git
cd DESTINATION.git
```

Example:

```bash
git clone --mirror --no-local cruddur-source.git cruddur-infrastructure.git
cd cruddur-infrastructure.git
```

---

## 3. Filter the Directory

### Keep the directory

Original:

```text
aws/
├── cfn/
├── ecs/
└── ecr/
```

Run:

```bash
git filter-repo --path aws/
```

Result:

```text
cruddur-infrastructure/
└── aws/
    ├── cfn/
    ├── ecs/
    └── ecr/
```

### Flatten the directory

Run:

```bash
git filter-repo \
  --path frontend-react-js/ \
  --path-rename frontend-react-js/:
```

Result:

```text
cruddur-fe/
├── package.json
├── src/
└── public/
```

**Rule:**

```text
--path DIRECTORY/
                    → preserve DIRECTORY/

--path DIRECTORY/ --path-rename DIRECTORY/:
                    → flatten DIRECTORY/
```

---

## 4. Verify the Result

### Check top-level structure

```bash
git ls-tree --name-only HEAD
```

Preserved:

```text
aws
```

Flattened:

```text
package.json
src
public
```

### Check recursively

```bash
git ls-tree -r --name-only HEAD | head -30
```

### Check branch and history

```bash
git branch --show-current
git rev-parse HEAD
git log --oneline -10
```

---

## 5. Make Sure `main` Is Correct

Check:

```bash
git branch
```

If `main-branch` is the branch you want:

```bash
git branch -m main-branch main
```

If an existing migration `main` needs to be removed first:

```bash
git branch -D main
git branch -m main-branch main
```

---

## 6. Configure GitHub Remote

Mirror clones already have an `origin`, so use:

```bash
git remote set-url origin git@github.com:OWNER/NEW-REPO.git
```

Disable mirror push mode:

```bash
git config --unset remote.origin.mirror
```

Verify:

```bash
git remote -v
```

---

## 7. Push

### New/empty GitHub repository

```bash
git push -u origin main
```

### Replacing an existing migration

First fetch the remote:

```bash
git fetch origin main
```

Then:

```bash
git push --force-with-lease -u origin main
```

`--force-with-lease` safely replaces the remote branch while checking that it hasn't unexpectedly changed.

---

## Quick Workflow

```bash
cd ~/cruddur-migration

git clone --mirror --no-local cruddur-source.git NEW-REPO.git
cd NEW-REPO.git

# Preserve directory:
git filter-repo --path DIRECTORY/

# OR flatten directory:
git filter-repo --path DIRECTORY/ --path-rename DIRECTORY/:

# Verify
git ls-tree --name-only HEAD
git ls-tree -r --name-only HEAD | head -30
git branch --show-current
git log --oneline -10

# Configure remote
git remote set-url origin git@github.com:OWNER/NEW-REPO.git
git config --unset remote.origin.mirror

# Push
git push -u origin main
```

### Key command to remember

If you're unsure whether the migration produced the structure you want:

```bash
git ls-tree --name-only HEAD
```

**Check this before pushing.**
