# Termux Manager

**Termux Manager** adalah tool berbasis shell yang berfungsi sebagai pusat kontrol untuk berbagai skrip dan fitur di Termux. Tool ini dirancang untuk mempermudah pengelolaan layanan, skrip, dan manajemen sistem dalam satu antarmuka interaktif.

---

## Struktur Direktori

```
termux_manager/
├── main.sh             # Skrip utama, antarmuka menu
├── setup.sh            # Instalasi awal dan konfigurasi environment
├── uninstall.sh        # Menghapus instalasi dan shortcut
├── config.json         # Konfigurasi menu dan daftar skrip
├── utils/              # Fungsi bantu: banner, warna, validasi input
├── req/                # Daftar paket dependensi tambahan
├── img/                # Dokumentasi visual / screenshot
└── script/             # Folder berisi skrip yang dijalankan via menu
```

---

## Instalasi

```bash
git clone https://github.com/ariafatah0711/termux_manager
cd termux_manager
chmod +x setup.sh
./setup.sh
```

---

## Penggunaan

Setelah instalasi, Termux Manager dapat dijalankan dengan:

```bash
termux-manager
```

Atau secara langsung melalui skrip utama:

```bash
./main.sh
```

---

## Uninstall

Untuk menghapus instalasi dan shortcut Termux Manager:

```bash
./uninstall.sh
```

---

## Tampilan Menu Utama

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

---

## Subcommands Proot Distro Manager

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

---

## Daftar Skrip (dapat dikustomisasi melalui `config.json`)

* `main.sh` \
  ![](img/__1__.jpg)

* `script/ping` \
  ![](img/__2__.jpg)

* `script/speedtest` \
  ![](img/__3__.jpg)

* `script/ssh-manager` \
  ![](img/__4__.jpg)

* `script/code_server-manager` \
  ![](img/__5__.jpg)

* `script/proot-manager`

* `script/n8n_start`

* `script/create_shortcuts`

---

## GitHub Push dengan Token

1. Buat token dari: [GitHub Token Settings](https://github.com/settings/personal-access-tokens/new)
2. Aktifkan akses ke repository dengan izin **repo > contents**

Contoh perintah push:

```bash
git remote add origin https://<token>@github.com/username/myrepo.git
```

---