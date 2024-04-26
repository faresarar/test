import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../tools.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.label,
    this.hintText,
    this.errorText,
    this.errorColor,
    this.initialValue,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.readOnly = false,
    this.enabled = true,
    this.fillColor,
    this.prefixColor,
    this.focusNode,
    this.maxLength,
    this.keyboardType,
    this.maxLines = 1,
    this.obscureText = false,
    this.autofocus = false,
    this.contentPadding,
    this.margin,
    this.isHeightFixed = true,
    this.textCapitalization,
    this.validator,
    this.prefixOnTap,
    this.suffixOnTap,
    this.onChanged,
    this.onEditingComplete,
    this.textInputAction,
    this.onSaved,
    this.inputFormatters,
  }) : assert(
          ((prefixOnTap == null || prefixIcon != null) &&
              (suffixOnTap == null || suffixIcon != null)),
        );

  final String? label;
  final String? hintText;
  final String? errorText;
  final Color? errorColor;
  final String? initialValue;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final void Function()? onTap;
  final bool readOnly;
  final bool enabled;
  final Color? fillColor;
  final Color? prefixColor;
  final FocusNode? focusNode;
  final bool isHeightFixed;
  final int? maxLength;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool obscureText;
  final bool autofocus;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? margin;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCapitalization;
  final String? Function(String?)? validator;
  final void Function()? prefixOnTap;
  final void Function()? suffixOnTap;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final void Function(String?)? onSaved;
  final List<TextInputFormatter>? inputFormatters;
  @override
  Widget build(BuildContext context) {
    InputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.sp),
      borderSide: BorderSide(color: Styles.black[100]!),
    );
    Widget textFormField = TextFormField(
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      autofocus: autofocus,
      initialValue: initialValue,
      controller: controller,
      style: context.h5b1,
      onTap: onTap,
      readOnly: readOnly || onTap != null,
      enabled: enabled,
      onChanged: onChanged,
      focusNode: focusNode,
      validator: validator,
      maxLength: maxLength,
      textCapitalization: textCapitalization ??
          ([TextInputType.emailAddress, TextInputType.visiblePassword]
                  .contains(keyboardType)
              ? TextCapitalization.none
              : TextCapitalization.sentences),
      keyboardType: keyboardType,
      maxLines: maxLines,
      textInputAction: textInputAction,
      onEditingComplete: onEditingComplete,
      onSaved: onSaved,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        fillColor: Styles.black[100]!,
        filled: true,
        alignLabelWithHint: false,
        label: label != null
            ? Text(
                label!,
                style: context.h3b1,
              )
            : null,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: hintText,
        errorText: errorText,
        errorStyle: !isHeightFixed
            ? context.h6b1.copyWith(
                fontSize: 0,
                height: 0.3,
                color: errorColor ?? Styles.red,
              )
            : context.h6b1.copyWith(
                height: 0.6,
                color: errorColor ?? Styles.red,
              ),
        hintStyle: context.h5b3,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 18.sp,
          vertical: 18.sp,
        ),
        border: outlineInputBorder,
        focusedBorder: outlineInputBorder.copyWith(
          borderSide: BorderSide(color: context.primary),
        ),
        enabledBorder: outlineInputBorder,
        errorBorder: outlineInputBorder.copyWith(
          borderSide: BorderSide(
            color: errorColor ?? Styles.red,
          ),
        ),
        disabledBorder: outlineInputBorder.copyWith(
          borderSide: BorderSide(
            color: context.b3,
          ),
        ),
        suffixIcon: suffixIcon != null
            ? Focus(
                canRequestFocus: false,
                descendantsAreFocusable: false,
                child: InkResponse(
                  onTap: suffixOnTap,
                  child: Padding(
                    padding: EdgeInsets.all(12.sp),
                    child: Icon(
                      suffixIcon,
                      size: 18.sp,
                      color: prefixColor ?? context.b2,
                    ),
                  ),
                ),
              )
            : null,
        prefixIcon: prefixIcon != null
            ? InkResponse(
                onTap: prefixOnTap,
                child: Padding(
                  padding: EdgeInsets.all(12.sp),
                  child: Icon(
                    prefixIcon,
                    size: 18.sp,
                    color: prefixColor ?? context.b2,
                  ),
                ),
              )
            : null,
        errorMaxLines: 1,
      ),
    );
    if (keyboardType == TextInputType.multiline) {
      textFormField = SizedBox(
        height: 250.sp,
        child: textFormField,
      );
    } else {
      if ((validator != null && isHeightFixed) &&
          maxLines == 1 &&
          keyboardType != TextInputType.multiline) {
        textFormField = SizedBox(
          height: 75.sp,
          child: textFormField,
        );
      }
    }
    if (margin != null) {
      textFormField = Padding(
        padding: margin!,
        child: textFormField,
      );
    }
    return textFormField;
  }
}
