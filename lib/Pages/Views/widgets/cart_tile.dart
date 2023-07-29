
import 'package:flutter/material.dart';
import 'package:internshipapplication/Pages/app_color.dart';
import 'package:internshipapplication/Pages/core/model/Cart.dart';

class CartTile extends StatelessWidget {
  final Cart data;
  CartTile({required this.data});
  @override
  Widget build(BuildContext context) {

    String formatRupiah(int value) {
      String rupiah = value.toString();
      String result = '';

      while (rupiah.length > 3) {
        result = '.${rupiah.substring(rupiah.length - 3)}$result';
        rupiah = rupiah.substring(0, rupiah.length - 3);
      }

      return 'Rp $rupiah$result';
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80,
      padding: EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.border, width: 1),
      ),
      child: Row(
        children: [
          // Image
          Container(
            width: 70,
            height: 70,
            margin: EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: AppColor.border,
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(image: AssetImage(data.image[0]), fit: BoxFit.cover),
            ),
          ),
          // Info
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                Text(
                  '${data.name}',
                  style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'poppins', color: AppColor.secondary),
                ),
                // Product Price - Increment Decrement Button
                Container(
                  margin: EdgeInsets.only(top: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Product Price
                      Expanded(
                        child: Text(
                          '${formatRupiah(data.price,)}',
                          style: TextStyle(fontWeight: FontWeight.w700, fontFamily: 'poppins', color: AppColor.primary),
                        ),
                      ),
                      // Increment Decrement Button
                      Container(
                        height: 26,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColor.primarySoft,
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                print('minus');
                              },
                              child: Container(
                                width: 26,
                                height: 26,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColor.primarySoft,
                                ),
                                child: Text(
                                  '-',
                                  style: TextStyle(fontFamily: 'poppins', fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '${data.count}',
                                  style: TextStyle(fontFamily: 'poppins', fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                print('plus');
                              },
                              child: Container(
                                width: 26,
                                height: 26,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColor.primarySoft,
                                ),
                                child: Text(
                                  '+',
                                  style: TextStyle(fontFamily: 'poppins', fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}