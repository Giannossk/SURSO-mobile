import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/network/dio_client.dart';

part 'stats_repository.g.dart';

class StatsRepository {
  StatsRepository(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> summary() async {
    final res = await _dio.get('/stats/summary');
    return (res.data as Map<String, dynamic>)['totals'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> dashboard() async {
    final res = await _dio.get('/stats/dashboard');
    return res.data as Map<String, dynamic>;
  }
}

@Riverpod(keepAlive: true)
StatsRepository statsRepository(Ref ref) => StatsRepository(ref.watch(dioProvider));
