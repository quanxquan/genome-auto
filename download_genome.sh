#!/bin/bash

# 基因组下载脚本
# 用于下载人类基因组参考序列 (Homo sapiens GRCh38)
# 文件大小约 850MB

echo "=========================================="
echo "开始下载人类基因组参考序列"
echo "=========================================="

# 检查 wget 是否安装
if ! command -v wget &> /dev/null; then
    echo "错误: 未找到 wget 命令，请先安装 wget"
    echo "Ubuntu/Debian: sudo apt-get install wget"
    echo "CentOS/RHEL: sudo yum install wget"
    echo "macOS: brew install wget"
    exit 1
fi

echo "✓ wget 命令检查通过"

# 创建基因组目录
echo "正在创建目录: ~/genome"
mkdir -p ~/genome

if [ $? -eq 0 ]; then
    echo "✓ 目录创建成功"
else
    echo "错误: 无法创建目录 ~/genome"
    exit 1
fi

# 切换到基因组目录
echo "正在切换到目录: ~/genome"
cd ~/genome

if [ $? -eq 0 ]; then
    echo "✓ 目录切换成功"
    echo "当前工作目录: $(pwd)"
else
    echo "错误: 无法切换到目录 ~/genome"
    exit 1
fi

# 显示下载信息
echo ""
echo "=========================================="
echo "下载信息"
echo "=========================================="
echo "文件来源: Ensembl FTP 服务器"
echo "文件版本: GRCh38 (release-115)"
echo "文件大小: 约 850MB"
echo "下载地址: https://ftp.ensembl.org/pub/release-115/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz"
echo ""

# 开始下载
echo "开始下载基因组文件..."
echo "注意: 由于文件较大，下载可能需要几分钟时间"
echo ""

wget --progress=bar:force https://ftp.ensembl.org/pub/release-115/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz

# 检查下载是否成功
if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "下载完成!"
    echo "=========================================="
    echo "✓ 基因组文件下载成功"
    echo "文件位置: ~/genome/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz"
    echo "文件大小: $(du -h ~/genome/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz | cut -f1)"
    echo ""
    echo "使用说明:"
    echo "- 解压文件: gunzip Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz"
    echo "- 查看文件: less Homo_sapiens.GRCh38.dna.primary_assembly.fa"
    echo "- 构建索引: samtools faidx Homo_sapiens.GRCh38.dna.primary_assembly.fa"
    echo ""
else
    echo ""
    echo "=========================================="
    echo "下载失败!"
    echo "=========================================="
    echo "错误: 基因组文件下载失败"
    echo "请检查网络连接或稍后重试"
    exit 1
fi

echo "脚本执行完成，正在退出..."
exit 0
