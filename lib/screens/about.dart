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
              data: '''
> ## How to use
>
> - Drag downwards to refresh data.
>
> - Drag upwards from bottom third of the screen to reveal weather details.

## Acknowledgement

[Data.gov.sg](https://data.gov.sg/) datasets licensed under [Singapore Open Data License](https://data.gov.sg/open-data-licence). Access via API is subject to [API Terms of Service](https://data.gov.sg/privacy-and-website-terms#api-terms).

[Weather Icons](https://erikflowers.github.io/weather-icons/) licensed under [SIL OFL 1.1](http://scripts.sil.org/OFL).

[Unsplash](https://unsplash.com) photos licensed under [Unsplash License](https://unsplash.com/license) from contributors: [Christina Victoria Craft](https://unsplash.com/s/photos/wind?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText), [David Moum](https://unsplash.com/@davidmoum?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText), [Eric Muhr](https://unsplash.com/@ericmuhr?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText), [Fabio Neo Amato](https://unsplash.com/@cloudsdealer?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText), [Guillaume M.](https://unsplash.com/@guimgn?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText), [Jason Briscoe](https://unsplash.com/@jsnbrsc?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText), [Peyman Farmani](https://unsplash.com/@peymanfarmani?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText).

Developed using [Flutter](https://flutter.dev) using third-party libraries: [build_runner](https://pub.dev/packages/build_runner), [expandable_bottom_sheet](https://pub.dev/packages/expandable_bottom_sheet), [flutter_markdown](https://pub.dev/packages/flutter_markdown), [http](https://pub.dev/packages/http), [intl](https://pub.dev/packages/intl), [json_annotation](https://pub.dev/packages/json_annotation), [json_serializatble](https://pub.dev/packages/json_serializable), [location](https://pub.dev/packages/location), [package_info](https://pub.dev/packages/package_info), [provider](https://pub.dev/packages/provider), [url_launcher](https://pub.dev/packages/url_launcher), [weather_icons](https://pub.dev/packages/weather_icons).

## Privacy policy

This app itself *does not* collect any private data.

The app uses [Data.gov.sg](https://data.gov.sg/) (see relevant [Privacy Statement](https://data.gov.sg/privacy-and-website-terms#privacy)).

## License

Source code is available on [GitHub](https://github.com/hum-ler/singapore_weather) under [The MIT License](https://opensource.org/licenses/MIT).
''',
              onTapLink: (_, url, __) async {
                if (url != null && await canLaunch(url)) launch(url);
              },
              styleSheet: MarkdownStyleSheet(
                blockquoteDecoration: BoxDecoration(
                  color: Colors.deepOrange.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                blockquotePadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
