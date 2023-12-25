import 'package:ebook/models/audio_book.dart';
import 'package:flutter/cupertino.dart';

class HistoryAudioBook {
  final AudioBook audioBook;
  final int duration;
  final int indexChapter;
  final int dateUpdated;

  HistoryAudioBook({
    required this.audioBook,
    required this.duration,
    required this.indexChapter,
    required this.dateUpdated,
  });

  factory HistoryAudioBook.fromJson(Map<String, dynamic> json) {
    return HistoryAudioBook(
        audioBook: AudioBook.fromMap(json['audio_book']),
        duration: json['duration'] ?? 0,
        indexChapter: json['indexChapter'] ?? 0,
        dateUpdated: json['dateUpdated'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {
      'audio_book': audioBook.toJson(),
      'duration': duration,
      'indexChapter': indexChapter,
      'dateUpdated': dateUpdated,
    };
  }
}
