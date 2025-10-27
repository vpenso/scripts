
if command -v age >/dev/null
then
        alias pw=age-password
elif command -v ccrypt >/dev/null
then
        alias pw=password
fi
