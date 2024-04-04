import 'package:audioplayers/audioplayers.dart';

class BackgroundMusicPlayer {
  static final BackgroundMusicPlayer _instance = BackgroundMusicPlayer._internal();

  static BackgroundMusicPlayer get instance => _instance;

  static const String path_ost = 'audio/OST.mp3';
  final AudioPlayer _audioPlayer = AudioPlayer();

  BackgroundMusicPlayer._internal();

  Future<void> playOST() async {
    await Future.delayed(const Duration(seconds: 3)); // délai de 3 secondes
    await _audioPlayer.play(AssetSource(path_ost));
  }

  Future<void> pause() async {
    print("je pause");
    _audioPlayer.pause();
  }

  Future<void> stop() async {
    print("je stop");
    await _audioPlayer.stop();
  }

  Future<void> resume() async {
    print("je reprends");
    _audioPlayer.resume();
  }
}