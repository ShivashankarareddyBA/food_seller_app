import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:food_seller_app/global/global.dart';
import 'package:food_seller_app/model/menus.dart';
import 'package:food_seller_app/upload_screens/menus_upload_screen.dart';
import 'package:food_seller_app/widgets/info_design.dart';
import 'package:food_seller_app/widgets/my_drawer.dart';
import 'package:food_seller_app/widgets/progress_bar.dart';
import 'package:food_seller_app/widgets/text_widget_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final String? userId;

  @override
  void initState() {
    userId = sharedPreferences!.getString("uid");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Colors.cyan,
              Colors.amber,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )),
        ),
        title: Text(
          sharedPreferences!.getString("name") ?? "",
          style: const TextStyle(fontSize: 30, fontFamily: "Lobster"),
        ),
        centerTitle: true,
        //by default it is true
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.post_add,
              color: Colors.grey,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const MenusUploadScreen()));
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
              pinned: true, delegate: TextWidgetHeader(title: "My Menus")),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("sellers")
                .doc(userId)
                .collection('menus')
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.none) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Text('No data'),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Text('Done'),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: circularProgress(),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasError) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Text('Something went wrong'),
                    ),
                  );
                } else if (snapshot.hasData) {
                  return SliverStaggeredGrid.countBuilder(
                    crossAxisCount: 1,
                    staggeredTileBuilder: (c) => const StaggeredTile.fit(1),
                    itemBuilder: (context, index) {
                      final data = snapshot.data!.docs[index].data()
                          as Map<String, dynamic>;
                      Menus model = Menus.fromJson(
                        data,
                      );
                      return InfoDesignWidget(
                        model,
                        context: context,
                      );
                    },
                    itemCount: snapshot.data!.docs.length,
                  );
                } else {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Text('No data found'),
                    ),
                  );
                }
              }
              return const SliverToBoxAdapter(
                child: Center(
                  child: Text('Waiting...'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
