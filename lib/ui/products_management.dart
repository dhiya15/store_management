import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:storemanagement/db/product.dart';
import 'package:storemanagement/tools/strings.dart';
import 'package:storemanagement/tools/tools.dart';

class ProductsManagement extends StatefulWidget {
  @override
  _ProductsManagementState createState() => _ProductsManagementState();
}

class _ProductsManagementState extends State<ProductsManagement> {

  final _productFormKey = GlobalKey<FormState>();

  TextEditingController productName = TextEditingController();
  TextEditingController productQuantity = TextEditingController();
  TextEditingController productBuyPrice = TextEditingController();
  TextEditingController productSellingPrice = TextEditingController();
  TextEditingController productExpiration = TextEditingController();
  TextEditingController productBarCode = TextEditingController();

  TextEditingController productSearch = TextEditingController();

  List<Map<String, dynamic>> productsList;
  int length = 0;

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    fillProductsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          cleanProductFields();
          showProductWindow(0, Strings.add_product);
        },
        child: Icon(Icons.add_shopping_cart),
      ),
      body: manageProductWidget()
    );
  }

  Widget productWindow(){
    return Container(
      child: Form(
        key: _productFormKey,
        child: SingleChildScrollView(child: Column(children: <Widget>[
          TextFormField(
            controller: productName,
            maxLength: 50,
            decoration: InputDecoration(
              hintText: Strings.trade_name,
              icon: Icon(Icons.text_format),
            ),
            validator: (value) {
              return Tools.validateString(value, 6);
            },
          ),
          TextFormField(
            controller: productQuantity,
            maxLength: 50,
            decoration: InputDecoration(
              hintText: Strings.product_quantity,
              icon: Icon(Icons.plus_one),
            ),
            validator: (value) {
              return Tools.validateString(value, 4);
            },
          ),
          TextFormField(
            controller: productBuyPrice,
            maxLength: 50,
            decoration: InputDecoration(
              hintText: Strings.product_buy_price,
              icon: Icon(Icons.monetization_on),
            ),
            validator: (value) {
              return Tools.validateString(value, 7);
            },
          ),
          TextFormField(
              controller: productSellingPrice,
              maxLength: 50,
              decoration: InputDecoration(
                hintText: Strings.product_selling_price,
                icon: Icon(Icons.monetization_on),
              ),
              validator: (value) {
                return Tools.validateString(value, 7);
              }
          ),
          TextFormField(
            controller: productExpiration,
            maxLength: 50,
            readOnly: true,
            onTap: (){
              DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  onChanged: (date) {
                    setState(() {
                      productExpiration.text = Tools.fillDate(date);
                    });
                  }, onConfirm: (date) {
                    setState(() {
                      productExpiration.text = Tools.fillDate(date);
                    });
                  }, currentTime: DateTime.now(), locale: LocaleType.fr);
            },
            decoration: InputDecoration(
              hintText: Strings.product_expiration,
              icon: Icon(Icons.date_range),
            ),
            validator: (value) {
              return Tools.validateString(value, 5);
            },
          ),
          TextFormField(
            controller: productBarCode,
            readOnly: true,
            onTap: () async{
              String code = await Tools.scanQRCode();
              setState(() {
                productBarCode.text = code;
              });
            },
            decoration: InputDecoration(
              hintText: Strings.product_bar_code,
              icon: Icon(Icons.code),
            ),
            validator: (value) {
              return Tools.validateString(value, 5);
            },
          ),
        ]
        )),
      ),
    );
  }

  Widget manageProductWidget() {
    return new Container(
      margin: new EdgeInsets.all(20),
      alignment: Alignment.center,
      child: new Column(
        children: <Widget>[
          new Container(
            child:new TextField(
              controller: productSearch,
              keyboardType: TextInputType.text,
              onChanged: (String value) {
                searchProduct(value);
              },
              onSubmitted: (String value) {
                searchProduct(value);
              },
              maxLength: 30,
              decoration: InputDecoration(
                icon: Icon(Icons.search),
                hintText: Strings.searchField,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.all(10)),
          Expanded(
            //height: 200.0,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: length,
                  itemBuilder: (BuildContext context, int position) {
                    return Card(
                        borderOnForeground: true,
                        shadowColor: Colors.white70,
                        margin: EdgeInsets.all(6),
                        color: Colors.white70,
                        child: new Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: ListTile(
                              title: new Text(Strings.trade_name +
                                  productsList[position]["pName"]),
                              subtitle: new Column(
                                children: <Widget>[
                                  new Padding(padding: EdgeInsets.only(top: 10)),
                                  new Row(
                                    children: <Widget>[
                                      new Expanded(
                                        child: new Text(Strings.product_selling_price2 +
                                            productsList[position]["pSelPrice"]
                                                .toStringAsFixed(2) + " DA"),
                                        flex: 1,
                                      ),
                                      new Expanded(
                                        child: new Text(Strings.product_buy_price2 +
                                            productsList[position]["pBuyPrice"]
                                                .toStringAsFixed(2) + " DA"),
                                        flex: 1,
                                      ),
                                    ],
                                  ),
                                  new Padding(padding: EdgeInsets.only(top: 10)),
                                  new Row(
                                    children: <Widget>[
                                      new Expanded(
                                        child: new Text("${Strings.product_quantity}: ${productsList[position]["pQte"]}",
                                            style: new TextStyle(
                                                color: (productsList[position]["pQte"] > 5)
                                                    ? Colors.lightGreen
                                                    : Colors.red)),
                                        flex: 2,
                                      ),
                                      new Expanded(
                                        child: new Text(
                                          (Product.checkIsExpire(productsList[position]["pExp"]))
                                              ? Strings.acceptable
                                              : Strings.expired,
                                          style: new TextStyle(
                                              color: (Product.checkIsExpire(productsList[position]["pExp"]))
                                                  ? Colors.lightGreen
                                                  : Colors.red),
                                        ),
                                        flex: 1,
                                      )
                                    ],
                                  ),
                                  Divider(),
                                  new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      IconButton(icon: Icon(Icons.update), onPressed: () => updateProduct(position)),
                                      new Padding(padding: EdgeInsets.only(left: 15, right: 15)),
                                      IconButton(icon: Icon(Icons.delete), onPressed: () => deleteProduct(position))
                                    ],
                                  )
                                ],
                              ),
                              leading: new CircleAvatar(
                                backgroundColor: Colors.lightBlueAccent,
                                child: new Text(
                                    productsList[position]
                                        ["pName"]
                                        .toString()[0]
                                        .toUpperCase(),
                                    style: new TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white)
                                ),
                              ),
                            )
                        )
                    );
                  })),
        ],
      ),
    );
  }

  void cleanProductFields(){
    setState(() {
      productName.clear();
      productQuantity.clear();
      productSellingPrice.clear();
      productBuyPrice.clear();
      productExpiration.clear();
      productBarCode.clear();
    });
  }

  void fillProductsList() async{
    List<Map<String, dynamic>> pList = await new Product.name(null).query();
    setState((){
      productsList = pList;
      length = productsList.length;
    });
  }

  void showProductWindow(int id, String title){
    var alertDialog = AlertDialog(
      title: Text(title),
      content: productWindow(),
      actions: <Widget>[
        FlatButton(
            onPressed: (){
              if (_productFormKey.currentState.validate()) {

                int qte = int.parse(productQuantity.text);
                double sPrice = double.parse(productSellingPrice.text);
                double bPrice = double.parse(productBuyPrice.text);
                DateTime date = DateTime.parse(productExpiration.text);

                Product p = new Product(
                    id, productName.text, qte,
                    sPrice, bPrice,
                    date, productBarCode.text
                );

                if(id == 0) p.insert();
                else p.update();

                cleanProductFields();
                fillProductsList();

                if(id != 0) Navigator.pop(context);

              }
            },
            child: Text(title)),
        FlatButton(
            onPressed: (){Navigator.pop(context);},
            child: Text(Strings.cancel)),
      ],
    );
    showDialog(context: context, child: alertDialog, barrierDismissible: false);
  }

  void deleteProduct(int position){
    Product p = new Product.name(productsList[position]["pId"]);
    p.delete();
    fillProductsList();
  }

  void updateProduct(int position) {
    var product = productsList[position];
    productName.text = product["pName"];
    productQuantity.text = product["pQte"].toString();
    productBuyPrice.text = product["pSelPrice"].toString();
    productSellingPrice.text = product["pBuyPrice"].toString();
    productExpiration.text = product["pExp"].toString().substring(0, 10);
    productBarCode.text = product["pCode"];
    showProductWindow(product["pId"], Strings.update_product);
  }

  void searchProduct(String value) async{
    List<Map<String, dynamic>> pList = await new Product.name(null).find(value);
    setState((){
      productsList = pList;
      length = productsList.length;
    });
  }

}