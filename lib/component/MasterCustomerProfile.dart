import 'package:flutter/material.dart';

class MasterCustomerProfile extends StatefulWidget {
  final String nama;
  final String noHp;
  final String alamat;
  final String kota;

  const MasterCustomerProfile(
      {super.key, required this.nama, required this.noHp, required this.alamat, required this.kota});

  @override
  State<MasterCustomerProfile> createState() => _MasterCustomerProfileState();
}

class _MasterCustomerProfileState extends State<MasterCustomerProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // First shadow
            blurRadius: 2.0,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.15), // Second shadow
            blurRadius: 3.0,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(
            left: 10.0, right: 20, top: 10.0, bottom: 10.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: SizedBox(
                    height: 100,
                    child: Icon(
                      Icons.account_circle, // Icon for account
                      size: 100, // Icon size
                      color: Colors.black, // Icon color
                    ),
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.nama,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Plus Jakarta Sans Bold',
                          fontWeight: FontWeight.w700,
                          color: Color(0XFF344054),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.noHp,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Plus Jakarta Sans Regular',
                          fontWeight: FontWeight.w400,
                          color: Color(0XFF1D2939),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.kota,
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Plus Jakarta Sans Bold',
                          fontWeight: FontWeight.w700,
                          color: Color(0XFFE19767),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0XFFE19767), // Background color
                      shape: BoxShape.rectangle, // Box shape
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Divider placed here
            Divider(
              color: Colors.grey[400], // Color of the line
              thickness: 2.0, // Thickness of the line
              // height: 20.0,
            ),
            // Row for text on the left and text with icon on the right
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space elements between
              children: [
                Text(
                  '${widget.kota}, Indonesia',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.delete, 
                      color: Colors.red,
                    ),
                    SizedBox(width: 4), 
                    Text(
                      'Delete Customer',
                      style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Plus Jakarta Sans Bold',
                          color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
