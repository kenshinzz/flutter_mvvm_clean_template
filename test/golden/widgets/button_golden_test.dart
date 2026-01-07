@Tags(['golden'])
library;

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  goldenTest(
    'ElevatedButton renders correctly',
    fileName: 'elevated_button',
    builder: () => GoldenTestGroup(
      scenarioConstraints: const BoxConstraints(maxWidth: 300),
      children: [
        GoldenTestScenario(
          name: 'default',
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('Click Me'),
          ),
        ),
        GoldenTestScenario(
          name: 'disabled',
          child: const ElevatedButton(onPressed: null, child: Text('Disabled')),
        ),
        GoldenTestScenario(
          name: 'with icon',
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Add Item'),
          ),
        ),
      ],
    ),
  );

  goldenTest(
    'OutlinedButton renders correctly',
    fileName: 'outlined_button',
    builder: () => GoldenTestGroup(
      scenarioConstraints: const BoxConstraints(maxWidth: 300),
      children: [
        GoldenTestScenario(
          name: 'default',
          child: OutlinedButton(
            onPressed: () {},
            child: const Text('Outlined'),
          ),
        ),
        GoldenTestScenario(
          name: 'with icon',
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
          ),
        ),
      ],
    ),
  );

  goldenTest(
    'TextButton renders correctly',
    fileName: 'text_button',
    builder: () => GoldenTestGroup(
      scenarioConstraints: const BoxConstraints(maxWidth: 300),
      children: [
        GoldenTestScenario(
          name: 'default',
          child: TextButton(onPressed: () {}, child: const Text('Text Button')),
        ),
      ],
    ),
  );
}
