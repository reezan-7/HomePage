class Contact{
  String name;
  String contact;
  String image;
  Contact({required this.name,required this.contact,required this.image});

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
    name: json["name"],
    contact: json["contact"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "contact": contact,
    "image": image,
  };
}