import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_list/models/list_item_model.dart';
import 'package:grocery_list/services/firestore_database.dart';
import 'package:provider/provider.dart';

class QuantityTextField extends StatefulWidget {
  final String listId;
  final String itemId;
  final int quantity;

  const QuantityTextField({Key? key, required this.listId, required this.itemId, required this.quantity})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _QuantityTextFieldState();
}

class _QuantityTextFieldState extends State<QuantityTextField> {
  late int _quantity;
  late TextEditingController _quantityController;
  late FixedExtentScrollController _scrollController;

  bool _isEmptyQuantity = false;

  @override
  void initState() {
    super.initState();
    _quantity = widget.quantity;
    _quantityController = TextEditingController();
    _scrollController = FixedExtentScrollController();
  }

  @override
  void didChangeDependencies() {
    _quantityController.text = _quantity.toString();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _quantityController.dispose();
    _scrollController.dispose();
  }

  void updateQuantity(int value, firestoreDatabase) {
    if (value < 0) {
      return;
    }
    ListItemModel newListItem = ListItemModel(id: widget.itemId, quantity: value);
    firestoreDatabase.setListItem(newListItem, widget.listId);
  }

  @override
  Widget build(BuildContext context) {
    final firestoreDatabase = Provider.of<FirestoreDatabase>(context, listen: false);
    return GestureDetector(
      onDoubleTap: () async {
          int newVal = await _showModal(context);
        if (newVal != _quantity) {
          updateQuantity(newVal, firestoreDatabase);
          _quantityController.text = newVal.toString();
        }
      },
      child: SizedBox(
        width: 50,
        child: TextField(
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            errorText: _isEmptyQuantity ? " " : null,
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: const TextInputType.numberWithOptions(
            signed: false,
            decimal: false,
          ),
          textAlign: TextAlign.center,
          controller: _quantityController,
          onChanged: (value)  {
            _isEmptyQuantity = value.isEmpty;
            if(!_isEmptyQuantity) {
              _quantity = int.parse(value);
            }
          },
          onSubmitted: (String value) {
            _isEmptyQuantity = value.isEmpty;
            if (!_isEmptyQuantity) {
              updateQuantity(int.parse(value), firestoreDatabase);
            } else {
              _quantityController.text = _quantity.toString();
            }
          },
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
        ),
      ),
    );
  }

  _showModal(context) async {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double minHeight = height > width ? height * 0.3 : width * 0.3;
    BuildContext dialogContext;
    int newValue = -1;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          dialogContext = context;
          return AlertDialog(
            insetPadding: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SizedBox(
                    height: minHeight,
                    child: CupertinoPicker(
                      scrollController: _scrollController,
                      itemExtent: 20,
                      diameterRatio: 1,
                      looping: true,
                      onSelectedItemChanged: (int value) {
                        newValue = value;
                      },
                      children: [for (int i = 1; i < 31; i++) Text((i).toString())],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: () => {
                              //update value
                              Navigator.pop(dialogContext, _quantity)
                            },
                        child: const Text("Cancel")),
                    ElevatedButton(
                        onPressed: () => {
                              //update value
                              Navigator.pop(dialogContext, newValue + 1)
                            },
                        child: const Text("Update")),
                  ],
                )
              ],
            ),
          );
        }).then((val) {
      return val;
    });
  }
}
