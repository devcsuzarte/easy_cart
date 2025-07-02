class ListItem {
	int? id;
	String title;
	bool selected;
	int amount;

	ListItem({
		this.id,
		required this.title,
		required this.amount,
		this.selected = false
	});
}