#!/bin/bash

# 安装 Python 3.11 和相关依赖
install_python3_11() {
    echo "正在更新系统包列表..."
    sudo apt update

    echo "正在安装依赖项..."
    sudo apt install -y software-properties-common

    echo "正在添加 deadsnakes PPA..."
    sudo add-apt-repository -y ppa:deadsnakes/ppa

    echo "正在更新包列表..."
    sudo apt update

    echo "正在安装 Python 3.11..."
    sudo apt install -y python3.11

    echo "正在安装 pip..."
    sudo apt install -y python3-pip
}

# 设置 Python 3.11 为默认版本
set_default_python3_11() {
    echo "正在设置 Python 3.11 为默认版本..."

    # 添加 Python 3.11 到 update-alternatives
    sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1

    # 配置默认 Python 版本
    sudo update-alternatives --config python3

    echo "Python 3.11 已设置为默认版本。"

    sudo ln -s /usr/bin/python3 /usr/bin/python
}

# 验证安装
verify_installation() {
    echo "验证 Python 3.11 和 pip 是否安装成功..."

    python3 --version
    pip3 --version

    if python3 --version | grep -q "Python 3.11"; then
        echo "Python 3.11 安装成功！"
    else
        echo "Python 3.11 安装失败，请检查日志。"
        exit 1
    fi

    if pip3 --version; then
        echo "pip 安装成功！"
    else
        echo "pip 安装失败，请检查日志。"
        exit 1
    fi
}

install_requirements() {
    echo "Install required dependancy"
    pip install -r requirements.txt
}

# 主函数
main() {
    install_python3_11
    set_default_python3_11
    verify_installation
    install_requirements
}

# 执行主函数
main