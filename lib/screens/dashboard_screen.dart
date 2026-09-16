import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // 📊 Contadores (Lógica das metas)
  int aguaConsumida = 0;
  final int aguaMeta = 2000;

  int passosDados = 0;
  final int passosMeta = 10000;

  int _indiceAba = 0;

  void adicionarAgua(int quantidade) {
    setState(() {
      aguaConsumida += quantity;
    });
  }

  void adicionarPassos(int quantidade) {
    setState(() {
      passosDados += quantidade;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🗓️ Cabeçalho igual ao Figma
              const Text(
                'Quarta-Feira, 16 de Setembro',
                style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              const Text(
                'Boa noite 👋',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 24),

              // 💧 CARD DA ÁGUA
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '💧 ÁGUA',
                              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$aguaConsumida ml',
                              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                            ),
                            Text(
                              'meta: $aguaMeta ml',
                              style: const TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ],
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator(
                                value: (aguaConsumida / aguaMeta).clamp(0.0, 1.0),
                                strokeWidth: 6,
                                backgroundColor: Colors.blue.withOpacity(0.1),
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                              ),
                            ),
                            Text(
                              '${((aguaConsumida / aguaMeta) * 100).toInt()}%',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _botaoIncremento('+150ml', () => adicionarAgua(150), Colors.blue),
                        _botaoIncremento('+250ml', () => adicionarAgua(250), Colors.blue),
                        _botaoIncremento('+350ml', () => adicionarAgua(350), Colors.blue),
                        _botaoIncremento('+500ml', () => adicionarAgua(500), Colors.blue),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 👟 CARD DOS PASSOS
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '👟 PASSOS',
                              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$passosDados',
                              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                            ),
                            Text(
                              'meta: $passosMeta passos',
                              style: const TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ],
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator(
                                value: (passosDados / passosMeta).clamp(0.0, 1.0),
                                strokeWidth: 6,
                                backgroundColor: Colors.green.withOpacity(0.1),
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                              ),
                            ),
                            Text(
                              '${((passosDados / passosMeta) * 100).toInt()}%',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _botaoIncremento('+500', () => adicionarPassos(500), Colors.green),
                        _botaoIncremento('+1k', () => adicionarPassos(1000), Colors.green),
                        _botaoIncremento('+2k', () => adicionarPassos(2000), Colors.green),
                        _botaoIncremento('+5k', () => adicionarPassos(5000), Colors.green),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              if (aguaConsumida >= aguaMeta)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.blue),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Incrível! Meta de água atingida hoje.',
                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAba,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          setState(() {
            _indiceAba = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'Histórico'),
        ],
      ),
    );
  }

  Widget _botaoIncremento(String texto, VoidCallback aoClicar, Color cor) {
    return ElevatedButton(
      onPressed: aoClicar,
s      style: ElevatedButton.styleFrom(
        backgroundColor: cor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(
        texto,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}