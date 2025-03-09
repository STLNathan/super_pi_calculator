markdown
复制
# Super π Calculator 🚀

[![Python Version](https://img.shields.io/badge/python-3.8+-blue.svg)](https://www.python.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

一个高性能的圆周率计算工具，支持多种算法和并行加速，可计算千万位精度的π值。

## 功能特性 ✨

- **多种经典算法支持**
  - 拉马努金公式（Ramanujan）
  - Chudnovsky算法（基础版 & 并行优化版）
  - 高斯-勒让德迭代法（Gauss-Legendre）
  - 马青公式（Machin）
  
- **极致性能优化**
  - 多进程并行计算加速
  - 二进制分割算法优化
  - 智能进度预测系统
  
- **高精度计算**
  - 支持千万位精度计算
  - 动态内存管理
  - 精度验证系统

- **用户友好界面**
  - 交互式命令行界面
  - 实时进度显示
  - 结果保存功能

## 安装步骤 📦

1. 克隆仓库：
```bash
git clone https://github.com/STLNathan/super_pi_calculator.git
cd super_pi_calculator

使用指南 🖥️
基本使用
bash
复制
python super_pi.py
交互式界面将引导您：

选择算法（支持1-5号算法）

输入目标小数位数

选择是否保存结果

命令行参数
bash
复制
python super_pi.py --algorithm 5 --digits 1000000 --output pi.txt
参数	说明	默认值
-a, --algorithm	算法编号（1-5）	交互输入
-d, --digits	目标小数位数	交互输入
-o, --output	输出文件路径	自动生成
算法比较 📊
算法
拉马努金公式    中等精度教学演示
Chudnovsky基础版	通用高精度计算
高斯-勒让德	  快速高精度计算
并行Chudnovsky	超大规模计算
马青公式	低精度快速计算
性能优化建议 💡使用cython
内存配置：建议12g及以上

bash
复制
export MPIMATH_CACHE_SIZE=2048  # 设置mpmath缓存大小（MB）
并行计算：

使用算法5（并行Chudnovsky）

推荐CPU核心数 >= 8

自动任务分割系统

精度选择：

< 100万位：算法3（高斯-勒让德）

> 100万位：算法5（并行Chudnovsky）

贡献指南 🤝
欢迎贡献代码！请遵循以下流程：

Fork仓库

创建特性分支（git checkout -b feature/awesome）

提交修改（git commit -m 'Add awesome feature'）

推送分支（git push origin feature/awesome）

发起Pull Request

许可证 📄
本项目采用 MIT License

致谢 🙏
Ramanujan, S. 的非凡公式

Chudnovsky兄弟的开创性工作

mpmath开发团队提供的高精度数学库