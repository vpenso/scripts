### Polybar

[Polybar][0] (cf. github:[polybar][1])

> Polybar aims to help users build beautiful and highly customizable status 
> bars for their desktop environment.

Files                      | Description
---------------------------|---------------------------
[etc/polybar/config][3]    | Configuration within this repository
[etc/polybar/launch.sh][4] | Launch script used with i3 window manager
[bin/polybar-install][5]   | Build from source, and install
[var/aliases/polybar.sh][6]| Setup the environment

Test the configuration:

```bash
polybar --config=$SCRIPTS/etc/polybar/config top
```

Launch Polybar with i3 (cf. `~/.i3/config`):

```bash
exec_always --no-startup-id ~/.config/polybar/launch.sh
```

Read the documentation in the [Polybar Wiki][2].

## Build


```bash
apt install -y \
        build-essential \
        git \
        ccache \
        cmake \
        cmake-data \
        compton \
        pkg-config \
        python3-sphinx \
        libcairo2-dev \
        libxcb1-dev \
        libxcb-util0-dev \
        libxcb-randr0-dev \
        libxcb-composite0-dev \
        python-xcbgen \
        xcb-proto \
        libxcb-image0-dev \
        libxcb-ewmh-dev \
        libxcb-icccm4-dev
```

Get the latest release version:

<https://github.com/polybar/polybar/releases>

```bash
wget https://github.com/jaagr/polybar/releases/download/3.3.1/polybar-3.3.1.tar
tar -xvf polybar-3.3.1.tar && cd polybar
mkdir build && cd build
cmake ..
make -j$(nproc)
sudo make install
```



[0]: https://polybar.github.io/
[1]: https://github.com/jaagr/polybar
[2]: https://github.com/jaagr/polybar/wiki
[3]: config
[4]: launch.sh
[5]: ../../bin/polybar-install
[6]: ../../var/aliases/polybar.sh
