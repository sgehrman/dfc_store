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
