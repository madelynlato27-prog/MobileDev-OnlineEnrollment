import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  int _selectedIndex = -1; // -1 = main page, 0 = mission, 1 = chairman, etc.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
        leading: _selectedIndex != -1
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _selectedIndex = -1; // Go back to main page
                  });
                },
              )
            : null,
      ),
      body: _selectedIndex == -1 ? _buildMainPage() : _buildDetailPage(),
    );
  }

  String _getTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'MISSION AND VISION';
      case 1:
        return 'CHAIRMAN OFFICE';
      case 2:
        return 'SCHOOL HYMN';
     
      default:
        return 'ABOUT';
    }
  }

  // Main Page with Clickable Text
  Widget _buildMainPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Text(
              'AMA Computer Learning Center (ACLC) is a leading computer training institution in the country offering full 2-year programs and short-term courses. It is focused on producing highly competent and skilled graduates to address the growing needs of the local and international markets.',
              style: TextStyle(fontSize: 14, height: 1.6),
              textAlign: TextAlign.justify,
            ),
          ),
          const SizedBox(height: 30),
          _buildClickableText('MISSION AND VISION', 0),
          const SizedBox(height: 15),
          _buildClickableText('OFFICE OF THE CHAIRMAN AND VICE CHAIRMAN', 1),
          const SizedBox(height: 15),
          _buildClickableText('SCHOOL HYMN', 2),
          
        ],
      ),
    );
  }

  Widget _buildClickableText(String text, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.blue,
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Detail Page based on selected index
  Widget _buildDetailPage() {
    switch (_selectedIndex) {
      case 0:
        return _buildMissionVisionPage();
      case 1:
        return _buildChairmanPage();
      case 2:
        return _buildHymnPage();
    
      default:
        return const Center(child: Text('Page not found'));
    }
  }

  // Mission and Vision Page
  Widget _buildMissionVisionPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MISSION',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const SizedBox(height: 10),
          const Text(
            'To provide a holistic, relevant, quality and globally recognized IT-based education in all levels and disciplines with the objective of producing professionals and leaders responsive to the needs of Science and the international community.',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 30),
          const Text(
            'VISION',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const SizedBox(height: 10),
          const Text(
            'To be the leader and dominant provider of relevant globally recognized information technology-based education and related services in the global market.',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }

  // Chairman Page
  Widget _buildChairmanPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildPersonCard('Dr. Amable R. Aguiluz V', 'Chairman', Icons.person),
          const SizedBox(height: 15),
          _buildPersonCard('Dr. Bella C. Aguiluz', 'Vice Chairman', Icons.person),
        ],
      ),
    );
  }

  Widget _buildPersonCard(String name, String position, IconData icon) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(child: Icon(icon)),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(position, style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Hymn Page
  Widget _buildHymnPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            const Text('AMA HYMN', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildHymnStanza('You put us in mold dear Alma Mater\nyou hold the future in this race against time'),
            _buildHymnStanza('Through the years in your folds\nwe nurture our dreams our promise to you the toast is for you'),
            _buildHymnStanza('Dear Alma Mater you have given us arms\nfor the battles of life and the conquest of our dreams'),
            _buildHymnStanza('Oh, dear AMA\n''you have sharpened our minds\n''we will triumph by which''the toast is for you'),
            _buildHymnStanza('The light up ahead ''is victory foreseen\n''with noble desires\n''we behold its gleam' ),
            _buildHymnStanza('our motherland lays''her hopes on the youth\n''the future that we hold''is her hope that unfolds'),
          ],
        ),
      ),
    );
  }

  Widget _buildHymnStanza(String lyrics) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(lyrics, textAlign: TextAlign.center, style: const TextStyle(fontStyle: FontStyle.italic)),
    );
  }
  

  }