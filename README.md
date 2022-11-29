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
