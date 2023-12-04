import 'package:flutter/material.dart';
import 'package:practica/widget/counter_stream.dart';
import 'package:practica/widget/tarea.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Stream Counter',
      home: CounterScreen(),
    );
  }
}

class CounterScreen extends StatefulWidget {
  const CounterScreen({Key? key}) : super(key: key);

  @override
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  final CounterStream _counterStream = CounterStream();
  List<Tarea> listadeTareas = [];

  @override
  void initState() {
    super.initState();
    _counterStream.startCounter(listadeTareas);
  }

  void deleteTask(int index) {
    setState(() {
      listadeTareas.removeAt(index);
    });
  }

  void addTask(String userInput) {
    final nuevaTarea = Tarea(listadeTareas.length + 1, userInput, false);
    setState(() {
      listadeTareas.add(nuevaTarea);
      _counterStream.startCounter(listadeTareas);
    });
  }

  @override
  void dispose() {
    _counterStream.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stream Counter"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: StreamBuilder<List<Tarea>>(
                stream: _counterStream.counterStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    listadeTareas = snapshot.data!;
                    return buildListView(listadeTareas);
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showAddTaskDialog(context),
              child: const Text('Añadir'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListView(List<Tarea> miList) {
    return ListView.builder(
      itemCount: miList.length,
      itemBuilder: (BuildContext context, int index) {
        final tarea = miList[index];
        return ListTile(
          title: Row(
            children: [
              _buildTaskInfoContainer('${tarea.id}', 50),
              _buildTaskInfoContainer(tarea.titulo, 120),
              _buildTaskInfoContainer(
                tarea.estado ? 'Completado' : 'Pendiente',
                100,
                color: tarea.estado ? Colors.green : Colors.red,
              ),
              _buildIconButton(
                  Icons.close, Colors.red, () => deleteTask(index)),
              if (!tarea.estado)
                _buildIconButton(
                    Icons.check, Colors.green, () => _completeTask(index)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTaskInfoContainer(String text, double width, {Color? color}) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border.all(),
        color: color,
      ),
      child: Center(
        child: Text(text),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    String userInput = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nombra tu tarea'),
          content: TextField(
            onChanged: (value) {
              userInput = value;
            },
            decoration: const InputDecoration(
              hintText: 'Ingrese el texto aquí',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Guardar'),
              onPressed: () {
                addTask(userInput);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _completeTask(int index) {
    setState(() {
      listadeTareas[index].estado = true;
      _counterStream.startCounter(listadeTareas);
    });
  }

  Widget _buildIconButton(IconData icon, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: 20,
      child: RawMaterialButton(
        onPressed: onPressed,
        constraints: const BoxConstraints.tightFor(
          width: 25,
          height: 25,
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        fillColor: color,
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
