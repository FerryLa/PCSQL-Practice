import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/di.dart';
import 'app/theme.dart';
import 'presentation/bloc/dashboard/dashboard_bloc.dart';
import 'presentation/bloc/calendar/calendar_bloc.dart';
import 'presentation/bloc/timer/timer_bloc.dart';
import 'presentation/pages/dashboard_page.dart';
import 'presentation/pages/study_tracker_page.dart';
import 'presentation/pages/timer_page.dart';
import 'presentation/pages/calendar_page.dart';
import 'presentation/pages/sql_tracker_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await initDependencies();
  runApp(const StudyHubApp());
}

class StudyHubApp extends StatelessWidget {
  const StudyHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DashboardBloc>(
          create: (_) => sl<DashboardBloc>()..add(LoadDashboard()),
        ),
        BlocProvider<CalendarBloc>(
          create: (_) => sl<CalendarBloc>()..add(LoadEvents()),
        ),
        BlocProvider<TimerBloc>(
          create: (_) => TimerBloc()..add(InitTimers()),
        ),
      ],
      child: MaterialApp(
        title: 'Study Hub',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: const MainScaffold(),
      ),
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final _pages = const [
    DashboardPage(),
    StudyTrackerPage(),
    TimerPage(),
    CalendarPage(),
    SQLTrackerPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: '대시보드',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist),
            label: '학습',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: '타이머',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '캘린더',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'SQL',
          ),
        ],
      ),
    );
  }
}
