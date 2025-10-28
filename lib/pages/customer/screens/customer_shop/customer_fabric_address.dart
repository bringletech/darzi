import 'package:darzi/Reusable/text_reusable_pop.dart';
import 'package:darzi/colors.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';

class CustomerFabricAddress extends StatefulWidget {
  const CustomerFabricAddress({super.key});

  @override
  State<CustomerFabricAddress> createState() => _CustomerFabricAddressState();
}

class _CustomerFabricAddressState extends State<CustomerFabricAddress> {
  int activeStep = 0;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController houseController = TextEditingController();
  final TextEditingController localityController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

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
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.arrow_back_ios, size: 18),
            TextResPopp(FontWeight.w600, "Select Address", 20,
                color: AppColors.newUpdateColor),
            const Spacer(),
            const Icon(Icons.favorite_border),
            const SizedBox(width: 5),
            const Icon(Icons.notifications_none),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildStepper(),
            // Add bottom padding directly to each field
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: buildField("Full Name",
                  label: "Enter Details", controller: fullNameController),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: buildField("Email",
                  label: "Contact", controller: emailController),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: buildField("House no/ Building/ street",
                  controller: houseController, label: "Address"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: buildField("Locality", controller: localityController),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                children: [
                  Expanded(
                      child: buildField("City", controller: cityController)),
                  const SizedBox(width: 10),
                  Expanded(
                      child:
                          buildField("Pincode", controller: pincodeController)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: buildDateField("DD - MM - YYYY",
                  label: "Delivery date", controller: dateController),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStepper() {
    return EasyStepper(
      activeStep: activeStep,
      lineStyle: LineStyle(
        lineSpace: 0,
        lineLength: 65,
        lineType: LineType.normal,
        defaultLineColor: AppColors.blackTextColor,
      ),
      stepShape: StepShape.circle,
      stepRadius: 28,
      borderThickness: 2,
      internalPadding: 0,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      finishedStepBorderColor: Colors.orange,
      finishedStepBackgroundColor: Colors.white,
      activeStepBorderColor: Colors.orange,
      activeStepBackgroundColor: Colors.white,
      unreachedStepBorderColor: Colors.grey,
      unreachedStepBackgroundColor: Colors.white,
      showStepBorder: false,
      enableStepTapping: false,
      steps: [
        buildStep(Icons.location_city, "Address", 0),
        buildStep(Icons.local_shipping_outlined, "", 1),
        buildStep(Icons.account_balance_wallet_outlined, "", 2),
      ],
      onStepReached: (index) => setState(() => activeStep = index),
    );
  }

  EasyStep buildStep(IconData icon, String label, int stepIndex) {
    return EasyStep(
      customStep: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            child: Icon(icon,
                color: activeStep == stepIndex ? Colors.orange : Colors.grey,
                size: 28),
          ),
          if (label.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(label,
                  style: TextStyle(
                      color:
                          activeStep == stepIndex ? Colors.orange : Colors.grey,
                      fontWeight: FontWeight.w600,
                      fontSize: 14)),
            ),
        ],
      ),
    );
  }

  Widget buildField(String hint,
      {String? label, TextEditingController? controller}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) TextResPopp(FontWeight.w500, label, 16),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDateField(String hint,
      {String? label, TextEditingController? controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) TextResPopp(FontWeight.w500, label, 16),
          TextFormField(
            controller: controller,
            readOnly: true, // user taps to select date
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide.none,
              ),
              suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
            ),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                String formattedDate =
                    "${pickedDate.day.toString().padLeft(2, '0')} - ${pickedDate.month.toString().padLeft(2, '0')} - ${pickedDate.year}";
                setState(() {
                  controller?.text = formattedDate; // store selected date
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
