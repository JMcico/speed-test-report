from influxdb_client import InfluxDBClient, Point
from influxdb_client.client.write_api import SYNCHRONOUS 

class InfluxDBWriter:
    def __init__(self, url, token, org, bucket):
        """
        初始化 InfluxDB 客户端。

        :param url: InfluxDB 的 URL（例如：http://localhost:8086）
        :param token: InfluxDB 的 API Token
        :param org: 组织名称
        :param bucket: Bucket 名称
        """
        self.url = url
        self.token = token
        self.org = org
        self.bucket = bucket

        # 创建 InfluxDB 客户端
        self.client = InfluxDBClient(url=self.url, token=self.token, org=self.org)
        self.write_api = self.client.write_api(write_options=SYNCHRONOUS)

    def write_data(self, measurement, fields, tags=None, time=None):
        """
        将数据写入 InfluxDB。

        :param measurement: 测量值名称（类似于表名）
        :param fields: 字段字典（存储实际数据）
        :param tags: 标签字典（可选，用于索引和分组）
        :param time: 时间戳（可选，默认为当前时间）
        """
        # 创建数据点
        point = Point(measurement)

        # 添加标签（如果提供）
        if tags:
            for key, value in tags.items():
                point.tag(key, value)

        # 添加字段
        for key, value in fields.items():
            point.field(key, value)

        # 添加时间戳（如果提供）
        if time:
            point.time(time)

        # 写入 InfluxDB
        self.write_api.write(bucket=self.bucket, record=point)

    def close(self):
        """关闭 InfluxDB 客户端连接。"""
        self.client.close()