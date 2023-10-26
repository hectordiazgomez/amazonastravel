import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_hour/blocs/ads_bloc.dart';
import 'package:travel_hour/blocs/notification_bloc.dart';
import 'package:travel_hour/pages/blogs.dart';
import 'package:travel_hour/pages/bookmark.dart';
import 'package:travel_hour/pages/explore.dart';
import 'package:travel_hour/pages/profile.dart';
import 'package:travel_hour/pages/states.dart';
import 'package:travel_hour/services/app_service.dart';
import 'package:travel_hour/utils/snacbar.dart';

import '../services/notification_service.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  PageController _pageController = PageController();

  void onTabTapped(int index) {
    setState(() => _currentIndex = index);
    _pageController.animateToPage(index,
        curve: Curves.easeIn, duration: Duration(milliseconds: 300));
  }

  Future configureAds() async {
    await context.read<AdsBloc>().initiateAdsOnApp();
    context.read<AdsBloc>().loadAds();
  }

  Future _initNotifications() async {
    await NotificationService()
        .initFirebasePushNotification(context)
        .then((value) => context.read<NotificationBloc>().checkPermission());
  }

  Future _showImage() async {
    FirebaseFirestore.instance
        .collection('admin')
        .doc('image')
        .get()
        .then((value) async {
      SharedPreferences sp = await SharedPreferences.getInstance();
      if (value['url'] != sp.getString('image')) {
        sp.setString('image', value['url']);
        _showDialog(value['url']);
      }
    });
  }

  _showDialog(String url) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (ctx) {
          return Center(
            child: Wrap(
              children: [
                Material(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Container(
                        width: 300,
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 400,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(url),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Column(
                          children: [],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _initNotifications();
    _showImage();
    AppService().checkInternet().then((hasInternet) {
      if (hasInternet == false) {
        openSnacbar(context, 'no internet'.tr());
      }
    });

    Future.delayed(Duration(milliseconds: 0)).then((_) async {
      await context.read<AdsBloc>().checkAdsEnable().then((isEnabled) async {
        if (isEnabled != null && isEnabled == true) {
          debugPrint('ads enabled true');
          configureAds(); /* enable this line to enable ads on the app */
        } else {
          debugPrint('ads enabled false');
        }
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    //context.read<AdsBloc>().dispose();
    super.dispose();
  }

  Future _onWillPop() async {
    if (_currentIndex != 0) {
      setState(() => _currentIndex = 0);
      _pageController.animateToPage(0,
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      await SystemChannels.platform
          .invokeMethod<void>('SystemNavigator.pop', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await _onWillPop(),
      child: Scaffold(
        appBar: AppBar(elevation: 0, toolbarHeight: 0),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xffFABC18),
          backgroundColor: Color(0xffB9261A),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svgs/home.svg',
                height: 24,
                width: 24,
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcATop),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svgs/stack.svg',
                height: 24,
                width: 24,
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcATop),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svgs/list.svg',
                height: 24,
                width: 24,
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcATop),
              ),
              label: 'Blogs',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svgs/bookmark.svg',
                height: 24,
                width: 24,
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcATop),
              ),
              label: 'Bookmarks',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svgs/person.svg',
                height: 24,
                width: 24,
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcATop),
              ),
              label: 'Profile',
            ),
          ],
          currentIndex: _currentIndex,
          iconSize: 22,
          onTap: (index) => onTabTapped(index),
        ),
        body: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            StatesPage(),
            Explore(),
            BlogPage(),
            BookmarkPage(),
            ProfilePage(),
          ],
        ),
      ),
    );
  }
}
