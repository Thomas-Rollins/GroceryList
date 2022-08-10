import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PriceTextField extends StatefulWidget {
  final String listId;
  final String itemId;
  final ValueNotifier priceNotifier;

  const PriceTextField({Key? key, required this.listId, required this.itemId, required this.priceNotifier})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _PriceTextFieldState();
}

class _PriceTextFieldState extends State<PriceTextField> {
  late TextEditingController _quantityController;

  bool _isEmptyValue = false;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    _quantityController.text = widget.priceNotifier.value.toString();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _quantityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.priceNotifier,
        builder: (BuildContext context, price, _) {
          return SizedBox(
            width: 50,
            child: TextField(
              decoration: InputDecoration(
                border: const UnderlineInputBorder(),
                errorText: _isEmptyValue ? " " : null,
              ),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))],
              keyboardType: const TextInputType.numberWithOptions(
                signed: false,
                decimal: true,
              ),
              textAlign: TextAlign.center,
              controller: _quantityController,
              onChanged: (value) {
                _isEmptyValue = value.isEmpty;
                if (value.isEmpty) {
                  widget.priceNotifier.value = -1.0;
                } else {
                  double newVal = double.tryParse(value) ?? -1.0;
                  if (newVal > 0.0) {
                    widget.priceNotifier.value = newVal;
                  }
                }
              },
              onSubmitted: (String value) {
                if (value.isEmpty) {
                  widget.priceNotifier.value = -1.0;
                }
                double newVal = double.tryParse(value) ?? -1.0;
                if (newVal > 0.0) {
                  widget.priceNotifier.value = newVal;
                }
              },
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
            ),
          );
        });
  }
}
