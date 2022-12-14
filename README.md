# action_broadcast

[![pub package](https://img.shields.io/pub/v/action_broadcast.svg)](https://pub.dartlang.org/packages/action_broadcast)

一个简单的全局广播系统，类似于Android的本地广播

## Usage

* [添加 `action_broadcast` 到 pubspec.yaml 文件](https://flutter.io/platform-plugins/).
* `import 'package:action_broadcast/action_broadcast.dart';`

## Listen

* 传统使用方式

``` example

 const actionUserLogin = 'actionUserLogin';
 const actionUserInfoChange = 'actionUserInfoChange';
 const actionLogout = 'actionLogout';
 
 // in State

 StreamSubscription receiver;

 @override
 void initState() {
    super.initState();

    receiver = registerReceiver([actionUserLogin, actionUserInfoChange, actionLogout]).listen((intent){
            switch(intent.action){
                case actionUserLogin: 
                  accountId = intent.data;
                  break;
                case actionUserInfoChang: 
                  nickname = intent['nickname'];
                  break;
                case actionLogout: 
                  Navigator.pop(context);
                  break;
            }
    });
 }

 @override
 void dispose(){
   receiver.cancel();
   super.dispose();
 }

```

* 在`State`中混入自动化管理`StreamSubscription`的`AutoCancelStreamMixin`以简化工作

``` for state

class _ExampleState extends State<Example> with AutoCancelStreamMixin{

  @override
  Iterable<StreamSubscription> get registerSubscriptions sync* {
    yield registerReceiver([actionUserLogin]).listen((intent) {
        setState(() {
          // do something
        });
      },
    );
    
    yield registerSingleReceiver(actionLogout).listen((intent) {
        setState(() {
          // do something
        });
      },
    );
  }

}

```

## Notify

`sendBroadcast(actionUserLogin, data : 'accountId');`

`sendBroadcast(actionUserInfoChang, extras: {'nickname' : 'asdasd'});`

`sendBroadcast(actionLogout);`
