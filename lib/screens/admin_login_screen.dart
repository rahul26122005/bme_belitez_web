import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/theme.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});
  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool loading = false;

  @override
  void dispose() { email.dispose(); password.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppTheme.lightBg,
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: const BorderSide(color: AppTheme.border)),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const CircleAvatar(radius: 30, backgroundColor: AppTheme.navy,
                  child: Icon(Icons.admin_panel_settings_outlined, color: AppTheme.teal, size: 32)),
                const SizedBox(height: 18),
                const Text('ADMINISTRATION', style: TextStyle(color: AppTheme.teal, fontWeight: FontWeight.w900, letterSpacing: 2)),
                const SizedBox(height: 8),
                const Text('Admin Login', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
                const SizedBox(height: 22),
                TextField(controller: email, keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined))),
                const SizedBox(height: 14),
                TextField(controller: password, obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline))),
                const SizedBox(height: 20),
                SizedBox(width: double.infinity, child: FilledButton(
                  onPressed: loading ? null : _login,
                  style: FilledButton.styleFrom(backgroundColor: AppTheme.teal, foregroundColor: AppTheme.dark,
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: loading ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Login', style: TextStyle(fontWeight: FontWeight.w900)),
                )),
                const SizedBox(height: 10),
                TextButton(onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                  child: const Text('Back to website')),
              ]),
            ),
          ),
        ),
      ),
    ),
  );

  Future<void> _login() async {
    if (email.text.trim().isEmpty || password.text.isEmpty) {
      _msg('Enter email and password.', error: true); return;
    }
    setState(() => loading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(), password: password.text);
      if (mounted) Navigator.pushReplacementNamed(context, '/admin');
    } on FirebaseAuthException catch (e) {
      if (mounted) _msg(e.message ?? 'Login failed.', error: true);
    } catch (e) {
      if (mounted) _msg(e.toString(), error: true);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void _msg(String m, {bool error = false}) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(m), backgroundColor: error ? Colors.red.shade700 : Colors.green.shade700));
}
