import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guitar_app/firebase_auth_services.dart';
import 'package:guitar_app/login_screen.dart';
import 'package:guitar_app/placeholder.dart';
import 'package:guitar_app/profile_screen.dart';
import 'package:guitar_app/register_screen.dart';
import 'package:guitar_app/scaffold_nested.dart';

class AppNavigation {
  AppNavigation._();
  // Private navigators
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorSearch =
      GlobalKey<NavigatorState>(debugLabel: 'shellSearch');
  static final _shellNavigatorAddSong =
      GlobalKey<NavigatorState>(debugLabel: 'shellAddSong');
  static final _shellNavigatorProfile =
      GlobalKey<NavigatorState>(debugLabel: 'shellProfile');
  static final _shellNavigatorSettings =
      GlobalKey<NavigatorState>(debugLabel: 'shellSettings');

  // GoRouter configuration
  static final GoRouter router = GoRouter(
    initialLocation: "/search",
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
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
                    PlaceholderScreen(content: "base search content"),
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
                      child:
                          PlaceholderScreen(content: "Search detail content"),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                              FadeTransition(opacity: animation, child: child),
                    ),
                  ),
                ],
                // redirect: (BuildContext context, GoRouterState state) {
                //   if (Auth().currentUser == null) {
                //     return '/login';
                //   } else {
                //     return null;
                //   }
                // },
              ),
            ],
          ),

          StatefulShellBranch(
            navigatorKey: AppNavigation._shellNavigatorAddSong,
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
            navigatorKey: AppNavigation._shellNavigatorProfile,
            routes: <RouteBase>[
              GoRoute(
                path: "/profile",
                builder: (context, state) => ProfileScreen(),
                routes: [
                  GoRoute(
                    path: ":id", // this gets display in the url
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
}
