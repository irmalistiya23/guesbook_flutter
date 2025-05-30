class Guest {
  final int id;
  final String name;
  final String email;
  final String message;

  Guest({required this.id, required this.name, required this.email, required this.message});

  factory Guest.fromJson(Map<String, dynamic> json) {
    return Guest(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      message: json['message'],
    );
  }
}