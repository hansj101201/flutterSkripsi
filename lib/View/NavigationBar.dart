
import 'package:flutter/material.dart';
import 'package:flutter_skripsi/View/CustomWillPopScope.dart';
import 'package:flutter_skripsi/View/CustomerView.dart';
import 'package:flutter_skripsi/View/Home.dart';
import 'package:flutter_skripsi/View/TransaksiHome.dart';
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
      TransaksiHome(viewModel: viewModel, salesmanData: widget.salesmanData,)
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
                  'assets/home.png',
                  width: 24, // Set the desired width
                  height: 24, // Set the desired height
                  color: Color(0xff1C274C),
                ),
                activeIcon: Image.asset(
                  'assets/home_active.png',
                  width: 24, // Set the desired width
                  height: 24, // Set the desired height
                  color: Color(0xff0029FF),
                ),
                label: "Home",
              ),

              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/customer.png',
                  width: 24, // Set the desired width
                  height: 24, // Set the desired height
                  color: Color(0xff1C274C),
                ),
                activeIcon: Image.asset(
                  'assets/customer_active.png',
                  width: 24, // Set the desired width
                  height: 24, // Set the desired height
                  color: Color(0xff0029FF),
                ),
                label: "Lihat Customer",
              ),

              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/list.png',
                  width: 24, // Set the desired width
                  height: 24, // Set the desired height
                  color: Color(0xff1C274C),
                ),
                activeIcon: Image.asset(
                  'assets/list_active.png',
                  width: 24, // Set the desired width
                  height: 24, // Set the desired height
                  color: Color(0xff0029FF),
                ),
                label: "Transaksi Saya",
              ),
            ],
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}

