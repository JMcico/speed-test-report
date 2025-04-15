import os
from dotenv import load_dotenv
from speed_test import speeder
from dao.utils import save_data, print_test_results


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
    # print_test_results(results)

    # 写入数据
    save_data(results)
    # writer = InfluxDBWriter(url, token, org, bucket)
    # writer.write_data(results['measurement'], results['fields'], results['tags'], results['time'])
    
    # 关闭连接
    # writer.close()
