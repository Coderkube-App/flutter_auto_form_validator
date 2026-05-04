import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:auto_form_validator/auto_form_validator.dart';

void main() {
  group('AutoFormValidator', () {
    test('required validation', () {
      expect(AutoFormValidator.required(null), 'This field is required');
      expect(AutoFormValidator.required(''), 'This field is required');
      expect(AutoFormValidator.required('  '), 'This field is required');
      expect(AutoFormValidator.required('text'), null);
      expect(
        AutoFormValidator.required('', message: 'Custom Required'),
        'Custom Required',
      );
    });

    test('email validation', () {
      expect(AutoFormValidator.email('test@example.com'), null);
      expect(
        AutoFormValidator.email('invalid-email'),
        'Please enter a valid email address',
      );
      expect(
        AutoFormValidator.email(''),
        null,
      ); // Should return null for empty to let required() handle it
    });

    test('phone validation', () {
      expect(AutoFormValidator.phone('1234567890'), null);
      expect(AutoFormValidator.phone('+1234567890'), null);
      expect(
        AutoFormValidator.phone('123'),
        'Please enter a valid phone number',
      );
      expect(
        AutoFormValidator.phone('abc'),
        'Please enter a valid phone number',
      );
      expect(AutoFormValidator.phone(''), null);
    });

    test('password validation', () {
      expect(
        AutoFormValidator.password('password'),
        'Password must be at least 8 characters and contain at least one letter and one number',
      );
      expect(
        AutoFormValidator.password('12345678'),
        'Password must be at least 8 characters and contain at least one letter and one number',
      );
      expect(
        AutoFormValidator.password('pass12'),
        'Password must be at least 8 characters and contain at least one letter and one number',
      ); // Less than 8
      expect(AutoFormValidator.password('password123'), null);
      expect(
        AutoFormValidator.password('Password@123'),
        null,
      ); // Special characters allowed
      expect(AutoFormValidator.password('P@ssw0rd!'), null);
    });

    test('minLength validation', () {
      expect(
        AutoFormValidator.minLength('1234', 5),
        'Must be at least 5 characters long',
      );
      expect(AutoFormValidator.minLength('12345', 5), null);
      expect(AutoFormValidator.minLength('123456', 5), null);
    });

    test('maxLength validation', () {
      expect(
        AutoFormValidator.maxLength('123456', 5),
        'Must be at most 5 characters long',
      );
      expect(AutoFormValidator.maxLength('12345', 5), null);
      expect(AutoFormValidator.maxLength('1234', 5), null);
    });

    test('numeric validation', () {
      expect(AutoFormValidator.numeric('12345'), null);
      expect(AutoFormValidator.numeric('123.45'), null);
      expect(AutoFormValidator.numeric('abc'), 'Please enter a valid number');
    });

    test('alphabetic validation', () {
      expect(AutoFormValidator.alphabetic('abc'), null);
      expect(AutoFormValidator.alphabetic('abcDEF'), null);
      expect(AutoFormValidator.alphabetic('abc1'), 'Please enter only letters');
    });

    test('regex validation', () {
      final customRegex = RegExp(r'^[A-Z]+$');
      expect(AutoFormValidator.regex('ABC', customRegex), null);
      expect(AutoFormValidator.regex('abc', customRegex), 'Invalid format');
    });

    test('url validation', () {
      expect(AutoFormValidator.url('https://google.com'), null);
      expect(AutoFormValidator.url('http://example.org/path?q=1'), null);
      expect(AutoFormValidator.url('invalid-url'), 'Please enter a valid URL');
    });

    test('alphaNumeric validation', () {
      expect(AutoFormValidator.alphaNumeric('abc123'), null);
      expect(
        AutoFormValidator.alphaNumeric('abc_123'),
        'Please enter only letters and numbers',
      );
    });

    test('integer validation', () {
      expect(AutoFormValidator.integer('123'), null);
      expect(AutoFormValidator.integer('-123'), null);
      expect(
        AutoFormValidator.integer('123.45'),
        'Please enter a valid integer',
      );
    });

    test('range validation', () {
      expect(AutoFormValidator.range('15', 10, 20), null);
      expect(
        AutoFormValidator.range('5', 10, 20),
        'Value must be between 10 and 20',
      );
      expect(
        AutoFormValidator.range('25', 10, 20),
        'Value must be between 10 and 20',
      );
    });

    test('lowercase validation', () {
      expect(AutoFormValidator.lowercase('abc'), null);
      expect(AutoFormValidator.lowercase('aBc'), 'Must be in lowercase');
    });

    test('uppercase validation', () {
      expect(AutoFormValidator.uppercase('ABC'), null);
      expect(AutoFormValidator.uppercase('ABc'), 'Must be in uppercase');
    });

    test('contains validation', () {
      expect(AutoFormValidator.contains('hello world', 'world'), null);
      expect(
        AutoFormValidator.contains('hello world', 'dart'),
        'Must contain "dart"',
      );
    });

    test('hexColor validation', () {
      expect(AutoFormValidator.hexColor('#FFF'), null);
      expect(AutoFormValidator.hexColor('#FFFFFF'), null);
      expect(AutoFormValidator.hexColor('FFF'), null);
      expect(
        AutoFormValidator.hexColor('#ZZZ'),
        'Please enter a valid hex color code',
      );
    });

    test('creditCard validation', () {
      // 49927398716 is a valid luhn number commonly used in tests
      expect(AutoFormValidator.creditCard('49927398716'), null);
      expect(AutoFormValidator.creditCard('4992 7398 716'), null);
      expect(
        AutoFormValidator.creditCard('1234567890123'),
        'Please enter a valid credit card number',
      ); // invalid luhn
    });

    test('ipAddress validation', () {
      expect(AutoFormValidator.ipAddress('192.168.1.1'), null);
      expect(
        AutoFormValidator.ipAddress('2001:0db8:85a3:0000:0000:8a2e:0370:7334'),
        null,
      );
      expect(AutoFormValidator.ipAddress('::1'), null);
      expect(
        AutoFormValidator.ipAddress('256.1.1.1'),
        'Please enter a valid IP address',
      ); // invalid ipv4
    });

    test('date validation', () {
      expect(AutoFormValidator.date('2023-10-15'), null);
      expect(AutoFormValidator.date('2023-13-15'), 'Invalid month');
      expect(AutoFormValidator.date('2023-10-32'), 'Invalid day');
      expect(
        AutoFormValidator.date('10/15/2023'),
        'Please enter a valid date (YYYY-MM-DD)',
      );
    });

    test('macAddress validation', () {
      expect(AutoFormValidator.macAddress('00:1B:44:11:3A:B7'), null);
      expect(AutoFormValidator.macAddress('00-1B-44-11-3A-B7'), null);
      expect(
        AutoFormValidator.macAddress('invalid'),
        'Please enter a valid MAC address',
      );
    });

    test('uuid validation', () {
      expect(
        AutoFormValidator.uuid('123e4567-e89b-12d3-a456-426614174000'),
        null,
      );
      expect(AutoFormValidator.uuid('invalid'), 'Please enter a valid UUID');
    });

    test('base64 validation', () {
      expect(AutoFormValidator.base64('SGVsbG8gV29ybGQ='), null);
      expect(
        AutoFormValidator.base64('invalid!'),
        'Please enter a valid Base64 string',
      );
    });

    test('json validation', () {
      expect(AutoFormValidator.json('{"key": "value"}'), null);
      expect(
        AutoFormValidator.json('invalid'),
        'Please enter a valid JSON string',
      );
    });

    test('inList validation', () {
      expect(AutoFormValidator.inList('apple', ['apple', 'banana']), null);
      expect(
        AutoFormValidator.inList('orange', ['apple', 'banana']),
        'Invalid value selected',
      );
    });

    test('notInList validation', () {
      expect(AutoFormValidator.notInList('orange', ['apple', 'banana']), null);
      expect(
        AutoFormValidator.notInList('apple', ['apple', 'banana']),
        'This value is not allowed',
      );
    });

    test('startsWith validation', () {
      expect(AutoFormValidator.startsWith('hello world', 'hello'), null);
      expect(
        AutoFormValidator.startsWith('hello world', 'world'),
        'Must start with "world"',
      );
    });

    test('endsWith validation', () {
      expect(AutoFormValidator.endsWith('hello world', 'world'), null);
      expect(
        AutoFormValidator.endsWith('hello world', 'hello'),
        'Must end with "hello"',
      );
    });

    test('hasUppercase validation', () {
      expect(AutoFormValidator.hasUppercase('hello World'), null);
      expect(
        AutoFormValidator.hasUppercase('hello world'),
        'Must contain at least one uppercase letter',
      );
    });

    test('hasLowercase validation', () {
      expect(AutoFormValidator.hasLowercase('HELLO wORLD'), null);
      expect(
        AutoFormValidator.hasLowercase('HELLO WORLD'),
        'Must contain at least one lowercase letter',
      );
    });

    test('hasNumber validation', () {
      expect(AutoFormValidator.hasNumber('hello 1 world'), null);
      expect(
        AutoFormValidator.hasNumber('hello world'),
        'Must contain at least one number',
      );
    });

    test('hasSpecialCharacter validation', () {
      expect(AutoFormValidator.hasSpecialCharacter('hello!world'), null);
      expect(
        AutoFormValidator.hasSpecialCharacter('helloworld'),
        'Must contain at least one special character',
      );
    });

    test('slug validation', () {
      expect(AutoFormValidator.slug('my-awesome-slug'), null);
      expect(
        AutoFormValidator.slug('invalid_slug!'),
        'Please enter a valid slug (e.g., my-url-slug)',
      );
    });

    test('boolean validation', () {
      expect(AutoFormValidator.boolean('true'), null);
      expect(AutoFormValidator.boolean('False'), null);
      expect(
        AutoFormValidator.boolean('yes'),
        'Please enter a valid boolean (true or false)',
      );
    });

    test('match validation', () {
      expect(AutoFormValidator.match('password', 'password'), null);
      expect(
        AutoFormValidator.match('password', 'different'),
        'Values do not match',
      );
    });

    test('custom validation', () {
      expect(AutoFormValidator.custom('value', (v) => v == 'value'), null);
      expect(
        AutoFormValidator.custom('value', (v) => v == 'other'),
        'Invalid input',
      );
    });

    testWidgets('compose validation and focus node', (
      WidgetTester tester,
    ) async {
      final focusNode = FocusNode();
      final validator = AutoFormValidator.compose([
        (val) => AutoFormValidator.required(val),
        (val) => AutoFormValidator.email(val),
      ], focusNode: focusNode);

      expect(validator(null), 'This field is required');
      expect(validator(''), 'This field is required');
      expect(validator('invalid'), 'Please enter a valid email address');
      expect(validator('test@example.com'), null);
    });
  });
}
