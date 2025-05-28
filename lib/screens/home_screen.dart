import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/custom_header.dart';
import '../utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _tamanoController = TextEditingController();
  final _estadoController = TextEditingController();

  String? _categoriaSeleccionada;
  String? _tipoCultivoSeleccionado;

  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      setState(() {
        _userName = doc.data()?['name'] ?? 'Usuario';
      });
    }
  }

  Future<void> _registrarParcela() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        await FirebaseFirestore.instance.collection('parcelas').add({
          'nombre': _nombreController.text,
          'tamano': double.parse(_tamanoController.text),
          'categoria': _categoriaSeleccionada,
          'tipoCultivo': _tipoCultivoSeleccionado,
          'estado': _estadoController.text,
          'userId': user?.uid,
          'fecha': Timestamp.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Parcela registrada con éxito')),
        );

        _formKey.currentState!.reset();
        setState(() {
          _categoriaSeleccionada = null;
          _tipoCultivoSeleccionado = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al registrar: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomHeader(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_userName != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  'Hola, $_userName',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre de la parcela',
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Campo requerido'
                                : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _tamanoController,
                    decoration: const InputDecoration(
                      labelText: 'Tamaño (hectáreas)',
                    ),
                    keyboardType: TextInputType.number,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Campo requerido'
                                : null,
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: _categoriaSeleccionada,
                    decoration: const InputDecoration(labelText: 'Categoría'),
                    items:
                        ['Hortaliza', 'Cereal'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged:
                        (val) => setState(() => _categoriaSeleccionada = val),
                    validator:
                        (value) =>
                            value == null ? 'Selecciona una categoría' : null,
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: _tipoCultivoSeleccionado,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de cultivo',
                    ),
                    items:
                        ['Tomate', 'Lechuga'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged:
                        (val) => setState(() => _tipoCultivoSeleccionado = val),
                    validator:
                        (value) =>
                            value == null
                                ? 'Selecciona un tipo de cultivo'
                                : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _estadoController,
                    decoration: const InputDecoration(
                      labelText: 'Estado actual',
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Campo requerido'
                                : null,
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                    ),
                    onPressed: _registrarParcela,
                    child: const Text('Registrar Parcela'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
