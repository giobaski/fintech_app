class User {
  int? id;
  String? name;
  String? sname;
  String? phone;
  DateTime? phoneVerifiedAt;
  String? pn;
  String? dn;
  int? isVerified = 0;
  String? verificator;
  DateTime? deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? isStore;

  User({
    this.id,
    this.name,
    this.sname,
    this.phone,
    this.phoneVerifiedAt,
    this.pn,
    this.dn,
    this.isVerified,
    this.verificator,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.isStore,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      sname: json["sname"],
      phone: json["phone"],
      phoneVerifiedAt: DateTime.parse(json["phone_verified_at"]),
      pn: json["pn"],
      dn: json["dn"],
      isVerified: json['is_verified'],
      verificator: json["verificator"],
      deletedAt: json["deleted_at"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      isStore: json["is_store"],
    );
  }


  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "name": name,
        "sname": sname,
        "phone": phone,
        "phone_verified_at": phoneVerifiedAt!.toIso8601String(),
        "pn": pn,
        "dn": dn,
        "is_verified": isVerified,
        "verificator": verificator,
        "deleted_at": deletedAt,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "is_store": isStore,
      };

  @override
  String toString() {
    return 'User{id: $id, name: $name, sname: $sname, phone: $phone, phoneVerifiedAt: $phoneVerifiedAt, pn: $pn, dn: $dn, isVerified: $isVerified, verificator: $verificator, isStore: $isStore}';
  }

}
