import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_border_radius.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class WorkoutListItemSkeleton extends ConsumerWidget {
  const WorkoutListItemSkeleton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);

    return Skeletonizer(
      child: Container(
        padding: EdgeInsetsDirectional.only(
          top: AppSpace.s12.h,
          bottom: AppSpace.s12.h,
          start: AppSpace.s16.w,
          end: AppSpace.s28.w,
        ),
        decoration: BoxDecoration(
          borderRadius: AppBorderRadius.all24,
          color: palette.white,
        ),
        child: Row(
          children: [
            const Bone.square(size: 24),

            AppSpace.w16,

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Bone.text(words: 2),
                  SizedBox(height: 6),
                  Bone.text(words: 3),
                ],
              ),
            ),

            AppSpace.w16,

            const Bone.text(words: 1),

            AppSpace.w16,

            const Bone.square(size: 16),
          ],
        ),
      ),
    );
  }
}
