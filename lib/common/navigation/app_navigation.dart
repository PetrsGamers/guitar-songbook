import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guitar_app/screens/create/create_song_screen.dart';
import 'package:guitar_app/screens/search/comment_screen.dart';
import 'package:guitar_app/screens/auth/login_screen.dart';
import 'package:guitar_app/screens/settings/settings_screen.dart';
import 'package:guitar_app/screens/search/search_screen.dart';
import 'package:guitar_app/screens//profile/profile_screen.dart';
import 'package:guitar_app/screens/auth/register_screen.dart';
import 'package:guitar_app/common/navigation/scaffold_nested.dart';
import 'package:guitar_app/screens/profile/widgets/user_created_screen.dart';
import 'package:guitar_app/screens/profile/widgets/user_favorites_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../main.dart';
import 'package:guitar_app/screens/search/search_screen_detail.dart';

// Private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorSearch =
    GlobalKey<NavigatorState>(debugLabel: 'shellSearch');
final _shellNavigatorAddSong =
    GlobalKey<NavigatorState>(debugLabel: 'shellAddSong');
final _shellNavigatorProfile =
    GlobalKey<NavigatorState>(debugLabel: 'shellProfile');
final _shellNavigatorSettings =
    GlobalKey<NavigatorState>(debugLabel: 'shellSettings');

// GoRouter configuration
final routerProvider = Provider<GoRouter>((ref) {
  final authController = ref.watch(authProvider);
  return GoRouter(
    initialLocation: "/login",
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    redirect: (context, state) {
      final isAuthenticated = authController.isLoggedIn;

      if (state.fullPath == '/login' || state.fullPath == '/register') {
        return isAuthenticated ? '/search' : null;
      }
      // null represents no redirect
      return isAuthenticated ? null : '/login';
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNestedNavigation(
            navigationShell: navigationShell,
          );
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSearch,
            routes: <RouteBase>[
              GoRoute(
                path: "/search",
                name: "Search",
                builder: (BuildContext context, GoRouterState state) =>
                    SearchScreen(content: "base search content"),
                routes: [
                  GoRoute(
                      // https://stackoverflow.com/questions/76783122
                      // this is very important, use this when you want to hide
                      // the navbar and make the screen "fullscreen"
                      parentNavigatorKey: _rootNavigatorKey,
                      path: ':id',
                      name: 'Search details',
                      pageBuilder: (context, state) =>
                          CustomTransitionPage<void>(
                            key: state.pageKey,
                            child: SearchScreenDetail(
                                songId: state.pathParameters["id"]),
                            transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) =>
                                FadeTransition(
                                    opacity: animation, child: child),
                          ),
                      routes: [
                        GoRoute(
                          parentNavigatorKey: _rootNavigatorKey,
                          path: 'comments',
                          name: 'Comments',
                          pageBuilder: (context, state) =>
                              CustomTransitionPage<void>(
                            key: state.pageKey,
                            child: CommentScreen(
                                songId: state.pathParameters["id"]),
                            transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) =>
                                FadeTransition(
                                    opacity: animation, child: child),
                          ),
                        ),
                      ]),
                ],
              ),
            ],
          ),

          StatefulShellBranch(
            navigatorKey: _shellNavigatorAddSong,
            routes: <RouteBase>[
              GoRoute(
                path: "/add_song",
                name: "Add song",
                builder: (BuildContext context, GoRouterState state) =>
                    const CreateSongScreen(),
              ),
            ],
          ),

          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfile,
            routes: <RouteBase>[
              GoRoute(
                path: "/profile",
                builder: (context, state) => ProfileScreen(),
                routes: [
                  GoRoute(
                      path: ":id", // this gets displayed in the url
                      name:
                          "profile_details", // this is what can be used in context.goNamed()
                      pageBuilder: (context, state) {
                        return CustomTransitionPage<void>(
                          key: state.pageKey,
                          child:
                              ProfileScreen(userId: state.pathParameters["id"]),
                          transitionsBuilder: (
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ) =>
                              FadeTransition(opacity: animation, child: child),
                        );
                      },
                      routes: [
                        GoRoute(
                            path: "favorites",
                            name: "favorites",
                            pageBuilder: (context, state) {
                              return CustomTransitionPage<void>(
                                key: state.pageKey,
                                child: FavoriteSongsScreen(
                                    userId: state.pathParameters["id"]),
                                transitionsBuilder: (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) =>
                                    FadeTransition(
                                        opacity: animation, child: child),
                              );
                            }),
                        GoRoute(
                            path: "created",
                            name: "created",
                            pageBuilder: (context, state) {
                              return CustomTransitionPage<void>(
                                key: state.pageKey,
                                child: CreatedSongsScreen(
                                    userId: state.pathParameters["id"]),
                                transitionsBuilder: (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) =>
                                    FadeTransition(
                                        opacity: animation, child: child),
                              );
                            }),
                      ]),
                ],
              ),
            ],
          ),

          /// Branch Setting
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSettings,
            routes: <RouteBase>[
              GoRoute(
                path: "/settings",
                name: "Settings",
                builder: (BuildContext context, GoRouterState state) =>
                    SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/login',
        name: "Login",
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/register',
        name: "Register",
        builder: (context, state) => const RegisterScreen(),
      )
    ],
  );
});
