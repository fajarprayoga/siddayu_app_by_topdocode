import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Route {
  static GoRoute set(String path, Widget Function(GoRouterState state) builder,
      {FutureOr<String?> Function(GoRouterState)? redirect,
      List<RouteBase> routes = const []}) {
    return GoRoute(
        path: path,
        builder: (BuildContext context, GoRouterState state) => builder(state),
        redirect: (_, GoRouterState state) => redirect?.call(state),
        routes: routes);
  }
}
