class TextUtils {
 static String getConvertedPrice(String priceText) {
    String priceConverted = "";
    String price = priceText.replaceAll(',', '.');
	bool dotNotAdded = true;
    for (int i=0;  i < price.length; i++) {
		var char = price[i];
		switch (char) {
			case "0":
			case "1":
			case "2":
			case "3":
			case "4":
			case "5":
			case "6":
			case "7":
			case "8":
			case "9":
				priceConverted = priceConverted + char;
				break;
			case ".":
				if(i != 0 && dotNotAdded){
					priceConverted = priceConverted + char;
					dotNotAdded = false;
				}
				break;
			default:
			break;
		}
    }

    return priceConverted;
  }

  static bool isTextValid(String text) {
    if (text.length > 20 && text.contains(" ")){
      return true;
    } else {
      return false;
    }
  }

 static bool isPriceValid(String price) {
	if((price.contains(',') || price.contains('.')) && price.length > 3){
		return true;
	}
	return false;
 }
    
}