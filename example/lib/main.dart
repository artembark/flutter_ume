import 'package:example/detail_page.dart';
import 'package:example/home_page.dart';
import 'package:example/ume_switch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ume/flutter_ume.dart';
import 'package:flutter_ume_kit_ui/flutter_ume_kit_ui.dart';
import 'package:flutter_ume_kit_perf/flutter_ume_kit_perf.dart';
import 'package:flutter_ume_kit_device/flutter_ume_kit_device.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ume_kit_channel_monitor/flutter_ume_kit_channel_monitor.dart';
import 'package:analytics_inspector/analytics_inspector.dart';
import 'package:http_inspector/http_inspector.dart';
import 'package:flutter_ume_kit_shared_preferences/flutter_ume_kit_shared_preferences.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  runApp(const UMEApp());
}

class UMEApp extends StatefulWidget {
  const UMEApp({Key? key}) : super(key: key);

  @override
  State<UMEApp> createState() => _UMEAppState();
}

class _UMEAppState extends State<UMEApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    if (kDebugMode) {
      PluginManager.instance
        ..register(HttpInspector())
        ..register(AnalyticsInspector())
        ..register(WidgetInfoInspector())
        ..register(ColorSucker())
        ..register(AlignRuler())
        ..register(MemoryInfoPage())
        ..register(DeviceInfoPanel())
        ..register(SharedPreferencesInspector())
        ..register(ChannelPlugin());
    }
  }

  Widget _buildApp(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'UME Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(title: 'UME Demo Home Page'),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case 'detail':
            return MaterialPageRoute(builder: (_) => const DetailPage());
          default:
            return null;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget body = _buildApp(context);
    if (kDebugMode) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UMESwitch()),
        ],
        builder: (BuildContext context, _) => UMEWidget(
          enable: context.watch<UMESwitch>().enable,
          child: body,
        ),
      );
    }
    return body;
  }
}
