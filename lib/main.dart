import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const StudentInfoApp());
}

class StudentInfoApp extends StatelessWidget {
  const StudentInfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CSS3344 Lab 02',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const StudentProfileScreen(),
    );
  }
}

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  // Kept here so the picks survive switching between portrait and landscape
  DateTime? _selectedDate;
  String _selectedRole = 'Gryffindor';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSS3344 Mobile App Dev - Lab 02'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      // Rebuilds with a different layout whenever the device rotates
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? _buildPortraitView()
              : _buildLandscapeView();
        },
      ),
    );
  }

  // Portrait: stack every section vertically
  Widget _buildPortraitView() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const StudentDetailsSection(),
        const TitleSection(
          name: 'Kpg Sedi',
          location: 'Pulau Bruit,96200 Daro, Sarawak, Malaysia',
          starCount: 41,
        ),
        const ImageSection(imagePath: 'assets/kampong.jpg'),
        _buildPickersSection(),
      ],
    );
  }

  // Landscape: student details on the left, location on the right
  Widget _buildLandscapeView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: SingleChildScrollView(
              child: StudentDetailsSection(),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ListView(
              children: [
                const TitleSection(
                  name: 'Kpg Sedi',
                  location: 'Pulau Bruit,96200 Daro, Sarawak, Malaysia',
                  starCount: 41,
                ),
                const ImageSection(imagePath: 'assets/kampong.jpg'),
                _buildPickersSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Material Date Picker
  Future<void> _selectMaterialDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Cupertino Date Picker (Modal Sheet)
  void _showCupertinoDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 240,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: _selectedDate ?? DateTime.now(),
          maximumDate: DateTime.now(),
          onDateTimeChanged: (DateTime newDate) {
            setState(() => _selectedDate = newDate);
          },
        ),
      ),
    );
  }

  // Cupertino Picker (Wheel) in a modal sheet
  void _showCupertinoRolePicker(BuildContext context) {
    final List<String> roles = ['Gryffindor', 'Slytherin','Ravenclaw','Hufflepuff'];
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 200,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: CupertinoPicker(
          itemExtent: 32,
          // Open the wheel on the role that is already selected
          scrollController: FixedExtentScrollController(
            initialItem: roles.indexOf(_selectedRole),
          ),
          onSelectedItemChanged: (int index) {
            setState(() => _selectedRole = roles[index]);
          },
          children: roles.map((role) => Center(child: Text(role))).toList(),
        ),
      ),
    );
  }

  Widget _buildPickersSection() {
    final String dateText = _selectedDate == null
        ? 'No date selected'
        : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Date of Birth',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(dateText, style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: () => _selectMaterialDate(context),
                child: const Text('Material Date Picker'),
              ),
              ElevatedButton(
                onPressed: () => _showCupertinoDatePicker(context),
                child: const Text('Cupertino Date Picker'),
              ),
            ],
          ),
          const Divider(height: 32, thickness: 1),
          const Text(
            'Role',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(_selectedRole, style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Material DropdownButton
              DropdownButton<String>(
                value: _selectedRole,
                items: ['Gryffindor', 'Slytherin','Ravenclaw','Hufflepuff'].map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() => _selectedRole = newValue);
                  }
                },
              ),
              ElevatedButton(
                onPressed: () => _showCupertinoRolePicker(context),
                child: const Text('Cupertino Wheel Picker'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StudentDetailsSection extends StatelessWidget {
  const StudentDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.indigo,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Image.asset(
                  'assets/profileico.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  // Shift the crop up so the face stays in the circle
                  alignment: const Alignment(0, -0.6),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Your name
            const Text(
              'MOHD HAZAMI BIN HASNAH',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            // Your Student ID
            const Text(
              'Student ID: BCS24020006',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const Divider(height: 32, thickness: 1, color: Colors.white38),
            const Text(
              'Personal Life Goal / Quote:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            // Your specific quote
            const Text(
              '"MARRY A GOOD WOMAN"',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  final String name;
  final String location;
  final int starCount;
  const TitleSection({
    super.key,
    required this.name,
    required this.location,
    required this.starCount,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Icon(Icons.star, color: Colors.red[500]),
          const SizedBox(width: 4),
          Text('$starCount'),
        ],
      ),
    );
  }
}

class ImageSection extends StatelessWidget {
  final String imagePath;
  const ImageSection({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        imagePath,
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
        // Placeholder shown until the image file is added to assets/
        errorBuilder: (context, error, stackTrace) => Container(
          height: 220,
          color: Colors.grey[300],
          alignment: Alignment.center,
          child: const Icon(Icons.image_not_supported, size: 48),
        ),
      ),
    );
  }
}
