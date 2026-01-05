import 'package:flutter/material.dart';
import '../services/izin_service.dart';
import '../models/izin_model.dart';

class IzinPage extends StatefulWidget {
  const IzinPage({super.key});

  @override
  State<IzinPage> createState() => _IzinPageState();
}

class _IzinPageState extends State<IzinPage> {
  List<IzinModel> izinList = [];
  final TextEditingController alasanController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadIzin();
  }

  Future<void> loadIzin() async {
    try {
      final data = await IzinService.getIzin();
      setState(() {
        izinList = data;
      });
    } catch (e) {
      print("Error load izin: $e");
    }
  }

  Future<void> submitIzin() async {
    try {
      final success = await IzinService.ajukanIzin(alasan: alasanController.text);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Izin berhasil diajukan")),
        );
        alasanController.clear();
        loadIzin(); // refresh
      }
    } catch (e) {
      print("Error ajukan izin: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal ajukan izin: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Izin PKL")),
      body: Column(
        children: [
          TextField(
            controller: alasanController,
            decoration: const InputDecoration(labelText: "Alasan izin"),
          ),
          ElevatedButton(
            onPressed: submitIzin,
            child: const Text("Ajukan Izin"),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: izinList.length,
              itemBuilder: (context, index) {
                final izin = izinList[index];
                return ListTile(
                  title: Text(izin.alasan),
                  subtitle: Text("Tanggal: ${izin.tanggal} | Status: ${izin.status}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
