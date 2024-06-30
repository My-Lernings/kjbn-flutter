import 'package:app/app/ui/splash/screen.dart';
import 'package:app/core/DI/di.dart';
import 'package:flutter/material.dart';
import 'package:app/app/truck_feature/domain/repos/FoodTruckRepository.dart';
import 'package:app/app/truck_feature/presentation/ui/map_view.dart';
import 'package:app/app/truck_feature/presentation/view_model.dart';
import 'package:app/core/DI/di.dart';
import 'package:provider/provider.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await setup();
  runApp(const MyApp());
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) =>
                TruckMapViewModel(repository: getIt<FoodTruckRepository>()))
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Food Francisco',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
