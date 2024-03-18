import 'package:flutter/material.dart';
import 'package:flutter_wizard/flutter_wizard.dart';

import 'step_provider.dart';

class StepsOverview extends StatelessWidget {
  const StepsOverview({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return ListView.builder(
      itemCount: context.wizardController.stepControllers.length,
      itemBuilder: (context, index) {
        final step = context.wizardController.stepControllers[index].step;
        return StreamBuilder<bool>(
          stream: context.wizardController.getIsGoToEnabledStream(index),
          initialData: context.wizardController.getIsGoToEnabled(index),
          builder: (context, snapshot) {
            final enabled = snapshot.data!;
            String title = (step as StepProvider).description;
            return StreamBuilder<int>(
              stream: context.wizardController.indexStream,
              initialData: context.wizardController.index,
              builder: (context, snapshot) {
                final selectedIndex = snapshot.data!;
                return ListTile(
                  title: Text(title),
                  enabled: enabled,
                  selected: index == selectedIndex,
                );
              },
            );
          },
        );
      },
    );
  }
}
