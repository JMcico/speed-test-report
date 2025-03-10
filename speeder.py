import speedtest
import time
from datetime import datetime 

def run_speedtest():
    # 记录测试开始时间
    test_start_time = datetime.utcnow().isoformat() + "Z"

    # 创建 Speedtest 对象
    st = speedtest.Speedtest()

    # 获取最佳服务器
    st.get_best_server()

    # 测试下载速度（单位：比特/秒）
    download_speed = st.download() / 1_000_000  # 转换为 Mbps

    # 测试上传速度（单位：比特/秒）
    upload_speed = st.upload() / 1_000_000  # 转换为 Mbps

    # 获取服务器信息
    server = st.results.server
    server_name = server['name']
    server_country = server['country']
    server_sponsor = server['sponsor']

    # 进行多次 ping 测试，计算抖动
    ping_values = []
    for _ in range(10):  # 进行 10 次 ping 测试
        ping = st.results.ping  # 获取当前 ping 值
        ping_values.append(ping)
        time.sleep(1)  # 每次 ping 测试间隔 1 秒

    # 计算抖动jitter, jitter = |当前 ping 值 - 前一个 ping 值|
    jitter_values = []
    for i in range(1, len(ping_values)):
        jitter = abs(ping_values[i] - ping_values[i - 1])  # 计算每次的抖动
        jitter_values.append(jitter)

    # 计算平均抖动
    average_jitter = sum(jitter_values) / len(jitter_values)

    # 记录测试完成时间
    test_end_time = datetime.utcnow().isoformat() + "Z"

    # 获取发送和接收的字节数
    bytes_sent = st.results.bytes_sent
    bytes_received = st.results.bytes_received

    # 计算测试持续时间（单位：秒）
    test_duration = (datetime.fromisoformat(test_end_time[:-1]) - datetime.fromisoformat(test_start_time[:-1])).total_seconds()

    # 返回结果
    return {
        "test_start_time": test_start_time,
        "download_speed": download_speed,
        "upload_speed": upload_speed,
        "ping": ping_values[-1],
        "jitter": average_jitter,
        "bytes_sent": bytes_sent,
        "bytes_received": bytes_received,
        "server_name": server_name,
        "server_country": server_country,
        "server_sponsor": server_sponsor,
        "test_end_time": test_end_time,
        "test_duration": test_duration
    }

if __name__ == "__main__":
    # 运行速度测试
    results = run_speedtest()

    # 打印结果
    print(f"Test Start Time: {results['test_start_time']}")    
    print(f"Download Speed: {results['download_speed']:.2f} Mbps")
    print(f"Upload Speed: {results['upload_speed']:.2f} Mbps")
    print(f"Ping: {results['ping']:.2f} ms")
    print(f"Jitter: {results['jitter']:.2f} ms")
    print(f"Test End Time: {results['test_end_time']}")
    print(f"Bytes Sent: {results['bytes_sent']} bytes")
    print(f"Bytes Received: {results['bytes_received']} bytes")
    print(f"Server Name: {results['server_name']}")
    print(f"Server Country: {results['server_country']}")
    print(f"Server Sponsor: {results['server_sponsor']}")
    print(f"Test Duration: {results['test_duration']:.2f} seconds")