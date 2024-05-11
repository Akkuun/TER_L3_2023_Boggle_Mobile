import 'package:audioplayers/audioplayers.dart';

class BackgroundMusicPlayer {
  //passage en singleton pour avoir une seule instance du lecteur sinon, création de plusieurs intance
  //ce qui bloque le controle
  static final BackgroundMusicPlayer _instance =
      BackgroundMusicPlayer._internal();

  static BackgroundMusicPlayer get instance => _instance;

  static const String pathOst = 'audio/OST.mp3'; //path de l'asset audio
  final AudioPlayer _audioPlayer = AudioPlayer(); //player audio

  BackgroundMusicPlayer._internal();

  Future<void> playOST() async {
    await Future.delayed(const Duration(seconds: 3)); // délai de 3 secondes
    await _audioPlayer.play(AssetSource(pathOst));
  }

  Future<void> pause() async {
    _audioPlayer.pause();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  Future<void> resume() async {
    _audioPlayer.resume();
  }
}
