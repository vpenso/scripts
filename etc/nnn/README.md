
<https://github.com/jarun/nnn>

Install

```bash
# install dependencies
sudo apt install -y pkg-config libncursesw5-dev libreadline-dev
# get the latest versions
git clone https://github.com/jarun/nnn.git && cd nnn
sudo make strip install
```

Install plugins:

<https://github.com/jarun/nnn/tree/master/plugins>

```bash
wget https://github.com/jarun/nnn/blob/master/plugins/getplugs
chmod +x getplugs && ./getplugs
```

`R` to select a plugin

### Configuration

[var/aliases/nnn.sh](../../var/aliases/nnn.sh)

```bash
# select application to open a specified file
mimeopen -d <file>
```
