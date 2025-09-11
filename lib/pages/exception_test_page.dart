import 'package:flutter/material.dart';
import 'package:presence_app/core/exceptions/app_exception.dart';
import 'package:presence_app/core/handlers/exception_handler.dart';

class ExceptionTestPage extends StatelessWidget {
  void _triggerException(Function thrower) {
    try {
      thrower();
    } catch (e, s) {
      ExceptionHandler.handleException(
        e,
        stackTrace: s,
        context: "ExceptionTestPage",
      );
    }
  }

  const ExceptionTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Exception Handler Test")),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Text(
                'Press a button to trigger an exception and test the global hanlder. Check the console for logs and observe the dialog',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () =>
                    _triggerException(() => throw NetworkException()),
                child: const Text('Trigger NetworkException'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _triggerException(() => throw AuthException()),
                child: const Text('Trigger AuthException'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () =>
                    _triggerException(() => throw ValidationException()),
                child: const Text('Trigger ValidationException'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _triggerException(() => throw ApiException()),
                child: const Text('Trigger ApiException'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => _triggerException(
                  () => throw AppException('A Custom app error occurred'),
                ),
                child: const Text('Trigger generic AppException'),
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[100],
                ),
                onPressed: () => _triggerException(() {
                  final list = [];
                  print(list[1]);
                }),
                child: const Text("Trigger RangeError"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
