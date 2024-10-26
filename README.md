# private-neovim-config

一些个人软件配置

## Hyprland
这里是直接使用[JaKooLit/Arch-Hyprland](https://github.com/JaKooLit/Arch-Hyprland)安装脚本，
需要尽可能保持干净的系统环境再进行安装。

+ `waybar`配置修改

添加了部分 module


## Zshell

+ 安装`zsh`
```bash
## debian like
# 更新软件源
sudo apt update && sudo apt upgrade -y
# 安装 zsh git curl
sudo apt install zsh git
curl -y

## arch like
sudo pacman -Syu
sudo pacman -Sy git zsh
```

+ 安装`oh-my-zsh`

```bash
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# 国内源
sh -c "$(wget -O- https://gitee.com/pocmon/ohmyzsh/raw/master/tools/install.sh)"
```

+ 安装`powerlevel10k`

```bash
git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# 使用自定义的配置
cp <this-repo>/p10kconf/.p10k.zsh ~/.p10k.zsh
```

+ 安装CLI工具

```bash
## arch like
sudo pacman -Sy eza fastfetch fzf fd bat
paru -S yazi-git zsh-autosuggestions zsh-syntax-highlighting
```

+ 配置`yazi`

```bash
mkdir -p ~/.config/yazi
cp -r <this-repo>/yazi/* ~/.config/yazi
```

## lunarNeovm

官网地址[lunarNeovim](https://www.lunarvim.org/zh-Hans/docs/installation)

+ 安装`lunarNeovim`

建议还是使用官网的安装脚本，目前打算移步使用 AstroNvim。

```bash
LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)
```

## 安装`neovide`

### 基于`Rust`

+ 安装`Rust`

```bash
export RUSTUP_DIST_SERVER="https://rsproxy.cn"
export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"

curl --proto '=https' --tlsv1.2 -sSf https://rsproxy.cn/rustup-init.sh | sh
```

+ 设置`crate.io`镜像[RsProxy](https://rsproxy.cn/)

```bash
# in ~/.cargo/config.toml
[source.crates-io]
replace-with = 'rsproxy-sparse'
[source.rsproxy]
registry = "https://rsproxy.cn/crates.io-index"
[source.rsproxy-sparse]
registry = "sparse+https://rsproxy.cn/index/"
[registries.rsproxy]
index = "https://rsproxy.cn/crates.io-index"
[net]
git-fetch-with-cli = true
```

+ 源码编译安装`neovide`

```bash
cargo install --git https://github.com/neovide/neovide
```

### 基于`snap`

```bash
sudo apt install -y curl \
    gnupg ca-certificates git \
    gcc-multilib g++-multilib cmake libssl-dev pkg-config \
    libfreetype6-dev libasound2-dev libexpat1-dev libxcb-composite0-dev \
    libbz2-dev libsndio-dev freeglut3-dev libxmu-dev libxi-dev libfontconfig1-dev \
    libxcursor-dev
```

### archlinux 

```bash
sudo pacmans -Sy neovide
```

### `.zshrc`添加

```bash
alias vide="neovide --neovim-bin ${HOME}/.local/bin/lvim"
```
