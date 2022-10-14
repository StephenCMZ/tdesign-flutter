
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:tdesign_flutter/td_export.dart';

class ApiWidget extends StatefulWidget {
  const ApiWidget({Key? key, required this.apiName, this.visible = false}) : super(key: key);

  final bool visible;

  final String apiName;

  @override
  State<ApiWidget> createState() => _ApiWidgetState();
}

class _ApiWidgetState extends State<ApiWidget> {

  String? result;

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: widget.visible,
        child: FutureBuilder(
      future: getApiData(),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Markdown(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            selectable: true,
            data: snapshot.data ?? '',
            extensionSet: md.ExtensionSet(
              md.ExtensionSet.gitHubWeb.blockSyntaxes,
              [md.EmojiSyntax(), ...md.ExtensionSet.gitHubWeb.inlineSyntaxes],
            ),
          );
        } else {
          return  Container(
            alignment: Alignment.centerLeft,
            child: const TDText('加载中…'),
          );
        }
      },
    ));
  }

  Future<String> getApiData() async {
    const defaultResult = '加载失败';
    if(result != null && result != defaultResult){
      return result!;
    }
    try {
      result =  await rootBundle.loadString('assets/api/${widget.apiName}_api.md');
    } catch (e) {
      print('getApiData error: $e');
    }
    return result ?? defaultResult;
  }
}