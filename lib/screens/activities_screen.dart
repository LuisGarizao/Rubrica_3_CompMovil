import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Actividades extends StatefulWidget {
  final Map<String, dynamic> parcela;
  const Actividades({super.key, required this.parcela});

  @override
  State<Actividades> createState() => _ActividadesState();
}

class _ActividadesState extends State<Actividades> {
  bool mostrarFormulario = false;
  String? actividadSeleccionada;
  int horasSemanales = 6;

  List<Map<String, dynamic>> participaciones = [];

  @override
  Widget build(BuildContext context) {
    final parcela = widget.parcela;

    return Scaffold(
      appBar: AppBar(title: Text(parcela['nombre'] ?? 'Parcela')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nombre: ${parcela['nombre']}'),
            Text('Tamaño: ${parcela['tamanoHa']} ha (${parcela['tamanoM2']} m²)'),
            Text('Categoría: ${parcela['categoria']}'),
            Text('Producto: ${parcela['producto']}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  mostrarFormulario = !mostrarFormulario;
                });
              },
              child: const Text('Participar'),
            ),
            if (mostrarFormulario) ...[
              const SizedBox(height: 20),
              const Text('Actividad:', style: TextStyle(fontWeight: FontWeight.bold)),
              Column(
                children: ['siembra', 'cosecha', 'mantenimiento', 'otros'].map((actividad) {
                  return RadioListTile<String>(
                    title: Text(actividad[0].toUpperCase() + actividad.substring(1)),
                    value: actividad,
                    groupValue: actividadSeleccionada,
                    onChanged: (value) {
                      setState(() {
                        actividadSeleccionada = value;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('Horas semanales:'),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        if (horasSemanales > 6) horasSemanales--;
                      });
                    },
                  ),
                  Text(horasSemanales.toString()),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        horasSemanales++;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: actividadSeleccionada == null
                    ? null
                    : () {
                        setState(() {
                          participaciones.add({
                            'parcela': parcela['nombre'],
                            'actividad': actividadSeleccionada,
                            'horas': horasSemanales,
                          });
                          // Reiniciar formulario
                          mostrarFormulario = false;
                          actividadSeleccionada = null;
                          horasSemanales = 6;
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Participación registrada.')),
                        );
                      },
                child: const Text('Guardar participación'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
