import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guitar_app/firebase_auth_services.dart';
import 'package:guitar_app/login_screen.dart';
import 'package:guitar_app/placeholder.dart';
import 'package:guitar_app/search_screen.dart';
import 'package:guitar_app/register_screen.dart';
import 'package:guitar_app/scaffold_nested.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'main.dart';
import 'auth_notfier.dart';

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
      /**
       * Your Redirection Logic Code  Here..........
       */
      final isAuthenticated = authController.isLoggedIn;

      /// [state.fullPath] will give current  route Path

      if (state.fullPath == '/login') {
        return isAuthenticated ? '/search' : null;
      }

      /// null redirects to Initial Location

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
                    path: 'details',
                    name: 'Search details',
                    pageBuilder: (context, state) => CustomTransitionPage<void>(
                      key: state.pageKey,
                      child: SearchScreen(content: "Search detail content"),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                              FadeTransition(opacity: animation, child: child),
                    ),
                  ),
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
                    PlaceholderScreen(content: "base add_song screen"),
                routes: [
                  GoRoute(
                    path: "details",
                    name: "add_song details",
                    pageBuilder: (context, state) {
                      return CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: PlaceholderScreen(
                            content: "Add_song detail sub-screen"),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) =>
                            FadeTransition(opacity: animation, child: child),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfile,
            routes: <RouteBase>[
              GoRoute(
                path: "/profile",
                name: "Profile",
                builder: (BuildContext context, GoRouterState state) =>
                    PlaceholderScreen(content: "base profile screen"),
                routes: [
                  GoRoute(
                    path: "details", // this gets display in the url
                    name:
                        "profile_details", // this is what can be used in context.goNamed()
                    pageBuilder: (context, state) {
                      return CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: PlaceholderScreen(
                            content: "Profile detail sub-screen"),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) =>
                            FadeTransition(opacity: animation, child: child),
                      );
                    },
                  ),
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
                    PlaceholderScreen(content: "base settings screen"),
                routes: [
                  GoRoute(
                    path: "details",
                    name: "details",
                    pageBuilder: (context, state) {
                      return CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: PlaceholderScreen(
                            content: "Settings detail sub-screen"),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) =>
                            FadeTransition(opacity: animation, child: child),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      /// Player
      // GoRoute(
      //   parentNavigatorKey: _rootNavigatorKey,
      //   path: '/player',
      //   name: "Player",
      //   builder: (context, state) => PlayerView(
      //     key: state.pageKey,
      //   ),
      // )
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
        builder: (context, state) => RegisterScreen(),
      )
    ],
  );
});
