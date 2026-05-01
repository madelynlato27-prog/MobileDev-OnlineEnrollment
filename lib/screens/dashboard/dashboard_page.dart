import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onlineenrollment/screens/info/about_page.dart';
import 'package:onlineenrollment/screens/info/contact_page.dart';
import 'package:onlineenrollment/screens/info/courses_page.dart';
import 'package:onlineenrollment/screens/info/admission_page.dart';
import 'package:onlineenrollment/screens/widgets/page_header.dart';
import 'package:onlineenrollment/screens/dashboard/profile_page.dart';
import 'package:onlineenrollment/services/api_service.dart';
import 'package:onlineenrollment/screens/widgets/dashboard_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic>? _studentData;
  bool _isLoading = true;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DashboardContent(studentData: _studentData, isLoading: _isLoading),
      const AboutPage(),
      const CoursesPage(),
      const ContactPage(),
      const AdmissionPage(),
    ];
    _loadStudentData();
  }

  Future<void> _loadStudentData() async {
    try {
      final studentId = await ApiService.getStudentId();
      if (studentId != null) {
        final response = await ApiService.getStudent(studentId);
        if (response['status'] == 200 && response['data'] != null) {
          setState(() {
            _studentData = response['data'];
            _isLoading = false;
            _pages[0] = DashboardContent(
              studentData: _studentData,
              isLoading: _isLoading,
            );
          });
        } else {
          setState(() => _isLoading = false);
        }
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error loading student data: $e');
      setState(() => _isLoading = false);
    }
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProfilePage(studentData: _studentData, isLoading: _isLoading),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          PageHeader(
            showBackButton: false,
            onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
      drawer: _buildDrawer(context),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 180,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2901B7), Color(0xFF4A2FBD)],
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _navigateToProfile,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: _navigateToProfile,
                      child: Column(
                        children: [
                          Text(
                            _isLoading
                                ? 'Loading...'
                                : '${_studentData?['firstName'] ?? ''} ${_studentData?['lastName'] ?? ''}',
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'ID: ${_studentData?['studentID'] ?? 'N/A'}',
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildDrawerItem(Icons.dashboard, 'Dashboard', 0),
            _buildDrawerItem(Icons.info, 'About', 1),
            _buildDrawerItem(Icons.school, 'Courses', 2),
            _buildDrawerItem(Icons.phone, 'Contact', 3),
            _buildDrawerItem(Icons.description, 'Admission', 4),
            const Divider(height: 24, thickness: 1),
            _buildDrawerItem(Icons.logout, 'Logout', -1, isLogout: true),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    IconData icon,
    String title,
    int index, {
    bool isLogout = false,
  }) {
    final isSelected = _selectedIndex == index;
    return ListTile(
      leading: Icon(
        icon,
        color: isLogout
            ? Colors.red
            : (isSelected ? const Color(0xFF2901B7) : Colors.grey[700]),
      ),
      title: Text(
        title,
        style: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isLogout
              ? Colors.red
              : (isSelected ? const Color(0xFF2901B7) : Colors.grey[800]),
        ),
      ),
      onTap: () {
        if (isLogout) {
          Navigator.pop(context);
          _showLogoutDialog(context);
        } else {
          Navigator.pop(context);
          setState(() => _selectedIndex = index);
        }
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.logout, color: Colors.red, size: 28),
            SizedBox(width: 10),
            Text('Confirm Logout'),
          ],
        ),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ApiService.logout();
              Navigator.of(ctx).pop();
              Navigator.pushReplacementNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

// Dashboard Content Widget
class DashboardContent extends StatelessWidget {
  final Map<String, dynamic>? studentData;
  final bool isLoading;

  const DashboardContent({super.key, this.studentData, this.isLoading = false});

  final List<Map<String, dynamic>> _dashboardItems = const [
    {
      'title': 'Enroll Now',
      'icon': Icons.school,
      'color': Color(0xFF4A90E2),
      'gradient': [Color(0xFF4A90E2), Color(0xFF357ABD)],
      'route': '/enroll-old',
      'description': 'Start your enrollment process',
    },
    {
      'title': 'My Subjects',
      'icon': Icons.book,
      'color': Color(0xFF27AE60),
      'gradient': [Color(0xFF27AE60), Color(0xFF229954)],
      'route': '/my-subjects',
      'description': 'View your enrolled subjects',
    },
    {
      'title': 'Schedule',
      'icon': Icons.calendar_today,
      'color': Color(0xFFE67E22),
      'gradient': [Color(0xFFE67E22), Color(0xFFD35400)],
      'route': null,
      'description': 'Check your class schedule',
    },
    {
      'title': 'Profile',
      'icon': Icons.person,
      'color': Color(0xFF9B59B6),
      'gradient': [Color(0xFF9B59B6), Color(0xFF8E44AD)],
      'route': null,
      'description': 'View and manage your profile',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final dashboardState = context
        .findAncestorStateOfType<_DashboardPageState>();

    return Container(
      color: Colors.grey.shade50,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF2901B7).withOpacity(0.1),
                    const Color(0xFF4A2FBD).withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.school,
                      color: Color(0xFF2901B7),
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2901B7),
                          ),
                        ),
                        if (!isLoading && studentData != null)
                          Text(
                            '${studentData?['firstName'] ?? ''} ${studentData?['lastName'] ?? ''}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        else
                          const Text(
                            'Enrollment System',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF2901B7),
                    ),
                    onPressed: () => dashboardState?._navigateToProfile(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Quick Actions',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select an option to proceed',
              style: GoogleFonts.roboto(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
              children: _dashboardItems.map((item) {
                return DashboardCard(
                  title: item['title'] as String,
                  icon: item['icon'] as IconData,
                  color: item['color'] as Color,
                  gradient: (item['gradient'] as List).cast<Color>(),
                  route: item['title'] == 'Profile'
                      ? null
                      : item['route'] as String?,
                  description: item['description'] as String,
                  onTap: item['title'] == 'Profile'
                      ? () => dashboardState?._navigateToProfile()
                      : null,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
