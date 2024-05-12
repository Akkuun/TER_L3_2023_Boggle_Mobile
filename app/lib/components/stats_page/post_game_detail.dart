import 'package:bouggr/providers/game.dart';
import 'package:bouggr/providers/post_game_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@immutable
class PostGameDetail extends StatelessWidget {
  final String grid;

  const PostGameDetail({
    super.key,
    required this.grid,
  });

  @override
  Widget build(BuildContext context) {
    PostGameServices postGameServices =
        Provider.of<PostGameServices>(context, listen: false);
    GameServices gameServices =
        Provider.of<GameServices>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        height: 32,
        child: ElevatedButton(
            onPressed: () {
              postGameServices.setFocusGrid(grid);
              gameServices.letters = grid.split('');
              postGameServices.showPopUp();
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                    (states) => const Color.fromARGB(255, 161, 89, 194))),
            child: const Text('Detail', style: TextStyle(color: Colors.white))),
      ),
    );
  }
}
