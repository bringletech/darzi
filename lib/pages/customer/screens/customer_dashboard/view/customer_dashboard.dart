// ignore_for_file: avoid_print, deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:darzi/Reusable/Search_pages/search_field_all_pages.dart';
import 'package:darzi/Reusable/Search_pages/search_page.dart';
import 'package:darzi/Reusable/text_reusable_pop.dart';
import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/customer_favourite_response_model.dart';
import 'package:darzi/apiData/model/get_current_customer_list_details_model.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/pages/customer/screens/customer_Login/view/customerRegisterPage.dart';
import 'package:darzi/pages/customer/screens/customer_dashboard/view/my_favourite_tailor.dart';
import 'package:darzi/pages/customer/screens/customer_dashboard/view/mydresses%20copy.dart';
import 'package:darzi/pages/customer/screens/customer_dashboard/view/mytailors%20copy.dart';
import 'package:darzi/pages/customer/screens/customer_dashboard/view/tailor_search_detail.dart';
import 'package:darzi/pages/customer/screens/customer_notifications/view/customer_notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../l10n/app_localizations.dart';

class CustomerHomeScreen extends StatefulWidget {
  final Locale locale;
  const CustomerHomeScreen({super.key, required this.locale});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  List<CustomerOrder> orderList = [];
  List<Customer_Favourite_Data> customer_Favourite_Data = [];
  Favourite_Tailor? favourite_Tailor_Data;
  final List<bool> _isTapped = [false, false];
  // final int _selectedIndex = 0;
  int currentIndex = 0; // Track current position
  bool isLoading = true,
      isBackArrowTapped = false; // By default, icon color is grey

  final PageController _pageController = PageController(viewportFraction: 0.8);
  String userName = "";
  String? userProfile, userAddress;

  // Common method for access token check and navigation
  Future<bool> checkAccessTokenAndShowPopup({
    bool showPopup = true,
    Widget? destination,
    bool shouldNavigate = false,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');

    if (accessToken == null || accessToken.isEmpty) {
      if (showPopup) {
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
                            shouldNavigate
                                ? AppLocalizations.of(context)!.cancel
                                : "Cancel",
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
                                builder: (context) => CustomerregisterpagePage(
                                    locale: widget.locale),
                              ),
                            ).then((value) {
                              checkAccessTokenAndFetchData();
                            });
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
      return false;
    } else {
      // If access token exists and navigation is required
      if (shouldNavigate && destination != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => destination),
        );
      }
      return true;
    }
  }

  Future<void> checkAccessTokenAndFetchData() async {
    bool hasToken = await checkAccessTokenAndShowPopup(showPopup: false);

    if (hasToken) {
      getCustomerFavouriteData();
    } else {
      setState(() {
        isLoading = false;
      });
      print('accesstoken is null');
    }
  }

  @override
  void initState() {
    super.initState();
    checkAccessTokenAndFetchData(); // Only fetch if token exists
    getSharedPrefenceValue();
    _pageController.addListener(() {
      int newIndex = _pageController.page!.round();
      if (newIndex != currentIndex) {
        setState(() {
          currentIndex = newIndex;
        });
      }
    });
  }

  // Function to update state
  void updateBackArrowColor(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    // double spotlightWidth = screenWidth * 0.9;
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(
                color: AppColors.newUpdateColor,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  //Welcome + Location + Profile Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          userName.isNotEmpty
                              ? TextResPopp(
                                  FontWeight.w700, "Welcome ${userName}!", 20)
                              : Text(
                                  AppLocalizations.of(context)!.welcome,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                          const SizedBox(height: 4),
                          (userAddress != null &&
                                  userAddress.toString().trim().isNotEmpty)
                              ? Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 16,
                                      color: AppColors.blackTextColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      userAddress!,
                                      style: TextStyle(
                                        color: AppColors.blackTextColor,
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox.shrink(),
                        ],
                      ),

                      /// 🔹 Notification + Profile
                      Row(
                        children: [
                          Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print("Bell tapped!");
                                  checkAccessTokenAndShowPopup(
                                    destination: CustomerNotificationScreen(
                                      locale: widget.locale,
                                    ),
                                    shouldNavigate: true,
                                  );
                                },
                                child: const Icon(
                                  Icons.notifications_none,
                                  size: 28,
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            icon: const Icon(LucideIcons.shoppingCart,
                                color: Colors.black),
                            onPressed: () {},
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SearchFieldReusable(
                    hintText: "Search here",
                    onTap: () {
                      // ✅ Action when search field is tapped
                      print("Search field tapped!");
                      // Example: Navigate to another screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchScreenUi(),
                        ),
                      );
                    },
                  ),

                  // SearchFieldReusable(),
                  const SizedBox(height: 10),
                  TextResPopp(
                    FontWeight.w700,
                    "Let’s Get Started!",
                    25,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //  Grid Items
                  Row(
                    children: [
                      _buildCustomGridItem(
                        AppLocalizations.of(context)!.myTailor,
                        Center(
                          child: Image.asset(
                            'assets/images/carbon_order-details.png',
                            color: Colors.black,
                          ),
                        ),
                        0,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      _buildCustomGridItem1(
                        AppLocalizations.of(context)!.myDresses,
                        Image.asset(
                          'assets/images/order-icon.png',
                          color: Colors.black,
                        ),
                        1,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextResPopp(FontWeight.w600, "Popular Tailor Nearby >", 16),

                  // My Favourites Section
                  Visibility(
                    visible: customer_Favourite_Data.isNotEmpty,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 40, left: 10),
                          width: double.infinity,
                          child: Text(
                            AppLocalizations.of(context)!.my_favourites,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.newUpdateColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .16,
                          child: ListView.builder(
                            controller: _pageController,
                            scrollDirection: Axis.horizontal,
                            itemCount: customer_Favourite_Data.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MyFavouriteTailorDetails(
                                          locale: widget.locale,
                                          tailorId:
                                              customer_Favourite_Data[index]
                                                  .tailor!
                                                  .id
                                                  .toString(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.43,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4,
                                        )
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Stack(
                                        children: [
                                          CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                            imageUrl:
                                                customer_Favourite_Data[index]
                                                    .tailor!
                                                    .profileUrl
                                                    .toString(),
                                            errorWidget:
                                                (context, url, error) => Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Image.network(
                                                  'https://dummyimage.com/500x500/aaa/000000.png&text=',
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                ),
                                                const Text(
                                                  "No Image Available",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                                colors: [
                                                  Colors.black.withOpacity(0.6),
                                                  Colors.transparent
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 15,
                                            left: 10,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  customer_Favourite_Data[index]
                                                          .tailor!
                                                          .name ??
                                                      AppLocalizations.of(
                                                              context)!
                                                          .noUserName,
                                                  style: const TextStyle(
                                                    fontFamily: 'Poppins',
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.location_on,
                                                      color: AppColors
                                                          .newUpdateColor,
                                                      size: 14,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      customer_Favourite_Data[
                                                                  index]
                                                              .tailor!
                                                              .address ??
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .userNoAddress,
                                                      style: const TextStyle(
                                                        fontFamily: 'Poppins',
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w400,
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
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (currentIndex > 0) {
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.ease,
                                  );
                                }
                              },
                              icon: SvgPicture.asset(
                                'assets/svgIcon/back_arrow.svg',
                                color: currentIndex == 0
                                    ? Colors.grey
                                    : AppColors.newUpdateColor,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (currentIndex <
                                    customer_Favourite_Data.length - 1) {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.ease,
                                  );
                                }
                              },
                              icon: SvgPicture.asset(
                                'assets/svgIcon/forward_arrow.svg',
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Widget _buildCustomGridItem(String label, Widget icon, int index) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isTapped[index] = true;
        });
      },
      onTapUp: (_) {
        // Reset tapped state after a brief delay
        Future.delayed(const Duration(milliseconds: 100), () async {
          setState(() {
            _isTapped[index] = false;
          });

          bool isAllowed = await checkAccessTokenAndShowPopup();
          if (!isAllowed) return;

          // Your existing navigation logic here
          if (index == 0) {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      TailorSearchDetail(locale: widget.locale)
                  // MyTailors(locale: widget.locale),
                  ),
            );
            if (result == true) {
              setState(() {
                getCustomerFavouriteData();
              });
            }
          } else {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyDresses(locale: widget.locale)),
            );
            if (result == true) {
              setState(() {
                getCustomerFavouriteData();
              });
            }
          }
        });
      },
      onTapCancel: () {
        setState(() {
          _isTapped[index] = false;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 140, // box height
            width: 150, // box width
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.blackTextColor.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                "assets/images/carbon_order-details.png",
                height: 70,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.newUpdateColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomGridItem1(String label, Widget icon, int index) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isTapped[index] = true;
        });
      },
      onTapUp: (_) {
        Future.delayed(const Duration(milliseconds: 100), () async {
          setState(() {
            _isTapped[index] = false;
          });

          bool isAllowed = await checkAccessTokenAndShowPopup();
          if (!isAllowed) return;

          if (index == 0) {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyTailors(locale: widget.locale)),
            );
            if (result == true) {
              setState(() {
                getCustomerFavouriteData();
              });
            }
          } else {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyDresses(locale: widget.locale)),
            );
            if (result == true) {
              setState(() {
                getCustomerFavouriteData();
              });
            }
          }
        });
      },
      onTapCancel: () {
        setState(() {
          _isTapped[index] = false; // Reset tapped state on cancel
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 140, // box height
            width: 160, // box width
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.blackTextColor.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                "assets/images/order-icon.png",
                height: 70,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.newUpdateColor,
            ),
          ),
        ],
      ),
    );
  }

  void getCustomerFavouriteData() {
    setState(() {
      isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Customer_Favourites_Response_Model model =
            await CallService().getMyFavourite_TailorList();
        setState(() {
          isLoading = false;
          customer_Favourite_Data = model.data!;
          print("Favourite Data Value is: ${customer_Favourite_Data.length}");
        });
      });
    });
  }

  Future<void> getSharedPrefenceValue() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      userName = prefs.getString('userName') ?? "";
      userProfile = prefs.getString('userProfile') ?? "";
      userAddress = prefs.getString('userAddress') ?? "";
    });

    print("customer Name is $userName");
    print("customer Profile is $userProfile");
  }
}
