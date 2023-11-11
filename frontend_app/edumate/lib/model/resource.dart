// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Resource {
  String id;
  String name;
  String domain;
  String? subDomain;
  int semester;
  List<String> tags;
  String url;
  Resource({
    required this.id,
    required this.name,
    required this.domain,
    this.subDomain,
    required this.semester,
    required this.tags,
    required this.url,
  });

  Resource copyWith({
    String? id,
    String? name,
    String? domain,
    String? subDomain,
    int? semester,
    List<String>? tags,
    String? url,
  }) {
    return Resource(
      id: id ?? this.id,
      name: name ?? this.name,
      domain: domain ?? this.domain,
      subDomain: subDomain ?? this.subDomain,
      semester: semester ?? this.semester,
      tags: tags ?? this.tags,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'domain': domain,
      'subDomain': subDomain,
      'semester': semester,
      'tags': tags,
      'url': url,
    };
  }

  factory Resource.fromMap(Map<String, dynamic> map) {
    return Resource(
      id: map['id'] as String,
      name: map['name'] as String,
      domain: map['domain'] as String,
      subDomain: map['subDomain'] != null ? map['subDomain'] as String : null,
      semester: map['semester'] as int,
      tags: List<String>.from((map['tags'] as List<String>)),
      url: map['url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Resource.fromJson(String source) =>
      Resource.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Resource(id: $id, name: $name, domain: $domain, subDomain: $subDomain, semester: $semester, tags: $tags, url: $url)';
  }

  @override
  bool operator ==(covariant Resource other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.domain == domain &&
        other.subDomain == subDomain &&
        other.semester == semester &&
        listEquals(other.tags, tags) &&
        other.url == url;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        domain.hashCode ^
        subDomain.hashCode ^
        semester.hashCode ^
        tags.hashCode ^
        url.hashCode;
  }
}
