import 'package:flutter/material.dart';

typedef DataWidgetBuilder<T> = Widget Function(T data);
typedef ErrorWidgetBuilder = Widget Function(Object? error, StackTrace? stackTrace);
typedef LoadingWidgetBuilder<T> = Widget Function(T? data, [Object? error]);

class AsyncView<T> extends StatelessWidget {
  final DataWidgetBuilder<T> builder;
  final ErrorWidgetBuilder? errorBuilder;
  final LoadingWidgetBuilder<T>? loadingBuilder;
  final Future<T?> future;

  AsyncView(this.future, {required this.builder, this.errorBuilder, this.loadingBuilder});

  @override
  Widget build(BuildContext context) => FutureBuilder<T?>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData)
          return builder(snapshot.requireData!);
        else if (snapshot.hasError) {
          print(snapshot.error);
          print(snapshot.stackTrace);
          return errorBuilder?.call(snapshot.error, snapshot.stackTrace) ??
              Center(
                child: Text("Error: ${snapshot.error}"),
              );
        }

        // By default, show a loading spinner.
        return loadingBuilder?.call(snapshot.data, snapshot.error) ??
            Container(margin: EdgeInsets.all(16.0), child: Center(child: CircularProgressIndicator()));
      });
}
