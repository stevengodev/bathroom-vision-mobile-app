import 'package:bathroom_vision/core/api/api_client.dart';
import 'package:bathroom_vision/core/storage/secure_storage.dart';
import 'package:bathroom_vision/features/auth/data/auth_api.dart';
import 'package:bathroom_vision/features/auth/data/auth_repository.dart';
import 'package:bathroom_vision/features/auth/data/user_api.dart';
import 'package:bathroom_vision/features/auth/data/user_repository.dart';
import 'package:bathroom_vision/features/auth/presentation/auth_provider.dart';
import 'package:bathroom_vision/features/auth/presentation/login_page.dart';
import 'package:bathroom_vision/features/auth/presentation/register_page.dart';
import 'package:bathroom_vision/features/auth/presentation/user_profile_page.dart';
import 'package:bathroom_vision/features/auth/presentation/user_provider.dart';
import 'package:bathroom_vision/features/bathrooms/data/bathroom_api.dart';
import 'package:bathroom_vision/features/bathrooms/data/bathroom_repository.dart';
import 'package:bathroom_vision/features/bathrooms/presentation/bathroom_provider.dart';
import 'package:bathroom_vision/features/blocks/data/block_api.dart';
import 'package:bathroom_vision/features/blocks/data/block_repository.dart';
import 'package:bathroom_vision/features/blocks/presentation/blocks_page.dart';
import 'package:bathroom_vision/features/blocks/presentation/blocks_provider.dart';
import 'package:bathroom_vision/features/cleanings/data/cleaning_schedule_api.dart';
import 'package:bathroom_vision/features/cleanings/data/cleaning_schedule_repository.dart';
import 'package:bathroom_vision/features/cleanings/presentation/cleaning_schedule_form_page.dart';
import 'package:bathroom_vision/features/cleanings/presentation/cleaning_schedule_provider.dart';
import 'package:bathroom_vision/features/cleanings/presentation/my_cleaning_schedules_page.dart';
import 'package:bathroom_vision/features/incidents/data/incident_api.dart';
import 'package:bathroom_vision/features/incidents/data/incident_repository.dart';
import 'package:bathroom_vision/features/incidents/presentation/incident_provider.dart';
import 'package:bathroom_vision/features/incidents/presentation/pending_incidents_page.dart';
import 'package:bathroom_vision/shared/views/navigation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('es', null);

  await dotenv.load(fileName: ".env");

  final storage = SecureStorage();
  final apiClient = ApiClient(storage);

  final authApi = AuthApi(apiClient);
  final authRepository = AuthRepository(authApi, storage);

  final blockApi = BlockApi(apiClient);
  final blockRepository = BlockRepository(blockApi);

  final BathroomApi bathroomApi = BathroomApi(apiClient);
  final bathroomRepository = BathroomRepository(bathroomApi);

  final IncidentApi incidentApi = IncidentApi(apiClient);
  final incidentRepository = IncidentRepository(incidentApi);

  final CleaningScheduleApi cleaningScheduleApi = CleaningScheduleApi(apiClient);
  final cleaningScheduleRepository = CleaningScheduleRepository(cleaningScheduleApi);

  final userApi = UserApi(apiClient);
  final userRepository = UserRepository(userApi);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authRepository)),
        ChangeNotifierProvider(create: (_) => UserProvider(userRepository)),
        ChangeNotifierProvider(create: (_) => BlocksProvider(blockRepository)),
        ChangeNotifierProvider(create: (_) => BathroomProvider(bathroomRepository)),
        ChangeNotifierProvider(create: (_) => IncidentProvider(incidentRepository)),
        ChangeNotifierProvider(create: (_) => CleaningScheduleProvider(cleaningScheduleRepository)),
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
      theme: ThemeData(primarySwatch: Colors.green, fontFamily: 'Roboto'),
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/navegacion': (context) => const NavigationPage(),
        '/inicio': (context) => const PlaceholderPage(title: 'Inicio'),
        '/banos-disponibles': (context) =>
            const PlaceholderPage(title: 'Baños disponibles'),
        '/horarios-limpiezas': (context) =>
            const CleaningScheduleFormPage(),
        '/horarios-limpiezas/me': (context) =>
            const WeeklySchedulePage(),
        '/mantenimientos': (context) =>
            const PlaceholderPage(title: 'Mantenimientos'),
        '/incidencias': (context) =>
            const PendingIncidentsPage(),
        '/blocks': (context) => const BlocksPage(),
        '/user-profile': (context) => const UserProfilePage(),
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
            Icon(Icons.construction, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Esta página está en construcción',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
