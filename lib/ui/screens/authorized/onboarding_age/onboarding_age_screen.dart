import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class OnboardingAgeScreen extends ConsumerWidget {
  const OnboardingAgeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(body: Column(children: [Text('OnboardingAgeScreen')]));
  }
}
