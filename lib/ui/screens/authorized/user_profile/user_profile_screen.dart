import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/features/auth/api/auth_api.dart';
import 'package:bogge_app/features/user/providers/user_provider.dart';
import 'package:bogge_app/services/navigation_service.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/widgets/buttons/common_button.dart';
import 'package:bogge_app/ui/widgets/buttons/logout_button.dart';
import 'package:bogge_app/ui/widgets/headers/common_header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class UserProfileScreen extends HookConsumerWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpace.ph16,
          child: Column(
            children: [
              CommonHeader(title: user?.fullName),
              Text('UserProfileScreen'),
              AppSpace.h16,
              LogoutButton(),
            ],
          ),
        ),
      ),
    );
  }
}
