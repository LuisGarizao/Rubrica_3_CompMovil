import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huert/utils/colors.dart';
import 'package:huert/widgets/custom_button.dart';

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

  Future<void> registrarParticipacion({
    required String actividad,
    required int horas,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final participacion = {
      'parcela': widget.parcela['nombre'],
      'actividad': actividad,
      'horas': horas,
      'fecha': DateTime.now().toIso8601String().split('T').first,
    };

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {
          'participaciones': FieldValue.arrayUnion([participacion]),
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Participación registrada con éxito!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al registrar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final parcela = widget.parcela;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          parcela['nombre'] ?? 'Parcela',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),

        backgroundColor: AppColors.accent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //
            CustomButton(
              text: "Participar",
              onPressed: () {
                setState(() {
                  mostrarFormulario = !mostrarFormulario;
                });
              },
            ),

            if (mostrarFormulario) ...[
              const SizedBox(height: 20),
              const Text(
                'Actividad:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Column(
                children:
                    ['siembra', 'cosecha', 'mantenimiento', 'otros'].map((
                      actividad,
                    ) {
                      return RadioListTile<String>(
                        title: Text(
                          actividad[0].toUpperCase() + actividad.substring(1),
                        ),
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
                onPressed:
                    actividadSeleccionada == null
                        ? null
                        : () {
                          setState(() {
                            participaciones.add({
                              'parcela': parcela['nombre'],
                              'actividad': actividadSeleccionada,
                              'horas': horasSemanales,
                            });
                            registrarParticipacion(
                              actividad: actividadSeleccionada!,
                              horas: horasSemanales,
                            );

                            // Reiniciar formulario
                            mostrarFormulario = false;
                            actividadSeleccionada = null;
                            horasSemanales = 6;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Participación registrada.'),
                            ),
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
