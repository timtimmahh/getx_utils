/*
Widget obx<T>(Widget? Function() builder,
        {bool useNull = false,
        Widget fallback = const SizedBox(width: 0, height: 0)}) =>
    Obx(() => builder() ?? fallback);

Widget obxListValue<T>(Widget? Function(RxList<T> data) builder, RxList<T> data,
        {Widget fallback = const SizedBox(width: 0, height: 0)}) =>
    ObxValue<RxList<T>>((data) => builder(data) ?? fallback, data);

Widget obxMapValue<K, V>(
        Widget? Function(RxMap<K, V> data) builder, RxMap<K, V> data,
        {Widget fallback = const SizedBox(width: 0, height: 0)}) =>
    ObxValue<RxMap<K, V>>((data) => builder(data) ?? fallback, data);

Widget obxSetValue<T>(Widget? Function(RxSet<T> data) builder, RxSet<T> data,
        {Widget fallback = const SizedBox(width: 0, height: 0)}) =>
    ObxValue<RxSet<T>>((data) => builder(data) ?? fallback, data);

Widget obxValue<T>(Widget? Function(Rx<T> data) builder, Rx<T> data,
        {bool useNull = false,
        Widget fallback = const SizedBox(width: 0, height: 0)}) =>
    ObxValue<Rx<T>>(
        (data) =>
            (useNull || data.value != null ? builder(data) : null) ?? fallback,
        data);

Widget obxValueData<T>(
        Widget? Function(T data) builder, Rx<T?> data,
        {Widget fallback = const SizedBox(width: 0, height: 0)}) =>
    ObxValue<Rx<T?>>(
        (data) =>
            (data.value != null ? builder(data.value!) : null) ?? fallback,
        data);*/

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class ObxnValue<T> extends ObxValue<Rx<T?>> {
  final Widget Function()? nullBuilder;

  ObxnValue({required Rx<T?> data, required Widget Function(T p1) builder, this.nullBuilder})
      : super(
            (value) => value.value == null
                ? (nullBuilder?.call() ?? Center(child: CircularProgressIndicator()))
                : builder(value.value!),
            data);
}
