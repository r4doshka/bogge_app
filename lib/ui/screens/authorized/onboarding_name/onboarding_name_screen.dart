import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class OnboardingNameScreen extends ConsumerWidget {
  const OnboardingNameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(body: Column(children: [Text('OnboardingNameScreen')]));
  }
}
