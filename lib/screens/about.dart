import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../generated/l10n.dart';
import 'about/header.dart';

/// The about screen.
class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).aboutScreenTitle),
        elevation: 0.0,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 80.0,
            width: double.infinity,
            child: Header(),
          ),
          Expanded(
            child: Markdown(
              data: S.of(context).aboutReadmeText,
              onTapLink: (_, url, __) async {
                if (url != null && await canLaunch(url)) launch(url);
              },
              styleSheet: MarkdownStyleSheet(
                blockquoteDecoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                blockquotePadding:
                    const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 12.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
