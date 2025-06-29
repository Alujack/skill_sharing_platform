import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skill_sharing_platform/auth_provider.dart';
import 'package:skill_sharing_platform/services/enrollment_service.dart';
import 'package:skill_sharing_platform/widgets/payment_success_modal.dart';

class PaymentScreen extends StatefulWidget {
  final String courseId;
  final String courseTitle;
  final double coursePrice;

  const PaymentScreen({
    Key? key,
    required this.courseId,
    required this.courseTitle,
    this.coursePrice = 0.0,
  }) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardHolderController = TextEditingController();

  bool _isProcessing = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardHolderController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.user?.id;
      
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please login first')),
        );
        return;
      }

      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 2));

      // Process enrollment
      await EnrollmentService.buyNowEnroll(
        widget.courseId.toString(), 
        userId
      );

      // Show success modal
      _showSuccessModal();
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  void _showSuccessModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PaymentSuccessModal(
        courseTitle: widget.courseTitle,
        onClose: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course info
            _buildCourseInfo(),
            const SizedBox(height: 30),
            
            // Payment form
            _buildPaymentForm(),
            
            const SizedBox(height: 30),
            
            // Pay button
            _buildPayButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.courseTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          widget.coursePrice > 0 
              ? '\$${widget.coursePrice.toStringAsFixed(2)}' 
              : 'FREE',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: widget.coursePrice > 0 
                ? Theme.of(context).primaryColor 
                : Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Method',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Card number
          TextFormField(
            controller: _cardNumberController,
            decoration: InputDecoration(
              labelText: 'Card Number',
              prefixIcon: const Icon(Icons.credit_card),
              border: OutlineInputBorder(),
              hintText: '4242 4242 4242 4242',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter card number';
              }
              // Simple validation - real app would use proper validation
              if (value.replaceAll(' ', '').length != 16) {
                return 'Enter a valid 16-digit card number';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              // Expiry date
              Expanded(
                child: TextFormField(
                  controller: _expiryController,
                  decoration: InputDecoration(
                    labelText: 'Expiry Date',
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                    hintText: 'MM/YY',
                  ),
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter expiry date';
                    }
                    // Simple validation
                    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                      return 'Enter valid MM/YY format';
                    }
                    return null;
                  },
                ),
              ),
              
              const SizedBox(width: 16),
              
              // CVV
              Expanded(
                child: TextFormField(
                  controller: _cvvController,
                  decoration: InputDecoration(
                    labelText: 'CVV',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(),
                    hintText: '123',
                  ),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter CVV';
                    }
                    if (value.length != 3) {
                      return 'Enter valid 3-digit CVV';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Card holder name
          TextFormField(
            controller: _cardHolderController,
            decoration: InputDecoration(
              labelText: 'Card Holder Name',
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter card holder name';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPayButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isProcessing ? null : _processPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 35, 0, 210),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: _isProcessing
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                widget.coursePrice > 0 
                    ? 'Pay \$${widget.coursePrice.toStringAsFixed(2)}' 
                    : 'Enroll for Free',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
      ),
    );
  }
}