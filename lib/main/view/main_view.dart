import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stores_app/external/widget/view_map.dart';
import 'package:stores_app/main/view/main_profile_view.dart';
import 'package:stores_app/main/view/search_view.dart';
import 'package:stores_app/main/view/stores_view.dart';
import 'package:stores_app/external/theme/app_colors.dart';

import 'package:stores_app/main/provider/main_profile_provider.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});
  @override
  ConsumerState<MainView> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  int currentPageIndex = 1;
  int build_counter = 0;

  bool visitedProfile = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    build_counter++;
    return Scaffold(
      floatingActionButton:
          currentPageIndex == 0
              ? FloatingActionButton.extended(
                backgroundColor: AppColors.mainColor,
                onPressed: () async {
                  await Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (context) => ViewMap()));
                },
                label: Row(
                  children: [
                    Icon(Icons.map, color: Colors.white),
                    Text(
                      ' View Map  ',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              )
              : Container(),
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            if (value == currentPageIndex && value == 1) {
            } else if (value == currentPageIndex && value == 2) {
              ref.refresh(studentProfileProvider);
            }

            if (!visitedProfile && value == 2) {
              ref.refresh(studentProfileProvider);
              visitedProfile = true;
            }

            currentPageIndex = value;
          });
        },
        currentIndex: currentPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store_mall_directory),
            label: "Stores",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: "Profile",
          ),
        ],
        selectedItemColor: AppColors.mainColor,
      ),
      appBar: AppBar(
        toolbarHeight: 90,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        backgroundColor: AppColors.mainColor,
        title: Text(
          ["Search", "Stores", "Profile"][currentPageIndex],
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset('assets/images/logo.png', height: 50),
          ),
        ],
        leading: Container(),
      ),

      body:
          [
            SearchView(),
            StoresView(),
            const MainProfileView(),
          ][currentPageIndex],
    );
  }
}
