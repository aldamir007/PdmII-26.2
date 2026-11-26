
import 'package:flutter/material.dart';

import 'models/usuario.dart';
import 'services/api_service.dart';

const roxo = Color(0xFF6842A6);
const roxoEscuro = Color(0xFF43256F);
const lavanda = Color(0xFFEDE5FA);
const fundo = Color(0xFFF7F5FB);

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ADM Users',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: fundo,
        colorScheme: ColorScheme.fromSeed(
          seedColor: roxo,
        ),
        fontFamily: 'Roboto',
      ),
      home: const TelaUsuarios(),
    );
  }
}

class TelaUsuarios extends StatefulWidget {
  const TelaUsuarios({super.key});

  @override
  State<TelaUsuarios> createState() => _TelaUsuariosState();
}

class _TelaUsuariosState extends State<TelaUsuarios> {
  late Future<List<Usuario>> usuarios;

  @override
  void initState() {
    super.initState();
    usuarios = ApiService.buscarUsuarios();
  }

  void atualizarLista() {
    setState(() {
      usuarios = ApiService.buscarUsuarios();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // CABEÇALHO
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 25),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [roxoEscuro, roxo],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(11),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.people_alt_rounded,
                          color: Colors.white,
                          size: 27,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ADM USERS',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.3,
                              ),
                            ),
                            Text(
                              'Gerenciamento de usuários',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.cloud_done_rounded,
                        color: Colors.white,
                        size: 25,
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Bem-vindo!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Confira os usuários carregados pela API.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // CONTEÚDO
            Expanded(
              child: FutureBuilder<List<Usuario>>(
                future: usuarios,
                builder: (context, snapshot) {

                  // CARREGAMENTO
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: roxo,
                      ),
                    );
                  }

                  // ERRO
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.cloud_off_rounded,
                              size: 65,
                              color: roxo,
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              'Não foi possível carregar!',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${snapshot.error}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: atualizarLista,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Tentar novamente'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final lista = snapshot.data ?? [];

                  // LISTA VAZIA
                  if (lista.isEmpty) {
                    return const Center(
                      child: Text('Nenhum usuário encontrado.'),
                    );
                  }

                  return Column(
                    children: [
                      // CONTADOR
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          20, 22, 20, 12,
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Seus usuários',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: roxoEscuro,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 13,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: lavanda,
                                borderRadius:
                                    BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${lista.length} cadastrados',
                                style: const TextStyle(
                                  color: roxo,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // LISTA DINÂMICA
                      Expanded(
                        child: RefreshIndicator(
                          color: roxo,
                          onRefresh: () async {
                            final novaLista =
                                ApiService.buscarUsuarios();

                            setState(() {
                              usuarios = novaLista;
                            });

                            await novaLista;
                          },
                          child: ListView.builder(
                            physics:
                                const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(
                              16, 5, 16, 20,
                            ),
                            itemCount: lista.length,
                            itemBuilder: (context, index) {
                              final usuario = lista[index];

                              return Card(
                                elevation: 2,
                                shadowColor:
                                    roxo.withOpacity(0.12),
                                color: Colors.white,
                                margin: const EdgeInsets.only(
                                  bottom: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(18),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // NOME E AVATAR
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 25,
                                            backgroundColor: lavanda,
                                            child: Text(
                                              usuario.nome.isNotEmpty
                                                  ? usuario.nome[0]
                                                      .toUpperCase()
                                                  : '?',
                                              style: const TextStyle(
                                                color: roxo,
                                                fontSize: 20,
                                                fontWeight:
                                                    FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 13),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  usuario.nome,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    color: roxoEscuro,
                                                  ),
                                                ),
                                                const SizedBox(height: 3),
                                                Text(
                                                  'Usuário #${usuario.id}',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black45,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Icon(
                                            Icons.verified_user_rounded,
                                            color: roxo,
                                            size: 21,
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 15),
                                      const Divider(height: 1),
                                      const SizedBox(height: 13),

                                      // INFORMAÇÕES
                                      _Informacao(
                                        icone: Icons.email_outlined,
                                        texto: usuario.email,
                                      ),
                                      const SizedBox(height: 9),

                                      _Informacao(
                                        icone: Icons.location_on_outlined,
                                        texto: usuario.cidade,
                                      ),
                                      const SizedBox(height: 9),

                                      _Informacao(
                                        icone: Icons.phone_outlined,
                                        texto: usuario.telefone,
                                      ),
                                      const SizedBox(height: 9),

                                      _Informacao(
                                        icone: Icons.business_outlined,
                                        texto: usuario.empresa,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// WIDGET PARA EXIBIR AS INFORMAÇÕES
class _Informacao extends StatelessWidget {
  final IconData icone;
  final String texto;

  const _Informacao({
    required this.icone,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icone,
          color: roxo,
          size: 18,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            texto,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }
}
