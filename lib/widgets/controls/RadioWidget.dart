import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../constants/Ui.dart';

class RadioWidget extends StatelessWidget {
  final String? title;
  final EdgeInsets? padding;
  final String? groupValue;
  final String? value;
  final ValueChanged? onChanged;

  const RadioWidget(
      {@required this.title,
      @required this.padding,
      @required this.groupValue,
      @required this.value,
      @required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (value != groupValue) {
          onChanged!(value);
        }
      },
      child: Padding(
        padding: padding!,
        child: Row(
          children: <Widget>[
            Radio<String>(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              groupValue: groupValue,
              value: value!,
              onChanged: (String? newValue) {
                onChanged!(newValue);
              },
            ),
            Text(title!, style: TEXT_STYLE_REGULAR),
          ],
        ),
      ),
    );
  }
}
