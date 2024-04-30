import 'package:flutter/material.dart';
import 'package:flutter_skripsi/Model/Customer.dart';
import 'package:flutter_skripsi/View/CustomerDetail.dart';
import 'package:flutter_skripsi/View/Map.dart';
import 'package:flutter_skripsi/ViewModel/ViewModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomerView extends StatefulWidget {
  final ViewModel viewModel;
  final Map<String, dynamic> salesmanData;

  CustomerView({required this.viewModel, required this.salesmanData});

  @override
  _CustomerViewState createState() => _CustomerViewState();
}

class _CustomerViewState extends State<CustomerView> {
  late List<Customer> displayedCustomer;
  String? selectedValue;
  String? selectedGudangNama;

  late TextEditingController _searchController;
  late String searchText;

  @override
  void initState() {
    super.initState();
    displayedCustomer = [];
    searchText = '';
    _searchController = TextEditingController();
    _fetchCustomers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchCustomers() async {
    await widget.viewModel.getCustomer(widget.salesmanData['ID_SALES']);
    setState(() {
      displayedCustomer = List.from(widget.viewModel.customer);
    });
  }

  void _searchCustomer(String query) {
    setState(() {
      searchText = query;
      if (query.isEmpty) {
        displayedCustomer = widget.viewModel.customer.toList();
      } else {
        displayedCustomer = widget.viewModel.customer
            .where((customer) =>
                customer.nama.toLowerCase().contains(query.toLowerCase()) ||
                customer.idCustomer.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Data Customer',
            style: TextStyle(fontSize: 30),
          ),
          centerTitle: true,
          toolbarHeight: 100,
        ),
        body: Column(children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cari Customer',
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear), // Icon silang
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchCustomer('');
                    });
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
              onChanged: _searchCustomer,
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: displayedCustomer.length,
              itemBuilder: (BuildContext context, int index) {
                final customer = displayedCustomer[index];
                print(customer);
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CustomerDetail(
                              customer: customer,
                            ),
                          ));
                        },
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${customer.idCustomer} - ${customer.nama}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                            InkWell(
                              onTap: () {
                                String titik = customer.titikGps;
                                List<String> koordinat = titik.split(',');
                                double latitude = double.parse(koordinat[0]);
                                double longitude = double.parse(koordinat[1]);
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MapScreen(
                                    destination: LatLng(latitude, longitude),
                                  ),
                                ));
                              },
                              child: Row(
                                children: [
                                  ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                      Colors.blue,
                                      // Warna yang diinginkan (misalnya biru)
                                      BlendMode.srcIn,
                                    ),
                                    child: Image.asset(
                                      'assets/pictures/direction.png',
                                      // Ganti dengan path gambar Anda
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Arah',
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 30),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customer.alamat,
                              style: TextStyle(fontSize: 30),
                            ),
                            SizedBox(height: 4),
                            Text(
                              customer.kota,
                              style: TextStyle(fontSize: 30),
                            ),
                            SizedBox(height: 4),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ]));
  }
}
