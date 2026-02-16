import 'package:flutter/material.dart';

import '../../../core/widgets/no_network_widget.dart';

class NoInternetScreen extends StatelessWidget {
  static const String routePath = '/no-internet';

  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NoNetworkWidget(
      onRetry: () {
        Navigator.of(context).maybePop();
      },
    );
  }
}

