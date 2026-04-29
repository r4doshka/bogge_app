import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileButton extends ConsumerWidget {
  final void Function()? onPress;
  const ProfileButton({this.onPress, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);

    return PrimaryIconButton(
      svgPath: 'assets/icons/profile-icon.svg',
      iconWidth: AppSpace.s20.w,
      iconHeight: AppSpace.s20.h,
      containerHeight: AppSpace.s44.w,
      containerWidth: AppSpace.s44.w,
      backgroundColor: palette.primary12,
      onPress: onPress ?? () {},
    );
  }
}
