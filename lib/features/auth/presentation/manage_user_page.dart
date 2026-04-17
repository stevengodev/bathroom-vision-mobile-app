import 'package:bathroom_vision/features/auth/presentation/user_list.dart';
import 'package:bathroom_vision/features/auth/presentation/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/enums/role.dart';

class ManageUserPage extends StatefulWidget {
  const ManageUserPage({super.key});

  @override
  State<ManageUserPage> createState() => _ManageUserPageState();
}

class _ManageUserPageState extends State<ManageUserPage> {

  @override
  void initState() {
    super.initState();

    // Llamada automática a la API
    Future.microtask(() {
      context.read<UserProvider>().loadUsersByRoles([
        Role.MAINTAINER,
        Role.CLEANER,
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Usuarios"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Builder(
          builder: (_) {

            if (provider.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.error != null) {
              return Center(
                child: Text("Error: ${provider.error}"),
              );
            }

            if (provider.users == null || provider.users!.isEmpty) {
              return const Center(
                child: Text("No hay usuarios"),
              );
            }

            return UserList(users: provider.users!);
          },
        ),
      ),
    );
  }
}