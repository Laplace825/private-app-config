<!--
 * @Author: laplace825
 * @Date: 2024-04-29 19:56:21
 * @LastEditors: laplace825
 * @LastEditTime: 2024-04-29 20:54:12
 * @FilePath: /app_config/README.md
 * @Description: 
 * 
 * Copyright (c) 2024 by laplace825, All Rights Reserved. 
-->
# private-neovim-config

一些个人软件配置

## lunarNeovm

官网地址[lunarNeovim](https://www.lunarvim.org/zh-Hans/docs/installation)

+ 安装`lunarNeovim`
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

+ `.zshrc`添加
```shell
alias vid="neovide --neovim-bin ${HOME}/.local/bin/lvim"
```


## Zshell

+ 安装`zsh`
```bash
# 更新软件源
sudo apt update && sudo apt upgrade -y
# 安装 zsh git curl
sudo apt install zsh git
curl -y
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
```
