class Asset {
  final String id;
  final String month;
  final List<Account> accounts;

  Asset({
    required this.id,
    required this.month,
    required this.accounts,
  });

  double get total => accounts.fold(0, (sum, a) => sum + a.amount);

  Map<String, dynamic> toJson() => {
    'id': id,
    'month': month,
    'accounts': accounts.map((a) => a.toJson()).toList(),
  };

  factory Asset.fromJson(Map<String, dynamic> json) => Asset(
    id: json['id'],
    month: json['month'],
    accounts: (json['accounts'] as List).map((a) => Account.fromJson(a)).toList(),
  );
}

class Account {
  final String name;
  final String icon;
  final double amount;

  Account({
    required this.name,
    required this.icon,
    required this.amount,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'icon': icon,
    'amount': amount,
  };

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    name: json['name'],
    icon: json['icon'],
    amount: (json['amount'] as num).toDouble(),
  );
}
