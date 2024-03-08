import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_apps/device_apps.dart';

class AppListScreen extends StatefulWidget {
  @override
  _AppListScreenState createState() => _AppListScreenState();
}

class _AppListScreenState extends State<AppListScreen> {
  List<Application> _apps = [];
  late List<Application> apps;

  @override
  void initState() {
    super.initState();
    _loadApps();
  }

  Future<void> _loadApps() async {
    try {
      apps = await DeviceApps.getInstalledApplications(
        onlyAppsWithLaunchIntent: true,
        includeSystemApps: false,
      );
    } on PlatformException catch (e) {
      print("Error: ${e.message}");
    }

    if (!mounted) return;

    setState(() {
      _apps = apps;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apps List'),
      ),
      body: ListView.builder(
        itemCount: _apps.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: FlutterLogo(size: 36),
            title: Text(_apps[index].appName),
            subtitle: Text(_apps[index].packageName),
            onTap: () {
              DeviceApps.openApp(_apps[index].packageName);
            },
          );
        },
      ),
    );
  }
}