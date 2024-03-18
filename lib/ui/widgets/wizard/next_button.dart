import 'package:flutter/material.dart';
import 'package:flutter_wizard/flutter_wizard.dart';

class NextButton extends StatelessWidget {
  const NextButton({super.key});

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
          onPressed: enabled ? context.wizardController.goNext : null,
          child: const Text("Next"),
        );
      },
    );
  }
}
