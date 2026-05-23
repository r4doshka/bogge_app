import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/widgets/list_item/device_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DeviceList extends ConsumerWidget {
  const DeviceList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: 5,
      separatorBuilder: (context, index) => Container(
        height: AppSpace.s4.h,
        margin: EdgeInsetsDirectional.only(start: 62.w),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.h, color: palette.gray),
          ),
        ),
      ),
      itemBuilder: (context, index) {
        return DeviceListItem();
      },
    );
  }
}
