#!/bin/bash

# 定义变量
INFLUXDB_VERSION="2.7.1"  # InfluxDB 版本
INFLUXDB_ADMIN_USER="admin"  # 管理员用户名
INFLUXDB_ADMIN_PASSWORD="admin123"  # 管理员密码
INFLUXDB_ORG="speeder"  # 组织名称
INFLUXDB_BUCKET="speeder"  # Bucket 名称

# 安装依赖
sudo apt update
sudo apt install -y curl jq

# 下载并安装 InfluxDB
wget https://dl.influxdata.com/influxdb/releases/influxdb2-${INFLUXDB_VERSION}-amd64.deb
sudo dpkg -i influxdb2-${INFLUXDB_VERSION}-amd64.deb

# 启动 InfluxDB 服务
sudo systemctl start influxdb
sudo systemctl enable influxdb

# 等待 InfluxDB 服务启动
sleep 10

# 初始化 InfluxDB
influx setup --force \
  --username ${INFLUXDB_ADMIN_USER} \
  --password ${INFLUXDB_ADMIN_PASSWORD} \
  --org ${INFLUXDB_ORG} \
  --bucket ${INFLUXDB_BUCKET} \
  --retention 0 \
  --token my-super-secret-token

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