import 'package:cargaapp_mobile/backend/services/api.dart';
import 'package:cargaapp_mobile/backend/services/app_service.dart';
import 'package:cargaapp_mobile/backend/services/auth_service.dart';
import 'package:cargaapp_mobile/backend/services/equipment_service.dart';
import 'package:cargaapp_mobile/backend/services/load_service.dart';
import 'package:cargaapp_mobile/backend/services/subscription_service.dart';
import 'package:cargaapp_mobile/routes/routes.dart';
import 'package:cargaapp_mobile/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await PushNotificationService.initializeApp();
  await Supabase.initialize(
    url: 'https://jxdroaxdrmeurapnjmdb.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp4ZHJvYXhkcm1ldXJhcG5qbWRiIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTYyODQwODMsImV4cCI6MjAxMTg2MDA4M30.j19y7ITd8Iz3Kp1cANt429fzTivLO08q2pOJwQlY4Qc',
  );

  return runApp(const AppState());
}

// final supabase = Supabase.instance.client;

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => API()),
        ChangeNotifierProvider(create: (_) => AppService()),
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => LoadService()),
        ChangeNotifierProvider(create: (_) => EquipmentService()),
        ChangeNotifierProvider(create: (_) => SubscriptionService()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();

    //
    // PushNotificationService.messagesStream.listen(
    //   (message) {
    //     log(message.toString());
    //     if (message['ruta'] == 'profesor') {
    //       // navegar a la pantalla profesor
    //     }
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carga App',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.initialRoute,
      routes: AppRoutes.routes,
      theme: AppTheme.lightTheme,
    );
  }
}
