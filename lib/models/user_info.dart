class UserInfo {
  ///[unique] user's unique id. This id is et from the Firebase Auth MyUser id
  String userID;

  ///user's fullname
  String? fullName;

  ///[unique] user's email address
  String? emailAddress;

  /// user's profice picture url
  String? avatar;

  /// [unique] user's index number
  int? indexNum;

  /// user's study level or year as string
  String? userLevel;

  /// user's class group.
  String? classGroup;

  ///user's gender. Either of Male or Female; nothing more
  String? gender;

  ///[unique] user's refered username or nickname. used in place of fullname.  used to refer to user publicly.
  String? userName;

  ///[unique] user's phone number
  int? phoneNum;

  bool isAdmin = false;

  UserInfo(
      {required this.userID,
      this.fullName,
      this.emailAddress,
      this.userName,
      this.avatar,
      this.gender,
      this.phoneNum,
      this.indexNum,
      this.userLevel,
      this.classGroup,
      this.isAdmin = false});

  UserInfo.user({required this.userID, MyUser? user});
}

class MyUser {
  ///user's fullname
  String? fullName;

  ///[unique] user's email address
  String? emailAddress;

  /// user's profice picture url
  String? avatar;

  /// [unique] user's index number
  int? indexNum;

  /// user's study level or year as string
  String? userLevel;

  /// user's class group.
  String? classGroup;

  ///user's gender. Either of Male or Female; nothing more
  String? gender;

  ///[unique] user's refered username or nickname. used in place of fullname.  used to refer to user publicly.
  String? userName;

  ///[unique] user's phone number
  String? phoneNum;

  ///If user is an Admin or a normal user
  bool isAdmin;

  MyUser(
      {this.avatar,
      this.emailAddress,
      this.classGroup,
      this.fullName,
      this.gender,
      this.indexNum,
      this.phoneNum,
      this.userLevel,
      this.userName,
      this.isAdmin = false});

  //from json method
  Map<String, Object?> toJson() {
    return {
      UserFields.fullName: fullName as String,
      UserFields.emailAddress: emailAddress,
      UserFields.avatar: avatar,
      UserFields.indexNum: indexNum,
      UserFields.userLevel: userLevel,
      UserFields.classGroup: classGroup,
      UserFields.phoneNum: phoneNum,
      UserFields.gender: gender,
      UserFields.userName: userName,
    };
  }

  //to json method
  static MyUser fromJson(Map<String, Object?> json) {
    return MyUser(
        fullName: json[UserFields.fullName] as String?,
        emailAddress: json[UserFields.emailAddress] as String?,
        avatar: json[UserFields.avatar] as String?,
        indexNum: json[UserFields.indexNum] as int?,
        userLevel: json[UserFields.userLevel] as String?,
        classGroup: json[UserFields.classGroup] as String?,
        phoneNum: json[UserFields.phoneNum] as String?,
        gender: json[UserFields.gender] as String?,
        userName: json[UserFields.userName] as String?,
        isAdmin: json[UserFields.isAdmin] as bool);
  }
}

class UserFields {
  static var fullName = 'fullName';
  static var emailAddress = 'emailAddress';
  static var avatar = 'avatar';
  static var indexNum = 'indexNum';
  static var userLevel = 'userLevel';
  static var classGroup = 'classGroup';
  static var phoneNum = 'phoneNum';
  static var userName = 'userName';
  static var gender = 'gender';
  static var isAdmin = 'isAdmin';
}
