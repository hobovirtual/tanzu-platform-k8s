#!/bin/bash
# ---
# Generate the manifests required for this workshop
# ---
# clustergroup manifest
ytt -f values.yaml -f templates/1-clustergroup.yaml --output-files platform-engineer

# cluster manifest
ytt -f values.yaml -f templates/2-cluster.yaml --output-files platform-engineer

# cluster manifest
ytt -f values.yaml -f templates/3-nodepool.yaml --output-files platform-engineer

# availability target manifest
ytt -f values.yaml -f templates/4-target.yaml --output-files platform-engineer

# network prodile manifest
ytt -f values.yaml -f templates/5-profile.yaml --output-files platform-engineer

# space manifest
ytt -f values.yaml -f templates/6-space.yaml --output-files platform-engineer