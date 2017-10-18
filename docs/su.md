
Start X applications as another user:

```bash
>>> xhost +                  # grant users access to your display
>>> su - <user>              # switch user sourcing profiles
## after login as another user
>>> export DISPLAY=:0.0      # export DISPLAY environment variable
```
