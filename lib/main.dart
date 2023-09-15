import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Cubit Search Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SearchPage(),
    );
  }
}

class SearchState {
  SearchState();

  SearchState.fromState(SearchState state) {
    term = state.term;
    results = state.results;
  }

  final List<String> _terms = ["apple", "orange", "banana", "onion"];
  String? term;
  List<String> results = [];
}

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchState());

  search(String term) {
    var reg = RegExp(term, caseSensitive: false);
    var results =
        state._terms.map((e) => reg.hasMatch(e) ? e : null).nonNulls.toList();
    emit(SearchState.fromState(state)
      ..term = term
      ..results = results);
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});
  @override
  Widget build(context) {
    return Scaffold(
      body: BlocProvider<SearchCubit>(
        create: (context) => SearchCubit(),
        child: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            return ListView(
              children: [
                SearchAnchor(
                  builder: (context, controller) => SearchBar(
                    onChanged: (value) {
                      context.read<SearchCubit>().search(value);
                    },
                  ),
                  suggestionsBuilder: (context, controller) =>
                      state._terms.map((e) => Text(e)),
                ),
                ...state.results.map((e) => ListTile(title: Text(e)))
              ],
            );
          },
        ),
      ),
    );
  }
}
