import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardTextField extends StatelessWidget {
  const CardTextField({
    Key? key,
    this.title,
    this.bold = false,
    required this.hint,
    this.textInputType = TextInputType.text,
    required this.inputFormatters,
    required this.validator,
    this.maxLength = 50,
    this.textAlign = TextAlign.start,
    required this.focusNode,
    required this.onSubmitted,
    required this.onSaved,
  }) : super(key: key);

  final String? title;
  final bool bold;
  final String hint;
  final TextInputType textInputType;
  final List<TextInputFormatter> inputFormatters;
  final FormFieldValidator<String> validator;
  final int maxLength;
  final TextAlign textAlign;
  final FocusNode focusNode;
  final Function(String) onSubmitted;
  final FormFieldSetter<String> onSaved;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: '',
      validator: validator,
      onSaved: onSaved,
      builder: (state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Row(
                  children: [
                    Text(
                      title!,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    if (state.hasError)
                      const Text(
                        ' Inválido',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 9,
                        ),
                      ),
                  ],
                ),
              TextFormField(
                style: TextStyle(
                  color: title == null && state.hasError
                      ? Colors.red
                      : Colors.white,
                  fontWeight: bold ? FontWeight.bold : FontWeight.w500,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(
                    color: title == null && state.hasError
                        ? Colors.red.withAlpha(200)
                        : Colors.white.withAlpha(100),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 2),
                  counterText: '',
                ),
                keyboardType: textInputType,
                inputFormatters: inputFormatters,
                onChanged: (text) {
                  state.didChange(text);
                },
                maxLength: maxLength,
                textAlign: textAlign,
                focusNode: focusNode,
                onFieldSubmitted: onSubmitted,
              ),
            ],
          ),
        );
      },
    );
  }
}
