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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconBtnBoggle(
                    icon: const Icon(Icons.home),
                    onPressed: () {},
                    btnType: BtnType.primary,
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
                    btnType: BtnType.secondary,
                  ),
                  IconBtnBoggle(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      router.goToPage(PageName.settings);
                    },
                    btnType: BtnType.secondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
  }
}
