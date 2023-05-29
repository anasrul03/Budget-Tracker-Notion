class Item {
  final String name;
  final String amount;
  final DateTime date;
  final bool isPaid;

  Item({
    required this.name,
    required this.amount,
    required this.date,
    required this.isPaid,
  });

  factory Item.fromMap(Map<String, dynamic> map) {
    final properties = map['properties'] as Map<String, dynamic>;
    final dateString = properties['Created Date']?['created_time'];
    return Item(
        name: properties['Name']?['title']?[0]?['plain_text'] ?? '?',
        amount: (properties['Amount']?['number'] ?? 0).toDouble(),
        date: dateString != null ? DateTime.parse(dateString) : DateTime.now(),
        isPaid: properties['Paid']?['checkbox'] ?? false);
  }
}
