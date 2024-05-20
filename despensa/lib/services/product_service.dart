import 'package:despensa/database/notification_dao.dart';
import 'package:despensa/database/product_dao.dart';
import 'package:despensa/models/ean_info.dart';
import 'package:despensa/models/product.dart';
import 'package:despensa/services/notification_service.dart';
import 'package:despensa/util/dialog_manager.dart';
import 'package:despensa/util/formatter.dart';
import 'package:flutter/widgets.dart';
import 'package:despensa/models/notification.dart' as n;
import 'package:timezone/timezone.dart';

class ProductService {

  ProductDao _productDao;
  NotificationDao _notificationDao;

  ProductService(this._productDao, this._notificationDao);

  Future<List<Product>> getAllProducts() async {
    return await _productDao.getAllProducts();
  }

  void saveProduct(EanInfo? eanInfo, DateTime? expirationDate, BuildContext context) async {

    if(expirationDate == null) {
      DialogManager.showGenericDialog(context,'Atenção', 'Selecione a data de validade');
      return;
    }

    Product product = Product(
      eanInfo,
      expirationDate,
      false);

    var productId = await _productDao.insertProduct(product);

    if (productId <= 0)
    {
      DialogManager.showGenericDialog(context, 'Erro', 'Erro ao salvar produto, tente novamente');
    }

    n.Notification notification = n.Notification(Product.withId(productId, null, expirationDate, false));

    var notificationId = await _notificationDao.insertNotification(notification);

    if (notificationId <= 0)
    {
      DialogManager.showGenericDialog(context, 'Erro', 'Erro ao salvar produto, tente novamente');
    }

    var notificationHelper = NotificationService();

    notificationHelper.scheduleNotification(
      id: notificationId, title: 'Vencimento',
      body: '''O produto ${product.eanInfo!.description} está próximo do vencimento''',
      notificationDateTime: TZDateTime.from(expirationDate, local),
      context: context);
  }

  Future<void> openProduct(Product product, BuildContext context) async {

    await _productDao.openProduct(product);

    await DialogManager.showGenericDialog(context, 'Sucesso', '''Produto aberto ${product.eanInfo!.description}
    \nConsumir até ${formatDateTime(product.expirationDate)}''');

  }

  Future<void> discardProduct(Product product, BuildContext context) async {


    // For now, we'll discard the first item found
    var notifications = await _notificationDao.getNotificationsForProduct(product);

    notifications.forEach((notification) async {
    await NotificationService().removeScheduledNotification(notification.id);
      await _notificationDao.deleteNotification(notification);
    });
    
    await _productDao.deleteProduct(product);

    await DialogManager.showGenericDialog(context, 'Sucesso', 'Produto descartado!');
  }
}