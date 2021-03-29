import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/forecast.dart';
import '../../models/weather_model.dart';
import '../../services/geolocation.dart';
import '../../services/weather.dart';
import '../../utils/string_ext.dart';
import 'forecast_tile.dart';
import 'wrapped_icon.dart';

/// Draws the background and key information on the main screen.
class Summary extends StatefulWidget {
  const Summary({
    Key? key,
  }) : super(key: key);

  @override
  _SummaryState createState() => _SummaryState();
}

class _SummaryState extends State<Summary> with WidgetsBindingObserver {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!
      ..addObserver(this)
      ..addPostFrameCallback((_) => _refreshIndicatorKey.currentState!.show());
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // FIXME: If we need to request for location service or permission. the
    // resultant OS dialogs will change the state to AppLifecycleState.inactive
    // and then to AppLifecycleState.resumed.
    //
    // If the user agrees to turn on location and grant permission, we end up
    // refreshing data again because of the additional resumed state.
    //
    // If the user refuses, however, we will be stuck in a loop (request to
    // enable location or to grant permission) over and over again, until the
    // user either comply, or close the app.
    if (state == AppLifecycleState.resumed) {
      _refreshIndicatorKey.currentState!.show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () => _onRefresh(context),
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              minWidth: constraints.maxWidth,
            ),
            child: Consumer<WeatherModel>(
              builder: (context, data, child) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: data.condition?.background ??
                        AssetImage('assets/images/default.webp'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.4),
                      BlendMode.srcATop,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (data.temperature != null)
                          Text(
                            '${data.temperature!.value.round()}°',
                            style: TextStyle(
                              fontSize: 96.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (data.condition != null)
                          WrappedIcon(
                            data.condition!.icon,
                            size: 96.0,
                          ),
                      ],
                    ),
                    if (data.forecast != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          for (final Forecast forecast in data.forecast!)
                            ForecastTile(
                              forecast.icon,
                              forecast.type
                                  .toString()
                                  .asEnumLabel()
                                  .capitalize(),
                              iconSize: 48.0,
                              labelStyle: TextStyle(fontSize: 14.0),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Handles a drag-to-refresh in the RefreshIndicator.
  ///
  /// To activate the RefreshIndicator programmatically, use
  /// _refreshIndicatorKey.currentState!.show(). Calling this method directly
  /// will not show the progress on the screen.
  Future<void> _onRefresh(BuildContext context) async {
    await Provider.of<Weather>(context, listen: false)
        .refresh()
        .onError<GeolocationException>(
          (e, _) => _printError(
            context,
            'Cannot get user location — ' + e.message,
            retry: () => _refreshIndicatorKey.currentState!.show(),
          ),
        )
        .onError<WeatherException>(
          (e, _) => _printError(
            context,
            'Cannot get weather data — ' + e.message,
            retry: () => _refreshIndicatorKey.currentState!.show(),
          ),
        );
  }

  /// Displays an error message in the snack bar with a retry option.
  void _printError(
    BuildContext context,
    String message, {
    void Function()? retry,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: retry != null
            ? SnackBarAction(
                label: 'RETRY',
                onPressed: retry,
              )
            : null,
      ),
    );
  }
}
