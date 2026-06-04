import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'core/providers/app_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('zh_CN');
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider()..init(),
      child: const JizhangApp(),
    ),
  );
}
