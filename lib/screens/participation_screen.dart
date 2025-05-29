import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:huert/utils/colors.dart';
import 'package:huert/widgets/custom_header.dart';

class ParticipacionesScreen extends StatelessWidget {
  const ParticipacionesScreen({super.key});

  Future<List<Map<String, dynamic>>> obtenerParticipaciones() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final data = doc.data();

    if (data == null || data['participaciones'] == null) return [];

    final participaciones = List<Map<String, dynamic>>.from(data['participaciones']);
    return participaciones.reversed.toList(); // Muestra lo más reciente primero
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Mis Participaciones',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.accent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: obtenerParticipaciones(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.accent));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No tienes participaciones registradas.',
                style: TextStyle(color: AppColors.textLight),
              ),
            );
          }

          final participaciones = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // const Text(text: 'Historial de Participaciones'),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: participaciones.length,
                    itemBuilder: (context, index) {
                      final p = participaciones[index];

                      return Card(
                        color: AppColors.background,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p['parcela'] ?? 'Parcela desconocida',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text('Actividad: ${p['actividad'] ?? 'No especificada'}'),
                              Text('Horas: ${p['horas'] ?? 0}'),
                              Text('Fecha: ${p['fecha'] ?? '-'}'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
