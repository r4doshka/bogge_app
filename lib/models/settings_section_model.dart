import 'package:flutter/material.dart';

@immutable
class SettingsSectionModel {
  final List<SettingsSectionChildModel> children;

  const SettingsSectionModel({required this.children});

  @override
  String toString() {
    return '{ children: $children }';
  }
}

@immutable
class SettingsSectionChildModel {
  final String title;
  final String? iconPath;
  final void Function() onPress;
  final Widget Function()? rightPartRenderer;
  final bool withArrowRight;

  const SettingsSectionChildModel({
    required this.title,
    required this.onPress,
    this.iconPath,
    this.rightPartRenderer,
    this.withArrowRight = true,
  });

  @override
  String toString() {
    return '{ title: $title, iconPath: $iconPath, onPress: $onPress, withArrowRight: $withArrowRight }';
  }
}
