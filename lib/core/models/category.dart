class Category {
  final String id;
  final String icon;
  final String label;
  final List<SubCategory> subs;

  Category({
    required this.id,
    required this.icon,
    required this.label,
    this.subs = const [],
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'icon': icon,
    'label': label,
    'subs': subs.map((s) => s.toJson()).toList(),
  };

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['id'],
    icon: json['icon'],
    label: json['label'],
    subs: (json['subs'] as List?)?.map((s) => SubCategory.fromJson(s)).toList() ?? [],
  );
}

class SubCategory {
  final String id;
  final String icon;
  final String label;

  SubCategory({
    required this.id,
    required this.icon,
    required this.label,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'icon': icon,
    'label': label,
  };

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
    id: json['id'],
    icon: json['icon'],
    label: json['label'],
  );
}
