import 'package:flutter/foundation.dart';

import '../config.dart' as K;
import 'geoposition.dart';

/// A source of a reading or forecast.
@immutable
class Source {
  /// The ID of this source.
  final String id;

  /// The name of this source.
  final String name;

  /// The type of this source.
  final SourceType type;

  /// The location of this source.
  final Geoposition location;

  /// The effective range for this source type.
  double get effectiveRange => _effectiveRange[type]!;

  /// Creates a new source.
  const Source({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
  });

  /// Creates a new meteorological observing station.
  const Source.station({
    required String id,
    required String name,
    required Geoposition location,
  }) : this(
          id: id,
          name: name,
          type: SourceType.station,
          location: location,
        );

  /// Creates a new source that spans an area.
  const Source.area({
    required String id,
    required String name,
    required Geoposition location,
  }) : this(
          id: id,
          name: name,
          type: SourceType.area,
          location: location,
        );

  /// Creates a new source that spans a region.
  const Source.region({
    required String id,
    required String name,
    required Geoposition location,
  }) : this(
          id: id,
          name: name,
          type: SourceType.region,
          location: location,
        );

  /// The effective range for each [SourceType] in km.
  static const Map<SourceType, double> _effectiveRange = {
    SourceType.station: K.stationEffectiveRange,
    SourceType.area: K.areaEffectiveRange,
    SourceType.region: K.regionEffectiveRange,
  };
}

/// The types of source.
enum SourceType {
  station,
  area,
  region,
}

/// The set of reference region sources.
///
/// Mainly used by the 24-hour forecast, which has region names but no
/// associated coordinates.
///
/// Reference positions are based on metadata from PM2.5 call.
abstract class Sources {
  // Prevent instantiation and extension.
  Sources._();

  /// The reference central region.
  static const Source central = Source.region(
    id: 'central',
    name: 'central',
    location: const Geoposition(
      latitude: 1.35735,
      longitude: 103.82,
    ),
  );

  /// The reference north region.
  static const Source north = Source.region(
    id: 'north',
    name: 'north',
    location: const Geoposition(
      latitude: 1.41803,
      longitude: 103.82,
    ),
  );

  /// The reference east region.
  static const Source east = Source.region(
    id: 'east',
    name: 'east',
    location: const Geoposition(
      latitude: 1.35735,
      longitude: 103.94,
    ),
  );

  /// The reference south region.
  static const Source south = Source.region(
    id: 'south',
    name: 'south',
    location: const Geoposition(
      latitude: 1.29587,
      longitude: 103.82,
    ),
  );

  /// The reference west region.
  static const Source west = Source.region(
    id: 'west',
    name: 'west',
    location: const Geoposition(
      latitude: 1.35735,
      longitude: 103.7,
    ),
  );
}
