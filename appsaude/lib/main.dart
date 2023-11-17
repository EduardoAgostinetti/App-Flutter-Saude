import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/medico': (context) => MedicoPage(),
        //'/menu': (context) => Menu(),
      },
    );
  }
}

class RegisterPage extends StatefulWidget {
  @override
  RegisterPageState createState() => RegisterPageState();
}

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class MedicoPage extends StatefulWidget {
  @override
  MedicoPageState createState() => MedicoPageState();
}

class Menu extends StatefulWidget {
  final String cargo;
  final String cpf;

  Menu({
    required this.cargo,
    required this.cpf,
  });

  @override
  MenuState createState() => MenuState();
}

class LoginPageState extends State<LoginPage> {
  String notification = "Acesse sua conta";
  Color color = Colors.black;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _sendData() async {
    final String apiUrl =
        'http://10.21.3.203:3000/user/login'; // Substitua pela sua URL de destino

    var data = {
      'email': emailController.text,
      'senha': passwordController.text,
    };

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // Lógica para manipular a resposta de sucesso aqui
      print('Requisição bem-sucedida. Resposta: ${response.body}');

      var jsonRes = jsonDecode(response.body);
      print(jsonRes['success']);

      if (jsonRes['success'] == false) {
        setState(() {
          notification = "Não encontramos um usuario!";
          color = Colors.red;
        });
      } else {
        List<dynamic> users = jsonRes['user'];

        late String cargo;
        late String email;
        late String senha;
        late String cpf;

        for (var user in users) {
          cargo = user['cargo'];
          email = user['email'];
          senha = user['senha'];
          cpf = user['cpf'];
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Menu(cargo: cargo, cpf: cpf),
          ),
        );
        print('Cargo: $cargo');
        print('E-mail: $email');
        print('Senha: $senha');
        print('CPF: $cpf');
      }
    } else {
      // Lógica para manipular a resposta de erro aqui
      print('Falha na requisição. Código de status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Página de Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'E-mail',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Senha',
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
            ),
            Text(
              notification,
              style: TextStyle(
                color: color, // Substitua pela cor desejada
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
            ),
            ElevatedButton(
              onPressed: _sendData,
              child: Text('Entrar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterPageState extends State<RegisterPage> {
  String notification = 'Registre um usuario';
  Color color = Colors.black;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController cargoController = TextEditingController();

  void _sendData() async {
    final String apiUrl =
        'http://10.21.3.203:3000/user/register'; // Substitua pela sua URL de destino

    var data = {
      'cpf': cpfController.text,
      'cargo': cargoController.text,
      'email': emailController.text,
      'senha': passwordController.text,
    };

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // Lógica para manipular a resposta de sucesso aqui
      print('Requisição bem-sucedida. Resposta: ${response.body}');

      var jsonRes = jsonDecode(response.body);
      print(jsonRes['success']);

      if (jsonRes['success'] == false) {
        setState(() {
          notification = "Não registrou, tente novamente!";
          color = Colors.red;
        });

        print("não registrou");
      } else {
        setState(() {
          notification = "Registrou, realize seu login";
          color = Colors.green;
        });

        print("registrou");
      }
    } else {
      // Lógica para manipular a resposta de erro aqui
      print('Falha na requisição. Código de status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Página de Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: cpfController,
              obscureText: false,
              decoration: InputDecoration(
                hintText: 'CPF',
              ),
            ),
            TextField(
              controller: cargoController,
              obscureText: false,
              decoration: InputDecoration(
                hintText: 'enfermeiro/medico/farmaceutico/paciente',
              ),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'E-mail',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Senha',
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
            ),
            Text(
              notification,
              style: TextStyle(
                color: color, // Substitua pela cor desejada
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
            ),
            ElevatedButton(
              onPressed: _sendData,
              child: Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuState extends State<Menu> {
  bool isButtonMedico = false;
  bool isButtonEnfermeiro = false;
  bool isButtonFarmaceutico = false;
  bool isButtonPaciente = false;

  late String cargo;
  late String cpf;

  @override
  void initState() {
    super.initState();
    cargo = widget.cargo;
    cpf = widget.cpf;

    if (cargo == "medico") {
      isButtonMedico = true;
      print("É medico");
    }
    if (cargo == "enfermeiro") {
      isButtonEnfermeiro = true;
      print("É enfermeiro");
    }
    if (cargo == "paciente") {
      isButtonPaciente = true;
      print("É paciente");
    }
    if (cargo == "farmaceutico") {
      isButtonFarmaceutico = true;
      print("É farmaceutico");
    }
    if (cargo == "admin") {
      isButtonFarmaceutico = true;
      isButtonMedico = true;
      isButtonEnfermeiro = true;
      isButtonPaciente = true;
      print("É farmaceutico");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Menu')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize:
                MainAxisSize.min, // Configura o tamanho principal para min
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: isButtonMedico
                    ? () {
                        Navigator.pushNamed(context, '/medico');
                      }
                    : null,
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                      Size(350, 80)), // Ajusta o tamanho mínimo do botão
                  maximumSize: MaterialStateProperty.all(
                      Size(350, 80)), // Ajusta o tamanho máximo do botão
                ),
                icon: Icon(
                  Icons.add_circle_outline, // Ícone de coração
                  size: 50.0, // Tamanho do ícone
                ),
                label: Text(
                  'Médicos',
                  style: TextStyle(
                    fontSize: 34, // Substitua pelo tamanho de fonte desejado
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
              ),
              ElevatedButton.icon(
                onPressed: isButtonEnfermeiro
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CadastroProntuario(cpf: cpf),
                          ),
                        );
                      }
                    : null,
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                      Size(350, 80)), // Ajusta o tamanho mínimo do botão
                  maximumSize: MaterialStateProperty.all(
                      Size(350, 80)), // Ajusta o tamanho máximo do botão
                ),
                icon: Icon(
                  Icons.healing, // Ícone de coração
                  size: 50.0, // Tamanho do ícone
                ),
                label: Text(
                  'Enfermeiros',
                  style: TextStyle(
                    fontSize: 34, // Substitua pelo tamanho de fonte desejado
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
              ),
              ElevatedButton.icon(
                onPressed: isButtonFarmaceutico
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Farmacia(),
                          ),
                        );
                      }
                    : null,
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                      Size(350, 80)), // Ajusta o tamanho mínimo do botão
                  maximumSize: MaterialStateProperty.all(
                      Size(350, 80)), // Ajusta o tamanho máximo do botão
                ),
                icon: Icon(
                  Icons.medication, // Ícone de coração
                  size: 50.0, // Tamanho do ícone
                ),
                label: Text(
                  'Farmacéuticos',
                  style: TextStyle(
                    fontSize: 34, // Substitua pelo tamanho de fonte desejado
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
              ),
              ElevatedButton.icon(
                onPressed: isButtonPaciente
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Paciente(cpf: cpf),
                          ),
                        );
                      }
                    : null,
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                      Size(350, 80)), // Ajusta o tamanho mínimo do botão
                  maximumSize: MaterialStateProperty.all(
                      Size(350, 80)), // Ajusta o tamanho máximo do botão
                ),
                icon: Icon(
                  Icons.person, // Ícone de coração
                  size: 50.0, // Tamanho do ícone
                ),
                label: Text(
                  'Pacientes',
                  style: TextStyle(
                    fontSize: 34, // Substitua pelo tamanho de fonte desejado
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MedicoPageState extends State<MedicoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Página do Médico')),
        body: MedicoListView());
  }
}

class MedicoListView extends StatefulWidget {
  @override
  _MedicoListViewState createState() => _MedicoListViewState();
}

class _MedicoListViewState extends State<MedicoListView> {
  late List<Widget> listaDeItens = [];

  @override
  void initState() {
    super.initState();
    _sendData();
  }

  void _sendData() async {
    final String apiUrl = 'http://10.21.3.203:3000/user/medico';

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var jsonRes = jsonDecode(response.body);
      List<dynamic> prontuarios = [];

      prontuarios = jsonRes['prontuario'];

      if (prontuarios != null && prontuarios.isNotEmpty) {
        listaDeItens = prontuarios.map((prontuario) {
          String nomePaciente = prontuario['nome'];
          String cpf = prontuario['cpf'];
          String horario = prontuario['horario'];
          String status = prontuario['status'];
          String observacao = prontuario['observacoes'];
          String pressao = prontuario['pressao'];
          String peso = prontuario['peso'];
          String idade = prontuario['idade'];

          return ListTile(
            leading: Icon(Icons.people_alt),
            title: Text('Nome: $nomePaciente'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Horário Entrada: $horario'),
                Text('Status: $status'),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Prontuario(
                    cpf: cpf,
                    horario: horario,
                    observacao: observacao,
                    nomePaciente: nomePaciente,
                    pressao: pressao,
                    idade: idade,
                    peso: peso,
                  ),
                ),
              );
            },
          );
        }).toList();
      } else {
        // Caso não haja prontuários, você pode exibir uma mensagem ou algo do tipo
        listaDeItens = [Text('Nenhum prontuário disponível.')];
      }
      setState(() {});
      // Atualiza a interface após obter os dados
    } else {
      print('Falha na requisição. Código de status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
        ),
        ElevatedButton(
          onPressed: () {
            _sendData();
          },
          child: Text('Atualizar'),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
        ),
        Expanded(
          child: ListView(
            children: listaDeItens ?? <Widget>[],
          ),
        ),
      ],
    );
  }
}

class Prontuario extends StatefulWidget {
  final String cpf;
  final String horario;
  final String observacao;
  final String nomePaciente;
  final String pressao;
  final String idade;
  final String peso;

  Prontuario(
      {required this.cpf,
      required this.horario,
      required this.observacao,
      required this.nomePaciente,
      required this.pressao,
      required this.idade,
      required this.peso});

  @override
  ProntuarioState createState() => ProntuarioState();
}

class ProntuarioState extends State<Prontuario> {
  late String cpf;
  late String horario;
  late String observacao;
  late String nomePaciente;
  late String pressao;
  late String idade;
  late String peso;
  Color color = Colors.black;
  String notification = "Crie receita para o paciente!";

  final TextEditingController remedioController = TextEditingController();
  final TextEditingController quantidadeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cpf = widget.cpf;
    horario = widget.horario;
    observacao = widget.observacao;
    nomePaciente = widget.nomePaciente;
    pressao = widget.pressao;
    idade = widget.idade;
    peso = widget.peso;
  }

  void _sendData() async {
    final String apiUrl =
        'http://10.21.3.203:3000/user/createReceita'; // Substitua pela sua URL de destino

    var data = {
      'remedio': remedioController.text,
      'quantidade': quantidadeController.text,
      'cpf': cpf,
    };

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // Lógica para manipular a resposta de sucesso aqui
      print('Requisição bem-sucedida. Resposta: ${response.body}');

      var jsonRes = jsonDecode(response.body);
      print(jsonRes['success']);

      if (jsonRes['success'] == false) {
        setState(() {
          notification = "Problema ao criar receita, tente novamente";
          color = Colors.red;
        });
      } else {
        setState(() {
          notification = "Atendimento finalizado e Receita Criada com sucesso!";
          color = Colors.green;
        });
      }
    } else {
      print('Falha na requisição. Código de status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Prontuário do Paciente')),
      body: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(3.0),
            ),
            Text(
              'Nome: $nomePaciente',
              textAlign: TextAlign.left,
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
            ),
            Text(
              'CPF: $cpf',
              textAlign: TextAlign.left,
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
            ),
            Text(
              'Idade: $idade',
              textAlign: TextAlign.left,
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
            ),
            Text(
              'Peso: $peso',
              textAlign: TextAlign.left,
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
            ),
            Text(
              'Horario de Entrada: $horario',
              textAlign: TextAlign.left,
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
            ),
            Text(
              'Observações: $observacao',
              textAlign: TextAlign.left,
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
            ),
            Text(
              'Pressão: $pressao',
              textAlign: TextAlign.left,
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
            ),
            TextField(
              controller: remedioController,
              decoration: InputDecoration(
                hintText: 'Criar receita (Nome do medicamento)',
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: quantidadeController,
              decoration: InputDecoration(
                hintText: 'Criar receita (Quantidade do medicamento)',
              ),
            ),
            SizedBox(height: 15),
            Text(
              notification,
              style: TextStyle(
                color: color, // Substitua pela cor desejada
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _sendData();
              },
              child: Text('Criar Receita e Encerrar o atendimento'),
            ),
          ],
        ),
      ),
    );
  }
}

class CadastroProntuario extends StatefulWidget {
  final String cpf;
  CadastroProntuario({required this.cpf});

  @override
  CadastroProntuarioState createState() => CadastroProntuarioState();
}

class CadastroProntuarioState extends State<CadastroProntuario> {
  late String cpf;
  late String notification = "Crie um prontuario";
  Color color = Colors.black;

  void initState() {
    super.initState();
    cpf = widget.cpf;
  }

  final TextEditingController pesoController = TextEditingController();
  final TextEditingController observacaoController = TextEditingController();
  final TextEditingController pressaoController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController idadeController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();

  void _sendData() async {
    final String apiUrl =
        'http://10.21.3.203:3000/user/createProntuario'; // Substitua pela sua URL de destino

    var data = {
      'nome': nomeController.text,
      'idade': idadeController.text,
      'peso': pesoController.text,
      'observacao': observacaoController.text,
      'pressao': pressaoController.text,
      'cpf': cpfController.text,
    };

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // Lógica para manipular a resposta de sucesso aqui
      print('Requisição bem-sucedida. Resposta: ${response.body}');

      var jsonRes = jsonDecode(response.body);
      print(jsonRes['success']);

      if (jsonRes['success'] == false) {
        setState(() {
          notification = "CPF não está cadastrado.";
          color = Colors.red;
        });
      } else {
        setState(() {
          notification = "Prontuário Cadastrado !.";
          color = Colors.green;
        });
      }
    } else {
      print('Falha na requisição. Código de status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Prontuário do Paciente')),
      body: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nomeController,
              decoration: InputDecoration(
                hintText: 'Nome do Paciente',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: cpfController,
              decoration: InputDecoration(
                hintText: 'CPF',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: pesoController,
              decoration: InputDecoration(
                hintText: 'Peso',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: idadeController,
              decoration: InputDecoration(
                hintText: 'Idade',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: observacaoController,
              decoration: InputDecoration(
                hintText: 'Observações',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: pressaoController,
              decoration: InputDecoration(
                hintText: 'Pressão do Paciente',
              ),
            ),
            SizedBox(height: 10),
            Text(
              notification,
              style: TextStyle(
                color: color, // Substitua pela cor desejada
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _sendData();
              },
              child: Text('Criar Prontuário'),
            ),
          ],
        ),
      ),
    );
  }
}

class Paciente extends StatefulWidget {
  final String cpf;
  Paciente({required this.cpf});

  @override
  PacienteState createState() => PacienteState();
}

class PacienteState extends State<Paciente> {
  late String cpf;

  String nomePaciente = "Nome";
  String horario = "Horario de Entrada";
  String status = "Horario de Saida";
  String observacao = "Observações";
  String pressao = "Pressão";
  String peso = "Peso";
  String idade = "Idade";
  String receita = "receita";
  String quantidade = "Quantidade Remedio";
  String obtido = "obtido";

  String notification = "Seu Prontuário";
  Color color = Colors.black;

  @override
  void initState() {
    super.initState();
    cpf = widget.cpf;
    _sendData();
  }

  void _sendData() async {
    final String apiUrl =
        'http://10.21.3.203:3000/user/paciente'; // Substitua pela sua URL de destino

    var data = {
      'cpf': cpf,
    };

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // Lógica para manipular a resposta de sucesso aqui
      print('Requisição bem-sucedida. Resposta: ${response.body}');

      var jsonRes = jsonDecode(response.body);
      print(jsonRes['success']);

      late List<dynamic> prontuarios = [];

      if (jsonRes['prontuario'] != null) {
        prontuarios = jsonRes['prontuario'];

        for (var prontuario in prontuarios) {
          nomePaciente = prontuario['nome'];
          cpf = prontuario['cpf'];
          horario = prontuario['horario'];
          status = prontuario['status'];
          observacao = prontuario['observacoes'];
          pressao = prontuario['pressao'];
          peso = prontuario['peso'];
          idade = prontuario['idade'];
          receita = prontuario['receita'];
          quantidade = prontuario['quantidadeRemedio'];
          if (prontuario['boolRemedio'] == "0") {
            obtido = "Remédio não obtido";
          } else {
            obtido = "Remédio obtido";
          }
        }
      }

      if (jsonRes['success'] == false) {
        setState(() {
          notification = "Problema ao encontrar prontuário";
          color = Colors.red;
        });
      } else {
        setState(() {
          notification = "Seu Prontuário";
          color = Colors.green;
        });
      }
    } else {
      print('Falha na requisição. Código de status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Seu Prontuário')),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                notification,
                style: TextStyle(
                  color: color,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Nome: $nomePaciente',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Text(
                'CPF: $cpf',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Text(
                'Idade: $idade',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Text(
                'Peso: $peso',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Text(
                'Receita: $receita, quantidade: $quantidade, Obtido: $obtido',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Text(
                'Horario de Entrada: $horario',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Text(
                'Observações: $observacao',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Text(
                'Pressão: $pressao',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Text(
                'Status do Atendimento: $status',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Farmacia extends StatefulWidget {
  @override
  FarmaciaState createState() => FarmaciaState();
}

class FarmaciaState extends State<Farmacia> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Farmácia')),
      body: FarmaciaListView(),
    );
  }
}

class FarmaciaListView extends StatefulWidget {
  @override
  _FarmaciaListViewState createState() => _FarmaciaListViewState();
}

class _FarmaciaListViewState extends State<FarmaciaListView> {
  late String remedio;
  late String quantidade;
  late String boolRemedio;
  late String cpf;
  late List<Widget> listaDeItens = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _sendData2();
  }

  void _sendData1(var receita, var quantidade, var boolRemedio, var cpf) async {
    final String apiUrl =
        'http://10.21.3.203:3000/user/controle'; // Substitua pela sua URL de destino

    var data = {
      'receita': receita,
      'quantidade': quantidade,
      'boolRemedio': boolRemedio,
      'cpf': cpf,
    };

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // Lógica para manipular a resposta de sucesso aqui
      print('Requisição bem-sucedida. Resposta: ${response.body}');

      var jsonRes = jsonDecode(response.body);
      print(jsonRes['success']);
      _sendData2();
    } else {
      print('Falha na requisição. Código de status: ${response.statusCode}');
    }
  }

  void _sendData() async {
    FarmaciaListView();
    final String apiUrl =
        'http://10.21.3.203:3000/user/farmacia'; // Substitua pela sua URL de destino

    var data = {};

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // Lógica para manipular a resposta de sucesso aqui
      print('Requisição bem-sucedida. Resposta: ${response.body}');

      var jsonRes = jsonDecode(response.body);
      print(jsonRes['success']);

      if (jsonRes['success'] == false) {
      } else {
        late List<dynamic> receitas = [];

        if (jsonRes['receitas'] != null) {
          receitas = jsonRes['receitas'];

          for (var receita in receitas) {
            boolRemedio = receita['boolRemedio'];
            remedio = receita['receita'];
            quantidade = receita['quantidadeRemedio'];
            cpf = receita['cpf'];
            if (boolRemedio == "0") {
              _sendData1(remedio, quantidade, boolRemedio, cpf);
            }
          }
        }
      }
    } else {
      print('Falha na requisição. Código de status: ${response.statusCode}');
    }
  }

  void _sendData2() async {
    final String apiUrl = 'http://10.21.3.203:3000/user/estoque';

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var jsonRes = jsonDecode(response.body);
      List<dynamic> receitas = [];

      receitas = jsonRes['receitas'];

      if (receitas != null && receitas.isNotEmpty) {
        listaDeItens = receitas.map((receita) {
          String nomeRemedio = receita['nomeRemedio'];
          int quantidade = receita['quantidade'];

          return ListTile(
            leading: Icon(Icons.people_alt),
            title: Text('Nome do Remedio: $nomeRemedio'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quantidade em Estoque: $quantidade'),
              ],
            ),
            onTap: () {},
          );
        }).toList();
      } else {
        // Caso não haja prontuários, você pode exibir uma mensagem ou algo do tipo
        listaDeItens = [Text('Nenhum remédio em estoque.')];
      }
      setState(() {});
      // Atualiza a interface após obter os dados
    } else {
      print('Falha na requisição. Código de status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(onPressed: _sendData, child: Text("Atualizar")),
        Padding(
          padding: const EdgeInsets.all(8.0),
        ),
        Expanded(
          child: ListView(
            children: listaDeItens ?? <Widget>[],
          ),
        ),
      ],
    );
  }
}
