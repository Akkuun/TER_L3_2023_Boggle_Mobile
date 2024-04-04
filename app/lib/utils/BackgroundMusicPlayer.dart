import 'package:audioplayers/audioplayers.dart';

class BackgroundMusicPlayer {

  static const String  path_ost = 'audio/OST.mp3';

  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playOST() async {

    await _audioPlayer.setSource(AssetSource(path_ost));
    await Future.delayed(const Duration(seconds: 3)); // délai de 4 secondes
    await _audioPlayer.resume();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }
}
