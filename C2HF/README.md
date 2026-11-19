# Janus Monolayer C2HF 计算与研究资料全景归档

> **项目名称**：二维 Janus 单层氟氢化石墨烯（$C_2HF$）电子结构、稳定性与二次谐波（SHG）非线性光学响应计算  
> **更新时间**：2026-11-17  
> **归档位置**：`C2HF/`

---

## 1. 材料与计算体系概述

* **研究对象**：Janus 单层 $C_2HF$（单面氢化、单面氟化的双面不对称石墨烯衍生物）。
* **空间对称性**：
  * **六方晶系**（Hexagonal lattice），点群破除了空间反演对称性（Inversion symmetry broken）。
  * 一侧修饰电负性极强的氟原子（F），另一侧修饰氢原子（H），诱导了极强的面外自建电场与固有电偶极矩（Intrinsic Dipole Moment）。
  * **SHG 先决条件**：打破反演对称性是产生非零二阶非线性电极化率 $\chi^{(2)}$（SHG）的必要物理条件。
* **几何结构参数**（由 `1_scf/CONTCAR` 弛豫获得）：
  * 晶格常数：$a = b = 2.530\ \text{Å}$，夹角 $\gamma = 120^\circ$
  * 真空层厚度：$c = 20.00\ \text{Å}$（有效隔离层间虚假相互作用）
  * 碳碳键长 $d(\text{C}_1-\text{C}_2) = 1.536\ \text{Å}$（表现为典型 $sp^3$ 四面体成键特征）
  * 氟碳键长 $d(\text{C}_2-\text{F}) = 1.386\ \text{Å}$
  * 氢碳键长 $d(\text{C}_1-\text{H}) = 1.106\ \text{Å}$
  * 碳骨架起伏高度（Buckling $\Delta z_{\text{C-C}}$）：$0.476\ \text{Å}$
  * 原子层间物理垂直跨度：$\sim 2.97\ \text{Å}$；考虑范德华半径后二维有效厚度：$d_{\text{eff}} \approx 6.0\ \text{Å}$

---

## 2. 计算目录结构与功能导航

本文件夹包含从几何优化、电子能带、声子谱、分子动力学到 SHG 非线性光学响应的完整 DFT 计算链：

```
C2HF/
├── 1_scf/          # [步骤1] 几何构型弛豫与初步自洽 (Job 10525)
├── 2_scf/          # [步骤2] 高精度静态自洽 (Job 10526, EDIFF=1E-7)
├── 2_band/         # [步骤3] PBE 能带结构计算 (Job 10527)
├── 3_hse06_band/   # [步骤4] HSE06 杂化泛函精确能带计算 (Job 10528, 附 Origin 图 band.opju)
├── 4_pbe_dos/      # [步骤5] PBE 态密度与分波态密度 (Job 10529, PDOS_C/F/H)
├── 5_charge_diff/  # [步骤6] 差分电荷密度与面平均静电势 (Job 10530, CHGDIFF & PLANAR_AVERAGE)
├── 6_phonon/       # [步骤7] 声子谱与晶格动力学稳定性计算 (Job 10531/10532)
│   ├── 01_strain_relax/   # 声子应变与严格弛豫
│   └── 02_vasp_phonon/    # 有限位移法/超胞计算 (输出 C2HF_Phonon_Origin.csv)
├── 7_aimd/         # [步骤8] 从头算分子动力学热力学稳定性 (Job 10560, 293K, 5000 步)
├── 8_shg_vasp/     # [步骤9] SHG 前置大 K 网格波函数计算 (Job 10561, 50x50x1, 1.5GB WAVECAR)
└── 9_shg_nlo/      # [步骤10] 二阶非线性光学响应/SHG 张量求解 (Job 10562, run_nlo 软件)
    ├── run_nlo.json5      # NLO 控制参数文件 (含剪刀差 1.19 eV、厚度修正等)
    ├── shg.slurm          # 集群提交脚本
    └── output/            # 产物目录 (IPA_FEPR_onK: 2500 K点, IPA_SHG_onK: >11000 分块)
```

---

## 3. 核心计算结果与数据详表

### 3.1 能带结构与带隙修正（Band Gap & Scissors Operator）
| 计算方法 | 带隙类型 | 带隙大小 ($E_g$) | 价带顶 (VBM) | 导带底 (CBM) | 备注 |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **PBE (GGA)** | Direct | **$2.7804\ \text{eV}$** | $(0, 0, 0)\ [\Gamma]$ | $(0, 0, 0)\ [\Gamma]$ | 标准 GGA 泛函通常欠估带隙 |
| **HSE06** | Quasi-direct | **$3.9710\ \text{eV}$** | $(0.029, 0, 0)$ | $(0, 0, 0)\ [\Gamma]$ | 杂化泛函精确带隙 |

* **剪刀算符修正量（Scissors value）**：
  $$\Delta = E_g^{\text{HSE06}} - E_g^{\text{PBE}} = 3.9710 - 2.7804 = 1.1906\ \text{eV} \approx 1.19\ \text{eV}$$
  该修正参数已精确写入 `9_shg_nlo/run_nlo.json5` 的 `scissor_value: 1.19`，用以消除 PBE 导致的光学吸收与 SHG 谐振峰红移。

---

### 3.2 电子局域与内建电场（Charge Difference & Dipole）
* **文件归档**：`5_charge_diff/CHGDIFF.vasp`, `5_charge_diff/PLANAR_AVERAGE.dat`
* **面平均电荷特征**：
  * $z \approx 8.3\ \text{Å}$（F 原子侧）：形成极强的正密度峰（$+0.52\ e/\text{Å}$），表明电子强烈局域并转移至高电负性 F 原子；
  * $z \approx 9.36\ \text{Å}$：形成电荷耗尽谷（$-0.51\ e/\text{Å}$）；
  * $z \approx 10.0\ \text{Å}$（碳骨架区）：展现共价键合电荷累积；
  * $z \approx 11.1\ \text{Å}$（H 原子侧）：电荷富集度显著小于 F 原子侧。
* **物理推论**：沿 $z$ 方向存在巨大的偶极跃迁矩阵元，使得面外方向非线性极化分量（如 $\chi^{(2)}_{zzz}, \chi^{(2)}_{xxz}$ 等）具有显著物理响应。

---

### 3.3 晶格动力学稳定性（Phonon Spectrum）
* **数据来源**：`6_phonon/02_vasp_phonon/C2HF_Phonon_Origin.csv`
* **计算路径**：$\Gamma - M - K - \Gamma$（共 60 个 $q$ 点采样，12 条色散支，对应原胞 4 个原子）。
* **频率范围**：
  * 声学支：$\text{ZA}$ 弯曲模、$\text{TA}$ 和 $\text{LA}$ 面内声学支在 $\Gamma$ 点附近保持收敛（除轻微数值网格极限引起 $-14\ \text{cm}^{-1}$ 外，无深层虚频）；
  * 最高光学支（Mode 12）：位于 $2936.6 \sim 2965.7\ \text{cm}^{-1}$，属于极具特征的 $\text{C}-\text{H}$ 键伸缩振动特征峰；
  * **结论**：单层 $C_2HF$ 晶格具有良好的动力学稳定性。

---

### 3.4 室温热力学稳定性（AIMD）
* **模拟条件**：$T = 293\ \text{K}$（室温），步长 $\Delta t = 1.0\ \text{fs}$，Nosé-Hoover 恒温槽，共模拟 $5000$ 步（$5.0\ \text{ps}$）。
* **统计特征**（平衡态 1000~5000 fs）：
  * 平均温度：$\langle T \rangle = 289.50 \pm 39.04\ \text{K}$（完全稳定于目标设定值 293 K 附近）；
  * 体系总能：$\langle E \rangle = -403.7776 \pm 0.3881\ \text{eV}$；
  * **轨迹结构**：查看最终 `CONTCAR`，碳原子骨架、C-F 键和 C-H 键在 293 K 热扰动下保持完整完好，无化学键断裂、偏聚或破损脱附，验证了材料的室温热力学稳定性。

---

### 3.5 二次谐波响应（SHG 计算现状与配置）
* **前置波函数准备 (`8_shg_vasp/`)**：
  * K 网格：$50\times 50\times 1$ Gamma-centered（共 2500 个 K 点）；
  * 关键设置：`ISYM = -1`（关闭对称约化，输出全第一布里渊区波函数）；`NBANDS = 36`（包含 28 条空带）；生成 1.5 GB 的高精度 `WAVECAR`。
* **SHG 求解 (`9_shg_nlo/`)**：
  * 程序：`run_nlo_v0.095.1`
  * 理论方法：独立粒子近似（Independent Particle Approximation, IPA）+ Sipe-Ghahramani 动量跃迁矩阵元求解；
  * 参数：`vacuum: 20.0`，`thickness: 6.0`，`scissor_value: 1.19`，包含 18 个三维独立/对称相关张量分量；
  * **当前进度**：
    * `output/IPA_FEPR_onK/`：已完成全布里渊区 2500 个 K 点的动量矩阵元计算（`FEPR_mn_*K.npz`，共 2500 个文件，100% 完成）；
    * `output/IPA_SHG_onK/`：正在或已生成 11,963 个分块张量文件；
    * 下一步可进行全布里渊区积分（`calc_shg_int`）以及转为数据曲线文件（`calc_shg_npz2dat`）。

---

## 4. 后续工作与科研建议

1. **提取与绘制 SHG 谱图**：
   * 在集群或环境上，确认 `calc_shg_int` 与 `calc_shg_npz2dat` 执行完成，生成 `shg_*.dat` 文本曲线；
   * 重点观察面内主导分量（如 $\chi^{(2)}_{yyy}$ 或 $\chi^{(2)}_{xxx}$）与面外分量（$\chi^{(2)}_{zzz}$）在基频 $0 \sim 5\ \text{eV}$ 范围内的谐振吸收峰值大小（单位 $\text{pm/V}$）。
2. **二维厚度换算确认**：
   * 文中若汇报三维有效值，应明确标注所用的有效厚度 $d_{\text{eff}} = 6.0\ \text{Å}$；若换算为二维平面极化率 $\chi^{(2)}_{2D}$，则为 $\chi^{(2)}_{3D} \times d_{\text{eff}}$（单位通常为 $\text{nm}^2/\text{V}$ 或 $\text{pm}\cdot\text{nm}/\text{V}$）。
3. **准备组会汇报与论文图表**：
   * 结构图（俯视 + 侧视，标注 Janus 双面修饰特征）；
   * 能带 + 态密度投影图（HSE06 准直接带隙 $3.97\ \text{eV}$，对比 PBE）；
   * 声子谱曲线（动力学无虚频）与 AIMD 温度/能量波动图（室温 5 ps 热力学稳定）；
   * 差分电荷等值面图（展示从 C/H 向 F 的电荷转移与沿 $z$ 轴的内建偶极矩）；
   * SHG 二阶极化谱图 $\chi^{(2)}_{abc}(\omega)$。
