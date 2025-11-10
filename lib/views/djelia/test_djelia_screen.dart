import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' if (dart.library.html) 'dart:html';
import '../../core/widgets/icone_haut_parleur.dart';
import '../../core/services/djelia_service.dart';

class TestDjeliaScreen extends StatefulWidget {
  const TestDjeliaScreen({super.key});

  @override
  State<TestDjeliaScreen> createState() => _TestDjeliaScreenState();
}

class _TestDjeliaScreenState extends State<TestDjeliaScreen> {
  final TextEditingController _controller = TextEditingController(
    text: "Bonjour, comment allez-vous?",
  );
  
  String _platformInfo = '';
  String _urlInfo = '';
  bool _connectionOk = false;
  bool _isTestingConnection = false;
  
  @override
  void initState() {
    super.initState();
    _loadPlatformInfo();
    _testConnection();
  }
  
  void _loadPlatformInfo() async {
    String platform = 'Inconnue';
    if (kIsWeb) {
      platform = '🌐 Web (Chrome)';
    } else if (Platform.isAndroid) {
      platform = '📱 Android';
    } else if (Platform.isIOS) {
      platform = '🍎 iOS';
    }
    
    final url = await DjeliaService.baseUrl;
    
    setState(() {
      _platformInfo = platform;
      _urlInfo = url;
    });
  }
  
  Future<void> _testConnection() async {
    setState(() => _isTestingConnection = true);
    final ok = await DjeliaService.testConnection();
    setState(() {
      _connectionOk = ok;
      _isTestingConnection = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Djelia AI'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Informations plateforme
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ℹ️ Informations', 
                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                    const Divider(),
                    Text('Plateforme : $_platformInfo', style: TextStyle(color: textColor)),
                    const SizedBox(height: 8),
                    Text('URL Backend : $_urlInfo', style: TextStyle(color: textColor)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('Connexion : ', style: TextStyle(color: textColor)),
                        if (_isTestingConnection)
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        else
                          Icon(
                            _connectionOk ? Icons.check_circle : Icons.error,
                            color: _connectionOk ? Colors.green : Colors.red,
                          ),
                        const SizedBox(width: 8),
                        Text(_connectionOk ? 'OK' : 'Échec', style: TextStyle(color: textColor)),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.refresh, size: 20),
                          onPressed: _testConnection,
                          tooltip: 'Retester la connexion',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Champ de test
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        labelText: 'Texte en français',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Cliquez sur le haut-parleur →',
                            style: TextStyle(fontSize: 16, color: textColor),
                          ),
                        ),
                        IconeHautParleur(
                          texteFrancais: _controller.text,
                          couleur: Colors.orange,
                          taille: 32,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Exemples rapides
            Text('Exemples rapides :', 
                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 12),
            
            _buildExampleCard('Bonjour'),
            _buildExampleCard('Merci beaucoup'),
            _buildExampleCard('Comment allez-vous?'),
            _buildExampleCard('Bienvenue dans FasoDocs'),
            _buildExampleCard('Où se trouve le bureau?'),
            _buildExampleCard('Quel est le montant à payer?'),
          ],
        ),
      ),
    );
  }
  
  Widget _buildExampleCard(String texte) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(texte),
        trailing: IconeHautParleur(
          texteFrancais: texte,
          couleur: Colors.orange,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

