import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stores_app/external/app_data.dart';
import 'package:stores_app/external/widget/custom_loading.dart';
import 'package:stores_app/test/test_provider.dart';

class TestView extends ConsumerStatefulWidget {
  const TestView({super.key});

  @override
  ConsumerState<TestView> createState() => _TestViewState();
}

class _TestViewState extends ConsumerState<TestView> {

  @override
  void initState() {
    AppData.SERVER_URL = "http://192.168.1.10:5000";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final fetchingState = ref.watch(getStoresDataTestProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
      ref.read(getStoresDataTestProvider.notifier).FetchStoresData();
      },child: Icon(Icons.refresh),),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer(builder:(context,ref,widget)=> Text(ref.watch(testProvider).toString())),
            
            ElevatedButton(onPressed: (){
              ref.read(getStoresDataTestProvider.notifier).FetchStoresData();
            }, child: Text("Fetch Data")),
            
            ElevatedButton(onPressed: (){
              ref.refresh(testProvider);
            }, child: Text("Read from Local Database")),
            SizedBox(height: 15),
            if(fetchingState.isLoading)
            CustomLoading()
            
            ],
          ),
        ],
      ),
    );
  }
}


