// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'core/router/app_router.dart';
// import 'core/theme/app_theme.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Hive.initFlutter();
//   // TODO: register Hive adapters if/when needed.
//   runApp(const MiniSocialApp());
// }

// class MiniSocialApp extends StatelessWidget {
//   const MiniSocialApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final router = AppRouter.router;
//     return MaterialApp.router(
//       title: 'Mini Social Feed',
//       theme: AppTheme.light,
//       darkTheme: AppTheme.dark,
//       themeMode: ThemeMode.system,
//       routerConfig: router,
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mini_social_feed_starter/core/router/app_router.dart';
import 'package:mini_social_feed_starter/core/theme/app_theme.dart';
import 'package:mini_social_feed_starter/core/theme/theme_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Open a small settings box to remember theme choice
  final settings = await Hive.openBox('settingsBox');
  final initialMode = ThemeCubit.readInitial(settings);

  runApp(
    BlocProvider(
      create: (_) => ThemeCubit(settings, initialMode),
      child: const MiniSocialApp(),
    ),
  );
}

class MiniSocialApp extends StatelessWidget {
  const MiniSocialApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.router;

    // Rebuild MaterialApp when theme mode changes
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, mode) {
        return MaterialApp.router(
          title: 'Mini Social Feed',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: mode,
          routerConfig: router,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
