const String tableStarredMessages = 'starred_messages';

class StarredMFields {
  static String msgID = 'messageID';
  static String chatID = 'chatID';
  static String starredAt = 'starredAt';
  static String senderID = 'senderID';
  static String message = 'message';
}

class StarredMessage {
  String? messageID;
  String? chatID;
  String? starredAt;
  String? senderID;
  String? message;

  StarredMessage({this.messageID, this.chatID, this.starredAt, this.senderID, this.message});

  Map<String, Object?> toJson() => {
        StarredMFields.msgID: messageID,
        StarredMFields.chatID: chatID,
        StarredMFields.starredAt: starredAt,
        StarredMFields.senderID: senderID,
        StarredMFields.message: message,
      };

  static StarredMessage fromJson(Map<dynamic, Object?> json) {
    return StarredMessage(
      messageID: json[StarredMFields.msgID] as String?,
      chatID: json[StarredMFields.chatID] as String?,
      starredAt: json[StarredMFields.starredAt] as String?,
      senderID: json[StarredMFields.senderID] as String?,
      message: json[StarredMFields.message] as String?,
    );
  }

  StarredMessage copy({
    var messageID,
    var chatID,
    var starredAt,
    var senderID,
    var message,
  }) {
    return StarredMessage(
      messageID: messageID ?? this.messageID,
      chatID: chatID ?? this.chatID,
      starredAt: starredAt ?? this.starredAt,
      senderID: senderID ?? this.senderID,
      message: message ?? this.message,
    );
  }
}
