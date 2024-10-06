import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:products_repository/products_repository.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/common_network_check/firestore_provider.dart';
import 'package:shoppingapp/routes/routes.dart';
import 'package:user_repository/user_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      name: 'db2',
      options: const FirebaseOptions(
          apiKey: "AIzaSyDFPTw8FdvE7HmhVjQU3RNcdE49z3LMHUA",
          authDomain: "wastewise-7b983.firebaseapp.com",
          projectId: "wastewise-7b983",
          storageBucket: "wastewise-7b983.appspot.com",
          messagingSenderId: "951086348501",
          appId: "1:951086348501:web:c1f2244bfb584886ef8a5c"),
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
