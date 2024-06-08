import 'package:cornfield/splash.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async {
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyCW0pDnZEMAyjBxqwDgcRE-mMpkJzGSt_s',
      appId: '1:624974883878:android:7589486860f06f8a4e0ae7',
      messagingSenderId: '624974883878',
      projectId: 'cornfield-f722a',
      storageBucket: 'cornfield-f722a.appspot.com',
    )
);
runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF008000)),
        useMaterial3: true,
      ),
      home:const Splash(),
    );
  }
}
