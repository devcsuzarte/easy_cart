import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_cart/core/constants.dart';


void cupertinoDialog({
	required BuildContext context,
	required Function defaultFunction,
	required String title, 
		message,
		buttonTitle,
	Function? alternativeFunction,
	String? altFunctionMessage,
	}
){
  showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
      title: kDialogTitleText,
      content: kDialogContentText,
      actions: <CupertinoDialogAction> [
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: kDialogActionDefaultText,
          onPressed: () => defaultFunction(),
        ),
        CupertinoDialogAction(
          child: kDialogActionDismissText,
          onPressed: () {
			if(alternativeFunction != null){
				alternativeFunction();
			}			
		  },
        ),
      ],
    ),
   );
  }

  Future<void> materialDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: kDialogTitleText,
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget> [
                kDialogTitleText,
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
                child: kDialogActionDefaultText,
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
                child: kDialogActionDismissText,
            ),
          ],
        );
      }
    );
  }
