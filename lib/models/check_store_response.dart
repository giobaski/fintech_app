class CheckStoreResponse {
  final String storeTitle;
  final int storeId;

  CheckStoreResponse({
    required this.storeTitle,
    required this.storeId,
  });

  factory CheckStoreResponse.fromJson(Map<String, dynamic> json){
    return CheckStoreResponse(
        storeTitle: json['store_title'] as String,
        storeId: json['store_id'] as int
    );
  }


}