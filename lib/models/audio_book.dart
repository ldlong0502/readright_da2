import 'mp3_file.dart';

class AudioBook {
  final int id;
  final String title;
  final String image;
  final String author;
  final String year;
  final int createdAt;
  final double rate;
  final String publisher;
  final int listen;
  final List<String> genre;
  final String description;
  final List<Mp3File> listMp3;
  AudioBook({
    required this.id,
    required this.title,
    required this.image,
    required this.author,
    required this.year,
    required this.rate,
    required this.createdAt,
    required this.publisher,
    required this.listen,
    required this.genre,
    required this.description,
    required this.listMp3,
  });

  factory AudioBook.fromJson(Map<dynamic, dynamic> json , List<String> genre ,  List<Mp3File> mp3) {
    return AudioBook(
      id: json['id'] as int,
      title: json['title'] as String,
      image: json['image'] as String,
      author: json['author'] as String,
      year: json['year'] as String,
      rate: json['rate'] as double,
      createdAt: json['createdAt'] as int,
      publisher: json['publisher'] as String,
      listen: json['listen'] as int,
      genre: genre,
      listMp3: mp3,
      description: json['description'] as String,
    );
  }

  factory AudioBook.fromMap(Map<dynamic, dynamic> map) {
    return AudioBook(
      id: map['id'] as int,
      title: map['title'] as String,
      image: map['image'] as String,
      author: map['author'] as String,
      year: map['year'] as String,
      rate: map['rate'] ?? 0,
      createdAt: map['createdAt'] as int,
      publisher: map['publisher'] as String,
      listen: map['listen'] as int,
      genre: (map['genre'] as List<dynamic>).cast<String>(),
      description: map['description'] as String,
      listMp3: (map['listMp3'] as List<dynamic>).map((mp3) => Mp3File.fromJson(mp3)).toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'author': author,
      'rate': rate,
      'year': year,
      'createdAt': createdAt,
      'publisher': publisher,
      'listen': listen,
      'genre': genre,
      'description': description,
      'listMp3': listMp3.map((mp3) => mp3.toJson()).toList()
    };
  }
}
