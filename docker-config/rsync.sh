#!/usr/bin/env sh

# Make sure we never run 2 rsync at the same time
lockfile="/tmp/alpine-mirror.lock"
if [ -z "$flock" ] ; then
  exec env flock=1 flock -n $lockfile $0 "$@"
fi

src=rsync://rsync.alpinelinux.org/alpine/
dest=/var/www/repo/

/usr/bin/rsync \
    --archive \
    --update \
    --hard-links \
    --delete \
    --delete-after \
    --delay-updates \
    --timeout=600 \
    --exclude-from=/etc/rsync/exclude.txt  \
    --log-file=/dev/stdout \
    "$src" "$dest"

# /var/log/.rsyncd.log
