import 'package:app_segunda/data/tarefa_respository.dart';
import 'package:app_segunda/models/tarefa.dart';
import 'package:app_segunda/screens/adicionar_task_screen.dart';
import 'package:app_segunda/services/Tarefa_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Tarefa>> listaDeTarefas;

  @override
  void initState() {
    super.initState();

    _carregarListaDeTarefas();
  }

  void _carregarListaDeTarefas() {
    listaDeTarefas = TarefaRespository().listar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(Icons.notifications),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(child: Text("A")),
          ),
        ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Olá,", style: TextStyle(fontSize: 16.0)),
            Text("Janderson", style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
      body: FutureBuilder(
        future: listaDeTarefas,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("Carregando..."));
          }

          if (asyncSnapshot.hasError) {
            return Center(
              child: Text("opa... deu erro! ${asyncSnapshot.error}"),
            );
          }
          
          if (!asyncSnapshot.hasData || asyncSnapshot.data!.isEmpty) {
            return Center(child: Text("opa... sem tarefas!"));
          }

          var tarefas = asyncSnapshot.data!;

          return Column(
            children: [
              SizedBox(height: 10),
              Text(
                "Todas as tarefas",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: tarefas.length,
                  itemBuilder: (context, index) => Card(
                    child: ListTile(
                      leading: Checkbox(
                        value: tarefas[index].finalizada,
                        onChanged: (valor) async {
                          if (valor == true) {
                            setState(() {
                              tarefas[index].finalizar();
                            });

                            await TarefaRespository().finalizar(tarefas[index].id);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Tarefa finalizada com sucesso!"),
                              ),
                            );
                          } else {
                            setState(() {
                              tarefas[index].iniciar();
                            });

                            await TarefaRespository().reabrir(tarefas[index].id);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Tarefa reaberta com sucesso!"),
                              ),
                            );
                          }
                        },
                      ),
                      title: Text(tarefas[index].nome),
                      subtitle: Text(tarefas[index].descricao),
                      trailing: IconButton(
                        onPressed: () async{
                          await TarefaRespository().excluir(tarefas[index].id);
                          setState(() {
                            tarefas.removeAt(index); 
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Tarefa excluída com sucesso!"),
                              ),
                            );
                        }, 
                        icon: Icon(Icons.delete)
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdicionarTaskScreen()),
          ).then((valor) {
            if (valor == true) {
              setState(() {
                _carregarListaDeTarefas();
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Tarefa criada com sucesso!")),
              );
            }
          });
        },

        child: Icon(Icons.add),
      ),
    );
  }
}
