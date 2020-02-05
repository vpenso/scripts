# make Firefox the default browser
export BROWSER=${BROWSER:-chromium-browser}

# Allow multiple instances of Firefox
ff() {
	(firefox --no-remote 2>&1 1>/dev/null &)
}

# run Firefox in a container
ffj() { 
	(firejail \
                firefox --no-remote 2>&1 >/dev/null \
        &) 2>&1 >/dev/null
}

# run firefox even more contained (no sound!)
ffjs() {
        (firejail --private \
		  --private-dev \
		  --private-tmp \
		  --private-etc=empty \
		  --private-srv=empty \
		  --dns=1.1.1.1 \
		  --shell=none \
		  --caps.drop=all \
		  --nonewprivs \
		  --protocol=unix,inet,inet6 \
		  --noroot \
		  --nogroups \
		  --nosound \
		  --notv \
		  --seccomp \
		  --netfilter \
		  --machine-id \
		  --blacklist=/mnt \
		  --blacklist=/media \
		  --blacklist=/opt \
		  --blacklist=/boot \
		  --blacklist=/sys \
		  --quiet \
		  -- firefox --private \
		             --no-remote \
		             2>&1 >/dev/null & \
	) 2>&1 >/dev/null 
}

