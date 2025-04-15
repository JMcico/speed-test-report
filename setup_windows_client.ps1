# 定义变量
$download_path = "C:\Users\Jim.Chen\Github"
$pythonVersion = "3.11.4"  # Python 版本
$influxdbVersion = "2.7.1"  # InfluxDB 版本
$grafanaVersion = "10.1.5"  # Grafana 版本
$influxdbAdminUser = "admin"  # InfluxDB 管理员用户名
$influxdbAdminPassword = "admin123"  # InfluxDB 管理员密码
$influxdbOrg = "speeder"  # InfluxDB 组织名称
$influxdbBucket = "speeder"  # InfluxDB Bucket 名称
$influxDir = "E:\InfluxDB"  # InfluxDB 解压路径
$influxdbExePath = "$influxDir\influxdb2_windows_amd64\influxd.exe" # InfluxDB命令路径
$influxExePath = "$influxDir\influx.exe"  # Influx命令路径
$influxCliVersion = "2.7.5"   # InfluxCli命令路径
$grafanaDir = "E:\Grafana\grafana-$grafanaVersion"  # Grafana解压路径
$grafanaExePath = "$grafanaDir\bin\grafana-server.exe"  # Grafana命令路径
$grafanaConfigPath = "$grafanaDir\conf\defaults.ini"    # Grafana配置文件路径
$grafanaLogPath = "$grafanaDir\data\log\grafana.log"    # Grafana日志文件路径
# $taskName = "RunPythonMainEvery10Minutes"   # 定时任务名
# $taskDescription = "每10分钟运行一次 python main.py"    # 定时任务介绍
# $pythonPath = (Get-Command python).Source   # Python命令路径
# $scriptDir = "C:\Users\admin\Downloads\speed-test-report\speeder_poc"  # 运行脚本的母路径
# $scriptPath = "main.py"   #定时运行脚本名

# 检查下载目录是否存在
if (-Not (Test-Path $download_path)) {
  Write-Host "Download directory does not exist: $download_path"
  exit 1
}

# 更改工作目录
Set-Location -Path $download_path

# 安装 Python（已验证，可安装python3.11.4）
Write-Host "Installing Python..."
try {
  Invoke-WebRequest -Uri "https://www.python.org/ftp/python/$pythonVersion/python-$pythonVersion-amd64.exe" -OutFile "python-installer.exe"
  Start-Process -Wait -FilePath "python-installer.exe" -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1"
  Remove-Item "python-installer.exe"
} catch {
  throw "Failed to install Python: $_"
}

# 检查InfluxDir是否存在
if (-Not (Test-Path $influxDir)) {
  throw "Destination directory for InfluxDB does not exist: $influxDir"
}

# 安装 InfluxDB（已验证，可安装InfluxDB2.7.1）
Write-Host "Installing InfluxDB..."
try {
  Invoke-WebRequest -Uri "https://dl.influxdata.com/influxdb/releases/influxdb2-$influxdbVersion-windows-amd64.zip" -OutFile "influxdb.zip"
  Expand-Archive -Path "influxdb.zip" -DestinationPath $influxDir
  Remove-Item "influxdb.zip" 
} catch{
  throw "Failed to install InfluxDB: $_"
}

# 启动 InfluxDB 服务（已验证，可启动InfluxDB）
Write-Host "Starting InfluxDB..."
try {
  Start-Process -FilePath $influxdbExePath -ArgumentList "--http-bind-address :8086"
} catch {
  throw "Failed to start InfluxDB: $_"
}

# 等待 InfluxDB 启动
Start-Sleep -Seconds 10

# 检查 influx.exe 是否存在（已验证，可下载InfluxCLI工具 2.7.5）
if (-Not (Test-Path $influxExePath)) {
  Write-Host "Downloading influx.exe..."
  try {
    Invoke-WebRequest -Uri "https://dl.influxdata.com/influxdb/releases/influxdb2-client-$influxCliVersion-windows-amd64.zip" -OutFile "$influxDir\influx-cli.zip"
    Expand-Archive -Path "$influxDir\influx-cli.zip" -DestinationPath $influxDir
    Remove-Item "$influxDir\influx-cli.zip"
  } catch {
    throw "Failed to download or extract influx.exe: $_"
  }
}

# 检查 influx.exe 是否可运行（若安装解压成功，则程序正常执行）
if (-Not (Test-Path $influxExePath)) {
  throw "Failed to locate influx.exe at $influxExePath."
}

# 初始化 InfluxDB（已验证，可以初始化InfluxDB）
Write-Host "Setting up InfluxDB..."
try {
  & $influxExePath setup --force `
    --username $influxdbAdminUser `
    --password $influxdbAdminPassword `
    --org $influxdbOrg `
    --bucket $influxdbBucket `
    --retention 0 `
    --token my-super-secret-token
} catch {
  throw "Failed to setup InfluxDB: $_"
}

# 打印信息
Write-Host "InfluxDB Admin User: $influxdbAdminUser"
Write-Host "InfluxDB Admin Password: $influxdbAdminPassword"
Write-Host "InfluxDB Organization: $influxdbOrg"
Write-Host "InfluxDB Bucket: $influxdbBucket"
Write-Host "InfluxDB Token: my-super-secret-token"

# 使用 PowerShell 的 `cd` + `python main.py` 方式运行
# $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument `
#     "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$scriptDir'; & '$pythonPath' '$scriptPath'`""

# # 触发器（每10分钟运行一次）
# $trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 10) -RepetitionDuration ([TimeSpan]::MaxValue)

# # 任务设置
# $settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -DontStopOnIdleEnd

# # 删除旧任务（如果存在）
# if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
#   Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
# }

# # 注册新任务
# Register-ScheduledTask -TaskName $taskName -Description $taskDescription -Action $action -Trigger $trigger -Settings $settings -RunLevel Highest -Force

# Write-Host "已创建定时任务 '$taskName'，每10分钟运行一次 python main.py"

# 安装 Grafana（已验证，可安装Grafana 10.1.5）
Write-Host "Installing Grafana..."
try {
  Invoke-WebRequest -Uri "https://dl.grafana.com/oss/release/grafana-$grafanaVersion.windows-amd64.zip" -OutFile "grafana.zip"
  Expand-Archive -Path "grafana.zip" -DestinationPath "D:\Grafana"
  Remove-Item "grafana.zip"
} catch {
  throw "Failed to install Grafana: $_"
}

# 启动 Grafana 服务
Write-Host "Starting Grafana..."
try {
  Start-Process -FilePath $grafanaExePath -ArgumentList "--config=$grafanaConfigPath --homepath=$grafanaDir" -NoNewWindow -RedirectStandardOutput $grafanaLogPath -RedirectStandardError "$grafanaDir\data\log\grafana-error.log"  
  Write-Host "Grafana started successfully."
} catch {
  throw "Failed to start Grafana: $_"
}

# 等待 Grafana 启动
Start-Sleep -Seconds 10

# 打印信息
Write-Host "Installation completed successfully!"
Write-Host "Grafana is running at http://localhost:3000"