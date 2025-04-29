import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stores_app/test/test_provider.dart';

class TestView extends ConsumerWidget {
  const TestView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("hi");
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer(builder:(context,ref,widget)=> Text(ref.watch(testProvider).toString())),
            
            ElevatedButton(onPressed: (){
              ref.read(testProvider.notifier).increment();
            }, child: Text("Click Me")),
            
            ElevatedButton(onPressed: (){
              ref.refresh(testProvider);
            }, child: Text("Refrechh")),
            
            ],
          ),
        ],
      ),
    );
  }
}


