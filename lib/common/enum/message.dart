enum ChatMessageType {
  text('text'),
  image('image'),
  audio('audio'),
  video('video'),
  gif('gif');

  const ChatMessageType(this.type);
  final String type;
}
