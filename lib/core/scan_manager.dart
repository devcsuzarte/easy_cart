import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:easy_cart/utils/text.dart';

class ScanManager {
	final List<String> _possibleLables = [];
  	final List<String> _possiblePrices = [];

	Future<void> processScan(XFile labelImage) async {
		final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
		final inputImage = InputImage.fromFile(File(labelImage.path));
		final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
		
		await textRecognizer.close();

		for (TextBlock block in recognizedText.blocks) {
			for (TextLine line in block.lines) {
				if(TextUtils.isTextValid(line.text)) {
					_possibleLables.add(line.text);
				}
				if(TextUtils.isPriceValid(line.text)) {
					_possiblePrices.add(TextUtils.getConvertedPrice(line.text));
				}
			}
		}
	}

	List<String> getLabels(){
		return _possibleLables;
	}

	List<String> getPrices(){
		return _possiblePrices;
	}
}