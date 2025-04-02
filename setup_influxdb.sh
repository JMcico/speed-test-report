#!/bin/bash

# 定义变量
INFLUXDB_VERSION="2.7.1"  # InfluxDB 版本
INFLUXDB_DATA_DIR="/var/lib/influxdb"
INFLUXDB_CONFIG_DIR="/etc/influxdb"
INFLUXDB_ADMIN_USER="admin"  # 管理员用户名
INFLUXDB_ADMIN_PASSWORD="admin123"  # 管理员密码
INFLUXDB_ORG="speeder"  # 组织名称
INFLUXDB_BUCKET="speeder"  # Bucket 名称
INFLUXDB_PORT="8086"
INFLUXCLI_VERSION="2.7.5"

# 检查root权限
if [ "$(id -u)" -ne 0 ]; then
  echo "错误：请使用sudo或以root用户运行此脚本"
  exit 1
fi

# 安装依赖
sudo apt update
sudo apt install -y curl jq

# 下载并安装 InfluxDB
wget https://dl.influxdata.com/influxdb/releases/influxdb2-${INFLUXDB_VERSION}-amd64.deb
sudo dpkg -i influxdb2-${INFLUXDB_VERSION}-amd64.deb

# 安装独立的influx CLI工具（关键修复）
wget https://dl.influxdata.com/influxdb/releases/influxdb2-client-${INFLUXCLI_VERSION}-linux-amd64.tar.gz
tar xvzf influxdb2-client-${INFLUXCLI_VERSION}-linux-amd64.tar.gz
cp ./influx /usr/local/bin/
chmod +x /usr/local/bin/influx

# 启动 InfluxDB 服务
sudo systemctl start influxdb
sudo systemctl enable influxdb

# 等待 InfluxDB 服务启动
sleep 10

# 等待服务启动（关键：增加健康检查）
for i in {1..10}; do
  if curl -s http://localhost:8086/health; then
    break
  fi
  sleep 3
done

# 初始化（增加超时和重试）
timeout 30 influx setup --force \
  --username ${INFLUXDB_ADMIN_USER} \
  --password ${INFLUXDB_ADMIN_PASSWORD} \
  --org ${INFLUXDB_ORG} \
  --bucket ${INFLUXDB_BUCKET} \
  --retention 0 \
  --token my-super-secret-token

if [ $? -eq 0 ]; then
  echo -e "\n\033[32mInfluxDB 初始化成功!\033[0m"
  echo "URL: http://$(hostname -I | awk '{print $1}'):8086"
  echo "Token: my-super-secret-token"
else
  echo -e "\n\033[31m初始化失败，尝试手动执行:\033[0m"
  echo "influx setup --force \\"
  echo "  --username ${INFLUXDB_ADMIN_USER} \\"
  echo "  --password ${INFLUXDB_ADMIN_PASSWORD} \\"
  echo "  --org ${INFLUXDB_ORG} \\"
  echo "  --bucket ${INFLUXDB_BUCKET}"
  exit 1
fi

# 检查初始化是否成功
if [ $? -eq 0 ]; then
  echo "InfluxDB setup completed successfully!"
else
  echo "Failed to setup InfluxDB."
  exit 1
fi

# 打印 InfluxDB 信息
echo "InfluxDB Admin User: ${INFLUXDB_ADMIN_USER}"
echo "InfluxDB Admin Password: ${INFLUXDB_ADMIN_PASSWORD}"
echo "InfluxDB Organization: ${INFLUXDB_ORG}"
echo "InfluxDB Bucket: ${INFLUXDB_BUCKET}"
echo "InfluxDB Token: my-super-secret-token"

chown -R kds_admin:kds_admin ~/Speeder/speed-test-report
chmod 755 ~/Speeder/speed-test-report
