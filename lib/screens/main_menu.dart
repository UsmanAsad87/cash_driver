
import 'package:cash_driver/screens/activity_screen.dart';
import 'package:cash_driver/constants.dart';
import 'package:cash_driver/screens/home_screen.dart';
import 'package:cash_driver/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/user_provider.dart';


class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {

  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    addData();
    pageController = PageController();
    super.initState();
  }
  addData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: const [
          ActivityScreen(),
          HomeScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -4),
              blurRadius: 4,
              color: Colors.black.withOpacity(0.25),
            )
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _page,
          backgroundColor: kSecondaryColor2,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.access_time,
                  color: _page == 0 ? kSecondaryColor : kSecondaryColor.withOpacity(0.5),
                ),
                label: 'Activity',
                backgroundColor: kWhiteColor),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: _page == 1 ? kSecondaryColor : kSecondaryColor.withOpacity(0.5),
                ),
                label: 'Home',
                backgroundColor:  kWhiteColor),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_outline,
                  color: _page == 2 ? kSecondaryColor : kSecondaryColor.withOpacity(0.5),
                ),
                label: 'Profile',
                backgroundColor:  kWhiteColor),
          ],
          selectedLabelStyle: kBodyStyle4,
          unselectedLabelStyle: kBodyStyle4,
          onTap: navigationTapped,
        ),
      ),
    );
  }
}
