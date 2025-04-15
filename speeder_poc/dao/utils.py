import json
import time
from pathlib import Path


# 配置项
DATA_DIR = Path(__file__).parent / "data"

def save_data(data):
    """保存到JSONL文件"""
    DATA_DIR.mkdir(exist_ok=True)
    today_file = DATA_DIR / f"speed_{time.strftime('%Y%m%d')}.jsonl"
    
    with open(today_file, "a", encoding="utf-8") as f:
        f.write(json.dumps(data, ensure_ascii=False) + "\n")
        # print("Writen Json file successfully!")


def print_test_results(data):
    print(f"InfluxDB measurement: {data['measurement']}")  
    print(f"Speed Test start time: {data['time']}")  
    print(f"Download Speed: {data['fields']['download_speed']:.2f} Mbps")
    print(f"Upload Speed: {data['fields']['upload_speed']:.2f} Mbps")
    print(f"Ping: {data['fields']['ping']:.2f} ms")
    print(f"Jitter: {data['fields']['jitter']:.2f} ms")
    print(f"Bytes Sent: {data['fields']['bytes_sent']} bytes")
    print(f"Bytes Received: {data['fields']['bytes_received']} bytes")
    print(f"Server Name: {data['tags']['server_name']}")
    print(f"Server Country: {data['tags']['server_country']}")
    print(f"Server Sponsor: {data['tags']['server_sponsor']}")
    print(f"Test Duration: {data['fields']['test_duration']:.2f} seconds")
