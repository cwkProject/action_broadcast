library action_broadcast;

import 'dart:async';

import 'package:flutter/material.dart';

export 'dart:async';

/// 广播事件
class ActionIntent {
  /// 创建广播事件
  ///
  /// 用于在广播系统中传递
  ActionIntent(this.action, {this.data, Map<String, dynamic>? extras}) {
    if (extras != null) {
      this.extras.addAll(extras);
    }
  }

  /// 事件标识
  final String action;

  /// 额外附加数据集合
  final extras = <String, dynamic>{};

  /// 单一附加数据
  final dynamic data;

  /// 获取一个附加数据
  ///
  /// 如果广播事件没有携带数据或[key]不存在则返回null
  dynamic operator [](String key) => extras[key];

  /// 填充一个附加数据[key]
  void operator []=(String key, Object? value) => extras[key] = value;
}

/// 广播发送器
StreamController<ActionIntent> get _controller =>
    _controllerImp ??= StreamController.broadcast();
StreamController<ActionIntent>? _controllerImp;

/// 注册广播接收器
///
/// * 用于接收[sendBroadcast]或[sendIntentBroadcast]发送的广播，
/// * 通过传入[actions]来监听特定的广播事件，如果actions为null则表示监听所有事件。
/// * 方法返回独立创建的[Stream.isBroadcast]为true类型的[Stream]。
/// * 监听广播后必须由监听者自己管理[StreamSubscription]并在离开时调用[StreamSubscription.cancel]注销广播接收。
///
/// ```dart
///
/// StreamSubscription receiver;
///
/// @override
/// void initState() {
///  super.initState();
///
/// receiver = registerReceiver(['actionUserLogin','actionUserInfoChang
/// e','actionLogout']).listen((intent){
///   switch(intent.action){
///     case 'actionUserLogin': accountId = intent['accountId'];
///                             break;
///     case 'actionUserInfoChang': nickname = intent['nickname'];
///                             break;
///     case 'actionLogout': Navigator.pop(context);
///                           break;
///   }
/// });
///
/// }
///
/// @override
/// void dispose(){
///   receiver.cancel();
///   super.dispose();
/// }
///
/// ```
Stream<ActionIntent> registerReceiver([List<String>? actions]) =>
    _controller.stream
        .where((intent) => actions?.contains(intent.action) ?? true);

/// 注册单一action广播接收器
///
/// * 用于接收[sendBroadcast]或[sendIntentBroadcast]发送的广播，
/// * 通过传入[actions]来监听特定的广播事件，如果actions为null则表示监听所有事件。
/// * 方法返回独立创建的[Stream.isBroadcast]为true类型的[Stream]。
/// * 监听广播后必须由监听者自己管理[StreamSubscription]并在离开时调用[StreamSubscription.cancel]注销广播接收。
///
/// ```dart
///
/// StreamSubscription receiver;
///
/// @override
/// void initState() {
///  super.initState();
///
/// receiver = registerSingleReceiver('actionUserLogin').listen((intent){
///   accountId = intent['accountId'];
/// });
///
/// }
///
/// @override
/// void dispose(){
///   receiver.cancel();
///   super.dispose();
/// }
///
/// ```
Stream<ActionIntent> registerSingleReceiver(String action) =>
    _controller.stream.where((intent) => intent.action == action);

/// 发送广播
///
/// * [action]为事件标识
/// * [data]为单一附加数据，通常适用于仅携带单个数据的事件。
/// * [extras]为额外附加的数据集合，通常适用于携带多个数据的事件。
/// * [data]和[extras]可以同时使用。
/// * 当有接收端通过[registerReceiver]注册监听了[action]则他会收到该事件的[ActionIntent]。
void sendBroadcast(String action,
        {dynamic data, Map<String, dynamic>? extras}) =>
    _controller.add(ActionIntent(action, data: data, extras: extras));

/// 发送广播
///
/// * [intent]为事件。
/// * 当有接收端通过[registerReceiver]注册监听了[action]则他会收到该[intent]。
void sendIntentBroadcast(ActionIntent intent) => _controller.add(intent);

/// 在[State.dispose]中自动取消[Stream]的mixin类
///
/// 帮助管理[StreamSubscription]并自动取消
///
/// ``` example
///
/// class _ExampleState extends State<Example> with AutoCancelStreamMixin{
///
///  @override
///  Iterable<StreamSubscription> get registerSubscriptions sync* {
///    yield registerReceiver([actionExample]).listen((intent) {
///        setState(() {
///          /// do something
///        });
///      },
///    );
///  }
///
/// }
///
/// ```
mixin AutoCancelStreamMixin<T extends StatefulWidget> on State<T> {
  /// 当前管理的[StreamSubscription]集合
  final _streamSubscriptions = <StreamSubscription>[];

  /// 是否首次执行
  bool _first = true;

  @override
  void initState() {
    super.initState();
    if (firstAtInitState) {
      _first = false;
      _streamSubscriptions.addAll(registerSubscriptions);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_first) {
      _first = false;
      _streamSubscriptions.addAll(registerSubscriptions);
    }
  }

  /// 是否在[initState]中装配[registerSubscriptions]
  bool get firstAtInitState => false;

  /// 自动监听并注册[StreamSubscription]
  ///
  /// 如果[firstAtInitState]是false(默认),则该方法在首次[didChangeDependencies]中被执行一次，
  /// 如果[firstAtInitState]为true，则该方法在[initState]中被执行一次且[didChangeDependencies]不再执行，
  /// 通过[addSubscription]加入管理器。
  /// 需要在[State]初始化时添加一次的监听器，子类可以通过实现该方法监听[Stream]并返回[StreamSubscription]。
  @protected
  Iterable<StreamSubscription> get registerSubscriptions => [];

  /// 将一个[subscription]添加到自动管理集合
  void addSubscription(StreamSubscription subscription) {
    _streamSubscriptions.add(subscription);
  }

  /// 手动取消自动管理集合中的[StreamSubscription]并清空集合
  void cancelSubscriptionAll() {
    _streamSubscriptions
      ..forEach((sub) => sub.cancel())
      ..clear();
  }

  @override
  void dispose() {
    cancelSubscriptionAll();
    super.dispose();
  }
}
