// To parse this JSON data, do
//
//     final job = jobFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Job jobFromJson(String str) => Job.fromJson(json.decode(str));

String jobToJson(Job data) => json.encode(data.toJson());

class Job {
  Job({
    required this.id,
    required this.logo,
    required this.whatsapp,
  });

  int id;
  String logo;
  String whatsapp;

  factory Job.fromJson(Map<String, dynamic> json) => Job(
        id: json["id"],
        logo: json["logo"],
        whatsapp: json["whatsapp"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "logo": logo,
        "whatsapp": whatsapp,
      };
}
