#!/bin/sh

podman build -t isolated-workspace --build-arg SSH_PUBKEY="$(cat ~/.ssh/id_ed25519.pub)" .
