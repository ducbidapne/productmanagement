import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:productmanagement/constants/collection.dart';
import 'package:productmanagement/models/product.dart';
import 'package:uuid/uuid.dart';
class CreateSreen extends StatefulWidget {
  final Map<String,dynamic>? product;
  const CreateSreen({super.key,this.product});

  @override
  State<CreateSreen> createState() => _CreateSreenState();
}

class _CreateSreenState extends State<CreateSreen> {
  final _productNameCrt = TextEditingController();
  final _productPriceCrt = TextEditingController();
  final _productCategoryCrt = TextEditingController();
  late Product _product;
  var uuid = Uuid();

  void createProduct(Product product) async{
    final db = FirebaseFirestore.instance;
    try{
      await db.collection(Collection.products).withConverter(fromFirestore: Product.fromFirestore, toFirestore: (value,options)
      {
        return product.toFirestore();
      }).doc(product.id).set(product);
      Navigator.pop(context);
    } catch (e){
      print(e.toString());
    }
  }

  void updateProduct(Product product) async{
    final db = FirebaseFirestore.instance;
    try{
      await db.collection(Collection.products).doc(widget.product!['id']).delete();
      await db.collection(Collection.products).withConverter(fromFirestore: Product.fromFirestore, toFirestore: (value,options)
      {
        return product.toFirestore();
      }).doc(product.id).set(product);
      Navigator.pop(context);

    } catch (e){
      print(e.toString());
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.product!=null && widget.product!['id'] !=""){
      setState(() {
        _productNameCrt.text = widget.product!['productName'];
        _productPriceCrt.text = widget.product!['productPrice'].toString();
        _productCategoryCrt.text = widget.product!['productCategory'];

      });
    }
    // print(widget.product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product!=null && widget.product!['id'] !="" ? "Edit":"Add new product"),
        centerTitle: false,
        elevation: 5.0,
      ),
      body: Padding(padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),labelText: "Product name"
            ),
            keyboardType: TextInputType.text,
            controller: _productNameCrt,
          ),
          const SizedBox(height: 10,),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),labelText: "Product price"
            ),
            keyboardType: TextInputType.number,
            controller: _productPriceCrt,
          ),
          const SizedBox(height: 10,),
          TextField(
          decoration: const InputDecoration(
          border: OutlineInputBorder(),labelText: "Product category"
           ),
          keyboardType: TextInputType.text,
            controller: _productCategoryCrt,
          ),
          const SizedBox(height: 10,),
          ElevatedButton(onPressed: (){
            setState(() {
              _product = Product.create(
                  id: uuid.v4(),
                  productName: _productNameCrt.text,
                  productPrice: int.parse(_productPriceCrt.text),
                  productCategory: _productCategoryCrt.text);

              if(widget.product!=null && widget.product!['id'] !=""){
                updateProduct(_product);
              }else{
                createProduct(_product);
              }
            });
          }, child: Text(widget.product!=null && widget.product!['id'] !="" ? "Update":"Add"))
        ],
      ),),
    );
  }
}
