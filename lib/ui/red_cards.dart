import 'package:flutter/material.dart';
import 'package:storemanagement/db/product.dart';
import 'package:storemanagement/tools/strings.dart';

class RedCard extends StatefulWidget {
  @override
  _RedCardState createState() => _RedCardState();
}

class _RedCardState extends State<RedCard> {

  int selectedRadioTile;
  List<Map<String, dynamic>> productsList;
  int length = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedRadioTile = 1;
    fillProductsList(1);
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
      fillProductsList(val);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: manageProductWidget());
  }

  Widget manageProductWidget() {
    return new Container(
      margin: new EdgeInsets.all(20),
      alignment: Alignment.center,
      child: new Column(
        children: <Widget>[
          new Container(
            child: Row(
              children: [
                new Expanded(
                  child: RadioListTile(
                    value: 1,
                    groupValue: selectedRadioTile,
                    title: Text(Strings.order_by_qte),
                    onChanged: (val) {
                      setSelectedRadioTile(val);
                    },
                  ), flex: 1,),
                  new Expanded(
                      child: RadioListTile(
                        value: 2,
                        groupValue: selectedRadioTile,
                        title: Text(Strings.order_by_date),
                        onChanged: (val) {
                          setSelectedRadioTile(val);
                        },
                      ), flex: 1,)
              ],
            ),
          ),
          new Padding(padding: EdgeInsets.all(10)),
          new Expanded(
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
                                        child: new Text(
                                            "${Strings.product_quantity}: ${productsList[position]["pQte"]}",
                                          style: new TextStyle(
                                              color: (productsList[position]["pQte"] > 5)
                                                  ? Colors.lightGreen
                                                  : Colors.red),
                                        ),
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

  void fillProductsList(int val) async{
    List<Map<String, dynamic>> pList;
    pList = await new Product.name(null).redCardProducts(val);
    setState((){
      productsList = pList;
      length = productsList.length;
    });
  }

}
