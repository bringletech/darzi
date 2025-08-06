import 'dart:convert';
import 'dart:io';
import 'package:darzi/apiData/model/add_new_customer_response_model.dart';
import 'package:darzi/apiData/model/aws_response_model.dart';
import 'package:darzi/common/widgets/tailor/custom_toggle_button.dart';
import 'package:darzi/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../../apiData/all_urls/all_urls.dart';
import '../../../../../apiData/call_api_service/call_service.dart';
import '../../../../../apiData/model/verify_mobile_model.dart';
import '../../../../../colors.dart';
import '../../../../../common/all_text.dart';
import '../../../../../common/all_text_form_field.dart';
import '../../../../../common/widgets/tailor/commAddCustTextField.dart';
import '../../../../../common/widgets/tailor/common_app_bar_with_back.dart';
import '../../../../../constants/string_constant.dart';
import '../../tailor_dashboard/view/tailor_dashboard_new.dart';
import 'package:path/path.dart' as p;


class AddCustomer extends StatefulWidget {
  final Locale locale;
  AddCustomer({super.key, required this.locale,});

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  bool isPressed = false;
  bool selectValue = false;
  bool isLoading = false;
  String optional = "inch", message = "";
  final FocusNode _focusNode = FocusNode();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController dressNameController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final TextEditingController neckController = TextEditingController();
  final TextEditingController bustController = TextEditingController();
  final TextEditingController underBustController = TextEditingController();
  final TextEditingController waistController = TextEditingController();
  final TextEditingController hipsController = TextEditingController();
  final TextEditingController neckToAboveKneeController = TextEditingController();
  final TextEditingController armLengthController = TextEditingController();
  final TextEditingController shoulderSeamController = TextEditingController();
  final TextEditingController armHoleController = TextEditingController();
  final TextEditingController bicepController = TextEditingController();
  final TextEditingController foreArmController = TextEditingController();
  final TextEditingController wristController = TextEditingController();
  final TextEditingController shoulderToWaistController = TextEditingController();
  final TextEditingController bottomLengthController = TextEditingController();
  final TextEditingController ankleController = TextEditingController();
  final TextEditingController stitchingCostController = TextEditingController();
  final TextEditingController advancedReceivedController = TextEditingController();
  final TextEditingController outStandingBalanceController = TextEditingController();
  final TextEditingController textarea = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  String formattedDate = "", fileName = "",presignedUrl = "",objectUrl = "",extensionWithoutDot = "";
  String advancedCost = "00";


  @override
  void initState() {
    super.initState();
    stitchingCostController.addListener(calculateOutstandingBalance);
    advancedReceivedController.addListener(calculateOutstandingBalance);
  }

  @override
  void dispose() {
    stitchingCostController.removeListener(calculateOutstandingBalance);
    advancedReceivedController.removeListener(calculateOutstandingBalance);
    stitchingCostController.dispose();
    advancedReceivedController.dispose();
    outStandingBalanceController.dispose();
    super.dispose();
  }

  // Method to calculate outstanding balance
  void calculateOutstandingBalance() {
    double stitchingCost = double.tryParse(stitchingCostController.text) ?? 0;
    double advance = double.tryParse(advancedReceivedController.text) ?? 0;
    double outstanding = stitchingCost - advance;

    outStandingBalanceController.text = outstanding.toStringAsFixed(2);
  }

  bool _isFormDirty() {
    return nameController.text.isNotEmpty ||
        mobileNoController.text.isNotEmpty ||
        dressNameController.text.isNotEmpty ||
        dueDateController.text.isNotEmpty ||
        neckController.text.isNotEmpty ||
        bustController.text.isNotEmpty ||
        underBustController.text.isNotEmpty ||
        waistController.text.isNotEmpty ||
        hipsController.text.isNotEmpty ||
        neckToAboveKneeController.text.isNotEmpty ||
        armLengthController.text.isNotEmpty ||
        shoulderSeamController.text.isNotEmpty ||
        armHoleController.text.isNotEmpty ||
        bicepController.text.isNotEmpty ||
        foreArmController.text.isNotEmpty ||
        wristController.text.isNotEmpty ||
        shoulderToWaistController.text.isNotEmpty ||
        bottomLengthController.text.isNotEmpty ||
        ankleController.text.isNotEmpty ||
        stitchingCostController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isFormDirty()) {
          showWarningMessage(
            context,
            locale: widget.locale,
            onChangeLanguage: (newLocale) {
              print("Language changed to: ${newLocale.languageCode}");
            },
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => TailorDashboardNew(locale: widget.locale)),
          );
        }
        return false;
      },
      child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,),
          child: Scaffold(
              appBar: CustomAppBarWithBack(
                  title: AppLocalizations.of(context)!.newCustomer,
                  hasBackButton: true,
                  elevation: 2.0,
                  leadingIcon: SvgPicture.asset(
                    'assets/svgIcon/addCust.svg',
                    color: Colors.black,
                  ),
                  onBackButtonPressed: () async {
                    if (_isFormDirty()) {
                      showWarningMessage(
                        context,
                        locale: widget.locale,
                        onChangeLanguage: (newLocale) {
                          print("Language changed to: ${newLocale.languageCode}");
                        },
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TailorDashboardNew(locale: widget.locale)),
                      );
                    }

                  }
              ),
              body: SingleChildScrollView(
                  child: Container(
                      color: Colors.white,
                      child: Column(
                          children: [
                            Container(
                                child: Card(
                                  color: Colors.white,
                                  elevation: 6,
                                  shape: RoundedRectangleBorder(borderRadius:
                                  BorderRadius.vertical(bottom: Radius.circular(40)),),
                                  child: Container(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                      flex: 2,
                                                      child: AllText(text: AppLocalizations.of(context)!.userName, fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w500,)),
                                                  SizedBox(width: 8),
                                                  Expanded(
                                                      flex: 3,
                                                      child: AllTextFormField(inputType: TextInputType.text, hintText: AppLocalizations.of(context)!.enterName, mController: nameController, readOnly: false,)
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: AllText(text: AppLocalizations.of(context)!.mobileNumber, fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w500,),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Stack(
                                                          children: [
                                                            Material(elevation: 8, shadowColor: Colors.black.withOpacity(0.8), borderRadius: BorderRadius.circular(30),
                                                              child: TextFormField(
                                                                keyboardType: TextInputType.number,
                                                                onChanged: (value) => _checkInput(value),
                                                                readOnly: false,
                                                                focusNode: _focusNode,
                                                                controller: mobileNoController,
                                                                decoration: InputDecoration(
                                                                  hintMaxLines: 1,
                                                                  hintText: AppLocalizations.of(context)!.enterMobileNumber,
                                                                  contentPadding: EdgeInsets.only(left: 15.0),
                                                                  hintStyle: TextStyle(fontFamily: 'Inter', fontSize: 11, color: Color(0xff454545), fontWeight: FontWeight.w400,),
                                                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30),borderSide: BorderSide.none,),
                                                                  filled: true,
                                                                  fillColor: Colors.white,
                                                                ),
                                                              ),
                                                            ),
                                                            if (isLoading)
                                                              Positioned(
                                                                right: 8.0,
                                                                top: 12.0,
                                                                child: SizedBox(width: 24, height: 24,
                                                                  child: CircularProgressIndicator(strokeWidth: 2.0),
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 3),
                                                        // Debugging Text
                                                        //Text("Current message: $message", style: TextStyle(color: Colors.red)),
                                                        if (message.contains("Number registered on Darzi App")&& message.isNotEmpty)
                                                          Container(
                                                            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                                            decoration: BoxDecoration(
                                                              color: Colors.green.withOpacity(0.1),
                                                              borderRadius: BorderRadius.circular(10),
                                                              border: Border.all(color: Colors.green),
                                                            ),
                                                            child: Text(
                                                              message,
                                                              style: TextStyle(
                                                                fontFamily: 'Poppins',
                                                                fontSize: 13,
                                                                fontWeight: FontWeight.w500,
                                                                color: AppColors.newUpdateColor,
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(flex: 2,
                                                      child: AllText(text: AppLocalizations.of(context)!.dressName, fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w500)),
                                                  SizedBox(width: 8),
                                                  Expanded(flex: 3,
                                                      child: AllTextFormField(inputType: TextInputType.text, hintText: AppLocalizations.of(context)!.enterDressName, mController: dressNameController, readOnly: false,)),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              Row(crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(flex: 2,
                                                    child: Text(AppLocalizations.of(context)!.dressPhoto, style: TextStyle(fontFamily: 'Popins', fontSize: 15, fontWeight: FontWeight.w500,),),),
                                                  SizedBox(width: 8),
                                                  Expanded(
                                                      flex: 3,
                                                      child: GestureDetector(onTap: () async {
                                                        _handleImagePickerTap(context);
                                                      },
                                                        child: Container(
                                                          height: 45,
                                                          decoration: BoxDecoration(color: Colors.white,
                                                            borderRadius: BorderRadius.circular(25),
                                                            border: Border.all(color: Colors.white),
                                                            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 4.0, blurRadius: 4.0, offset: const Offset(0, 3),),],),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Padding(padding: EdgeInsets.symmetric(horizontal: 16),
                                                                child: Text(AppLocalizations.of(context)!.addImage, style: TextStyle(fontFamily:'Inter',fontSize: 11,color:AppColors.newUpdateColor, fontWeight: FontWeight.w400),),),
                                                              Padding(padding: EdgeInsets.symmetric(horizontal: 16),
                                                                child: Icon(Icons.add_circle_outline_sharp, size: 15, color: AppColors.newUpdateColor),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )),
                                                ],
                                              ),
                                              SizedBox(height: 3),
                                              Visibility(
                                                visible: _selectedImage != null,
                                                child: Center(
                                                  child: Container(
                                                    margin: EdgeInsets.only(left: 30),
                                                    child: Card(elevation: 4.0,
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
                                                      child: Column(
                                                        children: [
                                                          Container(child: _selectedImage == null
                                                              ? SvgPicture.asset('assets/svgIcon/profilepic.svg', width: 80, height: 80,)
                                                              : ClipOval(child: Image.file(_selectedImage!, fit: BoxFit.cover, width: 120, height: 120,
                                                          ),
                                                          ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(flex: 2,
                                                      child: AllText(text: AppLocalizations.of(context)!.dueDate, fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w500)),
                                                  SizedBox(width: 8),
                                                  Expanded(
                                                    flex: 3,
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                      setState(() {
                                                      print("Field is tapped");});
                                                    //_pickedImages(context);
                                                    },
                                                      child: Material(elevation: 10, shadowColor: Colors.black.withOpacity(1.0),
                                                        borderRadius: BorderRadius.circular(30),
                                                        child: TextFormField(
                                                          onTap: () async {
                                                            DateTime? pickedDate =
                                                            await showDatePicker(context: context,
                                                                initialDate: DateTime.now(),
                                                                firstDate: DateTime.now(),
                                                                lastDate: DateTime(2100),
                                                                builder: (context, child){
                                                                  return Theme(data: Theme.of(context).copyWith(
                                                                      colorScheme:  ColorScheme.light(primary: AppColors.newUpdateColor,onPrimary: Colors.white,onSurface: Colors.black,)
                                                                  ), child: child!);
                                                                });
                                                            if (pickedDate != null) {
                                                              print(pickedDate);
                                                              formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                                              print("Date Value is : $formattedDate");
                                                              setState(() {dueDateController.text = formattedDate;});
                                                              value:formattedDate;}
                                                            if (pickedDate != null) {
                                                              formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                                              dueDateController.text = formattedDate;
                                                            }
                                                          },
                                                          readOnly: true,
                                                          controller: dueDateController,
                                                          decoration: InputDecoration(
                                                            hintText:
                                                            formattedDate.isEmpty ? AppLocalizations.of(context)!.noDateSelected : formattedDate.toString(),
                                                            contentPadding: EdgeInsets.only(left: 15.0),
                                                            hintStyle: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: Color(0xff454545), fontWeight: FontWeight.w400),
                                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none), filled: true, fillColor: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ]
                                        ),)

                                  ),
                                )
                            ),
                            Container(
                                margin: EdgeInsets.all( 10),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 15,),
                                      Text(
                                        AppLocalizations.of(context)!.howToMeasure,
                                        style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 15),),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          AnimatedSwitch(
                                            value: selectValue,  // The current toggle state
                                            onChanged: (val) {
                                              setState(() {
                                                selectValue = val;
                                                optional = selectValue ? "cm" : "inch";
                                                print("Optional value is: $optional");
                                                print("Toggle value is: $selectValue");
                                              });
                                            },
                                            enabledTrackColor: AppColors.primaryRed,  // Custom color for the active state
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            optional,
                                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Container(
                                        margin: EdgeInsets.all(0),
                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white),
                                                  child: Column(
                                                    children: [
                                                      Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.neck, hintText: optional, controller: neckController,),
                                                      SizedBox(height: 10,),
                                                      Commonaddcusttextfield(inputType: TextInputType.number,text: AppLocalizations.of(context)!.bust, hintText: optional, controller: bustController,),
                                                      SizedBox(height: 10,),
                                                      Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.underBust, hintText: optional, controller: underBustController,),
                                                      SizedBox(height: 10,),
                                                      Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.waist, hintText: optional, controller: waistController,),
                                                      SizedBox(height: 10,),
                                                      Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.hips, hintText: optional, controller: hipsController,),
                                                      SizedBox(height: 10,),
                                                      Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.neckAbove, hintText: optional, controller: neckToAboveKneeController,),
                                                      SizedBox(height: 10,),
                                                      Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.armLength, hintText: optional, controller: armLengthController,),
                                                      SizedBox(height: 10,),
                                                      Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.shoulderSeam, hintText: optional, controller: shoulderSeamController,),
                                                      SizedBox(height: 10,),
                                                      Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.armHole, hintText: optional, controller: armHoleController,),
                                                      SizedBox(height: 10,),
                                                      Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.bicep, hintText: optional, controller: bicepController,),
                                                      SizedBox(height: 10,),
                                                      Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.foreArm, hintText: optional, controller: foreArmController,),
                                                      SizedBox(height: 10,),
                                                      Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.wrist, hintText: optional, controller: wristController,),
                                                      SizedBox(height: 10,),
                                                      Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.shoulderWaist, hintText: optional, controller: shoulderToWaistController,),
                                                      SizedBox(height: 10,),
                                                      Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.bottomLength, hintText: optional, controller: bottomLengthController,),
                                                      SizedBox(height: 10,),
                                                      Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.ankle, hintText: optional, controller: ankleController,),
                                                      SizedBox(height: 10,),
                                                      Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.stitchingCost, hintText: "₹", controller: stitchingCostController,),
                                                      SizedBox(height: 10,),
                                                      Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.advancedCost, hintText: "₹", controller: advancedReceivedController,),
                                                      SizedBox(height: 10,),
                                                      Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.outstandingBalance, hintText: "₹", controller: outStandingBalanceController,),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ]
                                        ),
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!.notes,
                                        style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 14),),
                                      SizedBox(height: 5,),
                                      TextField(controller: textarea,
                                        keyboardType: TextInputType.multiline, maxLines: 4, maxLength: 500,
                                        decoration: InputDecoration(hintText: AppLocalizations.of(context)!.textHere, enabledBorder: const OutlineInputBorder(
                                          borderSide: const BorderSide(color: Colors.grey, width: 0.0),),
                                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.0, color: Colors.grey))),
                                      ),
                                    ]
                                )
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: GestureDetector(
                                onTap: () {
                                  if (isLoading) return; // Prevent double tap

                                  setState(() {
                                    isLoading = true;
                                  });

                                  if (nameController.text.isEmpty) {
                                    showToast(AppLocalizations.of(context)!.enterName);
                                    setState(() => isLoading = false);
                                    return;
                                  }
                                  if (mobileNoController.text.isEmpty) {
                                    showToast(AppLocalizations.of(context)!.enterMobileNumber);
                                    setState(() => isLoading = false);
                                    return;
                                  }
                                  if (dressNameController.text.isEmpty) {
                                    showToast(AppLocalizations.of(context)!.enterDressName);
                                    setState(() => isLoading = false);
                                    return;
                                  }
                                  if (_selectedImage == null) {
                                    showToast(AppLocalizations.of(context)!.selectImage, isError: true);
                                    setState(() => isLoading = false);
                                    return;
                                  }
                                  if (dueDateController.text.isEmpty) {
                                    showToast(AppLocalizations.of(context)!.enterDueDate, isError: true);
                                    setState(() => isLoading = false);
                                    return;
                                  }

                                  if (stitchingCostController.text.isEmpty) {
                                    showToast(AppLocalizations.of(context)!.add_warning_message1);
                                    setState(() => isLoading = false);
                                    return;
                                  }

                                  int cost = int.tryParse(stitchingCostController.text.trim()) ?? 0;
                                  if (cost < 0) {
                                    showToast("Cost cannot be negative");
                                    return;
                                  }

                                  getAwsUrl();
                                },
                                child: Container(
                                  width: 350,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: AppColors.newUpdateColor,
                                    //color: isPressed ? AppColors.newUpdateColor:Colors.white,
                                    // gradient: LinearGradient(
                                    //   colors: isPressed ? AppColors.Gradient1 : [Colors.white, Colors.white],),
                                    borderRadius: BorderRadius.circular(8),
                                    // border: Border.all(color: AppColors.newUpdateColor, width: 2),
                                  ),
                                  child: Center(
                                    child: isLoading
                                        ? CircularProgressIndicator(color: Colors.white)
                                        : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(AppLocalizations.of(context)!.saveDetails1,
                                          style: TextStyle(
                                            color: Colors.white,
                                            // color: isPressed ? Colors.white : AppColors.newUpdateColor,
                                            fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 19,),),
                                      ],
                                    ),
                                  ),
                                ),
                              ), //buildSaveButton(context),
                            ),
                          ]
                      )
                  )
              )
          )
      ),
    );
  }
  void _pickedImages(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: Colors.black),
              title: Text('Camera'),
              onTap: () async {
                final XFile? photo =
                await _picker.pickImage(source: ImageSource.camera);

                if (photo != null) {
                  setState(() {
                    _selectedImage = File(photo.path);
                    fileName = p.basename(photo.path); // Get file name with extension
                    String extension = p.extension(photo.path); // Get extension with dot
                    extensionWithoutDot = extension.substring(1); // Remove dot
                    print("File Name: $fileName");
                    print("File Extension (with dot): $extension");
                    print("File Extension (without dot): $extensionWithoutDot");
                  });

                }
                Navigator.pop(context); // Close the modal after action
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: Colors.black),
              title: Text('Gallery'),
              onTap: () async {
                final XFile? photo =
                await _picker.pickImage(source: ImageSource.gallery);

                if (photo != null) {
                  setState(() {
                    _selectedImage = File(photo.path);
                    fileName = p.basename(photo.path); // Get file name with extension
                    String extension = p.extension(photo.path); // Get extension with dot
                    extensionWithoutDot = extension.substring(1); // Remove dot
                    print("File Name: $fileName");
                    print("File Extension (with dot): $extension");
                    print("File Extension (without dot): $extensionWithoutDot");
                  });
                }
                Navigator.pop(context); // Close the modal after action
              },
            ),
          ],
        );
      },
    );
  }

  void showToast(String msg, {bool isError = false}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: isError ? Colors.red : AppColors.newUpdateColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> getAwsUrl() async {
    String fileType = "image/$extensionWithoutDot", folder_name = "Order";
    print('Image FileType is $fileType');
    print('Folder Name is $folder_name');

    setState(() {
      isLoading = true; // Start loader
    });

    try {
      AwsResponseModel model = await CallService().getAwsUrl(fileType, folder_name);
      presignedUrl = model.presignedUrl.toString();
      objectUrl = model.objectUrl.toString();

      print("Presigned URL: $presignedUrl");
      print("Object URL: $objectUrl");

      await callPresignedUrl(presignedUrl); // ✅ Await here
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Failed to update details. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.newUpdateColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setState(() {
        isLoading = false; // Stop loader AFTER everything
      });
    }
  }


  Future<void> callPresignedUrl(String presignedUrl) async {
    if (_selectedImage == null) {
      Fluttertoast.showToast(
        msg: "No image selected",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    try {
      Uri url = Uri.parse(presignedUrl);
      print("Uploading to Presigned URL: $url");

      final imageBytes = await _selectedImage!.readAsBytes();

      var response = await http.put(
        url,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'image/$extensionWithoutDot',
        },
        body: imageBytes,
      );

      print("Upload response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        print("Image uploaded successfully.");
        await addCustomerMethod(); // 👈 Profile update after image upload
      } else {
        Fluttertoast.showToast(
          msg: "Image upload failed. Status: ${response.statusCode}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print("Upload error: $e");
      Fluttertoast.showToast(
        msg: "An error occurred during upload: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> addCustomerMethod() async {
    setState(() {
      isLoading = true;
    });

    var map = <String, dynamic>{};
    map['name'] = nameController.text.trim();
    map['dressImgUrl'] = objectUrl;
    map['dueDate'] = formattedDate;
    map['mobileNo'] =  mobileNoController.text.trim();
    map['neck'] = neckController.text.trim();
    map['Bust'] = bustController.text.trim();
    map['underBust'] = underBustController.text.trim();
    map['waist'] = waistController.text.trim();
    map['hips'] = hipsController.text.trim();
    map['neckToAboveKnee'] = neckToAboveKneeController.text.trim();
    map['armLength'] = armLengthController.text.trim();
    map['shoulderSeam'] = shoulderSeamController.text.trim();
    map['armHole'] = armHoleController.text.trim();
    map['bicep'] = bicepController.text.trim();
    map['foreArm'] = foreArmController.text.trim();
    map['wrist'] = wristController.text.trim();
    map['shoulderToWaist'] = shoulderToWaistController.text.trim();
    map['bottomLength'] = bottomLengthController.text.trim();
    map['ankle'] = ankleController.text.trim();
    map['stitchingCost'] =stitchingCostController.text.trim();
    map['advanceReceived'] = advancedReceivedController.text.isEmpty
        ? "00"
        : advancedReceivedController.text.trim();
    map['outstandingBalance'] = outStandingBalanceController.text.trim();
    map['notes'] = textarea.text.trim();
    map['dressName'] = dressNameController.text.trim();
    map['measurementUnit'] = optional;

    print("Tailor Data Map value is $map");
    try {
      Add_New_Customer_Response_Model model = await CallService().addNewCustomer(map);

      String message = model.message.toString();
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.newUpdateColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      updateUI();
      /// Clear all form fields
      nameController.clear();
      mobileNoController.clear();
      neckController.clear();
      bustController.clear();
      underBustController.clear();
      waistController.clear();
      hipsController.clear();
      neckToAboveKneeController.clear();
      armLengthController.clear();
      shoulderSeamController.clear();
      armHoleController.clear();
      bicepController.clear();
      foreArmController.clear();
      wristController.clear();
      shoulderToWaistController.clear();
      bottomLengthController.clear();
      ankleController.clear();
      stitchingCostController.clear();
      advancedReceivedController.clear();
      outStandingBalanceController.clear();
      textarea.clear();
      dressNameController.clear();
      dueDateController.clear();
      optional = "";
      formattedDate = "";
      fileName = "";
      _selectedImage = null;
    } catch (e) {
      print("Error in addCustomerMethod: $e");
      showToast("Something went wrong. Please try again.", isError: true);
    } finally {
      setState(() => isLoading = false);
    }
  }

  void updateUI() {
    setState(() {});
  }
  _checkInput(String input) {
    if (input.length == 10) {
      _callVerifyMobile(input);
      // Optionally unfocus the TextField after 10 digits
      _focusNode.unfocus();
    } else if (input.length < 10) {
      setState(() {
        message = ""; // Hide the "Number is already registered" box
      });
    }
  }

  _callVerifyMobile(String input) {
    setState(() {
      isLoading = true;
      var map = Map<String, dynamic>();
      map['mobileNo'] = input.toString();
      print("Map value is $map");
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Mobile_Verify_Model model =
        await CallService().verifyCustomerMobile(map);
        setState(() {
          isLoading = false;
          message = model.message.toString();
          print("Message received: $message");
        });
      });
    });
  }

  void showWarningMessage(BuildContext context,
      {required Locale locale, required Function(Locale) onChangeLanguage}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Container(
            margin: const EdgeInsets.only(left: 16),
            child: Text(
              AppLocalizations.of(context)!.unsaved_changes,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  fontSize: 20),
            ),
          ),
          content: Container(
            child: Text(
              AppLocalizations.of(context)!.unsaved_changes_warningMessage,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Colors.grey),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 47,
                  width: 100,
                  child: Card(
                    color: AppColors.newUpdateColor,
                    elevation: 4,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        final result = await
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TailorDashboardNew(locale: widget.locale,)),
                        );
                        Navigator.pop(context, true);

                      },
                      child: Text(
                        AppLocalizations.of(context)!.yesMessage,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20,),
                SizedBox(
                  height: 47,
                  width: 100,
                  child: Card(
                    color: Colors.white,
                    elevation: 4,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: AppColors.newUpdateColor, width: 1.5),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false); // Close the dialog
                      },
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: TextStyle(color: AppColors.newUpdateColor),
                      ),
                    ),
                  ),
                ),

              ],
            )
          ],
        );
      },
    );
  }

  Future<void> _handleImagePickerTap(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDisclosureShown = prefs.getBool('permission_disclosure_shown') ?? false;

    if (!isDisclosureShown) {
      _showPermissionDisclosure(context); // Show the dialog
      await prefs.setBool('permission_disclosure_shown', true); // Set flag
    } else {
      _pickedImages(context); // Proceed directly
    }
  }

  void _showPermissionDisclosure(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.permission_required,style: TextStyle(fontWeight: FontWeight.w600,fontFamily: 'Poppins',fontSize: 20)),
        content: Text(
          AppLocalizations.of(context)!.access_camera_permission,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              //  Navigator.of(context).pop();
              //_requestCameraPermission(context);
              _pickedImages(context);
            },
            child: Text(
              AppLocalizations.of(context)!.access_continue,
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: AppColors.newUpdateColor), // Styled like in the 3rd function
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: AppColors.newUpdateColor), // Styled like in the 3rd function
            ),
          ),
        ],
      ),
    );
  }
}