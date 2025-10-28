import 'package:cached_network_image/cached_network_image.dart';
import 'package:darzi/Reusable/custome_app_bar.dart';
import 'package:darzi/Reusable/text_reusable_pop.dart';
import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/l10n/app_localizations.dart';
import 'package:darzi/pages/customer/screens/customer_search/view/tailor_full_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:darzi/apiData/model/get_all_tailors_model.dart';
import 'package:url_launcher/url_launcher.dart';

class TailorSearchDetail extends StatefulWidget {
  final Locale locale;
  TailorSearchDetail({super.key, required this.locale});

  @override
  State<TailorSearchDetail> createState() => _TailorSearchDetailState();
}

class _TailorSearchDetailState extends State<TailorSearchDetail> {
  List<Data> filteredTailorList = [];
  List<Data> tailorList = [];
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = true;
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Get_All_Tailors_response_Model model =
            await CallService().getAllTailorsList();
        setState(() {
          isLoading = false;
          tailorList = model.data!;
          filteredTailorList = tailorList;
          _searchController.addListener(_filterContacts);
        });
      });
    });
  }

  Future<void> _loadData() async {
    print('Loading latest data...');
    setState(() {
      isRefreshing = true;
    });

    Get_All_Tailors_response_Model model =
        await CallService().getAllTailorsList();

    print('Loaded Tailors: ${model.data?.length}');
    setState(() {
      isRefreshing = false;
      tailorList = model.data!;
      filteredTailorList = tailorList;
    });
  }

  void _filterContacts() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredTailorList = tailorList.where((Data data) {
        return data.name.toString().toLowerCase().contains(query) ||
            data.mobileNo.toString().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBars(
        title: AppLocalizations.of(context)!.myTailor,
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppColors.blackTextColor,
                      width: 1.0,
                      style: BorderStyle.solid),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search here",
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
            ),
            Expanded(
              child: isLoading && !isRefreshing
                  ? Center(
                      child:
                          CircularProgressIndicator(color: AppColors.darkRed),
                    )
                  : filteredTailorList.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/no_results.png",
                              height: 80,
                            ),
                            Center(
                              child: Text(
                                AppLocalizations.of(context)!.no_customer_found,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: filteredTailorList.length,
                            itemBuilder: (context, index) {
                              final contact = filteredTailorList[index];
                              // customerId = contact.id.toString();
                              return GestureDetector(
                                onTap: () async {
                                  final shouldRefresh = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TailorFullView(
                                        locale: widget.locale,
                                        tailorId: contact.id.toString(),
                                        tailorloc: contact.address.toString(),
                                      ),
                                    ),
                                  );

                                  print('shouldRefresh: $shouldRefresh');

                                  if (shouldRefresh == true) {
                                    // ✅ Refresh this screen
                                    _loadData(); // ya jo bhi API/function chahiye
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3,
                                      horizontal:
                                          15), // 👈 Card ke beech ka space kam kiya
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child:
                                              //Image.network('https://randomuser.me/api/portraits/women/10.jpg',),
                                              CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            height: 40,
                                            width: 40,
                                            imageUrl:
                                                contact.profileUrl.toString(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    SvgPicture.asset(
                                              'assets/svgIcon/profilepic.svg',
                                              width: 40,
                                              height: 40,
                                            ),
                                          ),
                                        ),
                                      ),

                                      /// CARD DETAIL VIEW ///
                                      const SizedBox(width: 8),
                                      Expanded(
                                        flex: 5,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextResPopp(
                                                FontWeight.normal,
                                                contact.name ??
                                                    AppLocalizations.of(
                                                            context)!
                                                        .noUserName,
                                                16),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.3,
                                                    child: Text(
                                                      contact.address ??
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .userNoAddress,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xFF000000),
                                                        fontSize: 13,
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  // void _makePhoneCall(BuildContext context, String phoneNumber) async {
  //   final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);

  //   // 📌 कॉल परमिशन चेक करें
  //   var status = await Permission.phone.status;
  //   if (!status.isGranted) {
  //     status = await Permission.phone.request();
  //     if (!status.isGranted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Call permission is required")),
  //       );
  //       return;
  //     }
  //   }

  //   if (await canLaunchUrl(callUri)) {
  //     await launchUrl(callUri);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Could not launch $callUri")),
  //     );
  //   }
  // }

  /// Helper function to format phone number for WhatsApp
  String formatPhoneNumber(String phone, {String defaultCountryCode = '91'}) {
    String cleanedPhone = phone.replaceAll(RegExp(r'\D'), '');

    // Remove leading zero
    if (cleanedPhone.startsWith('0')) {
      cleanedPhone = cleanedPhone.substring(1);
    }

    if (!cleanedPhone.startsWith(defaultCountryCode)) {
      cleanedPhone = '$defaultCountryCode$cleanedPhone';
    }

    print("Formatted WhatsApp Phone: $cleanedPhone");
    return cleanedPhone; // ✅ no `+` in this string!
  }

  void openWhatsApp(BuildContext context, String phone) async {
    String formattedPhone = formatPhoneNumber(phone);

    final Uri whatsappUrl =
        Uri.parse("https://wa.me/$formattedPhone?text=Hello");

    try {
      // Always launch directly (skip canLaunch check)
      final launched = await launchUrl(
        whatsappUrl,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) throw 'Could not launch';
    } catch (e) {
      // Show fallback snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("WhatsApp not available")),
      );

      // Redirect to Play Store
      await launchUrl(
        Uri.parse("https://play.google.com/store/apps/details?id=com.whatsapp"),
        mode: LaunchMode.externalApplication,
      );
    }
  }
}
