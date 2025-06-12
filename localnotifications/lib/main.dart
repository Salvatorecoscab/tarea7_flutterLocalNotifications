import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Inicializa el plugin de notificaciones.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  // Asegura la inicialización de los widgets de Flutter.
  WidgetsFlutterBinding.ensureInitialized();

  // Configuración de inicialización para Android.
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher'); // Usa el ícono de la app.

  // Configuración de inicialización general.
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  // Inicializa el plugin con la configuración.
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notificaciones Locales',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const NotificationScreen(),
    );
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Controlador para el campo de texto.
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _requestNotificationPermissions();
  }

  // Solicita permisos para notificaciones en Android 13+.
  Future<void> _requestNotificationPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }
  }

  // Muestra la notificación.
  Future<void> _showNotification(String message) async {
    // Configuración de detalles de la notificación para Android.
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your_channel_id', // ID del canal.
      'your_channel_name', // Nombre del canal.
      channelDescription: 'your_channel_description', // Descripción del canal.
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    // Configuración general de la notificación.
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    // Muestra la notificación.
    await flutterLocalNotificationsPlugin.show(
      0, // ID de la notificación.
      'Notificación Local', // Título de la notificación.
      message, // Cuerpo de la notificación (mensaje del usuario).
      notificationDetails,
      payload: 'item x', // Datos adicionales opcionales.
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones Locales en Android'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Campo de texto para el mensaje.
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Escribe tu notificación',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // Botón para enviar la notificación.
            ElevatedButton(
              onPressed: () {
                if (_textController.text.isNotEmpty) {
                  _showNotification(_textController.text);
                }
              },
              child: const Text('Enviar Notificación'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}