import 'package:flutter/material.dart';

class ShopDetailPage extends StatelessWidget {
  final String shopName;
  final String tailorName;
  final String imageData;
  final String rating;
  const ShopDetailPage(
      {super.key,
      required this.shopName,
      required this.tailorName,
      required this.imageData,
      required this.rating});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.arrow_back_ios_new,
                    size: 24,
                  ),
                  title: Text(
                    "Fashion Style",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 24,
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 156,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(4)),
                  child: Image.asset(imageData),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    height: 15,
                    decoration: BoxDecoration(color: Colors.orange),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 10,
                        ),
                        Text(
                          rating,
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  shopName,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                ),
                const Spacer(),
                Icon(
                  Icons.chat_outlined,
                  size: 20,
                  color: Colors.grey,
                ),
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(3.1416),
                  child: const Icon(
                    Icons.reply_rounded,
                    size: 20,
                    color: Colors.grey,
                  ),
                ),
                Icon(
                  Icons.favorite_border,
                  size: 20,
                  color: Colors.grey,
                )
              ],
            ),
            Text(
              tailorName,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.blueGrey),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.blueGrey)),
            SizedBox(
              height: 15,
            ),
            Row(children: [
              Text("Latest Arrivals",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              Spacer(),
              Text(
                "sort by",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
              ),
              SizedBox(
                width: 5,
              ),
              Column(
                children: [
                  Icon(Icons.arrow_drop_up_outlined),
                  Icon(Icons.arrow_drop_down_outlined)
                ],
              ),
            ]),
            Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(12)),
            )
          ],
        ),
      )),
    );
  }

  Widget myReusableContainer({required String imageData}) {
    return Container(
      width: 161,
      height: 239,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Image.asset(
            imageData,
            height: 148,
            width: 137,
          ),
          Row(
            children: [
              Container(
                height: 15,
                decoration: BoxDecoration(color: Colors.orange),
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 10,
                    ),
                    Text(
                      rating,
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Text("Plain Cotton"),
              Text("₹ 200"),
              Row(
                children: [],
              )
            ],
          )
        ],
      ),
    );
  }
}
