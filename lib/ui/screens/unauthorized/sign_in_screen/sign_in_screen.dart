import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/features/auth/api/auth_api.dart';
import 'package:bogge_app/features/auth/api/backend_error_code_parser.dart';
import 'package:bogge_app/features/auth/providers/sign_in_provider.dart';
import 'package:bogge_app/helpers/handle_request_failure.dart';
import 'package:bogge_app/models/request_error_model.dart';
import 'package:bogge_app/providers/navigation/routers/un_authorized/un_authorized_router.gr.dart';
import 'package:bogge_app/services/navigation_service.dart';
import 'package:bogge_app/ui/screens/unauthorized/sign_in_screen/widgets/sign_in_form.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_button.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_text_button.dart';
import 'package:bogge_app/ui/widgets/buttons/text_button_with_icon.dart';
import 'package:bogge_app/ui/widgets/containers/dismiss_keyboard_container.dart';
import 'package:bogge_app/ui/widgets/headers/common_header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

@RoutePage()
class SignInScreen extends HookConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signInStateProvider);
    final navigationService = ref.read(navigationServiceProvider);
    final isSubmitting = useState(false);

    return Scaffold(
      body: DismissKeyboardContainer(
        child: SafeArea(
          child: Padding(
            padding: AppSpace.ph16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonHeader(
                  title: 'Вход'.tr(),
                  onPop: () => navigationService.goToUnAuthorizedMode(context),
                ),
                AppSpace.h24,
                ReactiveForm(
                  formGroup: state.signInForm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SignInForm(),
                      AppSpace.h16,
                      PrimaryTextButton(
                        text: 'Забыли пароль?'.tr(),
                        onPress: () =>
                            context.router.push(ResetPasswordRoute()),
                      ),
                      AppSpace.h32,
                      ReactiveFormConsumer(
                        builder: (context, form, _) {
                          return PrimaryButton(
                            text: 'Войти'.tr(),
                            isLoading: isSubmitting.value,
                            onPress: form.valid && !isSubmitting.value
                                ? () => handleSubmit(
                                    context: context,
                                    ref: ref,
                                    form: form,
                                    isSubmitting: isSubmitting,
                                  )
                                : null,
                          );
                        },
                      ),
                      AppSpace.h16,
                      Center(
                        child: TextButtonWithIcon(
                          text: 'Войти как гость'.tr(),
                          renderIconLeft: () => Padding(
                            padding: EdgeInsetsDirectional.only(
                              end: AppSpace.s4.w,
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/guest-icon.svg',
                            ),
                          ),
                          onPress: () =>
                              navigationService.goToGuestMode(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void handleSubmit({
    required BuildContext context,
    required WidgetRef ref,
    required FormGroup form,
    required ValueNotifier<bool> isSubmitting,
  }) async {
    try {
      FocusScope.of(context).unfocus();
      isSubmitting.value = true;
      final response = await ref.read(authRepository).signIn();

      if (!context.mounted) return;

      if (!response.success) {
        handleFormError(
          code: BackendErrorCodeX.fromCode(response.code),
          form: form,
          context: context,
        );
        return;
      }

      final navigationService = ref.read(navigationServiceProvider);
      navigationService.goToAuthorizedMode(context);
    } on RequestErrorModel catch (e) {
      if (!context.mounted) return;

      handleRequestFailure(context: context, failureType: e.failureType);
    } catch (_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Что-то пошло не так'.tr())));
    } finally {
      if (context.mounted) {
        isSubmitting.value = false;
      }
    }
  }
}
