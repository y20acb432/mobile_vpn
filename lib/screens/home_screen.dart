import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/helpers/pref.dart';
import 'package:vpn_basic_project/screens/select_apps.dart';
import '../controllers/home_controller.dart';
import '../main.dart';
import '../models/vpn_status.dart';
import '../services/vpn_engine.dart';
import '../widgets/count_down_timer.dart';
import '../widgets/home_card.dart';
import 'location_screen.dart';
import 'network_test_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  set switchValue(bool switchValue) {}

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = Get.put(HomeController());

  bool switchValue=false;
  bool themeValue=false;

  @override
  Widget build(BuildContext context) {
    ///Add listener to update vpn state
    VpnEngine.vpnStageSnapshot().listen((event) {
      _controller.vpnState.value = event;
    });

    return Scaffold(
      //app bar
      appBar: AppBar(
        title: Text('OpenVPN'),
      ),

      //Drawer

      drawer: Drawer(
      width: mq.width * 0.60,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Column(
                children: [
                  SizedBox(height: 75,),
            
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.lightBlue,
                  ),

                  SizedBox(height: 33.3,),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal:9),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                        Get.to(() => HomeScreen());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Text("H o m e",style: TextStyle(fontWeight: FontWeight.bold),),
                            padding: EdgeInsets.symmetric(vertical: 6.0,horizontal: 77),
                            decoration: BoxDecoration(
                              color:Colors.lightBlue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),

                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                      Get.to(() => NetworkTestScreen());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text("S e r v e r  I n f o",style: TextStyle(fontWeight: FontWeight.bold),),
                          padding: EdgeInsets.symmetric(vertical: 6.0 , horizontal: 50),
                          decoration: BoxDecoration(
                            color:Colors.lightBlue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                          Get.to(() => AppListScreen());
                        },
                        child: Container(
                          child: Text("S p l i t  T u n n e l i n g",style: TextStyle(fontWeight: FontWeight.bold),),
                          padding: EdgeInsets.symmetric(vertical: 6.0,horizontal: 30.0),
                          decoration: BoxDecoration(
                            color:Colors.lightBlue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),

                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => LocationScreen());
                    },
                    child: Container(
                      child: Text("C o u n t r y ' s",style: TextStyle(fontWeight: FontWeight.bold),),
                      padding: EdgeInsets.symmetric(vertical: 6.0,horizontal: 59.0),
                      decoration: BoxDecoration(
                        color:Colors.lightBlue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 9),
                    child: Container(
                      child: Text("T h e m e",style: TextStyle(fontWeight: FontWeight.bold),),
                        padding: EdgeInsets.symmetric(vertical: 6.0,horizontal: 42.0),
                          decoration: BoxDecoration(
                            color:Colors.lightBlue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: CupertinoSwitch(
                        value: themeValue,
                        activeColor: CupertinoColors.activeBlue,
                        onChanged: (bool? value) {
                          setState(() {
                            themeValue = value ?? false;
                            Get.changeThemeMode(
                              Pref.isDarkMode ? ThemeMode.light : ThemeMode.dark
                            );
                            Pref.isDarkMode = !Pref.isDarkMode;
                          });
                        },
                        ),
                      ),
                    ],
                ),
                ]
              ),
            ), 
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Container(
                      child: Text("D e v e l o p e r  I n f o",style: TextStyle(fontWeight: FontWeight.bold),),
                      padding: EdgeInsets.symmetric(vertical: 6.0,horizontal: 40.0),
                      decoration: BoxDecoration(
                        color:Colors.lightGreen,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
            ),
          ],
        ),
),

      bottomNavigationBar: _changeLocation(context),

      //body
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [

        //vpn button
        Obx(() => _vpnButton()),

        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //country flag
              HomeCard(
                  title: _controller.vpn.value.countryLong.isEmpty
                      ? 'Country'
                      : _controller.vpn.value.countryLong,
                  subtitle: 'FREE',
                  icon: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue,
                    child: _controller.vpn.value.countryLong.isEmpty
                        ? Icon(Icons.vpn_lock_rounded,
                            size: 30, color: Colors.white)
                        : null,
                    backgroundImage: _controller.vpn.value.countryLong.isEmpty
                        ? null
                        : AssetImage(
                            'assets/flags/${_controller.vpn.value.countryShort.toLowerCase()}.png'),
                  )),

              //ping time
              HomeCard(
                  title: _controller.vpn.value.countryLong.isEmpty
                      ? '100 ms'
                      : '${_controller.vpn.value.ping} ms',
                  subtitle: 'PING',
                  icon: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.equalizer_rounded,
                        size: 30, color: Colors.white),
                  )),
            ],
          ),
        ),

        StreamBuilder<VpnStatus?>(
            initialData: VpnStatus(),
            stream: VpnEngine.vpnStatusSnapshot(),
            builder: (context, snapshot) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //download
                    HomeCard(
                        title: '${snapshot.data?.byteIn ?? '0 kbps'}',
                        subtitle: 'DOWNLOAD',
                        icon: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.lightGreen,
                          child: Icon(Icons.arrow_downward_rounded,
                              size: 30, color: Colors.white),
                        )),

                    //upload
                    HomeCard(
                        title: '${snapshot.data?.byteOut ?? '0 kbps'}',
                        subtitle: 'UPLOAD',
                        icon: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.arrow_upward_rounded,
                              size: 30, color: Colors.white),
                        )),
                  ],
                ))
      ]),
    );
  }

  //vpn button
  Widget _vpnButton() => Column(
        children: [

          Transform.scale(
                      scale: 3.0,
                      child: CupertinoSwitch(
                                // This bool value toggles the switch.
                      value: switchValue,
                      //activeColor: CupertinoColors.activeGreen,
                      activeColor: _controller.getButtonColor,
                      onChanged: (bool? value) {
                        // This is called when the user toggles the switch.
                        setState(() {
                          switchValue = value ?? false;
                          _controller.connectToVpn();
                        });
                      },
                    ),
                  ),

          SizedBox(height: 40,),
          //button
          /*Semantics(
            button: true,
            child: InkWell(
              onTap: () {
                _controller.connectToVpn();
              },
              borderRadius: BorderRadius.circular(100),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _controller.getButtonColor.withOpacity(.1)),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _controller.getButtonColor.withOpacity(.3)),
                  child: Container(
                    width: mq.height * .14,
                    height: mq.height * .14,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _controller.getButtonColor),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //icon
                        Icon(
                          Icons.power_settings_new,
                          size: 28,
                          color: Colors.white,
                        ),

                        SizedBox(height: 4),

                        //text
                        Text(
                          _controller.getButtonText,
                          style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),*/

          //connection status label
          Container(
            margin:
                EdgeInsets.only(top: mq.height * .015, bottom: mq.height * .02),
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(15)),
            child: Text(
              _controller.vpnState.value == VpnEngine.vpnDisconnected
                  ? 'Not Connected'
                  : _controller.vpnState.replaceAll('_', ' ').toUpperCase(),
              style: TextStyle(fontSize: 12.5, color: Colors.white),
            ),
          ),

          //count down timer
          Obx(() => CountDownTimer(
              startTimer:
                  _controller.vpnState.value == VpnEngine.vpnConnected)),
        ],
      );

  //bottom nav to change location
  Widget _changeLocation(BuildContext context) => SafeArea(
          child: Semantics(
        button: true,
        child: InkWell(
          onTap: () => Get.to(() => LocationScreen()),
          child: Container(
              color: Theme.of(context).bottomNav,
              padding: EdgeInsets.symmetric(horizontal: mq.width * .04),
              height: 60,
              child: Row(
                children: [
                  //icon
                  Icon(CupertinoIcons.globe, color: Colors.white, size: 28),

                  //for adding some space
                  SizedBox(width: 10),

                  //text
                  Text(
                    'Change Location',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),

                  //for covering available spacing
                  Spacer(),

                  //icon
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.keyboard_arrow_right_rounded,
                        color: Colors.blue, size: 26),
                  )
                ],
              )),
        ),
      ));
}
