
```sh
sudo ln -sf ~/.dotfiles/home/.local/bin/backup/doc_backup.sh /opt/
sudo ln -sf ~/.dotfiles/home/.local/bin/backup/doc-backup.service /etc/systemd/system
sudo ln -sf ~/.dotfiles/home/.local/bin/backup/doc-backup.timer /etc/systemd/system
sudo systemctl start doc-backup.timer

```sh
sudo ln -sf ~/.dotfiles/home/.local/bin/backup/photo_backup.sh /opt/
sudo ln -sf ~/.dotfiles/home/.local/bin/backup/photo-backup.service /etc/systemd/system
sudo ln -sf ~/.dotfiles/home/.local/bin/backup/photo-backup.timer /etc/systemd/system
sudo systemctl start photo-backup.timer
```

```sh
dar --test <path/to/backup/file/without/extension>
dar --extract <path/to/backup/no/ext> --fs-root <path/to/extract/dir>
```

```sh
journalctl --unit doc-full-backup.service --lines 10
# Следить в реальном времени
journalctl --unit doc-full-backup.service --follow
systemctl list-timers
# Помошник для анализа того как работает таймер
systemd-analyze calendar --iterations=5 '10:00:00'
man systemd-analyze
```