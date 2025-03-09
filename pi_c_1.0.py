from decimal import Decimal, getcontext

def compute_pi(decimals):
    # 设置精度，多设置10位以避免舍入误差
    getcontext().prec = decimals + 10
    
    # 计算用常量
    C = Decimal(9801) / (Decimal(2) * Decimal(2).sqrt())
    precomputed_396_p4 = Decimal(396) ** 4
    tolerance = Decimal(10) ** (- (decimals + 10))
    
    # 初始化变量
    sum_terms = Decimal(0)
    k = 0
    
    # 计算k=0时的初始项
    numerator = Decimal(1103 + 26390 * k)
    denominator = Decimal(1)  # (0!)^4 * 396^(4*0) = 1
    term = numerator / denominator
    sum_terms += term
    
    # 迭代计算后续项
    while True:
        # 计算当前k对应的比率以得到下一项
        k_dec = Decimal(k)
        
        # 分子部分
        numerator = (4 * k_dec + 1) * (4 * k_dec + 2) * (4 * k_dec + 3) * (4 * k_dec + 4)
        numerator *= (Decimal(26390) * k_dec + Decimal(27493))
        
        # 分母部分
        denominator = (k_dec + 1) ** 4
        denominator *= precomputed_396_p4
        denominator *= (Decimal(26390) * k_dec + Decimal(1103))
        
        # 计算比率并更新当前项
        term *= numerator / denominator
        
        # 检查当前项是否小于容差
        if term < tolerance:
            break
        
        sum_terms += term
        k += 1
    
    # 计算最终的π值并四舍五入到指定小数位
    pi = C / sum_terms
    return pi.quantize(Decimal('1.' + '0' * decimals))

# 用户输入部分
if __name__ == "__main__":
    while True:
        try:
            decimals = int(input("请输入要计算的圆周率小数位数（1-1000）："))
            if 1 <= decimals <= 1000:
                break
            else:
                print("请输入1到1000之间的整数！")
        except ValueError:
            print("请输入有效的整数！")
    
    pi = compute_pi(decimals)
    print(f"圆周率（精确到{decimals}位小数）：\n{pi}")