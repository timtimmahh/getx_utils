import 'package:dartkt/dartkt.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopupMenuItemBuilder extends PopupMenuItem<String> {
  final String title;
  final String choiceKey;
  final void Function() onSelected;

  PopupMenuItemBuilder({Key? key, required this.title, required this.onSelected, required this.choiceKey})
      : super(key: key, value: choiceKey, child: Text(title));
}

class SettingsMenu<S extends GetLifeCycleBase> extends GetWidget<S> {
  final List<PopupMenuItemBuilder> menuItems = List.empty(growable: true);
  final void Function()? onSettingsChanged;
  final void Function()? onSettingsNotChanged;

  SettingsMenu(
      {Key? key,
      this.onSettingsChanged,
      this.onSettingsNotChanged,
      List<PopupMenuItemBuilder>? menuItems,
      required String settingsRoute})
      : super(key: key) {
    if (menuItems != null) this.menuItems.addAll(menuItems);
    this.menuItems.add(PopupMenuItemBuilder(
          title: 'Settings',
          choiceKey: 'settings',
          onSelected: () async {
            var result = await Get.toNamed(settingsRoute);
            if (result != null && result is bool && result)
              onSettingsChanged?.call();
            else
              onSettingsNotChanged?.call();
          },
        ));
  }

  @override
  Widget build(BuildContext context) => PopupMenuButton<String>(
        onSelected: (value) {
          switch (value) {
            case 'settings':
              menuItems.last.onSelected();
              break;
            default:
              menuItems.find((it) => it.choiceKey == value)?.onSelected();
              break;
          }
        },
        itemBuilder: (BuildContext context) => menuItems,
      );
}
