# Build deb packages of Mozc at debian or Ubuntu
## Bazel install
```sh
wget https://github.com/bazelbuild/bazel/releases/download/7.3.1/bazel-7.3.1-installer-linux-x86_64.sh
bash bazel-7.3.1-installer-linux-x86_64.sh --user
source ~/.bazel/bin/bazel-complete.bash
export PATH="$PATH:$HOME/bin"
bazel --version
```

## Dependencies
### Ubuntu:mantic
```sh
apt-get update
apt-get install -y sudo apt-utils wget
sudo sed 's/^.*deb-src /deb-src /' -i /etc/apt/sources.list
sudo apt-get update
sudo apt-get build-dep -y mozc
sudo apt-get install -y build-essential dpkg-dev make git qt6ct qt6-base-dev libfcitx5-qt6-dev curl unzip
```
```sh
git checkout ubuntu-mantic
```

### Ubuntu:noble
```sh
apt-get update
apt-get install -y sudo apt-utils wget
sudo sed 's/Types: deb *$/Types: deb deb-src/' -i /etc/apt/sources.list.d/ubuntu.sources
sudo apt-get update
sudo apt-get build-dep -y mozc
sudo apt-get install -y build-essential dpkg-dev make git qt6ct qt6-base-dev libfcitx5-qt6-dev curl unzip
```
```sh
git checkout ubuntu-noble
```
### Debian
```sh
apt-get update
apt-get install sudo apt-utils wget
sudo sed 's/Types: deb *$/Types: deb deb-src/' -i /etc/apt/sources.list.d/debian.sources
sudo apt-get update
sudo apt-get build-dep mozc
sudo apt-get install build-essential dpkg-dev make git qt6ct qt6-base-dev libfcitx5-qt6-dev curl unzip
```
```sh
git checkout debian-bookworm
```

### Build
```sh
git clone --recursive --filter=tree:0 https://github.com/google/mozc.git mozc
cd mozc
cp -a ../debian ./
dpkg-buildpackage -b --no-sign
```
or
```sh
git clone --recursive --filter=tree:0 https://github.com/google/mozc.git mozc
cd mozc
cp -a ../debian ./
ls debian/patches/*.patch|xargs -n1 patch -p1 -i 
fakeroot debian/rules binary
```

```sh
ls ../*.deb
```

## Install
### Ibus-Mozc
```sh
cd ..
sudo dpkg -i mozc-data*.deb mozc-server*.deb mozc-utils-gui*.deb ibus-mozc_*.deb
sudo apt-get --fix-broken install
sudo dpkg -i mozc-data*.deb mozc-server*.deb mozc-utils-gui*.deb ibus-mozc_*.deb
```
### Fcitx5-Mozc
```sh
cd ..
sudo dpkg -i mozc-data*.deb mozc-server*.deb mozc-utils-gui*.deb fcitx5-mozc_*.deb fcitx-mozc-data_*.deb
sudo apt-get --fix-broken install
sudo dpkg -i mozc-data*.deb mozc-server*.deb mozc-utils-gui*.deb fcitx5-mozc_*.deb fcitx-mozc-data_*.deb
```
