import 'package:fpdart/fpdart.dart';
import 'package:whatsup/common/enum/message.dart';

extension OptionHelper<T> on Option<T> {
  /// Returns the option's value if it is `Some(value)`.
  /// Otherwise, throws an error.
  ///
  /// When you are sure that the option is `Some(value)`,
  /// you can call `unwrap()` to get the value.
  T unwrap() {
    return getOrElse(() => throw "called `Option.unwrap()` on a `None` value");
  }
}

extension ChatMessageConverter on String {
  ChatMessageType intoChatMessage() {
    switch (this) {
      case 'text':
        return ChatMessageType.text;
      case 'image':
        return ChatMessageType.image;
      case 'audio':
        return ChatMessageType.audio;
      case 'video':
        return ChatMessageType.video;
      case 'gif':
        return ChatMessageType.gif;
      default:
        return ChatMessageType.text;
    }
  }
}
