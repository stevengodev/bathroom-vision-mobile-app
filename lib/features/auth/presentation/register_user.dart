import 'package:bathroom_vision/features/auth/models/user_request.dart';
import 'package:bathroom_vision/features/auth/models/user_response.dart';
import 'package:bathroom_vision/shared/enums/role.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;

  Role? selectedRole;

  bool obscurePassword = true;
  bool resetPassword = false;

  bool get isEdit => widget.user != null;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.user?.name ?? '');
    emailController = TextEditingController(text: widget.user?.email ?? '');
    passwordController = TextEditingController();

    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    selectedRole = widget.user != null
        ? Role.values.firstWhere((r) => r.name == widget.user!.role)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar Usuario' : 'Nuevo Usuario'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Ingrese nombre' : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Ingrese email' : null,
              ),

              const SizedBox(height: 12),

              if (!isEdit) ...[
                TextFormField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (v) =>
                      v!.length < 6 ? 'Mínimo 6 caracteres' : null,
                ),
              ] else ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '****************',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),

                const SizedBox(height: 8),

                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      resetPassword = !resetPassword;
                    });
                  },
                  icon: const Icon(Icons.lock_reset),
                  label: Text(resetPassword
                      ? 'Cancelar cambio'
                      : 'Restablecer contraseña'),
                ),

                if (resetPassword) ...[
                  TextFormField(
                    controller: newPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Nueva contraseña',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if (resetPassword && v!.length < 6) {
                        return 'Mínimo 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirmar contraseña',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if (resetPassword &&
                          v != newPasswordController.text) {
                        return 'No coinciden';
                      }
                      return null;
                    },
                  ),
                ]
              ],

              const SizedBox(height: 12),

              DropdownButtonFormField<Role>(
                initialValue: selectedRole,
                decoration: const InputDecoration(
                  labelText: 'Rol',
                  border: OutlineInputBorder(),
                ),
                items: Role.values
                    .where((r) => r != Role.ADMIN)
                    .map((role) => DropdownMenuItem(
                          value: role,
                          child: Text(role.displayName),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => selectedRole = v),
                validator: (v) => v == null ? 'Seleccione rol' : null,
              ),

              const SizedBox(height: 20),

              provider.loading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submit,
                        child: Text(isEdit ? 'Actualizar' : 'Guardar'),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<UserProvider>();

    try {
      if (isEdit) {
        await provider.updateUser(
          id: widget.user!.id,
          request: UserRequest(
            name: nameController.text,
            email: emailController.text,
            password:
                resetPassword ? newPasswordController.text : null,
            role: selectedRole!,
          ),
        );
      } else {
        await provider.registerUser(
          nameController.text,
          emailController.text,
          passwordController.text,
          selectedRole!.name,
        );
      }

      Navigator.pop(context, true);

    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}