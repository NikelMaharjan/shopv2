



class Review {
  final String username;
  final String comment;
  final int rating;
  final String user;
  final String id;

  Review({
    required this.rating,
    required this.id,
    required this.comment,
    required this.user,
    required this.username
  });

  factory Review.fromJson(Map<String, dynamic> json){
    return Review(
        rating: json['rating'],
        id: json['_id'],
        comment: json['comment'],
        user: json['user'],
        username: json['username']
    );
  }

}



class Product{


  final String id;
  final String product_name;
  final String product_detail;
  final int product_price;
  final int rating;
  final int numReviews;
  final String product_image;
  final String brand;
  final String category;
  final int countInStock;
  final List<Review> reviews;

  Product({
    required this.id,
    required this.brand,
    required this.category,
    required this.countInStock,
    required this.numReviews,
    required this.product_detail,
    required this.product_image,
    required this.product_name,
    required this.product_price,
    required this.rating,
    required this.reviews
  });

  factory Product.fromJson(Map<String, dynamic> json){
    return Product(
        id: json['_id'],
        brand: json['brand'],
        category: json['category'],
        countInStock: json['countInStock'],
        numReviews: json['numReviews'],
        product_detail: json['product_detail'],
        product_image: json['product_image'],
        product_name: json['product_name'],
        product_price: json['product_price'],
        rating: json['rating'],
        reviews: (json['reviews'] as List).map((e) => Review.fromJson(e)).toList()
    );
  }


}