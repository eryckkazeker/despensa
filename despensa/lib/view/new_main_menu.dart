import 'package:despensa/components/product_list_tile.dart';
import 'package:despensa/controller/scanner_screen_controller.dart';
import 'package:despensa/database/ean_info_dao.dart';
import 'package:despensa/database/notification_dao.dart';
import 'package:despensa/database/product_dao.dart';
import 'package:despensa/models/product.dart';
import 'package:despensa/models/scan_mode.dart';
import 'package:despensa/services/product_service.dart';
import 'package:despensa/util/dialog_manager.dart';
import 'package:despensa/view/scanner_screen.dart';
import 'package:flutter/material.dart';

class NewMainMenu extends StatefulWidget {
  final ProductService _productService;

  NewMainMenu(this._productService);

  @override
  State<NewMainMenu> createState() => _NewMainMenuState(_productService);
}

class _NewMainMenuState extends State<NewMainMenu> {
  List<Product>? _products;

  ProductService _productService;
  bool _isSearchEnabled = false;

  _NewMainMenuState(this._productService);

  List<Product> _filteredProducts = List.empty(growable: true);
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    _productService.getAllProducts().then((products) {
      setState(() {
        this._products = products;
        this._filteredProducts = products;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Despensa'),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  this._isSearchEnabled = true;
                });
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              if (_isSearchEnabled)
                Expanded(
                    flex: 15,
                    child: Container(
                        padding: EdgeInsets.only(right: 20, left: 20, top: 10),
                        child: TextField(
                          controller: _searchController,
                          onSubmitted: (value) => filterList(value),
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    _searchController.clear();
                                    filterList("");
                                    setState(() {
                                      this._isSearchEnabled = false;
                                    });
                                  },
                                  icon: Icon(Icons.clear_outlined)),
                              border: OutlineInputBorder(),
                              labelText: 'Buscar'),
                        ))),
              Expanded(flex: 85, child: productList())
            ],
          ),
          // Overlay button to add products
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.secondary,
              onPressed: () => _insertProduct(context),
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  Widget productList() {
    if (this._products == null || this._products!.length == 0) {
      return Center(
          child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Adicione produtos à sua despensa',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
            ElevatedButton(
              onPressed: () => _insertProduct(context),
              child: Text('Adicionar Produtos'),
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(
                      Theme.of(context).colorScheme.secondary)),
            )
          ],
        ),
      ));
    }

    return ListView.builder(
      padding: EdgeInsets.only(bottom: 80),
      itemCount: this._filteredProducts.length,
      itemBuilder: (context, index) {
        final item = this._filteredProducts[index];
        return ProductListTile(item, _openProduct, _discardProduct);
      },
    );
  }

  void _insertProduct(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Scanner(
                ScanMode.insertProduct,
                ScannerScreenController(EanInfoDao(), ProductDao(),
                    ProductService(ProductDao(), NotificationDao()),
                    saveProductCallback: this._loadProducts))));
  }

  void filterList(String value) {
    setState(() {
      if (value.length > 0) {
        var filteredList = this
            ._products!
            .where((element) => element.eanInfo!.description
                .toLowerCase()
                .contains(value.toLowerCase()))
            .toList();
        this._filteredProducts = filteredList;
      } else {
        this._filteredProducts = this._products!;
      }
    });
  }

  void _loadProducts() {
    this._productService.getAllProducts().then((products) {
      setState(() {
        this._products = products;
        this._filteredProducts = products;
      });
    });
  }

  void _openProduct(Product p) async {
    var confirmation = await DialogManager.showConfirmationDialog(context, 'Atenção', 'Abrir o produto ${p.eanInfo!.description}?');

    if (confirmation != null && confirmation) {
      this
        ._productService
        .openProduct(p, context)
        .then((value) => _loadProducts());
    }
    
  }

  void _discardProduct(Product p) async {
    var confirmation = await DialogManager.showConfirmationDialog(context, 'Atenção', 'Desacartar o produto ${p.eanInfo!.description}?');

    if (confirmation != null && confirmation) {
      this
        ._productService
        .discardProduct(p, context)
        .then((value) => this._loadProducts());
    }
    
  }
}
