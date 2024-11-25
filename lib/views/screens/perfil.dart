import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PerfilView extends StatefulWidget {
  const PerfilView({Key? key}) : super(key: key);

  @override
  State<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  final usr = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          makeInfo(
            name: "Nome de Usuário",
            field: usr.displayName ?? "Não definido",
            func: () {
              showDialog(
                context: context,
                builder: (context) {
                  TextEditingController controller = TextEditingController();
                  return AlertDialog(
                    title: const Text("Alterar Nome de Usuário"),
                    content: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        const Text("Informe o novo nome de usuário"),
                        TextField(
                          decoration: const InputDecoration(
                            hintText: "Nome de usuário",
                          ),
                          controller: controller,
                        )
                      ],
                    ),
                    actions: [
                      FilledButton(
                        onPressed: () {
                          FirebaseAuth.instance.currentUser!
                              .updateDisplayName(controller.value.text);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Nome de usuário atualizado!'),
                            ),
                          );
                          setState(() {});
                        },
                        child: const Text("Alterar"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancelar"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          makeInfo(
            name: "E-mail",
            field: usr.email ?? "Não definido",
          ),
          makeEditable(
            name: "Senha",
            widget: FilledButton(
              onPressed: () {
                FirebaseAuth.instance.sendPasswordResetEmail(email: usr.email!);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('E-mail para redefinir senha enviado!'),
                  ),
                );
              },
              child: const Text("Alterar"),
            ),
          ),
        ],
      ),
    );
  }
}

Widget makeInfo(
    {required String name, required String field, VoidCallback? func}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: const TextStyle(fontSize: 16),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                field,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            if (func != null)
              InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: func,
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.edit),
                ),
              ),
          ],
        ),
      ],
    ),
  );
}

Widget makeEditable({required String name, required Widget widget}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: const TextStyle(fontSize: 16),
        ),
        Row(
          children: [
            Padding(padding: const EdgeInsets.all(8), child: widget),
          ],
        ),
      ],
    ),
  );
}
