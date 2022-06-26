import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_seller_app/global/global.dart';
import 'package:food_seller_app/model/items.dart';
import 'package:food_seller_app/splashScreen/splash_screen.dart';
import 'package:food_seller_app/widgets/simple_app_bar.dart';




class ItemDetailsScreen extends StatefulWidget
{
  final Items? model;
  ItemDetailsScreen({this.model});

  @override
  _ItemDetailsScreenState createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen>
{
  TextEditingController counterTextEditingController = TextEditingController();

  deleteItem(String itemID)
  {
    FirebaseFirestore.instance.collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("menus")
        .doc(widget.model!.menuID!)
        .collection("items")
        .doc(itemID)
        .delete().then((value)
    {
      FirebaseFirestore.instance
          .collection("items")
          .doc(itemID)
          .delete();
      Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
      Fluttertoast.showToast(msg: "Item Deleted successfully");

    });
  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: SimpleAppBar(title: sharedPreferences!.getString("name"),),
      body: SingleChildScrollView(

        child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Image.network(widget.model!.thumbnailUrl.toString()),


            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.model!.title.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.model!.longDescription.toString(),
                textAlign: TextAlign.justify,
                style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
              "₹ " + widget.model!.price.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            const SizedBox(height:8),

            Center(
              child: InkWell(
                onTap: ()
                {
                  deleteItem(widget.model!.itemID!);
                },
                child: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.cyan,
                          Colors.amber,
                        ],
                        begin:  FractionalOffset(0.0, 0.0),
                        end:  FractionalOffset(1.0, 0.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp,
                      )
                  ),
                  width: MediaQuery.of(context).size.width - 40,
                  height: 20,
                  child: const Center(
                    child: Text(
                      "Delete Item",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
