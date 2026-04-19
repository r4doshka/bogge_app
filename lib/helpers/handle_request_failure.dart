import 'package:bogge_app/utils/enums.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

void handleRequestFailure({
  required BuildContext context,
  required RequestFailureType failureType,
}) {
  switch (failureType) {
    case RequestFailureType.network:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Нет подключения к интернету'.tr())),
      );
      break;

    case RequestFailureType.timeout:
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Превышено время ожидания'.tr())));
      break;

    case RequestFailureType.unauthorized:
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Сессия истекла'.tr())));
      break;

    case RequestFailureType.server:
    case RequestFailureType.cancelled:
    case RequestFailureType.unknown:
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Что-то пошло не так'.tr())));
      break;
  }
}
