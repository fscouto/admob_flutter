import 'dart:async';

import 'package:flutter/services.dart';
import 'admob_event_handler.dart';

class AdmobInterstitial extends AdmobEventHandler {
  static const MethodChannel _channel =
      MethodChannel('admob_flutter/interstitial');

  late int id;
  late MethodChannel _adChannel;
  final String adUnitId;
  final void Function(AdmobAdEvent, Map<String, dynamic>?)? listener;
  final bool nonPersonalizedAds;

  AdmobInterstitial({
    required this.adUnitId,
    this.listener,
    this.nonPersonalizedAds = false,
  }) : super(listener) {
    id = hashCode;
    if (listener != null) {
      _adChannel = MethodChannel('admob_flutter/interstitial_$id');
      _adChannel.setMethodCallHandler(handleEvent);
    }
  }

  Future<bool?> get isLoaded async {
    final result = await _channel.invokeMethod('isLoaded', _channelMethodsArguments);
    return result;
  }

  void load() async {
    await _channel.invokeMethod('load',
      _channelMethodsArguments
        ..['adUnitId'] = adUnitId
        ..['nonPersonalizedAds'] = nonPersonalizedAds
    );

    if (listener != null) {
      await _channel.invokeMethod('setListener', _channelMethodsArguments);
    }
  }

  void show() async {
    if (await isLoaded == true) {
      await _channel.invokeMethod('show', _channelMethodsArguments);
    }
  }

  void dispose() async {
    await _channel.invokeMethod('dispose', _channelMethodsArguments);
  }

  Map<String, dynamic> get _channelMethodsArguments => <String, dynamic>{
    'id': id,
  };
}
