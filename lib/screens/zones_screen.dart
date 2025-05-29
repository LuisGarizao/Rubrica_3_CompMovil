import 'package:huert/screens/activities_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_header.dart';
import '../utils/colors.dart';
import 'zone_register_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class ZonasPage extends StatefulWidget {
  const ZonasPage({super.key});

  @override
  State<ZonasPage> createState() => _ZonasPageState();
}

class _ZonasPageState extends State<ZonasPage> {

  List<Map<String, dynamic>> parcelas = [];

  int? seleccionIndex;

  void eliminarParcela(int index) {
    setState(() {
      parcelas.removeAt(index);
      seleccionIndex = null;
    });
  }

  void navegarARegistro() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ZoneRegister()),
    );
  }

  void obtenerParcelas() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('parcelas').get();

    final listado =
        snapshot.docs.map((doc) {
          final data = doc.data();

          // extraemos con claves exactas y valores por defecto
          final nombre = data['nombre'] as String? ?? '';
          final tamanoHa = (data['tamano'] as num?) ?? 0.0;
          final tamanoM2 = tamanoHa * 10000;
          final categoria = data['categoria'] as String? ?? '';
          final producto = data['tipoCultivo'] as String? ?? '';
          final estado = data['estado'] as String? ?? '';

          return {
            'nombre': nombre,
            'tamanoHa': tamanoHa,
            'tamanoM2': tamanoM2,
            'categoria': categoria,
            'producto': producto,
            'estado': estado,
            'color': AppColors.white,
          };
        }).toList();

    setState(() {
      parcelas = listado;
    });
  }

  @override
  void initState() {
    super.initState();
    obtenerParcelas(); // Tu función se llama apenas entra a la pantalla
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: const CustomHeader(),
      body: ListView.builder(
        itemCount: parcelas.length,
        itemBuilder: (context, index) {
          final parcela = parcelas[index];
          final seleccionada = seleccionIndex == index;

          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Actividades(parcela: parcela,)));
            },
            onLongPress: () {
              setState(() {
                seleccionIndex = index;
              });
            },
            child: Card(
              color: parcela['color'],
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      parcela['nombre'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tamaño: ${parcela['tamanoHa']} ha (${parcela['tamanoM2']} m²)',
                      style: const TextStyle(color: AppColors.textDark),
                    ),
                    Text(
                      parcela['categoria'],
                      style: const TextStyle(color: AppColors.textDark),
                    ),
                    Text(
                      parcela['producto'],
                      style: const TextStyle(color: AppColors.textDark),
                    ),
                    const SizedBox(height: 6),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Disponible',
                        style: TextStyle(color: AppColors.textLight),
                      ),
                    ),
                    if (seleccionada)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () => eliminarParcela(index),
                          icon: const Icon(Icons.delete, color: Colors.red),
                          label: const Text(
                            'Eliminar parcela',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navegarARegistro,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
