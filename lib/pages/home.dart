import 'package:fittracker/fittracker_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fittracker/pages/dashboard.dart';
import 'package:fittracker/pages/meals.dart';
import 'package:fittracker/pages/mood.dart';
import 'package:fittracker/pages/workouts.dart';
import 'package:fittracker/pages/map_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  Future<void> _showCalendarDialog(BuildContext context) async {
    final trackerState = Provider.of<FitTrackerState>(context, listen: false);
    DateTime selectedDay = trackerState.selectedDate;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select a Date'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400, // Adjust calendar height here
            child: TableCalendar(
              focusedDay: selectedDay,
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              selectedDayPredicate: (day) {
                return isSameDay(selectedDay, day);
              },
              onDaySelected: (selected, focused) {
                trackerState.setSelectedDate(
                  selected,
                ); // <-- Global date update!
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );

    // feedback after selection
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Selected date: ${trackerState.selectedDate.toLocal().toString().split(' ')[0]}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobileDevice = isMobile(context);
    final showTabBar = !isMobileDevice;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "FitTracker",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0.0,
        centerTitle: true,
        bottom:
            showTabBar
                ? TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: "Dashboard"),
                    Tab(text: "Meals"),
                    Tab(text: "Mood"),
                    Tab(text: "Workouts"),
                    Tab(text: "Map"),
                  ],
                )
                : null,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _showCalendarDialog(context),
          ),
          if (isMobileDevice)
            Builder(
              builder:
                  (context) => IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
            ),
        ],
      ),
      endDrawer:
          isMobileDevice
              ? Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const DrawerHeader(
                      decoration: BoxDecoration(color: Colors.blue),
                      child: Text(
                        'Navigation Menu',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.dashboard),
                      title: Text('Dashboard'),
                      onTap: () {
                        Navigator.pop(context);
                        _tabController.animateTo(0);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.restaurant),
                      title: Text('Meals'),
                      onTap: () {
                        Navigator.pop(context);
                        _tabController.animateTo(1);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.mood),
                      title: Text('Mood'),
                      onTap: () {
                        Navigator.pop(context);
                        _tabController.animateTo(2);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.fitness_center),
                      title: Text('Workouts'),
                      onTap: () {
                        Navigator.pop(context);
                        _tabController.animateTo(3);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.map),
                      title: Text('Map'),
                      onTap: () {
                        Navigator.pop(context);
                        _tabController.animateTo(4);
                      },
                    ),
                  ],
                ),
              )
              : null,
      body: TabBarView(
        controller: _tabController,
        children: [
          DashboardPage(),
          MealsPage(),
          MoodPage(),
          WorkoutsPage(),
          MapPage(),
        ],
      ),
    );
  }
}
