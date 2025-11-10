import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/services/djelia_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _urlController = TextEditingController();
  bool _isTestingConnection = false;
  String? _connectionStatus;
  
  @override
  void initState() {
    super.initState();
    _loadSavedUrl();
  }
  
  Future<void> _loadSavedUrl() async {
    final url = await DjeliaService.baseUrl;
    _urlController.text = url;
  }
  
  Future<void> _saveUrl() async {
    await DjeliaService.saveCustomUrl(_urlController.text);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ URL sauvegardée !'), backgroundColor: Colors.green),
      );
    }
  }
  
  Future<void> _resetToDefault() async {
    await DjeliaService.clearCustomUrl();
    await _loadSavedUrl();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ URL réinitialisée !'), backgroundColor: Colors.blue),
      );
    }
  }
  
  Future<void> _testConnection() async {
    setState(() {
      _isTestingConnection = true;
      _connectionStatus = null;
    });
    
    try {
      // Sauvegarder temporairement l'URL pour le test
      await DjeliaService.saveCustomUrl(_urlController.text);
      
      // Test simple
      final url = await DjeliaService.baseUrl;
      final response = await http.get(
        Uri.parse('$url/health'),
      ).timeout(const Duration(seconds: 10));
      
      setState(() {
        _connectionStatus = response.statusCode == 200
            ? '✅ Connexion réussie !'
            : '❌ Erreur : ${response.statusCode}';
        _isTestingConnection = false;
      });
    } catch (e) {
      setState(() {
        _connectionStatus = '❌ Échec : $e';
        _isTestingConnection = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres Djelia AI'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Configuration du serveur',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 20),
            
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'URL du backend',
                hintText: 'http://10.0.2.2:8080/api/djelia',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.link),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Exemples d'URL
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Exemples d\'URL :', 
                         style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                    const SizedBox(height: 8),
                    Text('🌐 Web : http://localhost:8080/api/djelia', 
                         style: TextStyle(color: textColor)),
                    Text('📱 Émulateur : http://10.0.2.2:8080/api/djelia', 
                         style: TextStyle(color: textColor)),
                    Text('📱 Réel : http://192.168.1.100:8080/api/djelia', 
                         style: TextStyle(color: textColor)),
                    const SizedBox(height: 8),
                    Text('💡 Trouvez votre IP avec ipconfig (Windows) ou ifconfig (Mac/Linux)', 
                         style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey[700])),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            ElevatedButton.icon(
              onPressed: _isTestingConnection ? null : _testConnection,
              icon: _isTestingConnection
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.wifi_find),
              label: const Text('Tester la connexion'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.blue,
              ),
            ),
            
            if (_connectionStatus != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  _connectionStatus!,
                  style: TextStyle(
                    fontSize: 16,
                    color: _connectionStatus!.contains('✅') ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            
            const SizedBox(height: 12),
            
            ElevatedButton.icon(
              onPressed: _saveUrl,
              icon: const Icon(Icons.save),
              label: const Text('Enregistrer'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.orange,
              ),
            ),
            
            const SizedBox(height: 12),
            
            OutlinedButton.icon(
              onPressed: _resetToDefault,
              icon: const Icon(Icons.restore),
              label: const Text('Réinitialiser par défaut'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                foregroundColor: Colors.grey[700],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Guide rapide
            Card(
              color: Colors.orange[50],
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lightbulb, color: Colors.orange),
                        const SizedBox(width: 8),
                        Text('Guide rapide', 
                             style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('📱 Pour appareil Android réel :', 
                         style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                    const SizedBox(height: 4),
                    Text('1. Connectez PC et téléphone au même WiFi', 
                         style: TextStyle(color: textColor)),
                    Text('2. Trouvez l\'IP de votre PC (ipconfig ou ifconfig)', 
                         style: TextStyle(color: textColor)),
                    Text('3. Entrez l\'URL : http://VOTRE_IP:8080/api/djelia', 
                         style: TextStyle(color: textColor)),
                    Text('4. Testez puis sauvegardez', 
                         style: TextStyle(color: textColor)),
                    const SizedBox(height: 12),
                    Text('⚠️ N\'oubliez pas d\'autoriser Java dans le pare-feu Windows !', 
                         style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.red)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }
}

