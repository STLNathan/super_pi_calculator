import mpmath 
from tqdm import tqdm 
import time 
from concurrent.futures  import ProcessPoolExecutor 
import math 
import os 
 
# 算法库定义 
ALGORITHMS = {
    1: ("拉马努金公式"， "ramanujan"),
    2: ("Chudnovsky算法"， "chudnovsky"),
    3: ("高斯-勒让德迭代法"， "gauss_legendre"),
    4: ("马青公式"， "machin"),
    5: ("并行Chudnovsky (千万位优化)"， "chudnovsky_parallel")
}
 
def compute_ramanujan(digits):
    """拉马努金公式实现"""
    mpmath.mp。dps  = digits + 10 
    C = 9801 / (2 * mpmath.sqrt(2)) 
    term = mpmath.mpf(1103) 
    sum_series = term 
    k = 0 
    precomputed_396_p4 = mpmath.power(396，  4)
    
    progress = tqdm(total=100, desc="初始化")
    start_time = time.time() 
    last_percent = 0 
    
    while True:
        term_contribution = mpmath.log10(abs(term/sum_series)) 
        current_digits = -int(term_contribution) if term_contribution < 0 else 0 
        
        completed_percent = min(int(current_digits/digits*100), 100)
        if completed_percent > last_percent:
            progress.update(completed_percent  - last_percent)
            last_percent = completed_percent 
            progress.set_description(f" 当前精度:{current_digits}位")
        
        if current_digits >= digits:
            break 
        
        numerator = (4*k + 1)*(4*k + 2)*(4*k + 3)*(4*k + 4)*(26390*k + 27493)
        denominator = (k+1)**4 * precomputed_396_p4 * (26390*k + 1103)
        term *= numerator / denominator 
        sum_series += term 
        k += 1 
    
    pi = C / sum_series 
    progress.close() 
    mpmath.mp。dps  = digits 
    return mpmath.mpf(pi),  time.time()  - start_time 
 
def compute_chudnovsky(digits):
    """Chudnovsky算法实现"""
    mpmath.mp。dps  = digits + 10 
    C = 426880 * mpmath.sqrt(10005) 
    sum_series = mpmath.mpf(0) 
    k = 0 
    
    progress = tqdm(total=100, desc="初始化")
    start_time = time.time() 
    last_percent = 0 
    
    while True:
        numerator = (-1)**k * mpmath.factorial(6*k)  * (545140134*k + 13591409)
        denominator = mpmath.factorial(3*k)  * (mpmath.factorial(k)**3)  * mpmath.power(640320,  3*k + 1.5)
        term = numerator / denominator 
        
        sum_series += term 
        term_contribution = mpmath.log10(abs(term/sum_series)) 
        current_digits = -int(term_contribution) if term_contribution < 0 else 0 
        
        completed_percent = min(int(current_digits/digits*100), 100)
        if completed_percent > last_percent:
            progress.update(completed_percent  - last_percent)
            last_percent = completed_percent 
            progress.set_description(f" 当前精度:{current_digits}位")
        
        if current_digits >= digits:
            break 
        k += 1 
    
    pi = C / sum_series 
    progress.close() 
    mpmath.mp.dps  = digits 
    return mpmath.mpf(pi),  time.time()  - start_time 
 
def compute_gauss_legendre(digits):
    """高斯-勒让德算法实现"""
    mpmath.mp.dps  = digits + 10 
    a = mpmath.mpf(1) 
    b = 1 / mpmath.sqrt(2) 
    t = mpmath.mpf(0.25) 
    p = mpmath.mpf(1) 
    
    # 计算迭代次数 
    iterations = int(float(mpmath.log(digits,  2))) + 2 
    progress = tqdm(total=iterations, desc="迭代计算")
    start_time = time.time() 
    
    for _ in range(iterations):
        a_new = (a + b) / 2 
        b = mpmath.sqrt(a  * b)
        t -= p * (a - a_new)**2 
        a = a_new 
        p *= 2 
        progress.update(1) 
    
    pi = (a + b)**2 / (4 * t)
    progress.close() 
    mpmath.mp.dps  = digits 
    return pi, time.time()  - start_time 
 
def compute_machin(digits):
    """马青公式实现"""
    mpmath.mp.dps  = digits + 10 
    threshold = mpmath.mpf(10)  ** (-digits - 3)  # 设置精度阈值 
 
    progress = tqdm(total=100, desc="初始化")
    start_time = time.time() 
    last_progress = 0  # 跟踪上一次进度 
 
    # 计算 arctan(1/5) 的级数 
    s1 = mpmath.mpf(0) 
    k_s1 = 0 
    term_s1 = (mpmath.mpf(1)/5)  ** (2*k_s1 + 1) / (2*k_s1 + 1)
    progress.set_description(" 计算arctan(1/5)")
 
    while True:
        current_term = (-1)**k_s1 * term_s1 
        s1 += current_term 
        term_abs = abs(current_term)
 
        if term_abs < threshold:
            break  # 达到精度要求，退出循环 
 
        # 动态预估剩余迭代次数 
        ratio = (mpmath.mpf(1)/5)**2   # 级数公比 
        remaining = mpmath.log(threshold  / term_abs) / mpmath.log(ratio) 
        remaining = max(0, int(mpmath.ceil(remaining))) 
        total_estimated = k_s1 + remaining + 1  # 预估总迭代次数 
 
        # 更新进度条（0-50%范围）
        current_progress = (k_s1 / total_estimated) * 50 if total_estimated > 0 else 0 
        delta = current_progress - last_progress 
        if delta > 0:
            progress.update(delta) 
            last_progress = current_progress 
 
        k_s1 += 1 
        term_s1 = (mpmath.mpf(1)/5)  ** (2*k_s1 + 1) / (2*k_s1 + 1)
 
    # 强制进度条到50%
    delta = 50 - last_progress 
    if delta > 0:
        progress.update(delta) 
    last_progress = 50 
 
    # 计算 arctan(1/239) 的级数 
    s2 = mpmath.mpf(0) 
    k_s2 = 0 
    term_s2 = (mpmath.mpf(1)/239)  ** (2*k_s2 + 1) / (2*k_s2 + 1)
    progress.set_description(" 计算arctan(1/239)")
 
    while True:
        current_term = (-1)**k_s2 * term_s2 
        s2 += current_term 
        term_abs = abs(current_term)
 
        if term_abs < threshold:
            break  # 达到精度要求，退出循环 
 
        # 动态预估剩余迭代次数 
        ratio = (mpmath.mpf(1)/239)**2  
        remaining = mpmath.log(threshold  / term_abs) / mpmath.log(ratio) 
        remaining = max(0, int(mpmath.ceil(remaining))) 
        total_estimated = k_s2 + remaining + 1 
 
        # 更新进度条（50-100%范围）
        current_progress = 50 + (k_s2 / total_estimated) * 50 if total_estimated > 0 else 50 
        delta = current_progress - last_progress 
        if delta > 0:
            progress.update(delta) 
            last_progress = current_progress 
 
        k_s2 += 1 
        term_s2 = (mpmath.mpf(1)/239)  ** (2*k_s2 + 1) / (2*k_s2 + 1)
 
    # 强制进度条到100%
    delta = 100 - last_progress 
    if delta > 0:
        progress.update(delta) 
 
    progress.close() 
 
    # 计算最终π值并调整精度 
    pi = 4 * (4*s1 - s2)
    mpmath.mp.dps  = digits 
    return pi, time.time()  - start_time 
 
def binary_split(a, b):
    """二进制分割法加速级数计算"""
    if b - a == 1:
        if a == 0:
            Pab = Qab = 1 
        else:
            Pab = (6*a-5)*(2*a-1)*(6*a-1)
            Qab = a**3 * 640320**3 // 24 
        Tab = Pab * (545140134*a + 13591409)
        if a & 1:
            Tab *= -1 
        return (Tab, Qab, Pab)
    else:
        mid = (a + b) // 2 
        (T1, Q1, P1) = binary_split(a, mid)
        (T2, Q2, P2) = binary_split(mid, b)
        return (T1*Q2 + T2*P1, Q1*Q2, P1*P2)
 
def compute_chudnovsky_parallel(digits):
    """并行优化的Chudnovsky算法"""
    import math 
    mpmath.mp.dps  = digits + 10 
    # 预估需要的迭代次数 
    N = int(math.ceil(digits  / 14.181647462))
    chunks = 8  # 根据CPU核心数调整 
    
    progress = tqdm(total=100, desc="初始化分割")
    start_time = time.time() 
    
    # 使用多进程并行计算二进制分割 
    with ProcessPoolExecutor() as executor:
        futures = []
        chunk_size = N // chunks 
        for i in range(chunks):
            a = i * chunk_size 
            b = (i+1)*chunk_size if i != chunks-1 else N 
            futures.append(executor.submit(binary_split,  a, b))
        
        results = []
        for future in futures:
            results.append(future.result()) 
            progress.update(100//chunks) 
    
    # 合并结果 
    T_total = 0 
    Q_total = 1 
    P_total = 1 
    for (T, Q, P) in results:
        T_total = T_total*Q + T*P_total 
        Q_total *= Q 
        P_total *= P 
    
    # 最终计算 
    progress.set_description(" 最终计算")
    pi = (426880 * mpmath.sqrt(10005,  prec=digits*4) * Q_total) / T_total 
    progress.update(100  - progress.n)
    progress.close() 
    
    mpmath.mp.dps  = digits 
    return mpmath.mpf(pi),  time.time()  - start_time 
 
def save_to_file(result, target_digits, algo_func):
    """保存结果到文件"""
    default_filename = f"pi_{target_digits}digits_{algo_func}.txt"
    file_path = input(f"请输入保存路径（直接回车使用默认路径 '{default_filename}'）：").strip()
    file_path = file_path if file_path else default_filename 
    
    try:
        with open(file_path, "w") as f:
            f.write(str(result)) 
        print(f"结果已保存到：{file_path}")
    except Exception as e:
        print(f"保存失败：{str(e)}")
 
def main():
    print("超级π计算器")
    print("支持算法：")
    for num, (name, _) in ALGORITHMS.items(): 
        print(f"{num}. {name}")
    
    # 选择算法 
    while True:
        try:
            algo_choice = int(input("请选择算法（输入编号）: "))
            if algo_choice in ALGORITHMS:
                break 
            print("请输入有效的编号！")
        except ValueError:
            print("请输入数字编号！")
    
    # 输入位数 
    while True:
        try:
            target_digits = int(input("请输入目标小数位数: "))
            if target_digits > 0:
                if target_digits > 100000:
                    print("警告：计算超过100,000位可能需要大量时间和内存！")
                    confirm = input("确定要继续吗？(y/n): ").lower()
                    if confirm != 'y':
                        continue 
                break 
            print("请输入正整数！")
        except ValueError:
            print("请输入有效整数！")
    
    # 执行计算 
    algo_name, algo_func = ALGORITHMS[algo_choice]
    print(f"\n开始使用{algo_name}计算π到{target_digits}位...")
    
    try:
        compute_func = globals()[f"compute_{algo_func}"]
        result, time_used = compute_func(target_digits)
        
        # 显示结果 
        print(f"\n计算完成！耗时 {time_used:.2f} 秒")
        print("\n前100位预览：")
        str_pi = str(result)[:100]
        print(' '.join([str_pi[i:i+5] for i in range(0, 100, 5)]))
        
        # 询问是否保存 
        save_choice = input("\n是否保存完整结果？(y/n): ").lower()
        if save_choice == 'y':
            save_to_file(result, target_digits, algo_func)
        else:
            print("结果未保存。")
            
    except Exception as e:
        print(f"\n计算过程中发生错误: {str(e)}")
 
if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n用户中断计算")
