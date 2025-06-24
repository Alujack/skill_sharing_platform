import 'package:flutter/material.dart';
import 'package:skill_sharing_platform/services/instructor_service.dart';

class BecomeInstructorDialog extends StatefulWidget {
  final String userId;

  const BecomeInstructorDialog({super.key, required this.userId});

  @override
  State<BecomeInstructorDialog> createState() => _BecomeInstructorDialogState();
}

class _BecomeInstructorDialogState extends State<BecomeInstructorDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      try {
        final data = {
          "userId": widget.userId,
          "name": _nameController.text,
          "bio": _bioController.text,
          "phone": _phoneController.text,
        };

        await InstructorService.becomeInstructor(data);
        
        if (mounted) {
          Navigator.of(context).pop(true); // Close dialog and indicate success
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Instructor request submitted successfully!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Become an Instructor'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Display Name'),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter your name' : null,
              ),
              TextFormField(
                controller: _bioController,
                decoration: const InputDecoration(labelText: 'Bio'),
                maxLines: 3,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a bio' : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter your phone number' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submitForm,
          child: _isLoading 
              ? const CircularProgressIndicator()
              : const Text('Submit'),
        ),
      ],
    );
  }
}