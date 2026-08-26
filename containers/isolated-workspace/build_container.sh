#!/bin/sh

podman build --pull=always --tag=isolated-workspace --build-arg SSH_PUBKEY="$(cat "${HOME}/.ssh/id_ed25519.pub" || true)" .
