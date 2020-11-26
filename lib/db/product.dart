import 'database.dart';

class Product{
  int _productId;
  String _productName;
  int _productQuantity;
  double _productSellingPrice;
  double _productBuyPrice;
  DateTime _productExpiration;
  String _productCode;

  final _dbHelper = DatabaseHelper.instance;

  Product(this._productId, this._productName,
      this._productQuantity, this._productSellingPrice,
      this._productBuyPrice, this._productExpiration,
      this._productCode);

  Product.name(this._productId);

  void insert() async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnName : _productName,
      DatabaseHelper.columnQte  : _productQuantity,
      DatabaseHelper.columnSPrice  : _productSellingPrice,
      DatabaseHelper.columnBPrice  : _productBuyPrice,
      DatabaseHelper.columnExp  : _productExpiration.toIso8601String(),
      DatabaseHelper.columnBarCode  : _productCode,
    };
    final id = await _dbHelper.insert(row);
    print('inserted row id: $id');
  }

  Future<List<Map<String, dynamic>>> query() async {
    final allRows = await _dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
    return allRows;
  }

  Future<List<Map<String, dynamic>>> find(String value) async {
    final allRows = await _dbHelper.serchProduct(value);
    print('query search rows:');
    allRows.forEach((row) => print(row));
    return allRows;
  }

  Future<Map<String, dynamic>> findProductByQrCode(String code) async {
    final allRows = await _dbHelper.serchProductByQrCode(code);
    print('query search rows:');
    allRows.forEach((row) => print(row));
    return allRows[0];
  }

  Future<List<Map<String, dynamic>>> redCardProducts(int val) async {
    final allRows = await _dbHelper.redCardProducts(val);
    print('query red card rows:');
    allRows.forEach((row) => print(row));
    return allRows;
  }

  void update() async {
    // row to update
    Map<String, dynamic> row = {
      DatabaseHelper.columnId   : _productId,
      DatabaseHelper.columnName : _productName,
      DatabaseHelper.columnQte  : _productQuantity,
      DatabaseHelper.columnSPrice  : _productSellingPrice,
      DatabaseHelper.columnBPrice  : _productBuyPrice,
      DatabaseHelper.columnExp  : _productExpiration.toIso8601String(),
      DatabaseHelper.columnBarCode  : _productCode,
    };
    final rowsAffected = await _dbHelper.update(row);
    print('updated $rowsAffected row(s)');
  }

  void delete() async {
    // Assuming that the number of rows is the id for the last row.
    final rowsDeleted = await _dbHelper.delete(_productId);
    print('deleted $rowsDeleted row(s): row $_productId');
  }

  static bool checkIsExpire(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return dateTime.isAfter(DateTime.now());
  }

}