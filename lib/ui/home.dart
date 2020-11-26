import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:storemanagement/db/product.dart';
import 'package:storemanagement/tools/strings.dart';
import 'package:storemanagement/tools/tools.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  static List<Map<String, dynamic>> totalList = List<Map<String, dynamic>>();
  int totalListLength = 0;
  double total = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => showQrWindow(),
        child: Image.asset("images/qr_code.png"),
      ),
      body: homeWidget(),
    );
  }

  Widget homeWidget(){
    return Container(
      child: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 10.0)),
          Center(child: RaisedButton(
            child: Text(Strings.reset),
            onPressed: ()=> resetTotalList(),
          )),
          Padding(padding: EdgeInsets.only(top: 10.0)),
          Expanded(
              //height: 200.0,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: totalListLength,
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
                                  totalList[position]["pName"]),
                              subtitle: new Column(
                                children: <Widget>[
                                  new Padding(padding: EdgeInsets.only(top: 10)),
                                  new Row(
                                    children: <Widget>[
                                      new Expanded(
                                        child: new Text(Strings.product_selling_price2 +
                                            totalList[position]["pSelPrice"]
                                                .toStringAsFixed(2) + " DA"),
                                        flex: 1,
                                      ),
                                      new Expanded(
                                        child: new Text(
                                          (Product.checkIsExpire(totalList[position]["pExp"]))
                                              ? Strings.acceptable
                                              : Strings.expired,
                                          style: new TextStyle(
                                              color: (Product.checkIsExpire(totalList[position]["pExp"]))
                                                  ? Colors.lightGreen
                                                  : Colors.red),
                                        ),
                                        flex: 1,
                                      )
                                    ],
                                  ),
                                  new Padding(padding: EdgeInsets.only(top: 10)),
                                  Divider(),
                                  new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      IconButton(icon: Icon(Icons.delete), onPressed: () => deleteProduct(position))
                                    ],
                                  )
                                ],
                              ),
                              leading: new CircleAvatar(
                                backgroundColor: Colors.lightBlueAccent,
                                child: new Text(
                                    totalList[position]
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
          Padding(padding: EdgeInsets.only(top: 10.0)),
          Center(child: Text(
            "${Strings.total} = ${total} DA",
            style: TextStyle(fontSize: 25, fontStyle: FontStyle.italic),
          )),
          Padding(padding: EdgeInsets.only(bottom: 10.0),),
        ],
      ),
    );
  }

  void showQrWindow() async{
    String code = await Tools.scanQRCode();
    Map<String, dynamic> product = await new Product.name(null).findProductByQrCode(code);
    setState(() {
      total = total + product["pSelPrice"];
      totalList.add(product);
      totalListLength = totalList.length;
    });
  }

  void resetTotalList(){
    setState(() {
      total = 0.0;
      totalList.clear();
      totalListLength = 0;
    });
  }
  
  void deleteProduct(position){
    setState(() {
      total = total - totalList[position]["pSelPrice"];
      totalList.removeAt(position);
      totalListLength = totalList.length;
    });
  }
}
