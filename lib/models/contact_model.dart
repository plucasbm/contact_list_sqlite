import 'package:contact_list/helpers/contact_helper.dart';

class Contact {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? image;

  Contact();

  Contact.fromMap(Map map){
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    image = map[imageColumn];
  }

  Map toMap(){
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imageColumn: image,
    };
    if(id != null){
      map[idColumn] = id;
    }

    return map;
  }

  @override
  String toString() {
    return ("Contact: (id: $id, name: $name, email: $email, phone: $phone, image: $image)\n");
  }
}