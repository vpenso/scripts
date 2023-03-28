
if test -d /etc/keyd
then
        test -L /etc/keyd/default.conf ||
               echo "Keyd configuration file missing in /etc/keyd" 
fi

