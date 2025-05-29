import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'zones_screen.dart';
import '../widgets/custom_header.dart';
import '../utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // const nombreUsuario = 'Luis Perez'; // Placeholder por ahora

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomHeader(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCard(
              context,
              titulo: 'Zonas de cultivo',
              descripcion:
                  'Visualiza y explora las distintas parcelas del huerto, con información como responsable y estado actual.',
              // color: const Color(0xFFE6F4EA),
              ruta: '/zonas',
            ),
            const SizedBox(height: 16),
            _buildCard(
              context,
              titulo: 'Mi Participación',
              descripcion:
                  'Consulta tu historial de actividades en el huerto, el tiempo dedicado y tareas realizadas.',
              // color: Color(0xFFFFF9C4),
              ruta: '/participacion',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String titulo,
    required String descripcion,
    // required Color color,
    required String ruta,
  }) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, ruta);
        if (ruta == '/zonas') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ZonasPage()),
          );
        } else {

        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    descripcion,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF424242),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // const Icon(Icons.ve, size: 48),
          ],
        ),
      ),
    );
  }
}
