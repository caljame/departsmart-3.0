import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../constants/Ui.dart';
import '../../models/CheckboxValue.dart';

class CheckboxWidget extends StatelessWidget {
  final String? title;
  final String? suffix;
  final EdgeInsets? padding;
  final String? groupValue;
  final bool? value;
  final ValueChanged<CheckboxValue>? onChanged;

  const CheckboxWidget(
      {@required this.title,
      this.suffix,
      @required this.padding,
      @required this.groupValue,
      @required this.value,
      @required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (value != groupValue) {
          onChanged!(CheckboxValue(value!, title!));
        }
      },
      child: Padding(
        padding: padding!,
        child: Row(
          children: <Widget>[
            Checkbox(
                value: value,
                onChanged: (v) => this.onChanged!(CheckboxValue(v!, title!)),
                materialTapTargetSize: MaterialTapTargetSize?.shrinkWrap),
            Text((suffix == null) ? title ?? '' : "${title} : ${suffix}",
                style: TEXT_STYLE_REGULAR),
          ],
        ),
      ),
    );
  }
}
