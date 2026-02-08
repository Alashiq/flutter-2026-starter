import 'package:starter/core/network/models/pagination_meta.dart';

sealed class ApiStatePaginated<T> {
  const ApiStatePaginated();
}

class ApiPaginatedInit<T> extends ApiStatePaginated<T> {
  const ApiPaginatedInit();
}

class ApiPaginatedLoading<T> extends ApiStatePaginated<T> {
  const ApiPaginatedLoading();
}

class ApiPaginatedLoadingMore<T> extends ApiStatePaginated<T> {
  final List<T> currentData;
  final PaginationMeta meta;

  const ApiPaginatedLoadingMore(this.currentData, this.meta);
}

class ApiPaginatedSuccess<T> extends ApiStatePaginated<T> {
  final List<T> data;
  final PaginationMeta meta;

  const ApiPaginatedSuccess(this.data, this.meta);
}

class ApiPaginatedEmpty<T> extends ApiStatePaginated<T> {
  const ApiPaginatedEmpty();
}

class ApiPaginatedError<T> extends ApiStatePaginated<T> {
  final int code;
  final String message;
  final List<T>? currentData;
  final PaginationMeta? meta;

  const ApiPaginatedError(
    this.code,
    this.message, {
    this.currentData,
    this.meta,
  });
}

class ApiPaginatedNoInternet<T> extends ApiStatePaginated<T> {
  final List<T>? currentData;
  final PaginationMeta? meta;

  const ApiPaginatedNoInternet({this.currentData, this.meta});
}

class ApiPaginatedUnauthorized<T> extends ApiStatePaginated<T> {
  const ApiPaginatedUnauthorized();
}

class ApiPaginatedNoPermission<T> extends ApiStatePaginated<T> {
  const ApiPaginatedNoPermission();
}
