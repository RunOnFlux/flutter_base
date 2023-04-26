import 'package:flutter/material.dart';
import 'package:flutter_wizard/flutter_wizard.dart';

import 'step_provider.dart';
import 'steps_overview.dart';
import 'steps_progress_indicator.dart';

mixin WizardUtils {
  Widget buildProgressIndicator(
    BuildContext context,
  ) {
    return StreamBuilder<int>(
      stream: context.wizardController.indexStream,
      initialData: context.wizardController.index,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.hasError) {
          return const SizedBox.shrink();
        }
        final index = snapshot.data!;
        return StepsProgressIndicator(
          count: context.wizardController.stepCount,
          index: index,
        );
      },
    );
  }

  Widget buildWizard(
    BuildContext context, {
    required BoxConstraints constraints,
  }) {
    final wizard = Wizard(
      stepBuilder: (context, state) {
        if (state is StepProvider) {
          return (state as StepProvider).getStepWidget();
        }
        return Container();
      },
    );
    final narrow = constraints.maxWidth <= 600;
    return Row(
      children: [
        Visibility(
          visible: !narrow,
          child: const SizedBox(
            width: 200,
            child: StepsOverview(),
          ),
        ),
        Expanded(
          child: wizard,
        ),
      ],
    );
  }
}
