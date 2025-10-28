import 'package:darzi/Reusable/Search_pages/search_field_all_pages.dart';
import 'package:darzi/Reusable/text_reusable_pop.dart';
import 'package:darzi/Reusable/text_reusable_rob.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/pages/customer/screens/customer_shop/example.dart';
import 'package:flutter/material.dart';

class SearchTailerDetail extends StatefulWidget {
  const SearchTailerDetail({super.key});

  @override
  State<SearchTailerDetail> createState() => _SearchTailerDetailState();
}

class _SearchTailerDetailState extends State<SearchTailerDetail> {
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredShops = [];

  List<Map<String, dynamic>> shopList = [
    {
      "name": "FashionStyle",
      "owner": "Tanya Sharma",
      "rating": 4.5,
      "store": "Cloth House",
      "location": "Himachal",
      "image": "assets/images/shop.png",
    },
    {
      "name": "StylePoint",
      "owner": "Rohan Kumar",
      "rating": 4.2,
      "store": "Fabric World",
      "location": "Punjab",
      "image": "assets/images/shop.png",
    },
    {
      "name": "FashionStyle",
      "owner": "Tanya Sharma",
      "rating": 4.5,
      "store": "Cloth House",
      "location": "Himachal",
      "image": "assets/images/shop.png",
    },
    {
      "name": "StylePoint",
      "owner": "Rohan Kumar",
      "rating": 4.2,
      "store": "Fabric World",
      "location": "Punjab",
      "image": "assets/images/shop.png",
    },
    {
      "name": "FashionStyle",
      "owner": "Tanya Sharma",
      "rating": 4.5,
      "store": "Cloth House",
      "location": "Himachal",
      "image": "assets/images/shop.png",
    },
    {
      "name": "StylePoint",
      "owner": "Rohan Kumar",
      "rating": 4.2,
      "store": "Fabric World",
      "location": "Punjab",
      "image": "assets/images/shop.png",
    },
  ];

  @override
  void initState() {
    super.initState();
    filteredShops = shopList;
  }

  void filterShops(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredShops = shopList;
      } else {
        filteredShops = shopList
            .where((shop) =>
                shop['name']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                shop['owner']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                shop['store']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                shop['location']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextResPopp(FontWeight.w500, "Shop fabric you like", 32),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              child: SearchFieldReusable(
                controller: searchController,
                onChanged: filterShops,
              ),
            ),
            ...filteredShops.map((shop) => reusableContainer(shop)),
          ],
        ),
      ),
    );
  }

  Widget reusableContainer(Map<String, dynamic> shop) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent, // <-- add this line
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShopDetailPage(
              shopName: shop['name'],
              tailorName: shop['owner'],
              imageData: shop['image'],
              rating: shop['rating'].toString(),
            ),
          ),
        );
      },
      child: Container(
        height: 118,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          children: [
            // Left Image Container
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                shop['image'],
                fit: BoxFit.cover,
                height: 107,
                width: 105,
              ),
            ),
            const SizedBox(width: 10),

            // Right Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating and Icons Row
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 15,
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: const Color.fromARGB(255, 214, 109, 17),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.white, size: 10),
                            const SizedBox(width: 5),
                            Text(
                              shop['rating'].toString(),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.chat_outlined,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(3.1416),
                            child: const Icon(Icons.reply_rounded,
                                size: 16, color: Colors.grey),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.favorite_border,
                              size: 16, color: Colors.grey),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  TextResPopp(FontWeight.w500, shop['name'], 16),
                  TextResuableRob(
                    FontWeight.normal,
                    shop['owner'],
                    12,
                    color: AppColors.greyColor,
                  ),

                  const SizedBox(height: 4),

                  // Store & Map
                  Row(
                    children: [
                      const Icon(Icons.house, size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      TextResuableRob(FontWeight.normal, shop['store'], 10),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(40, 20),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: TextResuableRob(
                          FontWeight.normal,
                          "View on map",
                          8,
                          color: AppColors.newUpdateColor,
                        ),
                      ),
                    ],
                  ),

                  // Location
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      TextResuableRob(FontWeight.normal, shop['location'], 10),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
