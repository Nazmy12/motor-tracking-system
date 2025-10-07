import 'package:flutter/material.dart';
import 'package:gocheck/services/firestore_service.dart';
import 'package:gocheck/models/borrow_request.dart';
import 'package:gocheck/models/user.dart';
import 'package:gocheck/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class FormBorrowPage extends StatefulWidget {
  const FormBorrowPage({super.key});

  @override
  State<FormBorrowPage> createState() => _FormBorrowPageState();
}

class _FormBorrowPageState extends State<FormBorrowPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  bool _isLoading = false;
  String? scooterId;
  User? _fetchedUser;
  bool _isLoadingUser = true;
  
  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scooterId = ModalRoute.of(context)?.settings.arguments as String?;
  }

  void _fetchUserData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final authUser = authProvider.user;
    if (authUser?.email != null) {
      _fetchedUser = await FirestoreService().getUserByEmail(authUser!.email!);
      if (_fetchedUser != null) {
        setState(() {
          _nameController.text = _fetchedUser!.name;
          _nikController.text = _fetchedUser!.id;
        });
      }
    }
    setState(() {
      _isLoadingUser = false;
    });
  }

  void _submitForm() async {
    setState(() {
      _isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: const Text("User not logged in."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    if (_fetchedUser == null) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: const Text("User data not found."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    if (scooterId == null) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: const Text("No scooter selected."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    try {
      final borrowRequest = BorrowRequest(
        borrowRequestID: const Uuid().v4(),
        userID: _fetchedUser!.id,
        motorcycleID: scooterId!,
        borrowTimestamp: DateTime.now(),
        nic: _fetchedUser!.id,
        name: _fetchedUser!.name,
        status: 'active',
        notes: '',
      );

      await FirestoreService().createBorrowRequest(borrowRequest);
      await FirestoreService().updateMotorcycleStatus(scooterId!, 'in use', 'not returned');

      setState(() {
        _isLoading = false;
      });

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Form Submitted"),
          content: const Text("Your borrow request has been submitted successfully."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
              },
              child: const Text("Go to Home"),
            ),
          ],
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: Text("Failed to submit: $e"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingUser) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Motorcycle Borrow Form"),
          backgroundColor: Colors.redAccent,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Motorcycle Borrow Form"),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.info_outline, color: Colors.black54),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Your details are auto-filled from your account. This information is needed for verification and to avoid future problems.",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Please review your details to borrow the motorcycle.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Name",
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nikController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "NIK",
                  prefixIcon: const Icon(Icons.badge),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "SUBMIT",
                          style: TextStyle(fontSize: 18, color: Colors.white),
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
