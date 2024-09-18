import '../entities/user_entity.dart';

class MyUser {
   String uid;
   String email;
   String name;
   bool hasActiveCart;

  MyUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.hasActiveCart,
  });
  
  static final MyUser empty = MyUser(
    uid: '',
    email: '',
    name: '',
    hasActiveCart: false,
  );

  MyUserEntity toEntity() {
    return MyUserEntity(
      uid: uid,
      email: email,
      name: name,
      hasActiveCart: hasActiveCart,
    );
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
      uid: entity.uid,
      email: entity.email,
      name: entity.name,
      hasActiveCart: entity.hasActiveCart,
    );
  }
}
