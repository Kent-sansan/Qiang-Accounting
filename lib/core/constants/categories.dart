import '../models/category.dart';

class AppCategories {
  static final expense = [
    Category(id: 'food', icon: '🍜', label: '餐饮', subs: [
      SubCategory(id: 'grain-oil', icon: '🫙', label: '粮油调味'),
      SubCategory(id: 'coffee-tea', icon: '☕', label: '咖啡奶茶'),
      SubCategory(id: 'tobacco-wine', icon: '🍵', label: '烟酒茶叶'),
      SubCategory(id: 'snack-fruit', icon: '🍎', label: '零食水果'),
      SubCategory(id: 'meals', icon: '🍱', label: '早中晚餐'),
    ]),
    Category(id: 'traffic', icon: '🚇', label: '交通', subs: [
      SubCategory(id: 'parking', icon: '🅿️', label: '停车费'),
      SubCategory(id: 'fuel-charge', icon: '⛽', label: '加油充电'),
      SubCategory(id: 'maintenance', icon: '🔧', label: '保养修车'),
      SubCategory(id: 'train-plane', icon: '✈️', label: '火车飞机'),
      SubCategory(id: 'taxi-rent', icon: '🚕', label: '打车租车'),
      SubCategory(id: 'bus-metro', icon: '🚌', label: '公交地铁'),
    ]),
    Category(id: 'shop', icon: '🛍️', label: '购物', subs: [
      SubCategory(id: 'clothes-sport', icon: '👔', label: '服饰运动'),
      SubCategory(id: 'daily-home', icon: '🏠', label: '日常家居'),
      SubCategory(id: 'appliance', icon: '🔌', label: '生活家电'),
      SubCategory(id: 'beauty-makeup', icon: '💄', label: '个护美妆'),
    ]),
    Category(id: 'house', icon: '🏠', label: '居住', subs: [
      SubCategory(id: 'rent', icon: '🏠', label: '房租'),
      SubCategory(id: 'utility', icon: '💡', label: '水电煤'),
      SubCategory(id: 'property', icon: '🏢', label: '物业'),
    ]),
    Category(id: 'fun', icon: '🎮', label: '娱乐', subs: [
      SubCategory(id: 'game', icon: '🎮', label: '游戏'),
      SubCategory(id: 'movie-show', icon: '🎬', label: '电影演出'),
      SubCategory(id: 'vip-service', icon: '💎', label: '会员服务'),
    ]),
    Category(id: 'medical', icon: '💊', label: '医疗', subs: [
      SubCategory(id: 'hospital', icon: '🏥', label: '看病'),
      SubCategory(id: 'medicine', icon: '💊', label: '药品'),
      SubCategory(id: 'health', icon: '🧬', label: '保健'),
    ]),
    Category(id: 'edu', icon: '📚', label: '教育', subs: [
      SubCategory(id: 'book', icon: '📖', label: '书籍'),
      SubCategory(id: 'course', icon: '🎓', label: '课程'),
    ]),
    Category(id: 'personal', icon: '💇', label: '个人', subs: [
      SubCategory(id: 'beauty', icon: '💆', label: '美容'),
      SubCategory(id: 'haircut', icon: '✂️', label: '理发'),
    ]),
    Category(id: 'social', icon: '👥', label: '社交', subs: [
      SubCategory(id: 'gift', icon: '🎁', label: '礼物'),
      SubCategory(id: 'redpack', icon: '🧧', label: '红包'),
    ]),
    Category(id: 'other', icon: '📌', label: '其他'),
  ];

  static final income = [
    Category(id: 'salary', icon: '💼', label: '工资', subs: [
      SubCategory(id: 'base', icon: '💰', label: '基本工资'),
      SubCategory(id: 'overtime', icon: '⏰', label: '加班费'),
    ]),
    Category(id: 'bonus', icon: '🎁', label: '奖金', subs: [
      SubCategory(id: 'year', icon: '🧧', label: '年终奖'),
      SubCategory(id: 'perf', icon: '🏅', label: '绩效'),
    ]),
    Category(id: 'invest', icon: '📈', label: '理财', subs: [
      SubCategory(id: 'fund', icon: '📊', label: '基金'),
      SubCategory(id: 'stock', icon: '💹', label: '股票'),
      SubCategory(id: 'interest', icon: '🏦', label: '利息'),
    ]),
    Category(id: 'sideline', icon: '💻', label: '副业', subs: [
      SubCategory(id: 'freelance', icon: '💻', label: '自由职业'),
    ]),
    Category(id: 'redpack', icon: '🧧', label: '红包'),
    Category(id: 'other', icon: '💰', label: '其他'),
  ];
}
