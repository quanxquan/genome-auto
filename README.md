# 人类基因组下载脚本

这是一个用于下载人类基因组参考序列 (Homo sapiens GRCh38) 的自动化脚本。

## 功能特性

- 🧬 自动下载人类基因组参考序列 (GRCh38 release-115)
- 📁 自动创建 `~/genome` 目录
- 📊 显示详细的下载进度和状态信息
- ✅ 包含错误检查和验证
- 🚀 支持一键远程执行

## 文件信息

- **基因组版本**: GRCh38 (release-115)
- **文件大小**: 约 850MB
- **数据来源**: Ensembl FTP 服务器
- **文件格式**: FASTA (压缩)

## 使用方法

### 方法一：一键远程执行（推荐）

```bash
curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/download_genome.sh | bash
```

### 方法二：本地执行

1. 下载脚本：
```bash
wget https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/download_genome.sh
```

2. 添加执行权限：
```bash
chmod +x download_genome.sh
```

3. 运行脚本：
```bash
./download_genome.sh
```

## 系统要求

- Linux/macOS 系统
- `wget` 命令（脚本会自动检查）
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

## 下载后的文件

脚本执行完成后，基因组文件将保存在：
```
~/genome/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
```

## 使用基因组文件

### 解压文件
```bash
cd ~/genome
gunzip Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
```

### 查看文件信息
```bash
# 查看文件大小
ls -lh ~/genome/Homo_sapiens.GRCh38.dna.primary_assembly.fa

# 查看序列统计
samtools faidx ~/genome/Homo_sapiens.GRCh38.dna.primary_assembly.fa
```

### 构建索引（用于 BWA、Bowtie2 等）
```bash
# BWA 索引
bwa index ~/genome/Homo_sapiens.GRCh38.dna.primary_assembly.fa

# Bowtie2 索引
bowtie2-build ~/genome/Homo_sapiens.GRCh38.dna.primary_assembly.fa ~/genome/GRCh38
```

## 注意事项

- 下载过程可能需要几分钟时间，请耐心等待
- 确保有足够的磁盘空间（至少 1GB）
- 建议在稳定的网络环境下下载
- 文件较大，请勿在移动网络环境下使用

## 故障排除

### 下载失败
- 检查网络连接
- 确认防火墙设置
- 尝试使用代理服务器

### 权限错误
- 确保对家目录有写权限
- 检查磁盘空间是否充足

## 许可证

本项目采用 MIT 许可证。基因组数据遵循 Ensembl 数据使用条款。

## 贡献

欢迎提交 Issue 和 Pull Request 来改进这个脚本。
