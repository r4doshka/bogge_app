import 'package:bogge_app/features/auth/api/auth_api.dart';
import 'package:bogge_app/services/navigation_service.dart';
import 'package:bogge_app/ui/widgets/buttons/common_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LogoutButton extends HookConsumerWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLogoutLoading = useState(false);

    return CommonButton(
      text: 'Выйти из аккаунта'.tr(),
      isLoading: isLogoutLoading.value,
      onPress: isLogoutLoading.value
          ? null
          : () async {
              await ref.read(authRepository).logout();
              if (context.mounted) {
                ref.read(navigationServiceProvider).goToSignIn(context);
              }
            },
    );
  }
}
