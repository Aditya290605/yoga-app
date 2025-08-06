// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:yoga_app/data/datasources/local_session_datasource.dart'
    as _i989;
import 'package:yoga_app/data/repositories/session_repository_impl.dart'
    as _i869;
import 'package:yoga_app/domain/repositories/session_repository.dart' as _i823;
import 'package:yoga_app/domain/usecases/load_session.dart' as _i809;
import 'package:yoga_app/presentation/bloc/session/session_bloc.dart' as _i1022;
import 'package:yoga_app/presentation/services/audio_service.dart' as _i95;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i95.AudioService>(() => _i95.AudioService());
    gh.lazySingleton<_i989.LocalSessionDatasource>(
      () => _i989.LocalSessionDatasourceImpl(),
    );
    gh.lazySingleton<_i823.SessionRepository>(
      () => _i869.SessionRepositoryImpl(gh<_i989.LocalSessionDatasource>()),
    );
    gh.factory<_i809.LoadSession>(
      () => _i809.LoadSession(gh<_i823.SessionRepository>()),
    );
    gh.factory<_i1022.SessionBloc>(
      () =>
          _i1022.SessionBloc(gh<_i809.LoadSession>(), gh<_i95.AudioService>()),
    );
    return this;
  }
}
