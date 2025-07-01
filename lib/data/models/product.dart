class Product {

	final int amount;
	final String title,
  		price;
	final int? id;

	Product({
		this.id, 
		required this.amount, 
		required this.price, 
		required this.title
	});
}