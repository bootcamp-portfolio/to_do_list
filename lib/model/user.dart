class User {
  int? id; //auto increment,pk
  String name;
  String email;
  //Uint8List image;
  String pw;
  String? createddate;

  User({
    this.id,
    required this.name,
    required this.email,
    //required this.image,
    required this.pw,
    this.createddate,
  });

  User.fromMap(Map<String, dynamic> res)
    : id = res['id'],
      name = res['name'],
      email = res['email'],
      //image = res['image'],
      pw = res['pw'],
      createddate = res['createddate'];
}
