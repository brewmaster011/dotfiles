#!/bin/sh
# Server aliases: read-only shortcuts for the homelab's break-glass work
# (Docker Swarm, systemd, ZFS). Each group only exists where its command is
# installed. Anything that changes state (--force, stack rm/deploy, zfs
# destroy) stays typed out in full on purpose.

if command -v docker >/dev/null 2>&1; then
    alias dnl='docker node ls'                  # dnl:  swarm nodes (Ready? manager status)
    alias dsl='docker service ls'               # dsl:  services and their replicas
    alias dps='docker service ps --no-trunc'    # dps:  where a service's tasks run, why they died
    alias dlog='docker service logs -f --tail 100'  # dlog: follow a service's logs
    alias dstl='docker stack ls'                # dstl: stacks
fi

if command -v systemctl >/dev/null 2>&1; then
    alias sst='systemctl status'                # sst:   status of a unit
    alias sfail='systemctl --failed'            # sfail: failed units
fi

if command -v journalctl >/dev/null 2>&1; then
    alias jfu='journalctl -fu'                  # jfu: follow a unit's journal
    alias jx='journalctl -xe'                   # jx:  latest journal, explained
fi

if command -v zfs >/dev/null 2>&1; then
    alias zl='zfs list'                         # zl:  datasets
    alias zps='zpool status -x'                 # zps: pool health (only problems)
fi
