import 'package:despensa/database/notification_dao.dart';
import 'package:despensa/database/product_dao.dart';
import 'package:despensa/models/ean_info.dart';
import 'package:despensa/models/notification.dart' as n;
import 'package:despensa/models/product.dart';
import 'package:despensa/services/notification_service.dart';
import 'package:despensa/util/dialog_manager.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart';

class ExpirationDateScreenController {

  ProductDao? _productDao;
  NotificationDao? _notificationDao;

  ExpirationDateScreenController(this._productDao, this._notificationDao);


  void saveProduct(EanInfo? eanInfo, DateTime? expirationDate, BuildContext context) async {

    if(expirationDate == null) {
      DialogManager.showGenericDialog(context,'Atenção', 'Selecione a data de validade');
      return;
    }

    Product product = Product(
      eanInfo,
      expirationDate,
      false);

    var productId = await _productDao!.insertProduct(product);

    if (productId <= 0)
    {
      DialogManager.showGenericDialog(context, 'Erro', 'Erro ao salvar produto, tente novamente');
    }

    n.Notification notification = n.Notification(Product.withId(productId, null, expirationDate, false));

    var notificationId = await _notificationDao!.insertNotification(notification);

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

}