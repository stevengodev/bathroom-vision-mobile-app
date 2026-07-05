import 'package:bathroom_vision/core/api/api_client.dart';
import 'package:bathroom_vision/core/storage/secure_storage.dart';

import 'package:bathroom_vision/features/auth/data/auth_api.dart';
import 'package:bathroom_vision/features/auth/data/auth_repository.dart';
import 'package:bathroom_vision/features/auth/data/user_api.dart';
import 'package:bathroom_vision/features/auth/data/user_repository.dart';

import 'package:bathroom_vision/features/auth/presentation/auth_provider.dart';
import 'package:bathroom_vision/features/auth/presentation/login_page.dart';
import 'package:bathroom_vision/features/auth/presentation/manage_user_page.dart';
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
import 'package:bathroom_vision/features/cleanings/presentation/cleaning_schedule_list_page.dart';
import 'package:bathroom_vision/features/cleanings/presentation/cleaning_schedule_provider.dart';
import 'package:bathroom_vision/features/cleanings/presentation/my_cleaning_schedules_page.dart';

import 'package:bathroom_vision/features/maintenances/data/maintenance_api.dart';
import 'package:bathroom_vision/features/maintenances/data/maintenance_repository.dart';
import 'package:bathroom_vision/features/maintenances/presentation/maintenance_provider.dart';
import 'package:bathroom_vision/features/maintenances/presentation/maintenance_list_page.dart';

import 'package:bathroom_vision/features/incidents/data/incident_api.dart';
import 'package:bathroom_vision/features/incidents/data/incident_repository.dart';
import 'package:bathroom_vision/features/incidents/presentation/incident_provider.dart';
import 'package:bathroom_vision/features/incidents/presentation/pending_incidents_page.dart';

import 'package:bathroom_vision/shared/views/navigation_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

// FIREBASE
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

// NOTIFICACIONES LOCALES
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'bathroom_channel',
  'Bathroom Notifications',
  description: 'Canal de notificaciones de Bañovisión',
  importance: Importance.max,
);

Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print("BACKGROUND MESSAGE");
  print(message.notification?.title);
  print(message.notification?.body);
}

Future<void> setupNotifications() async {

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // Config Android
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // Config general
  const InitializationSettings settings =
      InitializationSettings(
        android: androidSettings,
      );

  // Inicializar plugin
  await flutterLocalNotificationsPlugin.initialize(settings);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // FIREBASE
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // LOCAL NOTIFICATIONS
  await setupNotifications();

  // PERMISOS
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // TOPIC
  await FirebaseMessaging.instance.subscribeToTopic("bathrooms");

  print("Suscrito a bathrooms");

  // TOKEN
  final token = await FirebaseMessaging.instance.getToken();

  print("FCM TOKEN:");
  print(token);

  FirebaseMessaging.onBackgroundMessage(
    _firebaseBackgroundHandler,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {

    print("FOREGROUND MESSAGE");

    RemoteNotification? notification = message.notification;

    if (notification != null) {

      await flutterLocalNotificationsPlugin.show(
        notification.hashCode,

        notification.title ?? "Bañovisión",

        notification.body ?? "",

        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  });

  // CUANDO ABREN LA NOTIFICACIÓN
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("Usuario abrió la notificación");
  });

  await initializeDateFormatting('es', null);

  await dotenv.load(fileName: ".env");

  final storage = SecureStorage();
  final apiClient = ApiClient(storage);

  // APIs
  final authApi = AuthApi(apiClient);
  final userApi = UserApi(apiClient);

  // Repositories
  final authRepository = AuthRepository(authApi, storage);
  final userRepository = UserRepository(userApi, authApi);

  final blockRepository = BlockRepository(BlockApi(apiClient));

  final bathroomRepository =
      BathroomRepository(BathroomApi(apiClient));

  final incidentRepository =
      IncidentRepository(IncidentApi(apiClient));

  final cleaningScheduleRepository =
      CleaningScheduleRepository(
        CleaningScheduleApi(apiClient),
      );

  final maintenanceRepository =
      MaintenanceRepository(
        MaintenanceApi(apiClient),
      );

  runApp(
    MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (_) => AuthProvider(authRepository),
        ),

        ChangeNotifierProvider(
          create: (_) => UserProvider(userRepository),
        ),

        ChangeNotifierProvider(
          create: (_) => BlocksProvider(blockRepository),
        ),

        ChangeNotifierProvider(
          create: (_) => BathroomProvider(bathroomRepository),
        ),

        ChangeNotifierProvider(
          create: (_) => IncidentProvider(incidentRepository),
        ),

        ChangeNotifierProvider(
          create: (_) => CleaningScheduleProvider(
            cleaningScheduleRepository,
          ),
        ),

        ChangeNotifierProvider(
          create: (_) => MaintenanceProvider(
            maintenanceRepository,
          ),
        ),
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

        '/login': (_) => const LoginPage(),

        '/register': (_) => const RegisterPage(),

        '/navegacion': (_) => const NavigationPage(),

        '/inicio': (_) =>
            const PlaceholderPage(
              title: 'Inicio',
            ),

        '/banos-disponibles': (_) =>
            const PlaceholderPage(
              title: 'Baños disponibles',
            ),

        '/horarios-limpiezas': (_) =>
            const CleaningScheduleListPage(),

        '/horarios-limpiezas/me': (_) =>
            const WeeklySchedulePage(),

        '/mantenimientos': (_) =>
            const MaintenanceListPage(),

        '/incidencias': (_) =>
            const PendingIncidentsPage(),

        '/blocks': (_) =>
            const BlocksPage(),

        '/user-profile': (_) =>
            const UserProfilePage(),

        '/gestionar-usuarios': (_) =>
            const ManageUserPage(),
      },
    );
  }
}

class PlaceholderPage extends StatelessWidget {

  final String title;

  const PlaceholderPage({
    super.key,
    required this.title,
  });

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