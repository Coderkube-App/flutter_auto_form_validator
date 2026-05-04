library flutter_auto_form_validator;

import 'dart:convert';
import 'package:flutter/widgets.dart';

/// A utility class that provides common form validation methods for Flutter apps.
class AutoFormValidator {
  static final List<FocusNode> _failedNodes = [];
  static bool _isFocusScheduled = false;

  /// Validates if the input is not empty.
  static String? required(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'This field is required';
    }
    return null;
  }

  /// Validates if the input is a valid email address.
  static String? email(String? value, {String? message, RegExp? customRegex}) {
    if (value == null || value.trim().isEmpty) {
      return null; // Use required() to check for emptiness
    }
    final regex = customRegex ?? RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value)) {
      return message ?? 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates if the input is a valid phone number.
  static String? phone(String? value, {String? message, RegExp? customRegex}) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final regex = customRegex ?? RegExp(r'^\+?[0-9]{7,15}$');
    if (!regex.hasMatch(value)) {
      return message ?? 'Please enter a valid phone number';
    }
    return null;
  }

  /// Validates if the input is a strong password.
  /// Default requires at least 8 characters, one letter, and one number.
  static String? password(
    String? value, {
    String? message,
    RegExp? customRegex,
  }) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final regex = customRegex ?? RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).{8,}$');
    if (!regex.hasMatch(value)) {
      return message ??
          'Password must be at least 8 characters and contain at least one letter and one number';
    }
    return null;
  }

  /// Validates the minimum length of the input.
  static String? minLength(String? value, int min, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    if (value.length < min) {
      return message ?? 'Must be at least $min characters long';
    }
    return null;
  }

  /// Validates the maximum length of the input.
  static String? maxLength(String? value, int max, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    if (value.length > max) {
      return message ?? 'Must be at most $max characters long';
    }
    return null;
  }

  /// Validates if the input contains only numeric characters.
  static String? numeric(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    if (double.tryParse(value) == null) {
      return message ?? 'Please enter a valid number';
    }
    return null;
  }

  /// Validates if the input contains only alphabetic characters.
  static String? alphabetic(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final regex = RegExp(r'^[a-zA-Z]+$');
    if (!regex.hasMatch(value)) {
      return message ?? 'Please enter only letters';
    }
    return null;
  }

  /// Validates if the input matches a provided custom Regular Expression.
  static String? regex(String? value, RegExp regex, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    if (!regex.hasMatch(value)) {
      return message ?? 'Invalid format';
    }
    return null;
  }

  /// Validates if the input matches a target value (e.g., password confirmation).
  static String? match(String? value, String? targetValue, {String? message}) {
    if (value != targetValue) {
      return message ?? 'Values do not match';
    }
    return null;
  }

  /// Validates using a custom validation function.
  static String? custom(
    String? value,
    bool Function(String?) validator, {
    String? message,
  }) {
    if (!validator(value)) {
      return message ?? 'Invalid input';
    }
    return null;
  }

  /// Validates if the input is a valid URL.
  static String? url(String? value, {String? message, RegExp? customRegex}) {
    if (value == null || value.trim().isEmpty) return null;
    final regex =
        customRegex ??
        RegExp(
          r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([/\w \.-]*)*\/?(\?[^\s]*)?$',
        );
    if (!regex.hasMatch(value)) {
      return message ?? 'Please enter a valid URL';
    }
    return null;
  }

  /// Validates if the input is alphanumeric (only letters and numbers).
  static String? alphaNumeric(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) return null;
    final regex = RegExp(r'^[a-zA-Z0-9]+$');
    if (!regex.hasMatch(value)) {
      return message ?? 'Please enter only letters and numbers';
    }
    return null;
  }

  /// Validates if the input is a valid Integer (no decimals).
  static String? integer(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) return null;
    if (int.tryParse(value) == null) {
      return message ?? 'Please enter a valid integer';
    }
    return null;
  }

  /// Validates if a numeric input falls within a specific range (inclusive).
  static String? range(String? value, num min, num max, {String? message}) {
    if (value == null || value.trim().isEmpty) return null;
    final number = num.tryParse(value);
    if (number == null || number < min || number > max) {
      return message ?? 'Value must be between $min and $max';
    }
    return null;
  }

  /// Validates if the input is completely lowercase.
  static String? lowercase(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) return null;
    if (value != value.toLowerCase()) {
      return message ?? 'Must be in lowercase';
    }
    return null;
  }

  /// Validates if the input is completely uppercase.
  static String? uppercase(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) return null;
    if (value != value.toUpperCase()) {
      return message ?? 'Must be in uppercase';
    }
    return null;
  }

  /// Validates if the input contains a specific substring.
  static String? contains(String? value, String substring, {String? message}) {
    if (value == null || value.trim().isEmpty) return null;
    if (!value.contains(substring)) {
      return message ?? 'Must contain "$substring"';
    }
    return null;
  }

  /// Validates if the input is a valid Hex Color code.
  static String? hexColor(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) return null;
    final regex = RegExp(r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$');
    if (!regex.hasMatch(value)) {
      return message ?? 'Please enter a valid hex color code';
    }
    return null;
  }

  /// Validates a credit card number using basic format and Luhn algorithm.
  static String? creditCard(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) return null;
    final cleanValue = value.replaceAll(RegExp(r'\s|-'), '');
    final regex = RegExp(r'^[0-9]{10,19}$');
    if (!regex.hasMatch(cleanValue)) {
      return message ?? 'Please enter a valid credit card number';
    }

    int sum = 0;
    bool alternate = false;
    for (int i = cleanValue.length - 1; i >= 0; i--) {
      int n = int.parse(cleanValue[i]);
      if (alternate) {
        n *= 2;
        if (n > 9) {
          n = (n % 10) + 1;
        }
      }
      sum += n;
      alternate = !alternate;
    }
    if (sum % 10 != 0) {
      return message ?? 'Please enter a valid credit card number';
    }
    return null;
  }

  /// Validates if the input is a valid IPv4 or IPv6 address.
  static String? ipAddress(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) return null;

    final isIpv4 = RegExp(r'^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$').hasMatch(value);
    bool isValidIpv4 = false;
    if (isIpv4) {
      isValidIpv4 = value.split('.').every((part) => int.parse(part) <= 255);
    }

    final isIpv6 =
        RegExp(r'^([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$').hasMatch(value) ||
        (value.contains('::') && RegExp(r'^[0-9a-fA-F:]+$').hasMatch(value));

    if (!isValidIpv4 && !isIpv6) {
      return message ?? 'Please enter a valid IP address';
    }
    return null;
  }

  /// Validates if the input is a valid Date in YYYY-MM-DD format.
  static String? date(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) return null;
    final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!regex.hasMatch(value)) {
      return message ?? 'Please enter a valid date (YYYY-MM-DD)';
    }
    final parts = value.split('-');
    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);
    if (year == null || month == null || day == null) {
      return message ?? 'Invalid date';
    }
    if (month < 1 || month > 12) {
      return message ?? 'Invalid month';
    }
    if (day < 1 || day > 31) {
      return message ?? 'Invalid day';
    }
    return null;
  }

  /// Validates if the input is a valid MAC address.
  static String? macAddress(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) return null;
    final regex = RegExp(r'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$');
    if (!regex.hasMatch(value)) {
      return message ?? 'Please enter a valid MAC address';
    }
    return null;
  }

  /// Validates if the input is a valid UUID/GUID.
  static String? uuid(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) return null;
    final regex = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    );
    if (!regex.hasMatch(value)) {
      return message ?? 'Please enter a valid UUID';
    }
    return null;
  }

  /// Validates if the input is a valid Base64 string.
  static String? base64(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) return null;
    final regex = RegExp(
      r'^(?:[A-Za-z0-9+\/]{4})*(?:[A-Za-z0-9+\/]{2}==|[A-Za-z0-9+\/]{3}=)?$',
    );
    if (!regex.hasMatch(value)) {
      return message ?? 'Please enter a valid Base64 string';
    }
    return null;
  }

  /// Validates if the input is a valid JSON string.
  static String? json(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) return null;
    try {
      jsonDecode(value);
      return null;
    } catch (e) {
      return message ?? 'Please enter a valid JSON string';
    }
  }

  /// Validates if the input value exists in the provided list.
  static String? inList(String? value, List<String> list, {String? message}) {
    if (value == null || value.trim().isEmpty) return null;
    if (!list.contains(value)) {
      return message ?? 'Invalid value selected';
    }
    return null;
  }

  /// Validates if the input value does NOT exist in the provided list.
  static String? notInList(
    String? value,
    List<String> list, {
    String? message,
  }) {
    if (value == null || value.trim().isEmpty) return null;
    if (list.contains(value)) {
      return message ?? 'This value is not allowed';
    }
    return null;
  }

  /// Validates if the input starts with a specific substring.
  static String? startsWith(
    String? value,
    String substring, {
    String? message,
  }) {
    if (value == null || value.trim().isEmpty) return null;
    if (!value.startsWith(substring)) {
      return message ?? 'Must start with "$substring"';
    }
    return null;
  }

  /// Validates if the input ends with a specific substring.
  static String? endsWith(String? value, String substring, {String? message}) {
    if (value == null || value.trim().isEmpty) return null;
    if (!value.endsWith(substring)) {
      return message ?? 'Must end with "$substring"';
    }
    return null;
  }

  /// Validates if the input contains at least one uppercase letter.
  static String? hasUppercase(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) return null;
    final regex = RegExp(r'[A-Z]');
    if (!regex.hasMatch(value)) {
      return message ?? 'Must contain at least one uppercase letter';
    }
    return null;
  }

  /// Validates if the input contains at least one lowercase letter.
  static String? hasLowercase(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) return null;
    final regex = RegExp(r'[a-z]');
    if (!regex.hasMatch(value)) {
      return message ?? 'Must contain at least one lowercase letter';
    }
    return null;
  }

  /// Validates if the input contains at least one number.
  static String? hasNumber(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) return null;
    final regex = RegExp(r'[0-9]');
    if (!regex.hasMatch(value)) {
      return message ?? 'Must contain at least one number';
    }
    return null;
  }

  /// Validates if the input contains at least one special character.
  static String? hasSpecialCharacter(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) return null;
    final regex = RegExp(r'[!@#\$&*~`%^()_\-+={\[}\]|\\:;"<,>.?\/]');
    if (!regex.hasMatch(value)) {
      return message ?? 'Must contain at least one special character';
    }
    return null;
  }

  /// Validates if the input is a valid URL slug.
  static String? slug(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) return null;
    final regex = RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$');
    if (!regex.hasMatch(value)) {
      return message ?? 'Please enter a valid slug (e.g., my-url-slug)';
    }
    return null;
  }

  /// Validates if the input represents a boolean (true or false).
  static String? boolean(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) return null;
    if (value.toLowerCase() != 'true' && value.toLowerCase() != 'false') {
      return message ?? 'Please enter a valid boolean (true or false)';
    }
    return null;
  }

  /// Chains multiple validators together.
  /// Stops and returns the first error encountered.
  /// If [focusNode] is provided, it will automatically request focus (and scroll to)
  /// the first field that fails validation in the form.
  static FormFieldValidator<String> compose(
    List<FormFieldValidator<String>> validators, {
    FocusNode? focusNode,
  }) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) {
          if (focusNode != null) {
            _failedNodes.add(focusNode);
            if (!_isFocusScheduled) {
              _isFocusScheduled = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_failedNodes.isNotEmpty) {
                  _failedNodes.first.requestFocus();
                  _failedNodes.clear();
                }
                _isFocusScheduled = false;
              });
            }
          }
          return result;
        }
      }
      return null;
    };
  }
}
