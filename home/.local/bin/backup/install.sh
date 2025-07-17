sudo ln -sf ~/.dotfiles/home/.local/bin/backup/doc_backup.sh /opt/
sudo ln -sf ~/.dotfiles/home/.local/bin/backup/doc-backup.service /etc/systemd/system
sudo ln -sf ~/.dotfiles/home/.local/bin/backup/doc-backup.timer /etc/systemd/system
sudo systemctl start doc-backup.timer

sudo ln -sf ~/.dotfiles/home/.local/bin/backup/photo_backup.sh /opt/
sudo ln -sf ~/.dotfiles/home/.local/bin/backup/photo-backup.service /etc/systemd/system
sudo ln -sf ~/.dotfiles/home/.local/bin/backup/photo-backup.timer /etc/systemd/system
sudo systemctl start photo-backup.timer