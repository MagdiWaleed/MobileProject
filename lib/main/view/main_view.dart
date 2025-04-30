import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stores_app/main/services/main_profile_service/main_profile_bloc.dart';
import 'package:stores_app/main/view/main_profile_view.dart';
import 'package:stores_app/main/view/stores_view.dart';
import 'package:stores_app/external/theme/app_colors.dart';


class MainView extends ConsumerStatefulWidget {
  MainView({super.key});
  @override
  ConsumerState<MainView> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  int currentPageIndex = 1;
  int build_counter = 0;
  final MainProfileBloc mainProfileBloc = MainProfileBloc();

  List<String> appBarText = ["Search", "Stores", "Profile"];
  bool visitedProfile = false;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    
    build_counter++;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {

          setState(() {
            
           if(value == currentPageIndex && value ==2){
              // mainProfileBloc.add(MainProfileGetDataEvent());
            }
            
            if(!visitedProfile){
              mainProfileBloc.add(MainProfileGetDataEvent());
              visitedProfile= true;
            }

            currentPageIndex = value;
            

          });
        },
        currentIndex: currentPageIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: "Search"),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        backgroundColor: AppColors.mainColor,
        title: Text(
          appBarText[currentPageIndex],
          style: TextStyle(
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
            Placeholder(),
            StoresView(),
            MainProfileView(mainProfileBloc: mainProfileBloc,),
          ][currentPageIndex],
    );
  }
}
