#!/bin/bash
# Kịch bản tạo nhóm devops-admin, user deployer và cấu hình sudoers NOPASSWD cho systemctl

set -e

echo "=== 1. Tạo nhóm devops-admin ==="
sudo groupadd -f devops-admin

echo "=== 2. Tạo người dùng deployer và thêm vào nhóm devops-admin ==="
if ! id -u deployer >/dev/null 2>&1; then
    sudo adduser --disabled-password --gecos "" deployer
fi
sudo usermod -aG devops-admin deployer

echo "=== 3. Cấu hình đặc quyền sudoers bằng visudo rules ==="
SUDOERS_FILE="/etc/sudoers.d/devops-admin"
SUDOERS_RULE="%devops-admin ALL=(ALL) NOPASSWD: /usr/bin/systemctl start *, /usr/bin/systemctl stop *, /usr/bin/systemctl restart *, /usr/bin/systemctl status *"

echo "$SUDOERS_RULE" | sudo tee $SUDOERS_FILE > /dev/null
sudo chmod 0440 $SUDOERS_FILE

echo "=== 4. Kiểm tra cấu hình syntax sudoers ==="
sudo visudo -c

echo "Cấu hình thành công!"
