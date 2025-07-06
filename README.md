# Termux Manager

## Setup

```bash
git clone https://github.com/ariafatah0711/termux_manager
chmod +x setup.sh
./setup.sh
```

## Usage

```bash
termux-manager
```

**or**

```bash
./main.sh
```

## Uninstall

```bash
./uninstall.sh
```

## Menu List

```
╔════════════════════════════════════════╗
║    TERMUX MANAGER by @ariafatah0711    ║
╠════════════════════════════════════════╣
║ IP: 192.168.1.6                        ║
╠════════════════════════════════════════╣
║ ✓ SSH Server                           ║
║ ✓ Code Server                          ║
╠════════════════════════════════════════╣
║ 1. ping                                ║
║ 2. speedtest                           ║
║ 3. ssh_manager                         ║
║ 4. code_server_manager                 ║
║ 5. proot_distro-manager                ║
║ 6. n8n_start                           ║
║ 7. create_shortcuts                    ║
║ q. quit                                ║
╚════════════════════════════════════════╝
Select an option:
```

### Proot Distro Subcommands

```
Perintah yang tersedia:
  l             ➜ List distro yang diinstal
  l -a          ➜ List semua distro tersedia
  i <nama>      ➜ Install distro (langsung)
  r <nama>      ➜ Jalankan distro
  d <nama>      ➜ Hapus distro
  clear         ➜ Clear Terminal
  help          ➜ Tampilkan bantuan
  exit          ➜ Keluar
```

## List of Scripts

This list can be customized via `config.json`

* `main.sh`
  ![main](img/__1__.jpg)

* `script/ping`
  ![ping](img/__2__.jpg)

* `script/speedtest`
  ![speedtest](img/__3__.jpg)

* `script/ssh-manager`
  ![ssh-manager](img/__4__.jpg)

* `script/code_server-manager`
  ![code-server](img/__5__.jpg)

* `script/proot-manager`

* `script/n8n_start`

* `script/create_shortcuts`

## GitHub Push with Token

1. Generate token: [GitHub Token Settings](https://github.com/settings/personal-access-tokens/new)
2. Add repo access and set permission to **repo > contents**

Example command:

```bash
git remote add origin https://<token>@github.com/username/myrepo.git
```