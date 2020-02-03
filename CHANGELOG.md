## [2.1.0] - 2020/2/3

* 修改`AutoCancelStreamMixin`中的`registerSubscriptions`默认在首次执行`didChangeDependencies`时装配，
可通过重写`firstAtInitState`以便在`initState`中装配

## [2.0.0] - 2019/10/16

* 修改`Intent`为`ActionIntent`以回避flutter 1.9版本中的`Action`套件

## [1.0.0] - 2019/8/20

* 首次完成提交
