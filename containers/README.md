# Containers for detlearsom traffic generator

This directory holds git submodules for our containers.

## Setup

Navigate to the containers directory: `cd containers`

You may need to refresh the submodules (clone them):

    git submodule update --init

To build all the containers

    sudo make all

which runs `docker build` to build and tag.


## Adding repos

Add a new repo here with a command like this:

    git submodule add https://github.com/detlearsom/docker-ping

Watch out if moving/renaming submodules, need to edit `.gitmodules` in this repo root.


