import 'package:cached_network_image/cached_network_image.dart';
import 'package:dartkt/dartkt.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GridTileChild implements Comparable<GridTileChild> {
  Widget child;
  int index = -1;
  bool replace = false;

  GridTileChild(this.child, {this.index = -1, this.replace = false});

  @override
  int compareTo(GridTileChild other) {
    if (index == other.index)
      return 0;
    else if (index == -1)
      return 1;
    else if (other.index == -1)
      return -1;
    else
      return index < other.index ? -1 : 1;
  }
}

class GridTileView extends GetView {
  final String? pageRoute;
  final dynamic pageArguments;
  final Map<String, String>? pageParameters;
  final String title;
  final String? imageUrl;
  final List<GridTileChild>? extraChildren;
  late final List<Widget> _children;
  final String? heroTitleTag;
  final String? heroImageTag;

  GridTileView(this.title,
      {this.imageUrl,
      this.pageRoute,
      this.pageArguments,
      this.pageParameters,
      this.extraChildren,
      this.heroTitleTag,
      this.heroImageTag}) {
    _children = <Widget>[
      _checkHero(
          heroImageTag,
          imageUrl == null
              ? Icon(Icons.broken_image)
              : CachedNetworkImage(
                  imageUrl: imageUrl!,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                )),
      /*Image.network(
              imageUrl!,
              fit: BoxFit.fill,
            ),*/
      SizedBox(height: 2.0),
      Center(
          child: _checkHero(
              heroTitleTag, Text(title, overflow: TextOverflow.ellipsis, maxLines: 2, textScaleFactor: 1.5))),
    ];
    extraChildren?.let((extras) {
      extras.sort();
      for (var extra in extras) {
        if (extra.replace == true && extra.index > -1 && extra.index < _children.length)
          _children[extra.index] = extra.child;
        else if (extra.index == -1 || extra.index > _children.length)
          _children.add(extra.child);
        else
          _children.insert(extra.index, extra.child);
      }
    });
  }

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => pageRoute?.let((it) => Get.toNamed(it, arguments: pageArguments, parameters: pageParameters)),
        child: GridTile(
            header: _children[0],
            child: _children[1],
            footer: Card(
              elevation: 1.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _children.sublist(2),
              ),
            )),
      );

  Widget _checkHero(String? tag, Widget toWrap) => tag == null ? toWrap : Hero(tag: tag, child: toWrap);
}
