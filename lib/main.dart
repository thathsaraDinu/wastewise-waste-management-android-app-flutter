import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:products_repository/products_repository.dart';
import 'package:provider/provider.dart';
import 'package:waste_wise/common_network_check/firestore_provider.dart';
import 'package:waste_wise/routes/routes.dart';
import 'package:user_repository/user_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:waste_wise/constants/constants.dart' as constants;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  if (kIsWeb) {
    await Firebase.initializeApp(
      name: constants.dbName,
      options: FirebaseOptions(
          apiKey: constants.apiKey,
          authDomain: constants.authDomain,
          projectId: constants.projectId,
          storageBucket: constants.storageBucket,
          messagingSenderId: constants.messagingSenderId,
          appId: constants.appId),
    );
  } else {
    await Firebase.initializeApp();
  }
  debugPaintSizeEnabled = false; // Optionally enable for debugging
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FirestoreProvider(),
        ),
        ChangeNotifierProvider<FirebaseUserRepo>(
          create: (context) => FirebaseUserRepo(),
        ),
        StreamProvider<MyUser>(
          create: (context) =>
              Provider.of<FirebaseUserRepo>(context, listen: false).user,
          initialData: MyUser.empty, // Default value if no user is logged in
        ),
        ChangeNotifierProvider(create: (_) => ProductService()),
        ChangeNotifierProvider(
          create: (_) => FirebaseCartRepo(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      routes: AppRoutes.getRoutes(),
      initialRoute: '/',
      title: 'WasteWise',
    );
  }
}
