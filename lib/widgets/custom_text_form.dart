import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.validator,
    this.inputFormatters,
    this.keyboardType,
    this.suffixIcon,
    this.obscureText = false,
    this.hintText,
    this.labelText,
    this.controller,
    this.prefixIcon,
    this.customBorder,
    this.maxLines = 1,
    this.minLines,
    this.customHintStyle,
    this.enabledBorder,
    this.labelStyle,
    this.enabled = true,
    this.onTap,
    this.readOnly = false,
    this.initialValue,
    this.contentPadding,
  });
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final String? hintText;
  final String? labelText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final InputBorder? customBorder;
  final InputBorder? enabledBorder;
  final int? maxLines;
  final int? minLines;
  final TextStyle? customHintStyle;
  final TextStyle? labelStyle;
  final bool? enabled;
  final Function()? onTap;
  final bool readOnly;
  final String? initialValue;
  final EdgeInsetsGeometry? contentPadding;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      minLines: minLines,
      initialValue: initialValue,
      onTapOutside: (event) {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      onTap: onTap,
      scrollPadding: EdgeInsets.all(20.0),
      inputFormatters: inputFormatters,
      enabled: enabled,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: labelStyle,
        contentPadding: contentPadding,
        hintText: hintText,
        hintStyle: customHintStyle ??
            const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        //

        enabledBorder: enabledBorder,
        border: customBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
      ),
    );
  }
}
