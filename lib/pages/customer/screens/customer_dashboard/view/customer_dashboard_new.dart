// ignore_for_file: must_be_immutable

import 'package:darzi/colors.dart';
import 'package:darzi/common/common_bottom_navigation.dart';
import 'package:darzi/common/widgets/tab_data.dart';
import 'package:darzi/l10n/app_localizations.dart';
import 'package:darzi/pages/customer/screens/customer_Login/view/customerRegisterPage.dart';
import 'package:darzi/pages/customer/screens/customer_dashboard/view/customer_dashboard.dart';
import 'package:darzi/pages/customer/screens/customer_dashboard/view/search_tailer_detail.dart';
import 'package:darzi/pages/customer/screens/customer_search/view/customer_search_page.dart';
import 'package:darzi/pages/customer/screens/customer_shop/customer_fabric_address.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../customer_profile/view/customer_profile_page1.dart';

class CustomerDashboardNew extends StatefulWidget {
  static const TextStyle titleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 22,
    color: Colors.black,
  );

  final PageController tabController = PageController(initialPage: 1);

  var selectedIndex = 1;
  final Locale locale;

  CustomerDashboardNew({
    super.key,
    required this.locale,
  });

  @override
  State<CustomerDashboardNew> createState() => _CustomerDashboardNewState();
}

class _CustomerDashboardNewState extends State<CustomerDashboardNew> {
  // Function to check access token
  Future<bool> _checkAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');

    // Check if token is null or empty
    if (accessToken == null || accessToken.isEmpty) {
      return false;
    }
    return true;
  }

  // Function to show registration popup
  void _showRegistrationPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Container(
            margin: EdgeInsets.only(left: 16),
            child: Text(
              AppLocalizations.of(context)!.not_registered,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  fontSize: 20),
            ),
          ),
          content: Container(
            child: Text(
              AppLocalizations.of(context)!.login_message,
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
              children: [
                SizedBox(
                  height: 47,
                  width: 100,
                  child: Card(
                    color: Colors.white,
                    elevation: 4,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                          color: AppColors.newUpdateColor, width: 1.5),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: AppColors.newUpdateColor,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                SizedBox(
                  height: 47,
                  width: 110,
                  child: Card(
                    color: AppColors.newUpdateColor,
                    elevation: 4,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close popup
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CustomerregisterpagePage(locale: widget.locale),
                          ),
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.buttonContinue,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // Function to handle tab change with token validation
  Future<void> _handleTabChange(int index) async {
    // If trying to access profile screen (index 2)
    if (index == 2) {
      bool hasValidToken = await _checkAccessToken();

      if (!hasValidToken) {
        // Show popup if no valid token
        _showRegistrationPopup();
        return; // Don't change the tab
      }
    }

    // If token is valid or it's not profile screen, proceed normally
    setState(() {
      widget.selectedIndex = index;
      widget.tabController.jumpToPage(index);
      print("index..............    $index");
    });
  }

  int selectedIndex = 0;
  late List<Widget> _pages;

  void onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _pages = [
      CustomerHomeScreen(locale: widget.locale),
      SearchTailerDetail(),
      CustomerHomeScreen(locale: widget.locale),
      CustomerFabricAddress(),
      CustomerProfilePage(locale: widget.locale),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.newUpdateColor, // Orange background
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: onTabTapped,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.blackTextColor, // active
          unselectedItemColor: AppColors.textColor, // inactive
          selectedLabelStyle:
              GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 10),
          unselectedLabelStyle:
              GoogleFonts.poppins(fontWeight: FontWeight.normal, fontSize: 10),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Shop",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: "Messages",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              label: "Favorites",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined),
              label: "Profile",
            ),
          ],
        ),
      ),
      body: _pages[selectedIndex],
    );
  }
}
