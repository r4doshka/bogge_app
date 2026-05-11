import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/features/user/providers/user_provider.dart';
import 'package:bogge_app/models/settings_section_model.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/screens/authorized/user_profile/widgets/settings_item.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/buttons/logout_button.dart';
import 'package:bogge_app/ui/widgets/headers/nested_header.dart';
import 'package:bogge_app/ui/widgets/modals/edit_user_name_modal.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:string_extensions/string_extensions.dart';

@RoutePage()
class UserProfileScreen extends ConsumerWidget {
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
              NestedHeader(title: user?.fullName),
              AppSpace.h16,
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: settingSectionsRenderer(context: context).length,
                  separatorBuilder: (_, _) => AppSpace.h16,
                  itemBuilder: (context, index) => SettingsItem(
                    item: settingSectionsRenderer(context: context)[index],
                  ),
                ),
              ),
              AppSpace.h16,
              LogoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  List<SettingsSectionModel> settingSectionsRenderer({
    required BuildContext context,
  }) => [
    SettingsSectionModel(children: userInfoSectionsRenderer(context: context)),
    SettingsSectionModel(
      children: bodyMetricsSectionsRenderer(context: context),
    ),
    SettingsSectionModel(children: supportSectionsRenderer(context: context)),
  ];

  List<SettingsSectionChildModel> userInfoSectionsRenderer({
    required BuildContext context,
  }) => [
    SettingsSectionChildModel(
      title: 'Имя'.tr(),
      iconPath: 'assets/icons/profile-icon.svg',
      onPress: () => showEditUserNameModalBottom(context: context),
      rightPartRenderer: () => Consumer(
        builder: (context, ref, _) {
          final name = ref.watch(userProvider)?.fullName;
          final palette = ref.watch(paletteProvider);

          return Text(
            name ?? '',
            style: text_s17_w400_lsm043.copyWith(color: palette.text60),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          );
        },
      ),
    ),
    SettingsSectionChildModel(
      title: 'Почта'.tr(),
      iconPath: 'assets/icons/email-icon.svg',
      onPress: () => showEditUserNameModalBottom(context: context),
      rightPartRenderer: () => Consumer(
        builder: (context, ref, _) {
          final email = ref.watch(userProvider)?.email;
          final palette = ref.watch(paletteProvider);

          return Text(
            email ?? '',
            style: text_s17_w400_lsm043.copyWith(color: palette.text60),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          );
        },
      ),
    ),
  ];

  List<SettingsSectionChildModel> bodyMetricsSectionsRenderer({
    required BuildContext context,
  }) => [
    SettingsSectionChildModel(
      title: 'Дата рождения'.tr(),
      iconPath: 'assets/icons/calendar-icon.svg',
      onPress: () => showEditUserNameModalBottom(context: context),
      rightPartRenderer: () => Consumer(
        builder: (context, ref, _) {
          final date = ref.watch(userProvider)?.dateOfBirth;
          final palette = ref.watch(paletteProvider);

          final localeCode = context.locale.languageCode;
          final formatted = ref
              .watch(userProvider)
              ?.getFormattedDateOfBirth(localeCode, date);

          return Text(
            formatted ?? '',
            style: text_s17_w400_lsm043.copyWith(color: palette.text60),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          );
        },
      ),
    ),
    SettingsSectionChildModel(
      title: 'Пол'.tr(),
      iconPath: 'assets/icons/gender-icon.svg',
      onPress: () => showEditUserNameModalBottom(context: context),
      rightPartRenderer: () => Consumer(
        builder: (context, ref, _) {
          final gender = ref.watch(userProvider)?.sex;
          final palette = ref.watch(paletteProvider);

          return Text(
            gender?.name.toTitleCase ?? '',
            style: text_s17_w400_lsm043.copyWith(color: palette.text60),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          );
        },
      ),
    ),
    SettingsSectionChildModel(
      title: 'Рост'.tr(),
      iconPath: 'assets/icons/height-icon.svg',
      onPress: () => showEditUserNameModalBottom(context: context),
      rightPartRenderer: () => Consumer(
        builder: (context, ref, _) {
          final height = ref.watch(userProvider)?.formattedHeight;
          final palette = ref.watch(paletteProvider);

          return Text(
            height ?? '',
            style: text_s17_w400_lsm043.copyWith(color: palette.text60),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          );
        },
      ),
    ),
    SettingsSectionChildModel(
      title: 'Вес'.tr(),
      iconPath: 'assets/icons/weight-icon.svg',
      onPress: () => showEditUserNameModalBottom(context: context),
      rightPartRenderer: () => Consumer(
        builder: (context, ref, _) {
          final weight = ref.watch(userProvider)?.formattedWeight;
          final palette = ref.watch(paletteProvider);

          return Text(
            weight ?? '',
            style: text_s17_w400_lsm043.copyWith(color: palette.text60),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          );
        },
      ),
    ),
  ];

  List<SettingsSectionChildModel> supportSectionsRenderer({
    required BuildContext context,
  }) => [
    SettingsSectionChildModel(
      title: 'Обратная связь'.tr(),
      iconPath: 'assets/icons/calendar-icon.svg',
      onPress: () => showEditUserNameModalBottom(context: context),
    ),
  ];
}
