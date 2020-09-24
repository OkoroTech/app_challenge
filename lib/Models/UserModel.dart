

class UserModel {
  String name;
  String url;


  UserModel({
    this.url = "",
    this.name = "",
  });


  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? "",
      url: map['url'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name ?? "",
      "url": url ?? "",
    };
  }

  UserModel update({
    String name,
    String url,
  }) {
    return UserModel(
      name: name ?? this.url,
      url: url ?? this.url,
    );
  }

  @override
  List<Object> get props => [
    name,
    url,
  ];

  @override
  bool get stringify => true;
}
