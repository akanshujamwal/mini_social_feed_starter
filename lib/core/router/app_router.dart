import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/feed/presentation/pages/feed_page.dart';
import '../../features/feed/presentation/pages/profile_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: 'feed',
        builder: (BuildContext context, GoRouterState state) =>
            const FeedPage(),
        routes: [
          GoRoute(
            path: 'profile/:userId',
            name: 'profile',
            builder: (context, state) {
              final userId =
                  int.tryParse(state.pathParameters['userId'] ?? '') ?? 0;
              return ProfilePage(userId: userId);
            },
          ),
        ],
      ),
    ],
  );
}
