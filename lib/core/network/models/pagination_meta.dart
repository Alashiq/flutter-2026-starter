class PaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final String? nextPageUrl;
  final String? prevPageUrl;
  final int? from;
  final int? to;

  PaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    this.nextPageUrl,
    this.prevPageUrl,
    this.from,
    this.to,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 10,
      total: json['total'] ?? 0,
      nextPageUrl: json['next_page_url'],
      prevPageUrl: json['prev_page_url'],
      from: json['from'],
      to: json['to'],
    );
  }

  bool get hasNextPage => nextPageUrl != null && currentPage < lastPage;
  bool get hasPrevPage => prevPageUrl != null && currentPage > 1;
  bool get isLastPage => currentPage >= lastPage;
  bool get isFirstPage => currentPage == 1;
}
