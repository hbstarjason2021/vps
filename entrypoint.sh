#!/bin/bash
set -e

: "${ROOT_PASSWORD:=root}"

echo "🔐 设置 root 密码..."
echo "root:${ROOT_PASSWORD}" | chpasswd

echo "🔑 生成 SSH host keys..."
ssh-keygen -A

echo "📁 准备运行目录..."
mkdir -p /var/run/sshd
mkdir -p /var/run/xrdp
mkdir -p /var/log/xrdp

rm -f /var/run/xrdp/xrdp.pid
rm -f /var/run/xrdp/xrdp-sesman.pid

echo "🚀 启动 SSH 服务，外部端口 8022，容器内端口 22..."
/usr/sbin/sshd

echo "🚀 启动 Web 终端，端口 4200..."
/usr/bin/shellinaboxd \
  -t \
  -p 4200 \
  -s "/:LOGIN" &

echo "🚀 启动 XRDP 会话服务..."
/usr/sbin/xrdp-sesman

echo "✅ Ubuntu 容器已启动"
echo "   RDP: 3389"
echo "   SSH: 8022"
echo "   Web 终端: 4200"

exec /usr/sbin/xrdp --nodaemon
