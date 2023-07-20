
class CallModel {
  final String callerId;
  final String callerName;
  final String callerImage;
  final String receiverId;
  final String receiverName;
  final String receiverImage;
  final String callId;
  final bool missedOrDeclined;
  final DateTime date;

  const CallModel({
    required this.callerId,
    required this.callerName,
    required this.callerImage,
    required this.receiverId,
    required this.receiverName,
    required this.receiverImage,
    required this.callId,
    required this.missedOrDeclined,
    required this.date,
  });

  CallModel copyWith({
    String? callerId,
    String? callerName,
    String? callerImage,
    String? receiverId,
    String? receiverName,
    String? receiverImage,
    String? callId,
    bool? missedOrDeclined,
    DateTime? date,
  }) {
    return CallModel(
      callerId: callerId ?? this.callerId,
      callerName: callerName ?? this.callerName,
      callerImage: callerImage ?? this.callerImage,
      receiverId: receiverId ?? this.receiverId,
      receiverName: receiverName ?? this.receiverName,
      receiverImage: receiverImage ?? this.receiverImage,
      callId: callId ?? this.callId,
      missedOrDeclined: missedOrDeclined ?? this.missedOrDeclined,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'callerId': callerId,
      'callerName': callerName,
      'callerImage': callerImage,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'receiverImage': receiverImage,
      'callId': callId,
      'missedOrDeclined': missedOrDeclined,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory CallModel.fromMap(Map<String, dynamic> map) {
    return CallModel(
      callerId: map['callerId'] as String,
      callerName: map['callerName'] as String,
      callerImage: map['callerImage'] as String,
      receiverId: map['receiverId'] as String,
      receiverName: map['receiverName'] as String,
      receiverImage: map['receiverImage'] as String,
      callId: map['callId'] as String,
      missedOrDeclined: map['missedOrDeclined'] as bool,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }

  @override
  String toString() {
    return 'CallModel(callerId: $callerId, callerName: $callerName, callerImage: $callerImage, receiverId: $receiverId, receiverName: $receiverName, receiverImage: $receiverImage, callId: $callId, missedOrDeclined: $missedOrDeclined, date: $date)';
  }

  @override
  bool operator ==(covariant CallModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.callerId == callerId &&
      other.callerName == callerName &&
      other.callerImage == callerImage &&
      other.receiverId == receiverId &&
      other.receiverName == receiverName &&
      other.receiverImage == receiverImage &&
      other.callId == callId &&
      other.missedOrDeclined == missedOrDeclined &&
      other.date == date;
  }

  @override
  int get hashCode {
    return callerId.hashCode ^
      callerName.hashCode ^
      callerImage.hashCode ^
      receiverId.hashCode ^
      receiverName.hashCode ^
      receiverImage.hashCode ^
      callId.hashCode ^
      missedOrDeclined.hashCode ^
      date.hashCode;
  }

}
