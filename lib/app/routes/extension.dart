import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension CustomRouteExtension<T extends Widget> on T {
  GoRoute route(String path,
      {FutureOr<String?> Function(BuildContext, GoRouterState)? redirect}) {
    return GoRoute(
        path: path,
        builder: (BuildContext context, GoRouterState state) {
          return this;
        },
        redirect: redirect);
  }
}
