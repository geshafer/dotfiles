# Gale's Dotfiles

A collection of the minimum dotfiles necessary for Gale's workspace, designed to
work on mac and linux for local and cloud based dev environments.

## Installation

Clone this repo to your `$HOME` directory and then run the following:

```zsh
$HOME/dotfiles/install.sh
```

## Persisting command history across Spin instances

Several people at Shopify have asked about how I persist my command history across Spin instances. I use a command
history tool called McFly to provide a better interface that also stores its database in a way that can be loaded into
[cartridges](https://vault.shopify.io/page/Isospin-tools~dhb1fb6.md#moving-data-between-your-instances).

You will have to create a mcfly cartridge once but shouldn't ever have to do it again.

```
cartridge create mcfly
```

From now on, you can just insert the cartridge and link it's path in your `install.sh`. I install McFly after I link the
path just to make sure it doesn't load an empty database.

```bash
# install mcfly
cartridge insert mcfly
ln -sf ~/.data/cartridges/mcfly ~/.mcfly
curl -fsSL https://raw.githubusercontent.com/cantino/mcfly/master/ci/install.sh | sudo sh -s -- --git cantino/mcfly
```

I use a systemd timer and service to automatically save the cartridge every hour. This is not a perfect solution. If you
have multiple spin instances running at the same time, the instances will take turns overwriting eachother. This is
primarily focused on users that use one spin instance at a time.

```bash
# add systemd timer for persisting mcfly history
sudo cp machine/spin/persist-history.service /etc/systemd/system/persist-history.service
sudo cp machine/spin/persist-history.timer /etc/systemd/system/persist-history.timer
systemctl start persist-history.service
```

I'll update this repo if I ever find a way to merge databases from multiple instances.
