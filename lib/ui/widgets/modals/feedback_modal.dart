import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/features/feedback/api/feedback_api.dart';
import 'package:bogge_app/features/feedback/providers/feedback_provider.dart';
import 'package:bogge_app/models/router/router_model.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_button.dart';
import 'package:bogge_app/ui/widgets/containers/dismiss_keyboard_container.dart';
import 'package:bogge_app/ui/widgets/form/reactive_form/reactive_input_animated_field.dart';
import 'package:bogge_app/ui/widgets/form/reactive_form/reactive_input_field.dart';
import 'package:bogge_app/ui/widgets/modals/widgets/default_modal_bottom.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/widgets/modals/widgets/modal_close_button.dart';
import 'package:bogge_app/ui/widgets/modals/widgets/modal_title.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

Future<void> showFeedbackModalBottom({required BuildContext context}) async {
  final mediaQuery = MediaQuery.of(context);
  return await showDefaultModalBottom(
    context: context,
    minHeight: mediaQuery.size.height * 0.94,
    hasCloseButton: false,
    modalName: AppModalList.feedback.title,
    contentRenderer: () => Expanded(
      child: SafeArea(
        top: false,
        child: Padding(
          padding: AppSpace.ph16,
          child: DismissKeyboardContainer(child: FeedbackModal()),
        ),
      ),
    ),
    child: SizedBox.shrink(),
  );
}

class FeedbackModal extends HookConsumerWidget {
  const FeedbackModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(paletteProvider);
    final state = ref.watch(feedbackStateProvider);
    final isSubmitting = useState(false);

    return ReactiveForm(
      formGroup: state.feedbackForm,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                alignment: AlignmentDirectional.centerStart,
                height: AppSpace.s44.h,
                width: AppSpace.s44.w,
                child: ModalCloseButton(),
              ),
              Expanded(child: ModalTitle(label: "Обратная связь".tr())),
              AppSpace.w44,
            ],
          ),
          AppSpace.h24,
          ReactiveInputAnimatedField<String>(
            fieldName: state.titleField,
            keyboardType: TextInputType.text,
            minContainerHeight: 54.h,
            maxContainerHeight: 85.h,
            maxLines: 2,
            labelText: 'Заголовок'.tr(),
            hiddenErrors: ['required'],
            validationMessages: {
              'common': (_) => 'Что-то пошло не так'.tr(),
              'minLength': (error) {
                final requiredLength =
                    (error as Map<String, dynamic>)['requiredLength'];

                return 'Минимум COUNT символа'.tr(
                  namedArgs: {'count': '$requiredLength'},
                );
              },

              'maxLength': (error) {
                final requiredLength =
                    (error as Map<String, dynamic>)['requiredLength'];

                return 'Максимум COUNT символов'.tr(
                  namedArgs: {'count': '$requiredLength'},
                );
              },
              'invalidCharacters': (_) => 'Недопустимые символы'.tr(),
            },
          ),
          AppSpace.h8,
          ReactiveInputField<String>(
            fieldName: state.messageField,
            containerHeight: 382.h,
            maxLines: 16,
            keyboardType: TextInputType.text,
            labelText: 'Опишите проблему'.tr(),
            hiddenErrors: ['required'],
            validationMessages: {
              'common': (_) => 'Что-то пошло не так'.tr(),
              'minLength': (error) {
                final requiredLength =
                    (error as Map<String, dynamic>)['requiredLength'];

                return 'Минимум COUNT символа'.tr(
                  namedArgs: {'count': '$requiredLength'},
                );
              },

              'maxLength': (error) {
                final requiredLength =
                    (error as Map<String, dynamic>)['requiredLength'];

                return 'Максимум COUNT символов'.tr(
                  namedArgs: {'count': '$requiredLength'},
                );
              },
              'invalidCharacters': (_) => 'Недопустимые символы'.tr(),
            },
          ),
          AppSpace.h16,
          Text(
            'Если у вас есть вопрос проблема или предложение напишите нам Мы обязательно ответим вам на почту'
                .tr(),
            style: text_s14_w400_ls01.copyWith(color: palette.text60),
            textAlign: TextAlign.center,
          ),
          Spacer(),
          ReactiveFormConsumer(
            builder: (context, form, _) => PrimaryButton(
              text: 'Отправить'.tr(),
              onPress: form.valid && !isSubmitting.value
                  ? () => submitFeedback(
                      context: context,
                      ref: ref,
                      isSubmitting: isSubmitting,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> submitFeedback({
    required BuildContext context,
    required WidgetRef ref,
    required ValueNotifier<bool> isSubmitting,
  }) async {
    final state = ref.read(feedbackStateProvider);
    final form = state.feedbackForm;

    FocusScope.of(context).unfocus();
    form.unfocus();

    if (form.invalid) {
      form.markAllAsTouched();
      return;
    }

    try {
      isSubmitting.value = true;

      final success = await ref
          .read(feedbackRepository)
          .createFeedbackRequest();

      if (!success) return;

      if (!context.mounted) return;
      form.reset();
      context.router.pop();
    } catch (_) {
      final title = form.control(state.titleField);
      final message = form.control(state.messageField);

      title.setErrors({'common': true});
      title.markAsTouched();
      message.setErrors({'common': true});
      message.markAsTouched();
    } finally {
      if (context.mounted) {
        isSubmitting.value = false;
      }
    }
  }
}
