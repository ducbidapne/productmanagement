import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:productmanagement/constants/collection.dart';
import 'package:productmanagement/screens/create.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Map<String,dynamic>> _productIds;
  late List<dynamic> result = [];
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = true;
    fetchData();
  }

    fetchData() async {
      _isLoading = true;
    final db = FirebaseFirestore.instance;
    var snap = await db.collection(Collection.products).get();
    print(snap);
    List<dynamic> resultData = snap.docs.map((doc)=>doc.data()).toList();
    // return result;
      print(resultData);
      setState(() {
        _isLoading = false;
        result =resultData;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        title: Text("Home",style: TextStyle(color: Colors.black,)),
        actions: [IconButton(onPressed: (){
          Navigator.push(context,MaterialPageRoute(builder: (context)=>CreateSreen())).then((data)=>fetchData());
        }, icon: Icon(Icons.add))],
      ),
      body: ListView.builder(itemCount: result.length,
      itemBuilder: (context,index){
        return Card(
          child: ListTile(
            onTap: (){},leading: const Icon(Icons.add_shopping_cart),
            title: Text(result[index]['productName']),
            // subtitle: Text(result[index]['productPrice'].toString()),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(result[index]['productPrice'].toString(),
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue,
                  ),),
                Text(result[index]['productCategory'].toString(),
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>CreateSreen(product:result[index]))).then((data)=>fetchData());
                }, icon: Icon(Icons.edit,color:Colors.blue)),
                IconButton(onPressed: () {
                  deleteDialog(context,result[index]['id']);
                }, icon: Icon(Icons.delete,color:Colors.red))
              ],
            ),
          ),
        );
      },),
    );
  }
  deleteDialog(BuildContext context,id) async{
    print(id);
    return showDialog(context: context, builder: (param){
      return AlertDialog(title: const Text("Are you sure to delete",style: TextStyle(color:Colors.teal,fontSize: 20)
        ,),
          actions: [
            TextButton(onPressed: () async{
              final db = FirebaseFirestore.instance;
              await db.collection(Collection.products).doc(id).delete();
              await fetchData();
              Navigator.pop(context);
            },
                child: const Text("Delete"),style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 16) ),
            ),
            TextButton(onPressed: (){
              Navigator.pop(context);
            },
              child: const Text("Close"),style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 16) ),
            ),
          ],
      );
    });
  }
}
