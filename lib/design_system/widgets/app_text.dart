import 'package:flutter/material.dart';

/// High-level text styles used across the app.
///
/// These map onto the underlying `TextTheme` but give us a single
/// place to adjust typography without touching every call site.
abstract final class AppText {
  /// Large display text for headlines.
  static TextStyle display(final BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium!.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: 0.2,
    );
  }

  /// Primary body text for standard copy.
  static TextStyle body(final BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(height: 1.4);
  }

  /// Secondary body text for muted content or captions.
  static TextStyle muted(final BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Theme.of(
      context,
    ).textTheme.bodySmall!.copyWith(color: colors.onSurface.withOpacity(0.6));
  }
}

/// Convenience widget for display text.
class AppDisplayText extends StatelessWidget {
  /// Creates a new display text widget.
  const AppDisplayText(this.text, {super.key, this.textAlign});

  /// Text content to render.
  final String text;

  /// Optional text alignment.
  final TextAlign? textAlign;

  @override
  Widget build(final BuildContext context) {
    return Text(text, textAlign: textAlign, style: AppText.display(context));
  }
}

/// Convenience widget for body text.
class AppBodyText extends StatelessWidget {
  const AppBodyText(this.text, {super.key, this.textAlign});

  /// Text content to render.
  final String text;

  /// Optional text alignment.
  final TextAlign? textAlign;

  @override
  Widget build(final BuildContext context) {
    return Text(text, textAlign: textAlign, style: AppText.body(context));
  }
}
