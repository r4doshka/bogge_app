import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env.development')
abstract class DevEnv {
  @EnviedField(varName: 'BASE_URL')
  static const String baseUrl = _DevEnv.baseUrl;
}

@Envied(path: '.env.production')
abstract class ProdEnv {
  @EnviedField(varName: 'BASE_URL')
  static const String baseUrl = _ProdEnv.baseUrl;
}
