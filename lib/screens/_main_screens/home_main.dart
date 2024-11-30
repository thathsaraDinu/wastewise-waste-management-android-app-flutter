import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_repository/user_repository.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({super.key});

  @override
  State<HomeMain> createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  // Static list of vendor ads
  final List<Map<String, String>> vendorAds = [
    {
      'vendorName': 'Green Recycling Ltd.',
      'wasteType': 'Plastic Waste',
      'description': 'We offer best prices for your plastic waste!',
    },
    {
      'vendorName': 'Eco-Friendly Solutions',
      'wasteType': 'Organic Waste',
      'description': 'Recycle your organic waste with us and get discounts!',
    },
    {
      'vendorName': 'Tech Recyclers',
      'wasteType': 'E-Waste',
      'description': 'We safely dispose of all your electronic waste.',
    },
    {
      'vendorName': 'Metal Scrap Co.',
      'wasteType': 'Metal Waste',
      'description': 'We collect and recycle metal waste at great prices!',
    },
    {
      'vendorName': 'Paper Recycle Hub',
      'wasteType': 'Paper Waste',
      'description': 'Turn your paper waste into useful products with us.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final userRepo = Provider.of<FirebaseUserRepo>(context, listen: false);

    // Filter the vendorAds list based on the search query
    final List<Map<String, String>> filteredAds = vendorAds
        .where((ad) =>
            ad['vendorName']!
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            ad['wasteType']!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 220,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/vehicle.jpg"),
                  fit: BoxFit.fill),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          StreamBuilder<MyUser>(
                              stream: userRepo.user,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox(height: 35,); // Show loading indicator while waiting
                                } else if (snapshot.hasError) {
                                  return Text(
                                      'Error: ${snapshot.error}'); // Show error if there is one
                                } else if (!snapshot.hasData) {
                                  return const Text(
                                    "Hi, User",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ); // Handle case where there's no data
                                } else {
                                  MyUser user = snapshot.data!;
                                  return Text(
                                    "Hi, ${user.name}",
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  );
                                }
                              }),
                        ],
                      ),
                      const Row(
                        children: [
                          Text(
                            "Welcome",
                            style: TextStyle(
                                color: Color.fromARGB(255, 117, 117, 117),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ],
                  ),
                  // Search bar
                  TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search vendors or waste type...',
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              'Vendors for Waste Collection',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: List.generate(
                  filteredAds.length,
                  (index) {
                    var ad = filteredAds[index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          border: Border.all(
                              color: Colors.green.shade600, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ad['vendorName']!,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 16),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: Colors.green.shade600,
                                            width: 1)),
                                    child: Text(
                                      ad['wasteType']!,
                                      style: TextStyle(
                                        color: Colors.green.shade600,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                ad['description']!,
                                style: const TextStyle(color: Colors.black),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: () {},
                                    icon: Icon(Icons.info,
                                        color: Colors.green[600]),
                                    label: Text(
                                      "Details",
                                      style:
                                          TextStyle(color: Colors.green[600]),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                          color: Colors.green.shade600,
                                          width: 1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      backgroundColor: Colors.white,
                                    ),
                                  ),
                                  OutlinedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.contact_page,
                                        color: Colors.blue),
                                    label: const Text(
                                      "Contact",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                          color: Colors.blue, width: 1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      backgroundColor: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
