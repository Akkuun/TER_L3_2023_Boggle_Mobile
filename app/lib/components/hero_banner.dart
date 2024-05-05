import 'package:bouggr/components/global/card.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HeroBanner extends StatelessWidget {
  const HeroBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final NavigationServices router =
        Provider.of<NavigationServices>(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BoggleCard(
          onPressed: () {
            router.goToPage(PageName.rules);
          },
          title: "Rules",
          action: 'read',
          child: const Text(
            'Find words\n&\nearn points',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontFamily: 'Jua',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
        ),
        BoggleCard(
          title: "SoonTm",
          action: 'play',
          onPressed: () {
            router.goToPage(PageName.rules);
          },
        )
      ],
    );
  }
}
