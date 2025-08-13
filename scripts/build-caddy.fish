#!/usr/bin/env fish
# Build a custom Caddy build with caddy-l4 installed, and push to Cloudflare R2 for pulling at deploy-time

set -x GOOS linux
set -x GOARCH amd64
set -x CGO_ENABLED 0

echo "Building caddy..."
xcaddy build --with github.com/mholt/caddy-l4

echo "Pushing to R2..."
rclone copy --progress ./caddy i-bootleg-technology:i-bootleg-technology
