# 人类基因组下载测试脚本

这是一个用于测试服务器稳定性和下载速度的自动化脚本。下载人类基因组参考序列 (Homo sapiens GRCh38) 后自动删除，适合用于服务器性能测试。

## 功能特性

- 🧬 自动下载人类基因组参考序列 (GRCh38 release-115)
- 📁 自动创建和清理 `~/genome` 目录
- 📊 显示详细的下载进度和状态信息
- ⏱️ 计算下载时间和速度统计
- 🗑️ 测试完成后自动删除文件（节省磁盘空间）
- ✅ 包含错误检查和验证
- 🚀 支持一键远程执行
- ⏰ 支持每日自动运行测试

## 文件信息

- **基因组版本**: GRCh38 (release-115)
- **文件大小**: 约 850MB
- **数据来源**: Ensembl FTP 服务器
- **文件格式**: FASTA (压缩)

## 使用方法

### 方法一：一键远程执行（推荐）

```bash
curl -sSL https://raw.githubusercontent.com/quanxquan/genome-auto/auto/download_genome.sh | bash
```

### 方法二：本地执行

1. 下载脚本：
```bash
wget https://raw.githubusercontent.com/quanxquan/genome-auto/auto/download_genome.sh
```

2. 添加执行权限：
```bash
chmod +x download_genome.sh
```

3. 运行脚本：
```bash
./download_genome.sh
```

### 方法三：设置每日自动测试

1. 下载自动设置脚本：
```bash
wget https://raw.githubusercontent.com/quanxquan/genome-auto/auto/setup_cron.sh
chmod +x setup_cron.sh
```

2. 运行设置脚本：
```bash
./setup_cron.sh
```

3. 按照提示完成 crontab 配置（每天凌晨 2:00 自动运行）

## 系统要求

- Linux/macOS 系统
- `wget` 命令（脚本会自动检查）
- `crontab` 命令（用于自动测试功能）
- 至少 1GB 可用磁盘空间
- 稳定的网络连接

## 安装 wget

如果系统没有安装 wget，请根据系统类型安装：

```bash
# Ubuntu/Debian
sudo apt-get install wget

# CentOS/RHEL
sudo yum install wget

# macOS
brew install wget
```

## 安装 cron 服务

如果系统没有安装 cron 服务，请根据系统类型安装：

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install cron

# CentOS/RHEL
sudo yum install cronie
sudo systemctl enable crond
sudo systemctl start crond

# Alpine Linux
sudo apk add dcron
sudo rc-update add dcron
sudo rc-service dcron start
```

## 测试模式说明

**重要**: 这是测试模式脚本，下载完成后会自动删除文件！

### 测试流程
1. 创建 `~/genome` 目录
2. 下载基因组文件（约 850MB）
3. 计算下载时间和速度
4. 显示测试结果
5. **自动删除所有文件**（节省磁盘空间）

### 测试输出示例
```
==========================================
下载完成!
==========================================
✓ 基因组文件下载成功
文件位置: ~/genome/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
文件大小: 850M
下载时间: 120 秒
完成时间: 2024-01-15 02:05:30
下载速度: 7.08 MB/s

==========================================
测试模式：清理下载文件
==========================================
正在删除测试文件...
✓ 测试文件已清理
✓ 目录 ~/genome 已删除

测试完成！服务器稳定性和下载速度测试成功
总测试时间: 120 秒
```

### 日志文件
自动测试模式下，日志保存在：
```
~/genome_test_logs/genome_test_YYYYMMDD.log
```

## 注意事项

- 下载过程可能需要几分钟时间，请耐心等待
- 确保有足够的磁盘空间（至少 1GB，测试完成后会自动释放）
- 建议在稳定的网络环境下下载
- 文件较大，请勿在移动网络环境下使用
- **测试模式会自动删除文件，请勿用于实际基因组分析**
- 自动测试建议在服务器空闲时间运行（如凌晨）

## 故障排除

### 下载失败
- 检查网络连接
- 确认防火墙设置
- 尝试使用代理服务器

### 权限错误
- 确保对家目录有写权限
- 检查磁盘空间是否充足

### 自动测试问题
- 检查 crontab 配置：`crontab -l`
- 查看日志文件：`tail -f ~/genome_test_logs/genome_test_$(date +%Y%m%d).log`
- 手动运行测试：`./download_genome.sh`
- 检查 cron 服务状态：
  ```bash
  # Ubuntu/Debian
  sudo systemctl status cron
  
  # CentOS/RHEL
  sudo systemctl status crond
  
  # Alpine Linux
  sudo rc-service dcron status
  ```

### crontab 命令不存在
如果提示 `crontab: command not found`，请安装 cron 服务：
```bash
# Ubuntu/Debian
sudo apt-get install cron

# CentOS/RHEL
sudo yum install cronie

# Alpine Linux
sudo apk add dcron
```

### 停止自动测试
```bash
# 编辑 crontab
crontab -e

# 删除包含 genome 的行，保存退出
```

## 许可证

本项目采用 MIT 许可证。基因组数据遵循 Ensembl 数据使用条款。

## 快速开始

### 最简单的使用方式

```bash
# 一键运行测试（推荐）
curl -sSL https://raw.githubusercontent.com/quanxquan/genome-auto/auto/download_genome.sh | bash
```

### 设置每日自动测试

```bash
# 1. 下载设置脚本
wget https://raw.githubusercontent.com/quanxquan/genome-auto/auto/setup_cron.sh
chmod +x setup_cron.sh

# 2. 运行设置（会自动检查并安装依赖）
./setup_cron.sh
```

## 项目结构

```
genome-auto/
├── download_genome.sh    # 主测试脚本
├── setup_cron.sh        # 自动配置脚本
├── README.md            # 使用说明
└── .gitignore           # Git 忽略配置
```

## 分支说明

- **main**: 原始下载脚本（保留文件）
- **auto**: 自动测试脚本（删除文件）

## 贡献

欢迎提交 Issue 和 Pull Request 来改进这个脚本。
