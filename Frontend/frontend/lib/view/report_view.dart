import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/routing/app_routing.dart';
import 'package:frontend/view/dashboard.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF4338CA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4338CA),
          primary: const Color(0xFF4338CA),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF4338CA),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4338CA),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const report_view(),
    );
  }
}

class report_view extends StatefulWidget {
  const report_view({Key? key}) : super(key: key);

  @override
  State<report_view> createState() => _report_viewState();
}

class _report_viewState extends State<report_view> {
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedTopic;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final List<String> _topics = [
    'Parkir menghalangi akses/jalan',
    'Parkir di zona terlarang',
    'Parkir paralel',
    'Penggunaan slot khusus tanpa izin',
    'Penggunaan slot parkir lebih dari satu',
  ];

  Future<void> _getImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _getImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _getImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Make a Report'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            AppRouter.goBack(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'See or stuck in a frustrating parking situation? Report it here!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              // Topic Dropdown
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF4338CA),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton<String>(
                      dropdownColor: Colors.white,
                      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                      hint: const Text(
                        'Select Topic',
                        style: TextStyle(color: Colors.white),
                      ),
                      value: _selectedTopic,
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedTopic = newValue;
                        });
                      },
                      selectedItemBuilder: (BuildContext context) {
                        return _topics.map<Widget>((String item) {
                          return Center(
                            child: Text(
                              'Select Topic',
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList();
                      },
                      items: _topics.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Image Upload Area
              GestureDetector(
                onTap: _showImageSourceActionSheet,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _image == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4338CA),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Take or Select Image',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _image!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Description Field
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _descriptionController,
                  maxLength: 50,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Description (Optional)',
                    contentPadding: EdgeInsets.all(16),
                    border: InputBorder.none,
                    counterText: '',
                  ),
                  onChanged: (text) {
                    setState(() {});
                  },
                ),
              ),
              
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${_descriptionController.text.length}/50',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Info Text
              const Text(
                'Parkiri is here to help take action on parking violations that make the roads messy. Just fill out the form!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Submit Button
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle submit
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBBB7FA),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}