import 'package:get_it/get_it.dart';
import 'package:habittin/Repositories/Auth%20Repo/auth_repo.dart';

final lc = GetIt.instance;

Future<void> initializeDependencies() async {
  lc.registerLazySingleton(() => AuthRepo());

}
