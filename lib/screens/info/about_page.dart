import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    // Return content directly - NO PageHeader here
    return _selectedIndex == -1 ? _buildMainPage() : _buildDetailPage();
  }

  String _getTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'MISSION AND VISION';
      case 1:
        return 'SCHOOL HYMN';
      default:
        return 'ABOUT';
    }
  }

  Widget _buildMainPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFF2901B7), const Color(0xFF4A2FBD)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'AMA Computer Learning Center (ACLC) is a leading computer training institution in the country offering full 2-year programs and short-term courses. It is focused on producing highly competent and skilled graduates to address the growing needs of the local and international markets.',
              style: GoogleFonts.roboto(
                fontSize: 14,
                height: 1.6,
                color: Colors.white,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          const SizedBox(height: 30),
          _buildClickableText('MISSION AND VISION', 0),
          const SizedBox(height: 20),
          _buildClickableText('SCHOOL HYMN', 1),
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
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          text,
          style: GoogleFonts.montserrat(
            fontSize: 18,
            color: const Color(0xFF2901B7),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getTitle(),
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2901B7),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _selectedIndex = -1;
            });
          },
        ),
      ),
      body: _getDetailContent(),
    );
  }

  Widget _getDetailContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildMissionVisionPage();
      case 1:
        return _buildHymnPage();
      default:
        return const Center(child: Text('Page not found'));
    }
  }

  Widget _buildMissionVisionPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF2901B7).withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MISSION',
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2901B7),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'To provide a holistic, relevant, quality and globally recognized IT-based education in all levels and disciplines with the objective of producing professionals and leaders responsive to the needs of Science and the international community.',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF2901B7).withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'VISION',
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2901B7),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'To be the leader and dominant provider of relevant globally recognized information technology-based education and related services in the global market.',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHymnPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFF2901B7).withOpacity(0.05), const Color(0xFF4A2FBD).withOpacity(0.05)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(
              'AMA HYMN',
              style: GoogleFonts.montserrat(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2901B7),
              ),
            ),
            const SizedBox(height: 24),
            _buildHymnStanza('You put us in mold dear Alma Mater\nyou hold the future in this race against time'),
            _buildHymnStanza('Through the years in your folds\nwe nurture our dreams our promise to you the toast is for you'),
            _buildHymnStanza('Dear Alma Mater you have given us\n arms for the battles of life and the conquest of our dreams'),
            _buildHymnStanza('Oh, dear AMA\nyou have sharpened\n our minds we will triumph by which the toast is for you'),
            _buildHymnStanza('The light up ahead is victory\n foreseen with noble desires we behold its gleam'),
            _buildHymnStanza('Our motherland lays her hopes\n on the youth the future that we hold is her hope that unfolds'),
             _buildHymnStanza('Repeat Refrain '),

          ],
        ),
      ),
    );
  }

  Widget _buildHymnStanza(String lyrics) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        lyrics,
        textAlign: TextAlign.center,
        style: GoogleFonts.roboto(
          fontStyle: FontStyle.italic,
          fontSize: 14,
          height: 1.6,
        ),
      ),
    );
  }
}