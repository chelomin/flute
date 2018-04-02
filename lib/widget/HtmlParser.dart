import 'package:flutter/material.dart';

class HtmlParser {
  HtmlParser({this.html});

  final String html;

  List<TextSpan> toTextSpans() {
    List<TextSpan> spans = List();
    int index = 0;
    while (index < html.length) {
      Token token = getToken(index);
      index += token.length;
    }
  }

  Token getToken(int index) {
    if (html[index] != '<') {
      return StringToken(html: html.substring(index));
    }
  }
}

enum TokenType { TEXT, BOLD_START, BOLD_END, ITALIC_START, ITALIC_END, P }

class Token {
  final TokenType type;
  int length = 0;

  Token({this.type});
}

class StringToken extends Token {
  final String html;
  final int startIndex;
  String text;

  StringToken({this.startIndex, this.html}) : super(type: TokenType.TEXT) {
    html.indexOf("<");
  };
}
