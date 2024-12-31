import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'sql_helper.dart';
import 'auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _auth = AuthService();
  List<Map<String, dynamic>> _diaries = [];
  File? _image;

  bool _isLoading = true;
  final bool _isDarkMode = false;
  final String _userName = 'User';
  final int _userAge = 25;
  File? _profileImage;

  String _selectedFeeling = 'Happy';
  final Map<String, String> _feelings = {
    'Happy': 'assets/happy.png',
    'Sad': 'assets/sad.png',
    'Angry': 'assets/angry.png',
    'Anxious': 'assets/anxious.png',
    'Scared': 'assets/scared.png',
    'Bored': 'assets/bored.png',
  };

  final String _selectedFont = 'SFPro';

  void _refreshDiaries() async {
    final data = await SQLHelper.getDiaries();
    setState(() {
      _diaries = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshDiaries();
  }

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  void _showForm(int? id) async {
    if (id != null) {
      final existingDiary = _diaries.firstWhere((element) => element['id'] == id);
      _selectedFeeling = existingDiary['feeling'];
      _descriptionController.text = existingDiary['description'];
      if (existingDiary['image'] != null) {
        _image = File(existingDiary['image']);
      }
    } else {
      _selectedFeeling = _feelings.keys.first;
      _descriptionController.clear();
      _image = null;
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Container(
            padding: EdgeInsets.only(
              top: 15,
              left: 15,
              right: 15,
              bottom: MediaQuery.of(context).viewInsets.bottom + 120,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    DropdownButton<String>(
                      value: _selectedFeeling,
                      items: _feelings.keys.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: TextStyle(fontFamily: _selectedFont)),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setModalState(() {
                          _selectedFeeling = newValue!;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(hintText: 'Description'),
                  style: TextStyle(
                    fontFamily: _selectedFont,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _image == null
                        ? const Text('No image selected.')
                        : Image.file(
                            _image!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                    IconButton(
                      icon: const Icon(Icons.photo),
                      onPressed: () async {
                        final pickedFile =
                            await ImagePicker().pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          setModalState(() {
                            _image = File(pickedFile.path);
                          });
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.camera),
                      onPressed: () async {
                        final pickedFile =
                            await ImagePicker().pickImage(source: ImageSource.camera);
                        if (pickedFile != null) {
                          setModalState(() {
                            _image = File(pickedFile.path);
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (id == null) {
                      await _addDiary();
                    } else {
                      await _updateDiary(id);
                    }
                    _descriptionController.text = '';
                    _image = null;
                    Navigator.of(context).pop();
                  },
                  child: Text(id == null ? 'Create New' : 'Update'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _addDiary() async {
    String? imagePath = _image?.path;
    await SQLHelper.createDiary(
      _selectedFeeling,
      _descriptionController.text,
      imagePath,
    );
    _refreshDiaries();
  }

  Future<void> _updateDiary(int id) async {
    String? imagePath = _image?.path;
    await SQLHelper.updateDiary(
      id,
      _selectedFeeling,
      _descriptionController.text,
      imagePath,
    );
    _refreshDiaries();
  }

  Future<void> _deleteDiary(int id) async {
    await SQLHelper.deleteDiary(id);
    _refreshDiaries();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        primaryColor: Colors.pink[200],
        scaffoldBackgroundColor: _isDarkMode ? const Color(0xFFFFE4E1) : Colors.white,
        cardColor: _isDarkMode ? const Color(0xFFFFDAB9) : Colors.white,
        textTheme: TextTheme(
          bodyLarge: TextStyle(
              color: _isDarkMode ? Colors.white : Colors.black,
              fontFamily: _selectedFont),
          bodyMedium: TextStyle(
              color: _isDarkMode ? Colors.white70 : Colors.black87,
              fontFamily: _selectedFont),
          titleLarge: TextStyle(
              color: _isDarkMode ? Colors.white : Colors.black,
              fontFamily: _selectedFont),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "$_userName's Diary",
            style: TextStyle(fontFamily: _selectedFont),
          ),
          backgroundColor: Colors.pink[200],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _diaries.length,
                itemBuilder: (context, index) {
                  final diary = _diaries[index];
                  return Card(
                    child: ListTile(
                      title: Text(diary['feeling']),
                      subtitle: Text(diary['description']),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
