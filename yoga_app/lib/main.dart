import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoga_app/core/di/injection.dart';
import 'package:yoga_app/core/theme/app_theme.dart';
import 'package:yoga_app/presentation/bloc/session/session_bloc.dart';
import 'package:yoga_app/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const SmartYogaMatApp());
}

class SmartYogaMatApp extends StatelessWidget {
  const SmartYogaMatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => getIt<SessionBloc>())],
      child: MaterialApp(
        title: 'Smart Yoga Mat',
        theme: AppTheme.lightTheme,
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
