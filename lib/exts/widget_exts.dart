import 'dart:collection';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

List<Shadow> outlinedText({double strokeWidth = 2, Color strokeColor = Colors.black, int precision = 5}) {
  Set<Shadow> result = HashSet();
  for (int x = 1; x < strokeWidth + precision; x++) {
    for (int y = 1; y < strokeWidth + precision; y++) {
      double offsetX = x.toDouble();
      double offsetY = y.toDouble();
      result.add(Shadow(offset: Offset(-strokeWidth / offsetX, -strokeWidth / offsetY), color: strokeColor));
      result.add(Shadow(offset: Offset(-strokeWidth / offsetX, strokeWidth / offsetY), color: strokeColor));
      result.add(Shadow(offset: Offset(strokeWidth / offsetX, -strokeWidth / offsetY), color: strokeColor));
      result.add(Shadow(offset: Offset(strokeWidth / offsetX, strokeWidth / offsetY), color: strokeColor));
    }
  }
  return result.toList();
}

extension WidgetExts on Widget {
  Widget center({Key? key, double? widthFactor, double? heightFactor}) => Center(
        key: key,
        child: this,
        widthFactor: widthFactor,
        heightFactor: heightFactor,
      );

  bool get isSliver =>
      this is SliverAnimatedList ||
      this is SliverList ||
      this is SliverGrid ||
      this is SliverAnimatedOpacity ||
      this is SliverAppBar ||
      this is SliverPersistentHeader ||
      this is SliverFadeTransition ||
      this is SliverFillRemaining ||
      this is SliverFillViewport ||
      this is SliverFixedExtentList ||
      this is SliverIgnorePointer ||
      this is SliverMultiBoxAdaptorElement ||
      this is SliverToBoxAdapter ||
      this is SliverLayoutBuilder ||
      this is SliverOffstage ||
      this is SliverOpacity ||
      this is SliverOverlapAbsorber ||
      this is SliverOverlapInjector ||
      this is SliverPrototypeExtentList ||
      this is SliverReorderableList ||
      this is SliverSafeArea ||
      this is SliverVisibility ||
      this is SliverFadeTransition;
}

class IconImageProvider extends ImageProvider<IconImageProvider> {
  final IconData icon;
  final double scale;
  final int size;
  final Color color;

  IconImageProvider(this.icon, {this.scale = 1.0, this.size = 48, this.color = Colors.white});

  @override
  Future<IconImageProvider> obtainKey(ImageConfiguration configuration) => SynchronousFuture<IconImageProvider>(this);

  @override
  ImageStreamCompleter load(IconImageProvider key, DecoderCallback decode) =>
      OneFrameImageStreamCompleter(_loadAsync(key));

  Future<ImageInfo> _loadAsync(IconImageProvider key) async {
    assert(key == this);

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.scale(scale, scale);
    final textPainter = TextPainter(textDirection: TextDirection.rtl);
    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: size.toDouble(),
        fontFamily: icon.fontFamily,
        color: color,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset.zero);
    final image = await recorder.endRecording().toImage(size, size);
    return ImageInfo(image: image, scale: key.scale);
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final IconImageProvider typedOther = other;
    return icon == typedOther.icon && scale == typedOther.scale && size == typedOther.size && color == typedOther.color;
  }

  @override
  int get hashCode => hashValues(icon.hashCode, scale, size, color);

  @override
  String toString() => '$runtimeType(${describeIdentity(icon)}, scale: $scale, size: $size, color: $color)';
}
