import 'package:darzi/Reusable/Search_pages/search_field_all_pages.dart';
import 'package:darzi/Reusable/custome_app_bar.dart';
import 'package:darzi/Reusable/text_reusable_pop.dart';
import 'package:darzi/Reusable/text_reusable_rob.dart';
import 'package:darzi/colors.dart';
import 'package:flutter/material.dart';

class SearchScreenUi extends StatefulWidget {
  const SearchScreenUi({super.key});

  @override
  State<SearchScreenUi> createState() => _SearchScreenUiState();
}

class _SearchScreenUiState extends State<SearchScreenUi> {
  final TextEditingController searchController = TextEditingController();
  final List<String> customerList = [];
  List<String> filteredList = [];

  @override
  void initState() {
    super.initState();
    loadCustomers();
  }

  void loadCustomers() {
    // Sample data (can be replaced with API)
    customerList.addAll([
      "John Doe",
      "Emma Watson",
      "Michael",
      "Sophia",
      "David",
      "Lucas",
    ]);

    // Initially show all
    filteredList = List.from(customerList);
  }

  void updateSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredList = List.from(customerList);
      });
    } else {
      setState(() {
        filteredList = customerList
            .where((customer) =>
                customer.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  void clearSearch() {
    searchController.clear();
    setState(() {
      filteredList = List.from(customerList);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.textColor,
      appBar: CustomAppBars(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextResPopp(FontWeight.w700, "Find nearby tailor", 32),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextResuableRob(
                  FontWeight.w400, "Enter your location to find them.", 16),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SearchFieldReusable(
                hintText: "Search customers",
                suggestionList: filteredList,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
