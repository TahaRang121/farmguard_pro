import 'package:flutter/material.dart';

import '../../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AddFieldFab extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isExpanded;

  const AddFieldFab({
    super.key,
    this.onPressed,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      elevation: 4.0,
      icon: CustomIconWidget(
        iconName: 'add_location',
        color: theme.colorScheme.onPrimary,
        size: 24,
      ),
      label: Text(
        'Add Field',
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      heroTag: "addFieldFab",
    );
  }
}
