import 'package:dfc_flutter/dfc_flutter_web_lite.dart';
import 'package:dfc_store/src/widgets/store_admin/misc/store_prefs.dart';
import 'package:flutter/material.dart';

enum WebStoreDomain {
  cocoatechIo,
  cocoatechCom,
  deckr;

  String get restUrl {
    switch (this) {
      case WebStoreDomain.cocoatechCom:
        return 'https://cocoatech.com/wp-json/api/rest';
      case WebStoreDomain.cocoatechIo:
        return 'https://cocoatech.io/wp-json/api/rest';
      case WebStoreDomain.deckr:
        return 'https://deckr.surf/wp-json/api/rest';
    }
  }

  String get domain {
    switch (this) {
      case WebStoreDomain.cocoatechCom:
        return 'cocoatech.com';
      case WebStoreDomain.cocoatechIo:
        return 'cocoatech.io';
      case WebStoreDomain.deckr:
        return 'deckr.surf';
    }
  }

  String formKey(String field) {
    return '${field}_$domain';
  }
}

// =============================================================

class WebStoreDomainMenu extends StatefulWidget {
  const WebStoreDomainMenu();

  @override
  State<WebStoreDomainMenu> createState() => WebStoreDomainMenuState();
}

class WebStoreDomainMenuState extends State<WebStoreDomainMenu> {
  List<MenuButtonBarItemData> menuItems() {
    final result = <MenuButtonBarItemData>[];

    for (final domain in WebStoreDomain.values) {
      result.add(
        MenuButtonBarItemData(
          title: domain.name,
          leading: Icon(
            Icons.check,
            color:
                StorePrefs.webStoreDomain == domain ? null : Colors.transparent,
          ),
          action: () {
            StorePrefs.webStoreDomain = domain;

            // refresh menu, could also just do a prefs watch on this
            setState(() {});
          },
        ),
      );
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchorButton(
      title: StorePrefs.webStoreDomain.name.fromCamelCase(),
      menuData: menuItems(),
    );
  }
}
