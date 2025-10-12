import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class FacultyInfoScreen extends StatefulWidget {
  final String teacherName;
  const FacultyInfoScreen({super.key, required this.teacherName});

  @override
  State<FacultyInfoScreen> createState() => _FacultyInfoScreenState();
}

class _FacultyInfoScreenState extends State<FacultyInfoScreen> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.refFromURL('https://teacherlocater-default-rtdb.asia-southeast1.firebasedatabase.app/');
  Map<String, dynamic>? facultyData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFacultyInfo();
  }

  Future<void> _loadFacultyInfo() async {
    try {
      final snapshot = await _databaseRef
          .child('faculty_info')
          .child(widget.teacherName)
          .get();

      if (snapshot.exists) {
        setState(() {
          facultyData = Map<String, dynamic>.from(snapshot.value as Map);
          isLoading = false;
        });
      } else {
        setState(() {
          facultyData = {
            'photoUrl': 'https://via.placeholder.com/150',
            'cabin': 'Not specified',
            'department': 'Not specified',
            'email': 'Not specified',
          };
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading faculty info: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.teacherName}\'s Profile'),
        backgroundColor: Colors.indigo,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Image
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(
                      facultyData?['photoUrl'] ?? 'https://via.placeholder.com/150',
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Faculty Name
                  Text(
                    widget.teacherName,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 32),

                  // Info Cards
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.location_on),
                      title: const Text('Cabin'),
                      subtitle: Text(facultyData?['cabin'] ?? 'Not specified'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.school),
                      title: const Text('Department'),
                      subtitle: Text(facultyData?['department'] ?? 'Not specified'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text('Email'),
                      subtitle: Text(facultyData?['email'] ?? 'Not specified'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}