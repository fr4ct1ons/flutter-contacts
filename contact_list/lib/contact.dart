class Contact {
  String name;
  String phoneNumber;
  String email;
  String image = '';

  Contact(
      {required this.name,
      required this.phoneNumber,
      required this.email,
      this.image = ''});

  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'image': image};
  }
}
