import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';

class SplitTunnelingSettings extends StatefulWidget {
  @override
  _SplitTunnelingSettingsState createState() => _SplitTunnelingSettingsState();
}

class _SplitTunnelingSettingsState extends State<SplitTunnelingSettings> {
  List<Application> _installedApps = [];
  final _appSelectionsController = Get.put(AppSelectionsController());

  @override
  void initState() {
    super.initState();
    _loadInstalledApps();
  }

  Future<void> _loadInstalledApps() async {
    try {
      List<Application> apps = await DeviceApps.getInstalledApplications(
          onlyAppsWithLaunchIntent: true,
          includeAppIcons: true,
          includeSystemApps: true,
      );
      setState(() {
        _installedApps = apps;
      });
      _appSelectionsController.initializeAppSelections(_installedApps);
    } catch (e) {
      print('Failed to load installed apps: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Split Tunneling Settings'),
      ),
      body: _installedApps.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _installedApps.length,
              itemBuilder: (context, index) {
                final app = _installedApps[index];
                return Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [ 
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        child: Text(app.appName),
                      ),
                      CupertinoSwitch(
                        value: _appSelectionsController.appSelections[app.appName] ?? false,
                        onChanged: (value) {
                        setState(() {
                          _appSelectionsController.updateAppSelection(app.appName, value);
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class AppSelectionsController extends GetxController {
  final _box = Hive.box('appSelections');
  final _appSelections = {}.obs;

  Map<dynamic, dynamic> get appSelections => _appSelections.value;

  void initializeAppSelections(List<Application> installedApps) {
    final defaultSelections = {for (var app in installedApps) app.appName: true};
    _appSelections.value = _box.get('appSelections', defaultValue: defaultSelections);
  }

  void updateAppSelection(String appName, bool value) {
    _appSelections.value[appName] = value;
    _box.put('appSelections', _appSelections.value);
    update(); // Notify UI of changes
  }
}