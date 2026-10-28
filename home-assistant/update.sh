#!/usr/bin/fish

set compose_file /root/home-assistant/compose.yaml
set needs_update 0

# Home Assistant: compare version label of local image with the one the stable tag points to on ghcr
set repository home-assistant/home-assistant
set tag stable
set token (wget -qO- "https://ghcr.io/token?scope=repository:$repository:pull" | jq -r .token)
set manifest_digest (wget -qO- --header="Authorization: Bearer $token" \
    --header="Accept: application/vnd.oci.image.index.v1+json" \
    "https://ghcr.io/v2/$repository/manifests/$tag" \
    | jq -r '.manifests[] | select(.platform.os == "linux" and .platform.architecture == "arm64") | .digest')
set config_digest (wget -qO- --header="Authorization: Bearer $token" \
    --header="Accept: application/vnd.oci.image.manifest.v1+json" \
    "https://ghcr.io/v2/$repository/manifests/$manifest_digest" | jq -r .config.digest)
set latest_version (wget -qO- --header="Authorization: Bearer $token" \
    "https://ghcr.io/v2/$repository/blobs/$config_digest" \
    | jq -r '.config.Labels["org.opencontainers.image.version"]')
set current_version (docker image inspect ghcr.io/$repository:$tag --format '{{index .Config.Labels "org.opencontainers.image.version"}}')

echo "Home Assistant"
echo "  Current version:  $current_version"
echo "  Latest version:   $latest_version"

if test -z "$latest_version" -o "$latest_version" = null
    echo "  Could not fetch latest version, aborting"
    exit 1
end
if test "$current_version" != "$latest_version"
    set needs_update 1
end

# Matter server: image has no version label, so compare image digests
set repository home-assistant-libs/python-matter-server
set tag stable
set token (wget -qO- "https://ghcr.io/token?scope=repository:$repository:pull" | jq -r .token)
set latest_digest (wget -qSO /dev/null --header="Authorization: Bearer $token" \
    --header="Accept: application/vnd.oci.image.index.v1+json,application/vnd.docker.distribution.manifest.list.v2+json" \
    "https://ghcr.io/v2/$repository/manifests/$tag" 2>&1 \
    | string match -r -g -i 'docker-content-digest:\s*(\S+)')
set current_digest (docker image inspect ghcr.io/$repository:$tag --format '{{index .RepoDigests 0}}' | string split '@')[2]

echo "Matter server"
echo "  Current digest:   $current_digest"
echo "  Latest digest:    $latest_digest"

if test -z "$latest_digest"
    echo "  Could not fetch latest digest, aborting"
    exit 1
end
if test "$current_digest" != "$latest_digest"
    set needs_update 1
end

if test $needs_update = 1
    docker compose -f $compose_file pull && \
    docker compose -f $compose_file up --force-recreate -d && \
    docker system prune -f
end
