import 'package:flutter/material.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:bouggr/components/btn.dart';
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
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: child
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconBtnBoggle(
                      icon: const Icon(Icons.home),
                      onPressed: () {
                        router.goToPage(PageName.home);
                      },
                      btnType: index == PageName.home ? BtnType.primary : BtnType.secondary,
                    ),
                    IconBtnBoggle(
                      icon: const Icon(Icons.extension),
                      onPressed: () {},
                      btnType: BtnType.secondary,
                    ),
                    IconBtnBoggle(
                      icon: const Icon(Icons.insights),
                      onPressed: () {
                        router.goToPage(PageName.stats);
                      },
                      btnType: index == PageName.stats ? BtnType.primary : BtnType.secondary,
                    ),
                    IconBtnBoggle(
                      icon: const Icon(Icons.settings),
                      onPressed: () {
                        router.goToPage(PageName.settings);
                      },
                      btnType: index == PageName.settings ? BtnType.primary : BtnType.secondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}
