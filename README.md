FPGA-DAC based on R2R-PWM
===========================
基于 **FPGA** 的 **极简DAC设计**

仅用 **FPGA+若干电阻电容** ，实现 14bit+ 的中低速 DAC，代替集成 DAC 芯片 (例如AD5326，DAC8554等)，在FPGA系统中降低成本和电路复杂度，同时在采样率和精度间提高取舍的灵活性。

# 原理
使用 **R2R电阻网络** 融合 **PWM** : [参考网站](https://www.edn.com/design/analog/4458772/Hybrid-PWM-R2R-DAC-improves-on-both "参考网站")。我在此基础上利用 **FPGA的优势** 改进了 PWM 的方式，进一步 **降低了纹波** 。

# 进度
已完成代码和电路，实现了一个 **14bit的DAC** 。进行了初步测试，结果不错。但严谨起见还需要对 **非线性** 、 **失码** 、**SNR** 进行测量。另外，文档和代码也会继续完善。我将提供一个方便调用的 **Verilog顶层module** ，另外还会提供一个DAC后的有源滤波+缓冲器电路，以提高DAC的带负载能力。

以下是一些用示波器进行测试的结果。

# 测试结果

使用 **3bit R2R网络** + **11bit PWM** 拼成 **14bit 6000sps DAC** （电路如下），并用它产生 **三角波** ，用 **示波器** 观察。为了说明 PWM 产生的低bit是有效的，我截断了一些bit做比较。

![电路](https://github.com/WangXuan95/FPGA-DAC-R2R-PWM/blob/master/img/sch.png)

> 这里尚且使用的是普通的 1% 电阻，就已经能达到比较好的效果，如果用上 LT 的精密排阻，效果会更好。

## 大摆幅测试（Vpp=2500mV）

![大摆幅测试](https://github.com/WangXuan95/FPGA-DAC-R2R-PWM/blob/master/img/Vpp2500.png)

## 中摆幅测试（Vpp=96mV）

![中摆幅测试](https://github.com/WangXuan95/FPGA-DAC-R2R-PWM/blob/master/img/Vpp96.png)

## 小摆幅测试（Vpp=7.4mV）

![小摆幅测试](https://github.com/WangXuan95/FPGA-DAC-R2R-PWM/blob/master/img/Vpp7.png)

## 微摆幅测试（Vpp=1.0mV）

![微摆幅测试](https://github.com/WangXuan95/FPGA-DAC-R2R-PWM/blob/master/img/Vpp1.png)
