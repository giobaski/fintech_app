class Bank {
  int? id;
  String? title;
  String? identificationNumber;

  Bank({
      this.id,
      this.title,
      this.identificationNumber,
      });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
        id: json['id'],
        title: json['title'],
        identificationNumber: json['identification_number']
    );
  }

}