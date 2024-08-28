import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_flutter/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    final auth = ref.read(authProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(user?.photoURL ?? ''),
            ),
            const SizedBox(height: 10),
            Text(user?.displayName ?? '', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text(user?.email ?? ''),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await auth.signOut();
              },
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}