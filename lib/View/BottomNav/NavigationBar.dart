
import 'package:flutter/material.dart';
import 'package:flutter_skripsi/View/BottomNav/Profile.dart';
import 'package:flutter_skripsi/View/CustomBackButton/CustomWillPopScope.dart';
import 'package:flutter_skripsi/View/BottomNav/CustomerView.dart';
import 'package:flutter_skripsi/View/BottomNav/Home.dart';
import 'package:flutter_skripsi/View/BottomNav/TransaksiHome.dart';
import 'package:flutter_skripsi/ViewModel/ViewModel.dart';

class bottomnav extends StatefulWidget {
  final Map<String, dynamic> salesmanData;
  bottomnav({required this.salesmanData});

  @override
  State<bottomnav> createState() => _bottomnavState();
}

class _bottomnavState extends State<bottomnav> {
  List<Widget> _pages = [];
  final viewModel = ViewModel();

  @override
  void initState() {
    super.initState();
    _pages = [
      Home(viewModel: viewModel, salesmanData: widget.salesmanData,),
      CustomerView(viewModel: viewModel, salesmanData: widget.salesmanData),
      TransaksiHome(viewModel: viewModel, salesmanData: widget.salesmanData,),
      ProfilePage(salesmanData: widget.salesmanData)
    ];
  }
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomWillPopScopeWidget(
        child: Container(
          color: Color(0xFFFFBF09), // Set the background color of the body
          child: _pages[_currentIndex],
        ),
      ),

      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), // Adjust the radius as needed
            topRight: Radius.circular(20.0), // Adjust the radius as needed
          ),
          boxShadow: [
            BoxShadow(
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), // Adjust the radius as needed
            topRight: Radius.circular(20.0), // Adjust the radius as needed
          ),
          child: BottomNavigationBar(
            backgroundColor: Color(0xFFFFBF09), // Set the background color of the BottomNavigationBar
            showUnselectedLabels: false,
            selectedItemColor: Color(0xff0029FF),
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/pictures/home.png',
                  width: 40, // Set the desired width
                  height: 40, // Set the desired height
                  color: Color(0xff1C274C),
                ),
                activeIcon: Image.asset(
                  'assets/pictures/home_active.png',
                  width: 40, // Set the desired width
                  height: 40, // Set the desired height
                  color: Color(0xff0029FF),
                ),
                label: "Home",

              ),

              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/pictures/customer.png',
                  width: 40, // Set the desired width
                  height: 40, // Set the desired height
                  color: Color(0xff1C274C),
                ),
                activeIcon: Image.asset(
                  'assets/pictures/customer_active.png',
                  width: 40, // Set the desired width
                  height: 40, // Set the desired height
                  color: Color(0xff0029FF),
                ),
                label: "Lihat Customer",
              ),

              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/pictures/list.png',
                  width: 40, // Set the desired width
                  height: 40, // Set the desired height
                  color: Color(0xff1C274C),
                ),
                activeIcon: Image.asset(
                  'assets/pictures/list_active.png',
                  width: 40, // Set the desired width
                  height: 40, // Set the desired height
                  color: Color(0xff0029FF),
                ),
                label: "Transaksi Saya",
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/pictures/user.png',
                  width: 40, // Set the desired width
                  height: 40, // Set the desired height
                  color: Color(0xff1C274C),
                ),
                activeIcon: Image.asset(
                  'assets/pictures/user_active.png',
                  width: 40, // Set the desired width
                  height: 40, // Set the desired height
                  color: Color(0xff0029FF),
                ),
                label: "Akun Saya",
              ),
            ],
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            selectedFontSize: 18,
            unselectedFontSize: 18,
          ),
        ),
      ),
    );
  }
}

