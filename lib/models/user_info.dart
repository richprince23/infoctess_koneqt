class UserInfo {
  ///[unique] user's unique id. This id is et from the Firebase Auth User id
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

  UserInfo({
    required this.userID,
    this.fullName,
    this.emailAddress,
    this.userName,
    this.avatar,
    this.gender,
    this.phoneNum,
    this.indexNum,
    this.userLevel,
    this.classGroup,
  });

  UserInfo.user({required this.userID, User? user});
}

class User {
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

  User({
    this.avatar,
    this.emailAddress,
    this.classGroup,
    this.fullName,
    this.gender,
    this.indexNum,
    this.phoneNum,
    this.userLevel,
    this.userName,
  });
}
