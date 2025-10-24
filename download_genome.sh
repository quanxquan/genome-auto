#!/bin/bash

# 基因组下载测试脚本
# 用于测试服务器稳定性和下载速度
# 下载人类基因组参考序列 (Homo sapiens GRCh38) 后自动删除
# 文件大小约 850MB

echo "=========================================="
echo "开始基因组下载测试"
echo "用途: 测试服务器稳定性和下载速度"
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

# 清理旧的测试目录（如果存在）
if [ -d ~/genome ]; then
    echo "清理旧的测试目录: ~/genome"
    rm -rf ~/genome
    echo "✓ 旧目录已清理"
fi

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
echo "测试模式: 下载完成后将自动删除文件"
echo ""

# 记录开始时间
START_TIME=$(date +%s)
echo "开始下载基因组文件..."
echo "开始时间: $(date)"
echo "注意: 由于文件较大，下载可能需要几分钟时间"
echo ""

wget --progress=bar:force https://ftp.ensembl.org/pub/release-115/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz

# 检查下载是否成功
if [ $? -eq 0 ]; then
    # 计算下载时间
    END_TIME=$(date +%s)
    DOWNLOAD_TIME=$((END_TIME - START_TIME))
    
    echo ""
    echo "=========================================="
    echo "下载完成!"
    echo "=========================================="
    echo "✓ 基因组文件下载成功"
    echo "文件位置: ~/genome/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz"
    echo "文件大小: $(du -h ~/genome/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz | cut -f1)"
    echo "下载时间: ${DOWNLOAD_TIME} 秒"
    echo "完成时间: $(date)"
    echo ""
    
    # 计算下载速度
    FILE_SIZE_BYTES=$(stat -c%s ~/genome/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz 2>/dev/null || stat -f%z ~/genome/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz 2>/dev/null)
    if [ $FILE_SIZE_BYTES -gt 0 ]; then
        SPEED_MBPS=$(echo "scale=2; $FILE_SIZE_BYTES / 1024 / 1024 / $DOWNLOAD_TIME" | bc 2>/dev/null || echo "计算中...")
        echo "下载速度: ${SPEED_MBPS} MB/s"
    fi
    echo ""
    
    # 测试模式：删除下载的文件
    echo "=========================================="
    echo "测试模式：清理下载文件"
    echo "=========================================="
    echo "正在删除测试文件..."
    rm -rf ~/genome
    echo "✓ 测试文件已清理"
    echo "✓ 目录 ~/genome 已删除"
    echo ""
    echo "测试完成！服务器稳定性和下载速度测试成功"
    echo "总测试时间: ${DOWNLOAD_TIME} 秒"
    
else
    echo ""
    echo "=========================================="
    echo "下载失败!"
    echo "=========================================="
    echo "错误: 基因组文件下载失败"
    echo "请检查网络连接或稍后重试"
    echo "测试时间: $(( $(date +%s) - START_TIME )) 秒"
    exit 1
fi

echo "脚本执行完成，正在退出..."
exit 0
