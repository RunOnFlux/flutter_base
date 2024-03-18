import 'package:flutter/material.dart';
import 'package:flutter_wizard/flutter_wizard.dart';

import 'step_provider.dart';

class FinishedButton extends StatelessWidget {
  const FinishedButton({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return StreamBuilder<bool>(
      stream: context.wizardController.getIsGoNextEnabledStream(),
      initialData: context.wizardController.getIsGoNextEnabled(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.hasError) {
          return const SizedBox.shrink();
        }
        final enabled = snapshot.data!;
        return ElevatedButton(
          onPressed: enabled
              ? () {
                  (context.wizardController.stepControllers[context.wizardController.stepCount - 1].step
                          as FinalStepProvider)
                      .onFinish();
                  Navigator.of(context).pop();
                }
              : null,
          child: const Text("Finish"),
        );
      },
    );
  }
}
