# Image Publish Test Repository

Minimal repository for testing secure image publishing workflows.

## Purpose

This repo tests the following reusable workflows from `sonupreetam/org-infra-tests`:

- `reusable_publish_image.yml` - Build, sign, and push images to GHCR
- `reusable_promote.yml` - Copy images from GHCR to Quay.io
- `reusable_sign_and_verify.yml` - Sign images on Quay with Sigstore

## Workflow Flow

```
Push to main ──► Build & Sign ──► GHCR (ghcr.io/sonupreetam/test-compass:sha-xxx)
                     │
Create tag ─────────►│
test-v0.0.1          │
                     ▼
              Promote to Quay ──► quay.io/test_complytime/test-compass:test-v0.0.1
                     │
                     ▼
              Sign on Quay (Sigstore keyless)
```

## Testing

### 1. Test Build & Publish (Push to main)

```bash
git add .
git commit -m "test: trigger publish workflow"
git push origin main
```

This triggers `publish-images.yml` which:
- Builds the image from `Containerfile`
- Signs with Sigstore (keyless)
- Pushes to `ghcr.io/sonupreetam/test-compass:sha-<commit>`

### 2. Test Promote to Quay (Create tag)

```bash
git tag test-v0.0.1
git push origin test-v0.0.1
```

This triggers `promote-to-quay.yml` which:
- Copies from GHCR to Quay
- Creates semver tags (test-v0.0.1, test-v0.0, test-v0)
- Signs on Quay with Sigstore

## Required Secrets

Add these in Settings → Secrets → Actions:

| Secret | Description |
|--------|-------------|
| `QUAY_USERNAME` | Quay.io robot account username |
| `QUAY_PASSWORD` | Quay.io robot account password |

## Verify Signatures

```bash
# Verify GHCR image
cosign verify ghcr.io/sonupreetam/test-compass:sha-<commit> \
  --certificate-identity-regexp='https://github.com/sonupreetam/org-infra-tests/.*' \
  --certificate-oidc-issuer='https://token.actions.githubusercontent.com'

# Verify Quay image
cosign verify quay.io/test_complytime/test-compass:test-v0.0.1 \
  --certificate-identity-regexp='https://github.com/sonupreetam/org-infra-tests/.*' \
  --certificate-oidc-issuer='https://token.actions.githubusercontent.com'
```
