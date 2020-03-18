import 'package:flutter/material.dart';

class TabsView extends StatefulWidget {
  @override
  _TabsViewState createState() => _TabsViewState();
}

class _TabsViewState extends State<TabsView> with TickerProviderStateMixin{
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
