import 'package:bathroom_vision/core/api/api_client.dart';
import 'package:bathroom_vision/core/storage/secure_storage.dart';
import 'package:bathroom_vision/features/auth/data/auth_api.dart';
import 'package:bathroom_vision/features/auth/data/auth_repository.dart';
import 'package:bathroom_vision/features/auth/presentation/auth_provider.dart';
import 'package:bathroom_vision/features/auth/presentation/login_page.dart';
import 'package:bathroom_vision/features/blocks/data/block_api.dart';
import 'package:bathroom_vision/features/blocks/data/block_repository.dart';
import 'package:bathroom_vision/features/blocks/presentation/blocks_provider.dart';
import 'package:bathroom_vision/shared/views/navegacion_page.dart'; // 👈 IMPORTAR NavigacionPage
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await dotenv.load(fileName: ".env");

  final storage = SecureStorage();
  final apiClient = ApiClient(storage);

  final authApi = AuthApi(apiClient);
  final authRepository = AuthRepository(authApi, storage);

  final blockApi = BlockApi(apiClient);
  final blockRepository = BlockRepository(blockApi);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authRepository)),
        ChangeNotifierProvider(create: (_) => BlocksProvider(blockRepository)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bañovisión',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
      ),
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/navegacion': (context) => const NavigacionPage(),
        '/inicio': (context) => const PlaceholderPage(title: 'Inicio'),
        '/banos-disponibles': (context) => const PlaceholderPage(title: 'Baños disponibles'),
        '/horarios-limpiezas': (context) => const PlaceholderPage(title: 'Horarios de Limpiezas'),
        '/mantenimientos': (context) => const PlaceholderPage(title: 'Mantenimientos'),
        '/incidencias': (context) => const PlaceholderPage(title: 'Incidencias'),
      },
    );
  }
}

// Página placeholder para las rutas
class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF8FD99F),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Esta página está en construcción',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}