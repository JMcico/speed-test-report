import os
from dotenv import load_dotenv
from speed_test import speeder
from db.influxdb_writer import InfluxDBWriter

def print_test_results(results):
    print(f"InfluxDB measurement: {results['measurement']}")  
    print(f"Speed Test start time: {results['time']}")  
    print(f"Download Speed: {results['fields']['download_speed']:.2f} Mbps")
    print(f"Upload Speed: {results['fields']['upload_speed']:.2f} Mbps")
    print(f"Ping: {results['fields']['ping']:.2f} ms")
    print(f"Jitter: {results['fields']['jitter']:.2f} ms")
    print(f"Bytes Sent: {results['fields']['bytes_sent']} bytes")
    print(f"Bytes Received: {results['fields']['bytes_received']} bytes")
    print(f"Server Name: {results['tags']['server_name']}")
    print(f"Server Country: {results['tags']['server_country']}")
    print(f"Server Sponsor: {results['tags']['server_sponsor']}")
    print(f"Test Duration: {results['fields']['test_duration']:.2f} seconds")

if __name__ == "__main__":
    # 加载.env文件
    load_dotenv()
    url = os.getenv("INFLUXDB_URL")
    token = os.getenv("INFLUXDB_TOKEN")
    org = os.getenv("INFLUXDB_ORG")
    bucket = os.getenv("INFLUXDB_BUCKET")

    # 运行速度测试
    results = speeder.run_speedtest()

    # 打印结果
    print_test_results(results)

    # 写入数据
    writer = InfluxDBWriter(url, token, org, bucket)
    writer.write_data(results['measurement'], results['fields'], results['tags'], results['time'])
    
    # 关闭连接
    writer.close()
