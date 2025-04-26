import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seminari_flutter/provider/users_provider.dart';
import 'package:seminari_flutter/widgets/Layout.dart';
import '../models/user.dart';
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _guardarNovaContrasenya() async {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<UserProvider>(context, listen: false);

      await provider.editarUsuari(
      User(
        id: provider.registeredUser!.id,
        name: provider.registeredUser!.name,
        age: provider.registeredUser!.age,
        email: provider.registeredUser!.email,
        password: _confirmPasswordController.text,
      ),
    );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Contrasenya actualitzada correctament!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutWrapper(
      title: 'Canviar Contrasenya',
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: const Color.fromARGB(255, 175, 175, 175),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          'Actualitza la teva contrasenya',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: const Color.fromARGB(255, 175, 175, 175),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildPasswordField(
                              controller: _passwordController,
                              label: 'Nova Contrasenya',
                            ),
                            const SizedBox(height: 16),
                            _buildPasswordField(
                              controller: _confirmPasswordController,
                              label: 'Confirmar Contrasenya',
                              validator: (value) {
                                if (value != _passwordController.text) {
                                  return 'Les contrasenyes no coincideixen';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton.icon(
                              onPressed: _guardarNovaContrasenya,
                              icon: const Icon(Icons.save),
                              label: const Text(
                                'GUARDAR CANVIS',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color.fromARGB(221, 0, 0, 0),
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: const Icon(Icons.lock, color: Colors.deepPurple),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color.fromARGB(255, 224, 224, 224), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        ),
      ),
      obscureText: true,
      validator: validator ?? (value) {
        if (value == null || value.isEmpty) {
          return 'Cal omplir la contrasenya';
        }
        if (value.length < 6) {
          return 'Ha de tenir mínim 6 caràcters';
        }
        return null;
      },
    );
  }
}