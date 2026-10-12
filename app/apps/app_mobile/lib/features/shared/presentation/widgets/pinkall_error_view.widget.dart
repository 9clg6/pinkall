import 'package:core_presentation/core_presentation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pinkall/generated/locale_keys.g.dart';

/// Localized error state for a failed asynchronous screen.
final class PinkallErrorView extends StatelessWidget {
  /// Creates an error view with a retry callback.
  const PinkallErrorView({required this.onRetry, super.key});

  /// Invoked when the user retries the operation.
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final PinkallThemeTokens tokens =
        Theme.of(context).extension<PinkallThemeTokens>() ??
        PinkallThemeTokens.light;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: EdgeInsets.all(tokens.spaceLarge),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(tokens.panelRadius),
              border: Border.all(color: colors.outlineVariant),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: colors.shadow.withValues(alpha: 0.055),
                  blurRadius: 34,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(tokens.spaceExtraLarge),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.errorContainer,
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox.square(
                      dimension: 52,
                      child: Icon(
                        Icons.wifi_off_rounded,
                        color: colors.error,
                        size: 24,
                      ),
                    ),
                  ),
                  Gap(tokens.spaceLarge),
                  Text(
                    LocaleKeys.error_title.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Gap(tokens.spaceSmall),
                  Text(
                    LocaleKeys.error_body.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  Gap(tokens.spaceLarge),
                  FilledButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(LocaleKeys.common_retry.tr()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
