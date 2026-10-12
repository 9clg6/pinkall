import 'package:flutter/material.dart';

/// Quiet loading state used by asynchronous Pinkall screens.
final class PinkallLoadingView extends StatelessWidget {
  /// Creates the loading view.
  const PinkallLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final bool reduceMotion = MediaQuery.disableAnimationsOf(context);
    return Center(
      child: Semantics(
        label: 'Chargement',
        liveRegion: true,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: colors.outlineVariant),
          ),
          child: SizedBox.square(
            dimension: 72,
            child: Center(
              child: reduceMotion
                  ? Icon(Icons.more_horiz_rounded, color: colors.primary)
                  : SizedBox.square(
                      dimension: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        strokeCap: StrokeCap.round,
                        color: colors.primary,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
