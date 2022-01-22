class SectionItem {

  String image = "";

  SectionItem.fromMap(Map<String, dynamic> map) {
    image = map['image'] as String;
  }


  @override
  String toString() => 'SectionItem(image: $image)';
}
