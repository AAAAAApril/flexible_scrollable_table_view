import 'package:example/pages/normal_list.dart';
import 'package:example/pages/sliver_list.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, Widget> pages = <String, Widget>{
      '普通列表': const NormalList(),
      'Sliver内': const InSliverList(),
    };
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('双向滚动TableView'),
        ),
        body: DefaultTabController(
          length: pages.length,
          child: Column(
            children: [
              TabBar(tabs: pages.keys.map<Widget>((e) => Tab(text: e)).toList()),
              Expanded(
                child: TabBarView(
                  children: pages.values.toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
