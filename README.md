# Setup Instructions

Follow these steps to set up your environment.

## 1. Install required packages

Run the following command in Termux:

```
pkg install fzf zoxide file unrar p7zip termux-api
```

Make sure **Termux:API** is installed from the **same source** as Termux (the source where GitHub is installed).

## 2. Make scripts executable

```
chmod +x ~/.config/zsh/scripts/*.sh
```

## 3. Update plugins

```
update-plugins
```

## 4. Switch default shell

Use the command below to change your default shell:

```
switch-shell
```
