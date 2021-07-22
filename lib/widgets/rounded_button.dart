import 'package:chatty_app/common/size_config.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function onPressed;

  RoundedButton({
    @required this.color,
    @required this.onPressed,
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: (SizeConfig.safeBlockVertical * 2.6).roundToDouble(),
      ),
      child: RawMaterialButton(
        fillColor: color,
        elevation: 5,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        child: SizedBox(
          height: (SizeConfig.safeBlockVertical * 9.1).roundToDouble(),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize:
                      (SizeConfig.safeBlockHorizontal * 4.4).roundToDouble()),
            ),
          ),
        ),
      ),
    );
  }
}
