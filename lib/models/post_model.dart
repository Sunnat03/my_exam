class Post {
  late String postKey;
  late String userId;
  late String name;
  late String price;
  late String date;
  late String description;
  late String address;
  late String number;
  String? image;

  Post({
    required this.postKey,
    required this.userId,
    required this.name,
    required this.price,
    required this.date,
    required this.description,
    required this.address,
    required this.number,
    this.image});

  Post.fromJson(Map<String, dynamic> json) {
    postKey = json['postKey'];
    userId = json['userId'];
    name = json['name'];
    price = json['price'];
    date = json['date'];
    description = json['description'];
    address = json['address'];
    image = json['image'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() => {
    'postKey': postKey,
    'userId': userId,
    'number': number,
    'name': name,
    'price': price,
    'date': date,
    'description': description,
    'address': address,
    'image': image,
  };
}