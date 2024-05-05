import 'package:flutter/material.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:bouggr/components/btn.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class BottomButtons extends StatelessWidget {
  final Widget child;

  const BottomButtons({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final router = Provider.of<NavigationServices>(context, listen: false);
    final index = router.index;
    return Container(
      color: const Color.fromARGB(255, 169, 224, 255),
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.width * 0.02,
              right: MediaQuery.of(context).size.width * 0.02,
              child: IconBtnBoggle(
                key: const Key('settingsButton'),
                icon: const Icon(Icons.settings),
                onPressed: () {
                  router.goToPage(PageName.settings);
                },
                btnType: BtnType.secondary,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: child),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconBtnBoggleRouter(
                        icon: const Icon(Icons.home),
                        onPressed: () {
                          router.goToPage(PageName.home);
                        },
                        btnType: index == PageName.home
                            ? BtnType.primary
                            : BtnType.secondary,
                      ),
                      IconBtnBoggleRouter(
                        icon: const Icon(Icons.extension),
                        onPressed: () {},
                        btnType: BtnType.secondary,
                      ),
                      IconBtnBoggleRouter(
                        icon: const Icon(Icons.insights),
                        onPressed: () {
                          router.goToPage(PageName.stats);
                        },
                        btnType: index == PageName.stats
                            ? BtnType.primary
                            : BtnType.secondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


/**
 * 
 */