# Pursuarr
A better search interface connecting directly to Prowlarr, working on top of its API.

## Features
- Exclude from search: Prepend strings with "-" to exclude them from your search results. For example: Search for "S01 -S01E" to exclude single episodes from your results.
- Expand search: Add related keywords to your search. For example: A search for "x265" might also search for "h265" and "HEVC".
- Exact matches: Prowlarr sometimes returns fuzzy results. If you need an exact match, put your string into quotes. For example: "green" will return results for green, but not for greed.
- Instant result filtering: Refine already-fetched results in real time (`term`, `-exclude`, `"exact"`, `-"exact"`) without waiting on another Prowlarr search.
- Grab directly via Prowlarr's API (send to your default or chosen download client).
- Shareable search URLs: Query, filters, and sort state stay in sync with the URL (`?q=...`) for bookmarking or use as a custom browser search engine.

## Technical
- Nearly stateless: No database, only a single settings file containing the API key and base URL to Prowlarr and the expanded search keywords.
- Single PHP-File: No external dependencies, just drop into your web server and run.

## Install from GHCR

Images for `linux/amd64` and `linux/arm64` are built automatically on every push to `main`:

```sh
docker run -d -p 8080:8080 -v pursuarr-data:/data ghcr.io/theromi/pursuarr:latest
```

### Unraid

1. Copy `unraid-template.xml` to `/boot/config/plugins/dockerMan/templates/mytemplates/pursuarr.xml` on your Unraid server (e.g. via SCP or the CA "User Templates" share).
2. Docker → **Add Container** → pick **pursuarr** from the *Template* dropdown → **Apply**.
3. The container runs as UID:GID `99:100` (`nobody:users`), matching Unraid's default `appdata` permissions out of the box.

## Build from source

```sh
docker build -t pursuarr .
docker run -d -p 8080:8080 -v pursuarr-data:/data pursuarr
# or simply:
docker compose up -d --build
```

Settings live in `/data/settings.php` (persistent volume), or can be provided statelessly via environment variables (`PROWLARR_URL`, `PROWLARR_API_KEY`, `PURSUARR_EXPANSION_GROUPS`, `PURSUARR_VERIFY_TLS`, `PURSUARR_DOWNLOAD_CLIENT_ID`). Change the port with `PURSUARR_PORT=8081 docker compose up -d`.

**Note:** there is no login. Put Pursuarr behind a reverse proxy with auth or on a private network.
