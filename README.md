# Auto Form Validator

A highly customizable and comprehensive Flutter package for automated form validation. `auto_form_validator` provides a simple, unified, and declarative way to validate all kinds of form fields in your Flutter applications.

## Features

- **Comprehensive Built-in Validators:** `required`, `email`, `phone`, `password`, `minLength`, `maxLength`, `numeric`, `alphabetic`, `match` (for password confirmation).
- **Custom Error Messages:** Easily provide custom error messages for each validator.
- **Custom Regex Support:** Pass your own regular expressions to override default patterns or create entirely new validation rules.
- **Custom Functions:** Provide any custom boolean-returning function for complex validation logic.
- **Validator Composition:** Chain multiple validators together for a single form field using `AutoFormValidator.compose()`. First error encountered will be returned.
- **Zero Dependencies:** Pure Dart utility classes, lightweight and fast.

## Getting started

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  auto_form_validator:
    path: ../ # Replace with version when published to pub.dev
```

Then run `flutter pub get`.

## Usage

Import the package in your file:

```dart
import 'package:auto_form_validator/auto_form_validator.dart';
```

### Basic Validation

Use a single validator on a `TextFormField`:

```dart
TextFormField(
  decoration: const InputDecoration(labelText: 'Email'),
  validator: (value) => AutoFormValidator.email(value, message: 'Invalid email address'),
)
```

### Composing Multiple Validators & Auto-Scrolling

To check for multiple rules (e.g., required AND valid email AND custom rule), use `AutoFormValidator.compose()`. 

You can also pass an optional `focusNode` to `compose()`. If validation fails, it will automatically request focus on the **first** failed field in your form, seamlessly scrolling the user to it!

```dart
// First, create a FocusNode in your State class
final _ageFocus = FocusNode();

// Pass it to your TextFormField AND to the compose method
TextFormField(
  focusNode: _ageFocus,
  decoration: const InputDecoration(labelText: 'Age'),
  validator: AutoFormValidator.compose([
    (val) => AutoFormValidator.required(val, message: 'Age is required'),
    (val) => AutoFormValidator.numeric(val, message: 'Age must be a number'),
    (val) => AutoFormValidator.custom(
          val,
          (v) => int.tryParse(v ?? '') != null && int.parse(v!) >= 18,
          message: 'You must be at least 18 years old',
        ),
  ], focusNode: _ageFocus),
)
```

### Customizing Regex

You can override the default regex for email, phone, or passwords, or create entirely custom ones using `AutoFormValidator.regex()`:

```dart
TextFormField(
  decoration: const InputDecoration(labelText: 'Custom ID Code'),
  validator: (val) => AutoFormValidator.regex(
    val, 
    RegExp(r'^[A-Z]{3}-\d{4}$'), 
    message: 'Must follow format ABC-1234',
  ),
)
```

### Checking for Matching Values

Perfect for "Confirm Password" scenarios:

```dart
TextFormField(
  decoration: const InputDecoration(labelText: 'Confirm Password'),
  obscureText: true,
  validator: (val) => AutoFormValidator.match(
    val, 
    _passwordController.text, 
    message: 'Passwords do not match',
  ),
)
```

## Available Validators

| Validator | Description |
| :--- | :--- |
| `required` | Field cannot be null or empty string. |
| `email` | Validates standard email formats. |
| `phone` | Validates standard phone number formats (+ and 7-15 digits). |
| `password` | Validates strong password (8+ chars, min 1 letter, min 1 number). |
| `minLength` | Enforces a minimum character length. |
| `maxLength` | Enforces a maximum character length. |
| `numeric` | Ensures input only contains numbers. |
| `alphabetic`| Ensures input only contains alphabetic characters (a-z, A-Z). |
| `alphaNumeric` | Ensures input contains only letters and numbers. |
| `integer` | Validates if the input is a valid integer. |
| `range` | Validates if a numeric input falls within a specific range (inclusive). |
| `regex` | Validates against any user-provided `RegExp`. |
| `match` | Validates that the input matches another provided string. |
| `custom` | Validates against a user-provided boolean function. |
| `url` | Validates standard URL formats. |
| `lowercase` | Validates if the input is completely lowercase. |
| `uppercase` | Validates if the input is completely uppercase. |
| `contains` | Validates if the input contains a specific substring. |
| `hexColor` | Validates if the input is a valid hex color code. |
| `creditCard` | Validates a credit card number using basic format and Luhn algorithm. |
| `ipAddress` | Validates if the input is a valid IPv4 or IPv6 address. |
| `date` | Validates if the input is a valid Date in YYYY-MM-DD format. |
| `macAddress` | Validates if the input is a valid MAC address. |
| `uuid` | Validates if the input is a valid UUID/GUID. |
| `base64` | Validates if the input is a valid Base64 string. |
| `json` | Validates if the input is a valid JSON string. |
| `inList` | Validates if the input value exists in the provided list. |
| `notInList` | Validates if the input value does NOT exist in the provided list. |
| `startsWith` | Validates if the input starts with a specific substring. |
| `endsWith` | Validates if the input ends with a specific substring. |
| `hasUppercase` | Validates if the input contains at least one uppercase letter. |
| `hasLowercase` | Validates if the input contains at least one lowercase letter. |
| `hasNumber` | Validates if the input contains at least one number. |
| `hasSpecialCharacter` | Validates if the input contains at least one special character. |
| `slug` | Validates if the input is a valid URL slug. |
| `boolean` | Validates if the input represents a boolean (true or false). |

## Additional information

Check out the `example` folder in the repository for a fully working Flutter app demonstrating this package in action.

If you find a bug or have a feature request, please file an issue on the repository!

---

## License

* This package is licensed under the Apache-2.0 License.
