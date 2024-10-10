import 'package:cloud_firestore/cloud_firestore.dart';

class Product{
  final String id;
  String productName;
  int productPrice;
  String productCategory;
  Product({required this.id, required this.productName,  required this.productPrice,  required this.productCategory});
  factory Product.create({ required String id,required String productName,  required int productPrice,  required String productCategory}){
   return Product(id:id,productName:productName,productPrice:productPrice,productCategory:productCategory);
  }
  factory Product.fromFirestore(DocumentSnapshot<Map<String,dynamic>> snapshot,SnapshotOptions? options){
    final data = snapshot.data();
    return Product(id:data?['id'],productName: data?['productName'],productPrice:data?['productPrice'],productCategory:data?['productCategory']);
  }
  factory Product.fromJson(Map<String,dynamic> json){
    return Product(id:json?['id'],productName: json?['productName'],productPrice:json?['productPrice'],productCategory:json?['productCategory']);
  }
  Map<String,dynamic> toFirestore(){
    return {
      "id":id,
      "productName":productName,
      "productPrice":productPrice,
      "productCategory":productCategory
    };
  }
}