import 'dart:convert';

import 'package:app_segunda/models/tarefa.dart';
import 'package:http/http.dart' as http;

class TarefaService {
  Future<List<Tarefa>> listarTodas() async {
    List<Tarefa> listaDeTarefas = [];

    final resposta = await http.get(
      Uri.parse("https://691f450dbb52a1db22c11e06.mockapi.io/tarefas"),
    );

    if (resposta.statusCode != 200) {
      throw Exception("Falha ao carregar todas as tarefas!");
    }

    var bodyDecodificado = jsonDecode(resposta.body);

    for (var jsonDecode in bodyDecodificado) {
      Tarefa tarefa = Tarefa(
        int.parse(jsonDecode["id"]),
        jsonDecode["titulo"],
        jsonDecode["descricao"],
      );

      if (jsonDecode["finalizada"] == true) {
        tarefa.finalizar();
      } else {
        tarefa.iniciar();
      }

      listaDeTarefas.add(tarefa);
    }

    return listaDeTarefas;
  }

  Future<void> salvar(Tarefa tarefa) async {
    final resposta = await http.post(
      Uri.parse("https://691f450dbb52a1db22c11e06.mockapi.io/tarefas"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(tarefa.toMap()),
    );

    if(resposta.statusCode != 200 && resposta.statusCode != 201){
      throw Exception("Não foi possivel salvar a tarefa");
    }
  }

  Future<void> finalizar(int id) async{
    final resposta = await http.put(
      Uri.parse("https://691f450dbb52a1db22c11e06.mockapi.io/tarefas/$id"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },

      body: jsonEncode(
        {
          "finalizada": true
        })
    );

    if(resposta.statusCode != 200 && resposta.statusCode != 201){
      throw Exception("Não foi possivel salvar a tarefa");
    }
  }
  Future<void> reabrir(int id) async{
    final resposta = await http.put(
      Uri.parse("https://691f450dbb52a1db22c11e06.mockapi.io/tarefas/$id"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },

      body: jsonEncode(
        {
          "finalizada": false
        })
    );

    if(resposta.statusCode != 200 && resposta.statusCode != 201){
      throw Exception("Não foi possivel salvar a tarefa");
    }
  }

  Future<void> excluir(int id) async {
    final resposta = await http.delete(
      Uri.parse("https://691f450dbb52a1db22c11e06.mockapi.io/tarefas/$id"),
    );

    if(resposta.statusCode != 200 && resposta.statusCode != 201){
      throw Exception("Não foi possivel salvar a tarefa");
    }
  }
}
