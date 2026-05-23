import 'package:bogge_app/ui/widgets/list_item/text_with_dot_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ScanErrorList extends ConsumerWidget {
  const ScanErrorList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        TextWithDotItem(
          text:
              "Убедитесь что на мобильном телефоне включено разрешение Bluetooth Если системе Android требуется разрешение на доступ к данным о местоположении"
                  .tr(),
        ),
        TextWithDotItem(text: "Убедитесь что устройство включено".tr()),
        TextWithDotItem(
          text:
              "Убедитесь что тип устройства в левом верхнем углу указан правильно"
                  .tr(),
        ),
        TextWithDotItem(
          text:
              "Убедитесь что устройство не подключено к системе Bluetooth мобильного телефона Если соединение необходимо разорвать повторите поиск"
                  .tr(),
        ),
        TextWithDotItem(
          text: "Убедитесь что Ваше устройство поддерживает Bluetooth".tr(),
        ),
      ],
    );
  }
}
