
The `ibdiagnet` command may report trouble in a from like:

```bash
>>> ibdiagnet
...
Link at the end of direct route "1,1,19,10,9,25"
     Errors:
           -error noInfo -command {smNodeInfoMad getByDr {1 1 19 10 9 25}}
Errors types explanation:
     "noInfo"  : the link was ACTIVE during discovery but, sending MADs across it
                   failed 4 consecutive times
...
```

Use `ibdiagpath` to print all GUIDs on the route:

```bash
>>> ibdiagpath -d 1,1,19,10,9,25
...
-I- From: lid=0x0216 guid=0x7cfe90030097cef0 dev=51000 Port=17
```

Eventually use archived output of `ibnetdiscover` to identify the corresponding host:

```bash
>>> ibnetdiscover
...
switchguid=0x7cfe90030097cef0(7cfe90030097cef0)
Switch  36 "S-7cfe90030097cef0"         # "SwitchX -  Mellanox Technologies" base port 0 lid 534 lmc 0
...
[17]    "H-0cc47affff5fed24"[1](cc47affff5fed25)                # "node01.devops.test" lid 615 4xFDR
```

Otherwise check the end of the cable connected to the switch port identified.

