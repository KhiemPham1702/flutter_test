import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_flutter/providers/auth_provider.dart';

class StartScreen extends ConsumerWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authProvider.notifier);
    return Scaffold(
      body: Center(
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: ElevatedButton.icon(
              onPressed: () async {
                await auth.signInWithGoogle();
              },
              icon: Image.asset(
                'assets/icons_google.png',
                height: 24.0,
                width: 24.0,
              ),
              label: const Text('Sign in with Google'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                side: const BorderSide(color: Colors.blue, width: 2.0),
              ).copyWith(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (states) {
                    if (states.contains(MaterialState.hovered)) {
                      return Colors.blue.shade700;
                    }
                    return Colors.white;
                  },
                ),
              )),
        ),
      ),
    );
  }
}
