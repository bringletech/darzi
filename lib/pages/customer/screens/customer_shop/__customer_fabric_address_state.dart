import 'package:darzi/pages/customer/screens/customer_shop/customer_fabric_address.dart';
import 'package:flutter/material.dart';

class _CustomerFabricAddressState extends State<CustomerFabricAddress> {
  int activeStep = 0;

  // Controllers for each field
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController houseController = TextEditingController();
  final TextEditingController localityController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    fullNameController.dispose();
    emailController.dispose();
    houseController.dispose();
    localityController.dispose();
    cityController.dispose();
    pincodeController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
