import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authentication/splashscreen.dart';
import '../widgets/signupprovider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart'; // Import untuk mengatur orientasi

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Mengatur orientasi aplikasi hanya ke potret (portrait)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Potret normal
  ]);

  await initializeDateFormatting('id', null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignupFormProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
      },
      theme: ThemeData(
        fontFamily: 'Urbanist',
      ),
    );
  }
}
