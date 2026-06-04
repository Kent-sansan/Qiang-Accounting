class JzRecord {
  final String id;
  final RecordType type;
  final String category;
  final String? subcategory;
  final double amount;
  final String? note;
  final DateTime date;

  JzRecord({
    required this.id,
    required this.type,
    required this.category,
    this.subcategory,
    required this.amount,
    this.note,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'category': category,
    'subcategory': subcategory,
    'amount': amount,
    'note': note,
    'date': date.toIso8601String(),
  };

  factory JzRecord.fromJson(Map<String, dynamic> json) => JzRecord(
    id: json['id'],
    type: RecordType.values.byName(json['type']),
    category: json['category'],
    subcategory: json['subcategory'],
    amount: (json['amount'] as num).toDouble(),
    note: json['note'],
    date: DateTime.parse(json['date']),
  );

  JzRecord copyWith({
    String? id,
    RecordType? type,
    String? category,
    String? subcategory,
    double? amount,
    String? note,
    DateTime? date,
  }) => JzRecord(
    id: id ?? this.id,
    type: type ?? this.type,
    category: category ?? this.category,
    subcategory: subcategory ?? this.subcategory,
    amount: amount ?? this.amount,
    note: note ?? this.note,
    date: date ?? this.date,
  );
}

enum RecordType { expense, income }
