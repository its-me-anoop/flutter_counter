import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_counter/counter/counter.dart';

/// A [StatelessWidget] which is responsible for providing a
/// [CounterCubit] instance to the [CounterView].
class CounterPage extends StatelessWidget {
  /// Counter Page
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: const CounterView(),
    );
  }
}
