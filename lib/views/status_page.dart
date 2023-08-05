import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'auth/login_page.dart';





class StatusPage extends ConsumerWidget {

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        body: Consumer(
            builder: (context, ref, child) {
             final authData = ref.watch(authProvider);
             return authData.user == null ? LoginPage() : LoginPage();
            }
        )
    );
  }
}