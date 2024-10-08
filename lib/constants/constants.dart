import 'package:flutter_dotenv/flutter_dotenv.dart';

final String dbName = dotenv.env['DB_NAME'] ?? '';
final String apiKey = dotenv.env['API_KEY'] ?? '';
final String authDomain = dotenv.env['AUTH_DOMAIN'] ?? '';
final String projectId = dotenv.env['PROJECT_ID'] ?? '';
final String storageBucket = dotenv.env['STORAGE_BUCKET'] ?? '';
final String messagingSenderId = dotenv.env['MESSAGING_SENDER_ID'] ?? '';
final String appId = dotenv.env['APP_ID'] ?? '';
