class UserModel {
  final int id;
  final String username;
  final String name;
  final String phone;
  final String email;
  final String id_fr;
  final bool is_active;
  final bool is_superuser;

  UserModel(
      this.id,
      this.username,
      this.name,
      this.phone,
      this.email,
      this.id_fr,
      this.is_active,
      this.is_superuser,
      );

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        name = json['name'],
        phone = json['phone'],
        email = json['email'],
        id_fr = json['id_fr'],
        is_active = json['is_active'],
        is_superuser = json['is_superuser'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'name': name,
    'phone': phone,
    'email': email,
    'id_fr': id_fr,
    'is_active': is_active,
    'is_superuser': is_superuser,
  };
}