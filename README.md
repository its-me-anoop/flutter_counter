# flutter_counter

## Key Topics

- Observe state changes with ```BlocObserver```.
- ```BlocProvider```, Flutter widget which provides a bloc to its children.
- ```BlocBuilder```, Flutter widget that handles building the widget in response to new states.
- Using Cubit instead of Bloc. What's the difference?
- Adding events with ```context.read```.

## Setup

We'll start off by creating a brand new Flutter project.

```sh
flutter create flutter_counter
```

We can then go ahead and replace the contents of ```pubspec.yaml``` with

```yaml
name: flutter_counter
description: A new Flutter project.
version: 1.0.0+1
publish_to: none

environment:
  sdk: ">=2.17.0 <3.0.0"

dependencies:
  bloc: ^8.1.0
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.1

dev_dependencies:
  bloc_test: ^9.1.0
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  mocktail: ^0.3.0
  very_good_analysis: ^3.0.1

flutter:
  uses-material-design: true
```

and then install all of our dependencies.

```sh
flutter packages get
```

Replace contents of ```analysis_options.yaml``` with

```yaml
import 'package: very_good_analysis/very_good_analysis';
```

## Project Structure

```sh
├── lib
│   ├── app.dart
│   ├── counter
│   │   ├── counter.dart
│   │   ├── cubit
│   │   │   └── counter_cubit.dart
│   │   └── view
│   │       ├── counter_page.dart
│   │       └── counter_view.dart
│   ├── counter_observer.dart
│   └── main.dart
├── pubspec.lock
├── pubspec.yaml
```

The application uses a feature-driven directory structure. This project structure enables us to scale the project by having self-contained features. In this example we will only have a single feature (the counter itself) but in more complex applications we can have hundreds of different features.

## Bloc Observer

The first thing we're going to take a look at is how to create a ```BlocObserver``` which will help us observe all state changes in the application.

Let's create ```lib/counter_observer.dart```:

```dart
import 'package:bloc/bloc.dart';

/// [BlocObserver] for the counter application which
/// observes all state changes.
class CounterObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    // ignore: avoid_print
    print('${bloc.runtimeType} $change');
  }
}
```

In this case, we're only overriding ```onChange``` to see all state changes that occur.

Note: ```onChange``` works the same way for both ```Bloc``` and ```Cubit``` instances.

## main.dart

Next, let's replace the contents of main.dart with:

```dart
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_counter/app.dart';
import 'package:flutter_counter/counter_observer.dart';

void main() {
  Bloc.observer = CounterObserver();
  runApp(const CounterApp());
}
```

We're initializing the CounterObserver we just created and calling runApp with the CounterApp widget which we'll look at next.

## Counter App

Let's create ```lib/app.dart```:

```CounterApp``` will be a ```MaterialApp``` and is specifying the ```home``` as ```CounterPage```.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_counter/counter/counter.dart';

/// A [MaterialApp] which sets the `home` to [CounterPage].

class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CounterPage(),
    );
  }
}
```

Let's take a look at ```CounterPage``` next!

## Counter Page

Let's create ```lib/counter/view/counter_page.dart```:

The ```CounterPage``` widget is responsible for creating a ```CounterCubit``` (which we will look at next) and providing it to the CounterView.

```dart
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
```

Note: It's important to separate or decouple the creation of a ```Cubit``` from the consumption of a ```Cubit``` in order to have code that is much more testable and reusable.

## Counter Cubit

Let's create ```lib/counter/cubit/counter_cubit.dart```:

The ```CounterCubit``` class will expose two methods:

- ```increment```: adds 1 to the current state
- ```decrement```: subtracts 1 from the current state

The type of state the ```CounterCubit``` is managing is just an ```int``` and the initial state is ```0```.

```dart
import 'package:bloc/bloc.dart';

/// A [Cubit] which manages an [int] as its state.
class CounterCubit extends Cubit<int> {
  /// Counter Cubit
  CounterCubit() : super(0);

  /// Add 1 to the current state.
  void increment() => emit(state + 1);

  /// Subtract 1 from the current state.
  void decrement() => emit(state - 1);
}
```

Next, let's take a look at the ```CounterView``` which will be responsible for consuming the ```state``` and interacting with the ```CounterCubit```.

## Counter View

Let's create ```lib/counter/view/counter_view.dart```:

The ```CounterView``` is responsible for rendering the current count and rendering two FloatingActionButtons to increment/decrement the counter.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_counter/counter/counter.dart';

/// A [StatelessWidget] which reacts to the provided
/// [CounterCubit] state and notifies it in response to user input.

class CounterView extends StatelessWidget {
  /// Counter View
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(
        child: BlocBuilder<CounterCubit, int>(
          builder: (context, state) {
            return Text('$state', style: textTheme.headline2);
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            key: const Key('counterView_increment_floatingActionButton'),
            child: const Icon(Icons.add),
            onPressed: () => context.read<CounterCubit>().increment(),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            key: const Key('counterView_decrement_floatingActionButton'),
            child: const Icon(Icons.remove),
            onPressed: () => context.read<CounterCubit>().decrement(),
          ),
        ],
      ),
    );
  }
}
```

A ```BlocBuilder``` is used to wrap the ```Text``` widget in order to update the text any time the ```CounterCubit``` state changes. In addition, ```context.read<CounterCubit>()``` is used to look-up the closest ```CounterCubit``` instance.

Note: Only the ```Text``` widget is wrapped in a ```BlocBuilder``` because that is the only widget that needs to be rebuilt in response to state changes in the ```CounterCubit```. Avoid unnecessarily wrapping widgets that don't need to be rebuilt when a state changes.

## Barrel Files

Let's create ```lib/counter/view/view.dart```:

```dart
export 'counter_page.dart';
export 'counter_view.dart';
```

Let's create ```lib/counter/counter.dart```:

Add ```counter.dart``` to export all the public facing parts of the counter feature.

```dart
export 'cubit/counter_cubit.dart';
export 'view/view.dart';
```
