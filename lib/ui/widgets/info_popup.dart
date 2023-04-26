import 'package:flutter/material.dart';

mixin ShowInfoPopup {
  void showInfoPopup(String title, String info, BuildContext context) {
    showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        enableDrag: true,
        isDismissible: true,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close_outlined)),
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: FractionallySizedBox(widthFactor: 1, child: SelectableText(info)),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
