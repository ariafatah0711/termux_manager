# termux-manager

## setup
```bash
git clone https://github.com/ariafatah0711/termux_manager
chmod +x setup.sh
./setup.sh
```

## use
```bash
termux-manager
```

## list script
- ```main.sh``` \
  ![alt text](img/__1__.jpg)

- ```script/ping``` \
  ![alt text](img/__2__.jpg)

- ```script/speedtest``` \
  ![alt text](img/__3__.jpg)

- ```script/ssh-manager``` \
![alt text](img/__4__.jpg)

- ```script/code_server-manager``` \
  ![alt text](img/__5__.jpg)

## information
### push repo with token
- go to https://github.com/settings/personal-access-tokens/new
- and add the repo your want to token and add the permission repo **content**
```bash
git remote add origin https://<token>@github.com/username/myrepo.git
```