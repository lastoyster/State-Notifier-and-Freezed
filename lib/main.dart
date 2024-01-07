import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:english_words/english_words.dart';

class MyApiState {
  final List<String> names;
  final bool isLoading;
  final String error;

  MyApiState({required this.names, required this.isLoading, required this.error});

  factory MyApiState.loading() {
    return MyApiState(names: [], isLoading: true, error: '');
  }

  factory MyApiState.success(List<String> names) {
    return MyApiState(names: names, isLoading: false, error: '');
  }

  factory MyApiState.error(String error) {
    return MyApiState(names: [], isLoading: false, error: error);
  }
}

class MyApiModel extends StateNotifier<MyApiState> {
  MyApiModel() : super(MyApiState(names: [], isLoading: false, error: ''));

  Future<void> generateRandomNames(int n) async {
    state = MyApiState.loading();
    await Future.delayed(const Duration(seconds: 1));
    if (n < 0) {
      state = MyApiState.error('Error: the argument should be positive');
    } else {
      final randomNames = generateWordPairs()
          .take(n)
          .map((WordPair wp) => wp.asPascalCase)
          .toList();
      state = MyApiState.success(randomNames);
    }
  }
}

class StateNotifierFreezedExample extends StatelessWidget {
  const StateNotifierFreezedExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StateNotifierProvider<MyApiModel, MyApiState>(
      create: (_) => MyApiModel(),
      child: _DemoPage(),
    );
  }
}

class _DemoPage extends StatefulWidget {
  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<_DemoPage> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<MyApiState>();
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.api),
        title: const Text('Random Name Generator'),
      ),
      body: Center(
        child: state.isLoading
            ? CircularProgressIndicator()
            : state.error.isNotEmpty
                ? Text(state.error)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Generated Names:'),
                      SizedBox(height: 8),
                      for (var name in state.names) Text(name),
                    ],
                  ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: StateNotifierFreezedExample()));
}
