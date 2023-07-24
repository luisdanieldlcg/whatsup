enum MessageType {
  text('text'),
  image('image'),
  audio('audio'),
  video('video'),
  gif('gif');

  const MessageType(this.type);
  final String type;
}
