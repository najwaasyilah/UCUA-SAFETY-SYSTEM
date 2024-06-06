import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final StreamController<RemoteMessage> _messageStreamController = StreamController<RemoteMessage>.broadcast();

  Stream<RemoteMessage> get messageStream => _messageStreamController.stream;

  Future<void> initialize() async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _messageStreamController.add(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('A new onMessageOpenedApp event was published!');
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    print("Handling a background message: ${message.messageId}");
  }

  Future<void> sendNotification(String formId, String message, String userRole) async {
    // Simulate sending notification
    final notification = RemoteNotification(
      title: 'Form $formId Update',
      body: 'Message: $message\nRole: $userRole',
    );

    final remoteMessage = RemoteMessage(
      notification: notification,
    );

    _messageStreamController.add(remoteMessage);
  }

  void dispose() {
    _messageStreamController.close();
  }
}
