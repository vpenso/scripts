# make Firefox the default browser
export BROWSER=firefox

# Allow multiple instances of Firefox
ff() {
	(firefox -no-remote 2>&1 1>/dev/null &)
}

# run Firefox in a container
ffj() { 
	(firejail firefox -no-remote 2>&1 1>/dev/null &)
}

