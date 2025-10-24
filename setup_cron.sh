#!/bin/bash

# 自动测试设置脚本
# 用于配置每日自动运行基因组下载测试

echo "=========================================="
echo "基因组下载自动测试设置"
echo "=========================================="

# 检查 crontab 命令是否可用
if ! command -v crontab &> /dev/null; then
    echo "错误: 未找到 crontab 命令"
    echo ""
    echo "请根据系统类型安装 cron 服务:"
    echo ""
    echo "Ubuntu/Debian:"
    echo "  sudo apt-get update"
    echo "  sudo apt-get install cron"
    echo ""
    echo "CentOS/RHEL:"
    echo "  sudo yum install cronie"
    echo "  sudo systemctl enable crond"
    echo "  sudo systemctl start crond"
    echo ""
    echo "Alpine Linux:"
    echo "  sudo apk add dcron"
    echo "  sudo rc-update add dcron"
    echo "  sudo rc-service dcron start"
    echo ""
    echo "安装完成后重新运行此脚本"
    exit 1
fi

# 检查是否以 root 身份运行
if [ "$EUID" -eq 0 ]; then
    echo "警告: 检测到以 root 身份运行"
    echo "建议使用普通用户运行此脚本"
    read -p "是否继续? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "已取消设置"
        exit 1
    fi
fi

# 获取当前用户
CURRENT_USER=$(whoami)
echo "当前用户: $CURRENT_USER"

# 获取脚本路径
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_PATH="$SCRIPT_DIR/download_genome.sh"

echo "脚本路径: $SCRIPT_PATH"

# 检查脚本是否存在
if [ ! -f "$SCRIPT_PATH" ]; then
    echo "错误: 找不到 download_genome.sh 脚本"
    echo "请确保脚本在同一目录下"
    exit 1
fi

# 确保脚本有执行权限
chmod +x "$SCRIPT_PATH"
echo "✓ 脚本权限设置完成"

# 创建日志目录
LOG_DIR="$HOME/genome_test_logs"
mkdir -p "$LOG_DIR"
echo "✓ 日志目录创建: $LOG_DIR"

# 生成 crontab 条目
CRON_ENTRY="0 2 * * * $SCRIPT_PATH >> $LOG_DIR/genome_test_\$(date +\%Y\%m\%d).log 2>&1"

echo ""
echo "=========================================="
echo "Crontab 配置"
echo "=========================================="
echo "建议的 crontab 条目:"
echo "$CRON_ENTRY"
echo ""
echo "说明:"
echo "- 每天凌晨 2:00 自动运行"
echo "- 日志文件: $LOG_DIR/genome_test_YYYYMMDD.log"
echo "- 包含所有输出和错误信息"
echo ""

# 询问是否自动添加 crontab
read -p "是否自动添加到 crontab? (y/N): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    # 备份现有 crontab
    crontab -l > /tmp/crontab_backup_$(date +%Y%m%d_%H%M%S) 2>/dev/null || true
    echo "✓ 现有 crontab 已备份"
    
    # 添加新的 crontab 条目
    (crontab -l 2>/dev/null; echo "$CRON_ENTRY") | crontab -
    
    if [ $? -eq 0 ]; then
        echo "✓ Crontab 配置成功"
        echo ""
        echo "当前 crontab 配置:"
        crontab -l
    else
        echo "错误: Crontab 配置失败"
        echo ""
        echo "请尝试手动配置:"
        echo "1. 运行: crontab -e"
        echo "2. 添加以下行:"
        echo "   $CRON_ENTRY"
        echo "3. 保存并退出"
        exit 1
    fi
else
    echo "手动配置 crontab:"
    echo "1. 运行: crontab -e"
    echo "2. 添加以下行:"
    echo "   $CRON_ENTRY"
    echo "3. 保存并退出"
fi

echo ""
echo "=========================================="
echo "设置完成"
echo "=========================================="
echo "✓ 自动测试配置完成"
echo "✓ 日志目录: $LOG_DIR"
echo "✓ 测试时间: 每天凌晨 2:00"
echo ""
echo "手动运行测试:"
echo "  $SCRIPT_PATH"
echo ""
echo "查看日志:"
echo "  ls -la $LOG_DIR/"
echo "  tail -f $LOG_DIR/genome_test_\$(date +\%Y\%m\%d).log"
echo ""
echo "停止自动测试:"
echo "  crontab -e  # 删除相关行"
echo ""
