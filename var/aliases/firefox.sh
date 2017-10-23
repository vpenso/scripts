
alias fl='firefox -no-remote 2>&- & ; disown'

# run Firefox in a container
alias fj='firejail firefox -no-remote 2>&- & ; disown'

# Always select a user profile before launching the browser
alias ff='firefox -profilemanager -no-remote 2>&- & ; disown'
# Allow multiple instances of Firefox
