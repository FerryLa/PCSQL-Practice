import 'package:get_it/get_it.dart';
import '../core/network/api_client.dart';
import '../data/datasources/github_datasource.dart';
import '../data/datasources/cache_datasource.dart';
import '../data/repositories/dashboard_repository.dart';
import '../data/repositories/calendar_repository.dart';
import '../presentation/bloc/dashboard/dashboard_bloc.dart';
import '../presentation/bloc/calendar/calendar_bloc.dart';
import '../presentation/bloc/timer/timer_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // Data Sources
  sl.registerLazySingleton<GitHubDataSource>(
    () => GitHubDataSource(sl<ApiClient>()),
  );

  final cache = CacheDataSource();
  await cache.init();
  sl.registerLazySingleton<CacheDataSource>(() => cache);

  // Repositories
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepository(sl<GitHubDataSource>(), sl<CacheDataSource>()),
  );
  sl.registerLazySingleton<CalendarRepository>(
    () => CalendarRepository(sl<GitHubDataSource>(), sl<CacheDataSource>()),
  );

  // BLoCs
  sl.registerFactory<DashboardBloc>(
    () => DashboardBloc(sl<DashboardRepository>()),
  );
  sl.registerFactory<CalendarBloc>(
    () => CalendarBloc(sl<CalendarRepository>()),
  );
  sl.registerFactory<TimerBloc>(() => TimerBloc());
}
