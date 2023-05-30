class Item {
  // final String iconUrl;
  final String name;
  final double amount;
  final DateTime date;
  final bool isPaid;

  Item({
    // required this.iconUrl,
    required this.name,
    required this.amount,
    required this.date,
    required this.isPaid,
  });

  factory Item.fromMap(Map<String, dynamic> map) {
    final properties = map['properties'] as Map<String, dynamic>;
    // final icon = map['icon'] as Map<String, dynamic>;
    final dateString = properties['Created Date']?['created_time'];
    return Item(
        // iconUrl: icon['external']?['url'] ??
        //     'https://static-00.iconduck.com/assets.00/not-available-icon-510x512-bk9kndq5.png',
        name: properties['Name']?['title']?[0]?['plain_text'] ?? '?',
        amount: (properties['Amount']?['number'] ?? 0).toDouble(),
        date: dateString != null ? DateTime.parse(dateString) : DateTime.now(),
        isPaid: properties['Paid']?['checkbox'] ?? false);
  }
}
