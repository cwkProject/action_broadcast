## [3.0.2] - 2022/12/14

* 增加注册单个action的方法`registerSingleReceiver`

## [3.0.1+1] - 2021/7/14

* documentation fixes

## [3.0.1] - 2021/5/28

* clean code

## [3.0.0] - 2021/3/3

* 支持空安全

## [2.1.3] - 2020/8/11

* 执行标准格式化代码

## [2.1.2] - 2020/8/11

* 使用`pedantic`进行静态分析以符合dart语法规范
* 增加版权声明
* 增加示例程序

## [2.1.1] - 2020/2/5

* 修改`registerSubscriptions`的注释描述

## [2.1.0] - 2020/2/3

* 修改`AutoCancelStreamMixin`中的`registerSubscriptions`默认在首次执行`didChangeDependencies`时装配，
可通过重写`firstAtInitState`以便在`initState`中装配

## [2.0.0] - 2019/10/16

* 修改`Intent`为`ActionIntent`以回避flutter 1.9版本中的`Action`套件

## [1.0.0] - 2019/8/20

* 首次完成提交
