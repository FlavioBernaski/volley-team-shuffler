import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VolleyTeamGenerator',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 61, 10, 150)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Gerador de time'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Player {
  String name;
  bool selected;

  Player(this.name, this.selected);
}

class _MyHomePageState extends State<MyHomePage> {
  int _selected = 0;
  final List<Player> _players = [];
  final _nameController = TextEditingController();

  void _addPlayer() {
    setState(() {
      var name = _nameController.text.trim();
      if (name.isNotEmpty && !_players.any((player) => player.name == name)) {
        _players.add(Player(name, false));
      }
      _nameController.clear();
    });
  }

  void generateTeams(BuildContext context) {
    List<Player> selected =
        _players.where((player) => player.selected).toList();
    selected.shuffle();
    List<Player> left = selected.sublist(0, selected.length ~/ 2);
    List<Player> right = selected.sublist(selected.length ~/ 2);
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog.fullscreen(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            ListView.builder(
              itemCount: left.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(left[index].name),
                );
              },
            ),
            const Divider(),
            ListView.builder(
              itemCount: right.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(right[index].name),
                );
              },
            ),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fechar'))
          ])),
    );
  }

  void onChanged(bool? value, int index) {
    _players.elementAt(index).selected = value!;
    if (value) {
      _selected++;
    } else {
      _selected--;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                        hintText: 'Digite o nome do jogador',
                        constraints: BoxConstraints(
                          maxWidth: 300,
                        )),
                  ),
                  ElevatedButton(
                    onPressed: _addPlayer,
                    child: Icon(
                      Icons.add,
                      size: 30,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.all(5)),
              ElevatedButton(
                  onPressed: () => generateTeams(context),
                  child: const Text('Gerar times')),
              const Padding(padding: EdgeInsets.all(5)),
              Text(
                'Jogadores selecionados: $_selected',
              ),
              const Divider(),
              ListView.builder(
                itemCount: _players.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                      title: Text(_players[index].name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _players.removeAt(index);
                              });
                            },
                            icon: const Icon(Icons.delete),
                          ),
                          Checkbox(
                              value: _players[index].selected,
                              onChanged: (value) => onChanged(value, index))
                        ],
                      ));
                },
              ),
            ],
          ),
        ));
  }
}
