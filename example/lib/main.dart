import 'package:flutter/material.dart';
import 'package:auto_form_validator/auto_form_validator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auto Form Validator Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FormValidatorExample(),
    );
  }
}

class FormValidatorExample extends StatefulWidget {
  const FormValidatorExample({super.key});

  @override
  State<FormValidatorExample> createState() => _FormValidatorExampleState();
}

class _FormValidatorExampleState extends State<FormValidatorExample> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  // Define FocusNodes for fields you want to auto-scroll to on error
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();
  final _ageFocus = FocusNode();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form successfully validated!')),
      );
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _ageFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auto Form Validator Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                focusNode: _nameFocus,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter your full name',
                ),
                validator: AutoFormValidator.compose([
                  (val) => AutoFormValidator.required(
                    val,
                    message: 'Name is required',
                  ),
                  (val) => AutoFormValidator.alphabetic(
                    val,
                    message: 'Name should contain only letters',
                  ),
                ], focusNode: _nameFocus),
              ),
              const SizedBox(height: 16),
              TextFormField(
                focusNode: _emailFocus,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email address',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: AutoFormValidator.compose([
                  (val) => AutoFormValidator.required(
                    val,
                    message: 'Email is required',
                  ),
                  (val) => AutoFormValidator.email(val),
                ], focusNode: _emailFocus),
              ),
              const SizedBox(height: 16),
              TextFormField(
                focusNode: _phoneFocus,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Enter your phone number',
                ),
                keyboardType: TextInputType.phone,
                validator: AutoFormValidator.compose([
                  (val) => AutoFormValidator.required(
                    val,
                    message: 'Phone is required',
                  ),
                  (val) => AutoFormValidator.phone(val),
                ], focusNode: _phoneFocus),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                focusNode: _passwordFocus,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                ),
                obscureText: true,
                validator: AutoFormValidator.compose([
                  (val) => AutoFormValidator.required(
                    val,
                    message: 'Password is required',
                  ),
                  (val) => AutoFormValidator.password(val),
                ], focusNode: _passwordFocus),
              ),
              const SizedBox(height: 16),
              TextFormField(
                focusNode: _confirmPasswordFocus,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  hintText: 'Re-enter your password',
                ),
                obscureText: true,
                validator: AutoFormValidator.compose([
                  (val) => AutoFormValidator.required(
                    val,
                    message: 'Please confirm your password',
                  ),
                  (val) => AutoFormValidator.match(
                    val,
                    _passwordController.text,
                    message: 'Passwords do not match',
                  ),
                ], focusNode: _confirmPasswordFocus),
              ),
              const SizedBox(height: 16),
              TextFormField(
                focusNode: _ageFocus,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  hintText: 'Enter your age',
                ),
                keyboardType: TextInputType.number,
                validator: AutoFormValidator.compose([
                  (val) => AutoFormValidator.required(val),
                  (val) => AutoFormValidator.numeric(val),
                  (val) => AutoFormValidator.custom(
                    val,
                    (v) =>
                        v != null &&
                        int.tryParse(v) != null &&
                        int.parse(v) >= 18,
                    message: 'Must be 18 or older',
                  ),
                ], focusNode: _ageFocus),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
