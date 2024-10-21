import 'package:flutter/material.dart';
import 'package:puntos_client/util/images.dart';

class ResponseAndWinPage extends StatefulWidget {
  final String? id;
  const ResponseAndWinPage({super.key, this.id});

  @override
  State<ResponseAndWinPage> createState() => _ResponseAndWinPageState();
}

class _ResponseAndWinPageState extends State<ResponseAndWinPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responde y Gana'),
      ),
      body: Container(
        decoration: const BoxDecoration(),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container(
              height: 200,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'tienda $index',
                          style: const TextStyle(color: Colors.black),
                        ),
                        const Text(
                          'responde la encuesta y gana puntos',
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                  ),
                  Image.asset(Images.logotipo),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
