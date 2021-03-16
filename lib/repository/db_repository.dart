class Movie {
  final int id;
  final String name;
  final String type;
  final String title;
  final int year;
  final String poster;
  final String description;
   final int customer;

  Movie( {
   this.name,
    this.customer,
     this.type,
    this.id,
    this.title,
    this.year,
    this.poster,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer': customer,
      'name': name,
      'type': type,
      'title': title,
      'year': year,
      'poster': poster,
      'description': description,
    };
  }
}
