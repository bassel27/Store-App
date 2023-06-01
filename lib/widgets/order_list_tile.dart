import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:store_app/controllers/excpetion_handler.dart';
import 'package:store_app/helper/dialog_helper.dart';
import 'package:store_app/providers/orders_notifier.dart';

import '../models/order/order.dart';
import '../screens/order_screen.dart';

// TODO: fix order added even if you press order now on zero/ empty cart.
class OrderListTile extends StatefulWidget {
  Order order;
  OrderListTile(this.order);

  @override
  State<OrderListTile> createState() => _OrderListTileState();
}

class _OrderListTileState extends State<OrderListTile>
    with DialogHelper, ExceptionHandler {
  bool isExpanded = false;
  bool isDone = false;
  var myBorderSide = const BorderSide(color: Colors.grey, width: 1);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            OrderScreen.route,
            arguments: widget.order,
          );
        },
        child: Card(
          child: Material(
            elevation: 3,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: myBorderSide,
                  left: myBorderSide,
                  top: myBorderSide,
                ),
              ),
              child: ListTile(
                title: Text(
                  "${widget.order.address.firstName} ${widget.order.address.lastName}",
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 17.5),
                ),
                subtitle: Text(
                  DateFormat("dd/MM/yyyy").format(widget.order.dateTime),
                ),
                trailing: Transform.scale(
                  scale: 1.17, // Adjust the scale factor as needed
                  child: Checkbox(
                    value: isDone,
                    activeColor: Theme.of(context).colorScheme.tertiary,
                    onChanged: ((value) async {
                      try {
                        DialogHelper.showLoading();
                        await Provider.of<OrdersNotifier>(context,
                                listen: false)
                            .setOrderStatus(widget.order.id, !isDone);
                        setState(() {
                          isDone = !isDone;
                        });
                        DialogHelper.hideCurrentDialog();
                      } catch (e) {
                        handleException(e);
                      }
                    }
                        // CurrencyAndPriceText(
                        //   price: widget.order.total,
                        //   sizeMultiplicationFactor: 1.2,
                        // ),
                        ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
