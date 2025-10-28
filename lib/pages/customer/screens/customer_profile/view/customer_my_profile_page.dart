import 'package:darzi/Reusable/custome_app_bar.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CustomerMyProfilePage extends StatefulWidget {
  const CustomerMyProfilePage({super.key});

  @override
  State<CustomerMyProfilePage> createState() => _CustomerMyProfilePageState();
}

class _CustomerMyProfilePageState extends State<CustomerMyProfilePage> {
  final TextEditingController profileNameController = TextEditingController();
  final TextEditingController profileMobileNoController =
      TextEditingController();
  final TextEditingController profileAddressController =
      TextEditingController();
  String userAddress = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBars(
        title: "Profile",
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child:
                //  ExpansionPanelList.radio(
                //   elevation: 0,
                //   expandedHeaderPadding: EdgeInsets.zero,
                //   expansionCallback: (index, isExpanded) {
                //     setState(() {
                //       _expandedIndex = isExpanded ? null : index;
                //     });
                //   },
                // children: <ExpansionPanel>[
                // ✅ My Details hamesha show hoga
                // ExpansionPanelRadio(
                //   backgroundColor: Colors.grey.shade200,
                //   value: 0,
                //   headerBuilder: (context, isExpanded) {
                //     return ListTile(
                //       title: Text(
                //         AppLocalizations.of(context)!.my_details,
                //         style: TextStyle(
                //           fontWeight: FontWeight.w600,
                //           fontSize: 15,
                //         ),
                //       ),
                //     );
                //   },
                // body:
                Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  _buildDetailField(
                      label: AppLocalizations.of(context)!.userName,
                      hintText: '',
                      controller: profileNameController),
                  const SizedBox(height: 8),
                  _buildDetailField(
                    label: AppLocalizations.of(context)!.mobileNumber,
                    hintText: '',
                    controller: profileMobileNoController,
                    readOnly: true, // <-- yahan readOnly true kar diya
                  ),
                  const SizedBox(height: 8),
                  _buildDetailField(
                      label: AppLocalizations.of(context)!.userAddress,
                      hintText: userAddress,
                      controller: profileAddressController),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            // ),
            // ],
            // ),
          ),
        ],
      ),
    );
  }

  // My Details ka ek field widget
  Widget _buildDetailField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                color: Color(0xff454545),
                fontWeight: FontWeight.w400), // <-- yahan hintText add kar diya
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: AppColors.newUpdateColor),
            ),
          ),
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }
}
