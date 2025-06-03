import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:easy_cart/controller/text_manager.dart';
import 'package:easy_cart/screens/scan_screen.dart';

class ScanManager extends ChangeNotifier {

ScanManager({this.context});

  BuildContext? context;
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  void processScan(XFile labelImage) async{
    final textManager = TextManager();
    final inputImage = InputImage.fromFile(File(labelImage.path));
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();

    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        if(textManager.isTextValid(line.text)) {
          textManager.possibleLables.add(line.text);
        }
        if(textManager.isPriceValid(line.text)) {
          textManager.possiblePrices.add(textManager.getConvertedPrice(line.text));
        }
      }
    }
    showModalBottomSheet(
      context: context!,
      builder: (context) => ScanScreen(labelsList: textManager.possibleLables, priceList: textManager.possiblePrices,),
      enableDrag: true,
      showDragHandle: true,
    );
  }

  void scanLabel() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    try{
        processScan(pickedFile!);
    } catch (e) {
        throw('SOMETHING WENT WRONG: $e');
    }
  }
}