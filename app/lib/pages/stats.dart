import 'package:bouggr/components/stats_page/post_game_detail_popup.dart';
import 'package:bouggr/components/stats_page/stat.dart';
import 'package:bouggr/providers/firebase.dart';
import 'package:bouggr/providers/stat_provider.dart';
import 'package:flutter/material.dart';
import 'package:bouggr/components/bottom_buttons.dart';

import 'package:provider/provider.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  late List<String> allResults;

  @override
  void initState() {
    super.initState();
    Provider.of<StatProvider>(context, listen: false).loadStatsPageCount(
        Provider.of<FirebaseProvider>(context, listen: false));
    Provider.of<StatProvider>(context, listen: false)
        .loadInitPage(Provider.of<FirebaseProvider>(context, listen: false));
  }

  @override
  Widget build(BuildContext context) {
    var list = Provider.of<StatProvider>(context, listen: true)
        .getPageStats(Provider.of<FirebaseProvider>(context, listen: false))
        .map(
          (data) => Stat(
            key: UniqueKey(),
            grid: data['grid'],
            statName: 'mot',
            statValue: data['score'].toString(),
          ),
        )
        .toList();
    return Stack(
      children: [
        BottomButtons(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const StatTitle(),
              Container(
                  height: (MediaQuery.of(context).size.height -
                          MediaQuery.of(context).size.width * 0.15) *
                      0.7,
                  width: MediaQuery.of(context).size.width * 0.96,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        list.isEmpty
                            ? const CircularProgressIndicator()
                            : Expanded(
                                child: ListView(children: list),
                              ),
                      ])),
              const StatFooter()
            ],
          ),
        ),
        const PostGameDetailPopUp()
      ],
    );
  }
}

class StatFooter extends StatelessWidget {
  const StatFooter({super.key});

  @override
  Widget build(BuildContext context) {
    var statProvider = Provider.of<StatProvider>(context, listen: true);

    return SizedBox(
      height: (MediaQuery.of(context).size.height -
              MediaQuery.of(context).size.width * 0.15) *
          0.10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              statProvider.previousPage(
                  Provider.of<FirebaseProvider>(context, listen: false));
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                Colors.white,
              ),
              foregroundColor: MaterialStateProperty.all<Color>(
                const Color(0xFF1F87B3),
              ),
            ),
            child: const Text("<"),
          ),
          ElevatedButton(
              onPressed: () {
                statProvider.setPage(
                    0, Provider.of<FirebaseProvider>(context, listen: false));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                foregroundColor: MaterialStateProperty.all<Color>(
                  const Color(0xFF1F87B3),
                ),
              ),
              child: Text(statProvider.currentPage == 0 ? "..." : "1")),
          ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xFF1F87B3)),
                foregroundColor: MaterialStateProperty.all<Color>(
                  Colors.white,
                ),
              ),
              child: Text(
                (statProvider.currentPage + 1).toString(),
              )),
          ElevatedButton(
              onPressed: () {
                statProvider.setPage(statProvider.pageCount - 1,
                    Provider.of<FirebaseProvider>(context, listen: false));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                foregroundColor: MaterialStateProperty.all<Color>(
                  const Color(0xFF1F87B3),
                ),
              ),
              child: Text(statProvider.currentPage == statProvider.pageCount - 1
                  ? "..."
                  : statProvider.pageCount.toString())),
          ElevatedButton(
            onPressed: () {
              statProvider.nextPage(
                  Provider.of<FirebaseProvider>(context, listen: false));
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                Colors.white,
              ),
              foregroundColor: MaterialStateProperty.all<Color>(
                const Color(0xFF1F87B3),
              ),
            ),
            child: const Text(">"),
          ),
        ],
      ),
    );
  }
}

class StatTitle extends StatelessWidget {
  const StatTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: (MediaQuery.of(context).size.height -
                MediaQuery.of(context).size.width * 0.15) *
            0.1,
        child: const Center(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'St',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 64,
                    fontFamily: 'Jua',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
                TextSpan(
                  text: 'a',
                  style: TextStyle(
                    color: Color(0xFF1F87B3),
                    fontSize: 64,
                    fontFamily: 'Jua',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
                TextSpan(
                  text: 'ts',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 64,
                    fontFamily: 'Jua',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
