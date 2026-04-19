import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/enums/role.dart';
import '../models/user_response.dart';
import '../models/user_request.dart';
import 'user_provider.dart';

class RegisterUser extends StatefulWidget {
  final UserResponse? user;

  const RegisterUser({super.key, this.user});

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  Role? selectedRole;

  bool obscurePassword = true;

  bool get isEdit => widget.user != null;

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.user?.name ?? '');
    emailController =
        TextEditingController(text: widget.user?.email ?? '');

    passwordController = TextEditingController(
      text: isEdit ? '********' : '',
    );

    selectedRole = widget.user != null
        ? Role.values.firstWhere(
            (r) => r.name == widget.user!.role,
          )
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isEdit ? 'Editar Usuario' : 'Registrar Usuario',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.isEmpty
                      ? 'Ingrese nombre'
                      : null,
            ),

            const SizedBox(height: 12),

            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.isEmpty
                      ? 'Ingrese email'
                      : null,
            ),

            const SizedBox(height: 12),

            Column(
              children: [
                TextFormField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  readOnly: isEdit, 
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: const OutlineInputBorder(),

                    suffixIcon: IconButton(
                      icon: Icon(
                          isEdit
                              ? (obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility)
                              : (obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                          color: isEdit ? Colors.grey : null,
                        ),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (!isEdit) {
                      if (value == null || value.length < 6) {
                        return 'Mínimo 6 caracteres';
                      }
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),

              ],
            ),

            DropdownButtonFormField<Role>(
              value: selectedRole,
              decoration: const InputDecoration(
                labelText: 'Rol',
                border: OutlineInputBorder(),
              ),
              items: Role.values
                  .where((role) => role != Role.ADMIN) 
                  .map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(role.displayName),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedRole = value;
                });
              },
              validator: (value) =>
                  value == null ? 'Seleccione un rol' : null,
            ),

            const SizedBox(height: 16),

            provider.loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final name = nameController.text;
                        final email = emailController.text;
                        final role = selectedRole!;

                        try {
                          if (isEdit) {
                            
                            final request = UserRequest(
                              name: name,
                              email: email,
                              password: null, 
                              role: role,
                            );

                            await context
                                .read<UserProvider>()
                                .updateUser(
                                  id: widget.user!.id,
                                  request: request,
                                );
                          } else {
                            
                            final password =
                                passwordController.text;

                            await context
                                .read<UserProvider>()
                                .registerUser(
                                  name,
                                  email,
                                  password,
                                  role.name,
                                );
                          }

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isEdit
                                  ? 'Usuario actualizado'
                                  : 'Usuario creado correctamente'),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: $e'),
                            ),
                          );
                        }
                      }
                    },
                    child: Text(isEdit ? 'Actualizar' : 'Guardar'),
                  ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}