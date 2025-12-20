/// AppTextField: DS standardized Material 3 text field.
/// - Token/theme-driven via AppInputStyleResolver + DS ThemeExtensions.
/// - No validation logic: feature passes errorText.
/// - Accessible: label/hint/helper/error are supported.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'input_style_resolver.dart';

@immutable
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;

  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;

  final bool enabled;
  final bool readOnly;
  final bool obscureText;

  final AppInputSize size;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;

  final int? minLines;
  final int? maxLines;
  final int? maxLength;

  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final bool isDense;

  /// For screen readers: defaults to [labelText] if set.
  final String? semanticsLabel;

  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.size = AppInputSize.md,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.minLines,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.autofillHints,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.isDense = false,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final resolved = AppInputStyleResolver.resolve(
      context,
      size: size,
      enabled: enabled,
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      isDense: isDense,
    );

    final textStyle = AppInputStyleResolver.textStyleFor(context, size: size);

    return Semantics(
      textField: true,
      enabled: enabled,
      label: semanticsLabel ?? labelText,
      child: ConstrainedBox(
        constraints: resolved.constraints,
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,
          readOnly: readOnly,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          minLines: minLines,
          maxLines: maxLines,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          autofillHints: autofillHints,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          onTap: onTap,
          style: textStyle,
          decoration: resolved.decoration,
        ),
      ),
    );
  }
}
