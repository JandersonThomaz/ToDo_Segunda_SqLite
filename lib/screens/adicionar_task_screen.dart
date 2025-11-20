
import 'package:app_segunda/data/tarefa_respository.dart';
import 'package:app_segunda/models/tarefa.dart';
import 'package:app_segunda/services/Tarefa_service.dart';
import 'package:flutter/material.dart';

class AdicionarTaskScreen extends StatelessWidget {
  AdicionarTaskScreen({super.key});

  final tituloController = TextEditingController();
  final descricaoController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Adicionar tarefa")),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            //campo do titulo
            Padding(
              padding: EdgeInsets.all(16),
              child: TextFormField(
                decoration: InputDecoration(
                  label: Text("Título"),
                  border: OutlineInputBorder(),
                  hintText: "Digite o titulo da tarefa",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                controller: tituloController,
                maxLength: 20,
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return "Escreva um título";
                  }
                  if (valor.length < 4) {
                    return "Digite pelo menos 4 caracteres";
                  }
                  return null;
                },
              ),
            ),
            //campo da descrição
            Padding(
              padding: EdgeInsetsGeometry.all(16),
              child: TextFormField(
                decoration: InputDecoration(
                  label: Text("Descrição"),
                  border: OutlineInputBorder(),
                  hintText: "Digite a descrição da tarefa",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                minLines: 3,
                maxLines: 3,
                maxLength: 140,
                controller: descricaoController,
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return "Escreva uma descrição";
                  }
                  if (valor.length < 10) {
                    return "Digite pelo menos 10 caracteres";
                  }
                  return null;
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  //Caso esteja valido
                  Tarefa novaTarefa = Tarefa(
                    0,
                    tituloController.text,
                    descricaoController.text,
                  );

                  await TarefaRespository().salvar(novaTarefa);

                  Navigator.pop(context, true);
                } else {
                  //Caso não esteja válido
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Faça o preenchimento correto do fomulário!",
                      ),
                    ),
                  );
                }
              },
              child: Text("Salvar"),
            ),
          ],
        ),
      ),
    );
  }
}
