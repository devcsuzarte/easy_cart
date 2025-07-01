class ShopItem {
	int? id;
	String title;
	bool selected;
	int amount;

	ShopItem({
		this.id,
		required this.title,
		required this.amount,
		this.selected = false
	});
}