# 📚Super π Calculator - 超级π+计算器

[![Python Version](https://img.shields.io/badge/python-3.6+-blue.svg)](https://www.python.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

一个高性能的圆周率计算工具，支持多种算法和并行加速，可计算千万位精度的π值。

本程序使用Cython构建：[Cython的简单使用](https://www.cnblogs.com/freeweb/p/6548208.html)。

🎉为庆祝2025年的圆周率日🎉

## ✨ 功能特性

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

## 📦 安装步骤

1. 克隆仓库：
```bash
git clone https://github.com/STLNathan/super_pi_calculator.git
cd super_pi_calculator
```

2.安装Python和Pip3：
- Windows：[全网最详细的Python安装教程（Windows）](https://zhuanlan.zhihu.com/p/344887837)
- MacOS：[如何在 Mac 上安装Python环境的详细指南](blog.csdn.net/linnaa6/article/details/145408266)
- Linux：[如何在 Linux 下安装 Python 环境的详细指南](https://xie.infoq.cn/article/8dc39ff330bc650542d2b2e6e)

3.运行：
- 1.0版本（最多计算到一千位）：

```bash
python pi_c_1.0.py
```

- 1.1版本（可以无限计算）：
```bash
pip3 install mpmath
pip3 install tqdm
python pi_c_1.1.py
```

## 🖥️ 使用指南

交互式界面将引导您：
- 选择算法（支持1-5号算法）
- 输入目标小数位数
- 选择是否保存结果


## 📊 算法比较
- 拉马努金公式：中等精度教学演示
- Chudnovsky基础版：通用高精度计算
- 高斯-勒让德：快速高精度计算
- 并行Chudnovsky：超大规模计算
- 马青公式	低精度快速计算
  
## 💻 性能建议
内存配置：建议4GiB及以上

## 🤝 参与开发
欢迎提交PR或Issue，开发准则：
- 新功能请创建feature分支
- 使用Google-style Python注释规范
- 重要功能需包含单元测试
- 遵循PEP8代码格式规范


## 📄 开源协议
本项目采用 MIT License

## 🙏 致谢
- Ramanujan, S. 的非凡公式
- Chudnovsky兄弟的开创性工作
- mpmath开发团队提供的高精度数学库
