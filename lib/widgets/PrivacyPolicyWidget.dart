import 'package:flutter/material.dart';

import '../constants/Ui.dart';

class PrivacyPolicyWidget extends StatelessWidget {
  PrivacyPolicyWidget() {}

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        Padding(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text("""
            Ius possim sapientem consulatu cu, et errem sanctus blandit has. Et laoreet inciderint his, eam ut nisl viderer salutandi. In quod fuisset comprehensam quo. Aliquip labitur ex has, no possit legendos vituperatoribus vis.
            \r
            Vix ea vivendo detraxit. Ferri aeque ponderum ut vel, sed quod legere consulatu ne. An nec quando disputando, nam sale decore cetero cu, mei graeci luptatum conclusionemque id. Ei vis vocibus vivendo, at eos porro elitr voluptaria, salutatus definiebas pri eu. Ne qui dico autem vivendum, ignota option ius ut. Nec epicurei molestiae ex, mea cu hinc maiestatis.
            """, style: TEXT_STYLE_REGULAR)),
      ],
    );
  }
}
