import 'package:bathroom_vision/features/auth/presentation/user_list.dart';
import 'package:bathroom_vision/features/auth/presentation/user_provider.dart';
import 'package:bathroom_vision/features/auth/presentation/register_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/enums/role.dart';

class ManageUserPage extends StatefulWidget {
  const ManageUserPage({super.key});

  @override
  State<ManageUserPage> createState() => _ManageUserPageState();
}

class _ManageUserPageState extends State<ManageUserPage> {

  final TextEditingController searchController = TextEditingController();
  String searchText = '';

  String normalize(String text) {
    return text
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u');
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<UserProvider>().loadUsersByRoles([
        Role.MAINTAINER,
        Role.CLEANER,
      ]);
    });

    searchController.addListener(() {
      setState(() {
        searchText = searchController.text.trim();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
        child: Column(
          children: [

            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, email o rol',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchText.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
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

                  final query = normalize(searchText);

                    final filteredUsers = provider.users!.where((user) {
                      final name = normalize(user.name);
                      final email = normalize(user.email);

                      final role = normalize(
                        Role.values
                            .firstWhere(
                              (r) => r.name == user.role,
                              orElse: () => Role.CLEANER,
                            )
                            .displayName,
                      );

                      return name.contains(query) ||
                          email.contains(query) ||
                          role.contains(query);
                    }).toList();

                  if (filteredUsers.isEmpty) {
                    return const Center(
                      child: Text("No se encontraron resultados"),
                    );
                  }

                  return UserList(users: filteredUsers);
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddUserModal(context);
        },
        child: const Icon(Icons.add),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _showAddUserModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: const RegisterUser(),
        );
      },
    );
  }

  void _showEditUserModal(BuildContext context, user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: RegisterUser(user: user),
        );
      },
    );
  }
}