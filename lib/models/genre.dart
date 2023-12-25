// ignore_for_file: public_member_api_docs, sort_constructors_first


class Genre {
  final int id;
  final String name;
  final String icon;
  Genre({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory Genre.fromJson(Map<dynamic, dynamic> json) {
    return Genre(
      id: json['id'] as int,
      name: json['name'] as String,
      icon: json['icon'] as String,
    );
  }
  Map<dynamic, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }




}
