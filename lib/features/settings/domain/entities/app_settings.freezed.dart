// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppSettings {

 String get themeMode; double get defaultPlaybackSpeed; bool get resumeFromLastPosition; bool get useGestureControls; bool get showSubtitlesByDefault; bool get keepScreenOn; List<String> get scanRootPaths; String get defaultSortOrder; String get libraryViewMode;
/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSettingsCopyWith<AppSettings> get copyWith => _$AppSettingsCopyWithImpl<AppSettings>(this as AppSettings, _$identity);

  /// Serializes this AppSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSettings&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.defaultPlaybackSpeed, defaultPlaybackSpeed) || other.defaultPlaybackSpeed == defaultPlaybackSpeed)&&(identical(other.resumeFromLastPosition, resumeFromLastPosition) || other.resumeFromLastPosition == resumeFromLastPosition)&&(identical(other.useGestureControls, useGestureControls) || other.useGestureControls == useGestureControls)&&(identical(other.showSubtitlesByDefault, showSubtitlesByDefault) || other.showSubtitlesByDefault == showSubtitlesByDefault)&&(identical(other.keepScreenOn, keepScreenOn) || other.keepScreenOn == keepScreenOn)&&const DeepCollectionEquality().equals(other.scanRootPaths, scanRootPaths)&&(identical(other.defaultSortOrder, defaultSortOrder) || other.defaultSortOrder == defaultSortOrder)&&(identical(other.libraryViewMode, libraryViewMode) || other.libraryViewMode == libraryViewMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,themeMode,defaultPlaybackSpeed,resumeFromLastPosition,useGestureControls,showSubtitlesByDefault,keepScreenOn,const DeepCollectionEquality().hash(scanRootPaths),defaultSortOrder,libraryViewMode);

@override
String toString() {
  return 'AppSettings(themeMode: $themeMode, defaultPlaybackSpeed: $defaultPlaybackSpeed, resumeFromLastPosition: $resumeFromLastPosition, useGestureControls: $useGestureControls, showSubtitlesByDefault: $showSubtitlesByDefault, keepScreenOn: $keepScreenOn, scanRootPaths: $scanRootPaths, defaultSortOrder: $defaultSortOrder, libraryViewMode: $libraryViewMode)';
}


}

/// @nodoc
abstract mixin class $AppSettingsCopyWith<$Res>  {
  factory $AppSettingsCopyWith(AppSettings value, $Res Function(AppSettings) _then) = _$AppSettingsCopyWithImpl;
@useResult
$Res call({
 String themeMode, double defaultPlaybackSpeed, bool resumeFromLastPosition, bool useGestureControls, bool showSubtitlesByDefault, bool keepScreenOn, List<String> scanRootPaths, String defaultSortOrder, String libraryViewMode
});




}
/// @nodoc
class _$AppSettingsCopyWithImpl<$Res>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._self, this._then);

  final AppSettings _self;
  final $Res Function(AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? themeMode = null,Object? defaultPlaybackSpeed = null,Object? resumeFromLastPosition = null,Object? useGestureControls = null,Object? showSubtitlesByDefault = null,Object? keepScreenOn = null,Object? scanRootPaths = null,Object? defaultSortOrder = null,Object? libraryViewMode = null,}) {
  return _then(_self.copyWith(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as String,defaultPlaybackSpeed: null == defaultPlaybackSpeed ? _self.defaultPlaybackSpeed : defaultPlaybackSpeed // ignore: cast_nullable_to_non_nullable
as double,resumeFromLastPosition: null == resumeFromLastPosition ? _self.resumeFromLastPosition : resumeFromLastPosition // ignore: cast_nullable_to_non_nullable
as bool,useGestureControls: null == useGestureControls ? _self.useGestureControls : useGestureControls // ignore: cast_nullable_to_non_nullable
as bool,showSubtitlesByDefault: null == showSubtitlesByDefault ? _self.showSubtitlesByDefault : showSubtitlesByDefault // ignore: cast_nullable_to_non_nullable
as bool,keepScreenOn: null == keepScreenOn ? _self.keepScreenOn : keepScreenOn // ignore: cast_nullable_to_non_nullable
as bool,scanRootPaths: null == scanRootPaths ? _self.scanRootPaths : scanRootPaths // ignore: cast_nullable_to_non_nullable
as List<String>,defaultSortOrder: null == defaultSortOrder ? _self.defaultSortOrder : defaultSortOrder // ignore: cast_nullable_to_non_nullable
as String,libraryViewMode: null == libraryViewMode ? _self.libraryViewMode : libraryViewMode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppSettings].
extension AppSettingsPatterns on AppSettings {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSettings value)  $default,){
final _that = this;
switch (_that) {
case _AppSettings():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String themeMode,  double defaultPlaybackSpeed,  bool resumeFromLastPosition,  bool useGestureControls,  bool showSubtitlesByDefault,  bool keepScreenOn,  List<String> scanRootPaths,  String defaultSortOrder,  String libraryViewMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.themeMode,_that.defaultPlaybackSpeed,_that.resumeFromLastPosition,_that.useGestureControls,_that.showSubtitlesByDefault,_that.keepScreenOn,_that.scanRootPaths,_that.defaultSortOrder,_that.libraryViewMode);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String themeMode,  double defaultPlaybackSpeed,  bool resumeFromLastPosition,  bool useGestureControls,  bool showSubtitlesByDefault,  bool keepScreenOn,  List<String> scanRootPaths,  String defaultSortOrder,  String libraryViewMode)  $default,) {final _that = this;
switch (_that) {
case _AppSettings():
return $default(_that.themeMode,_that.defaultPlaybackSpeed,_that.resumeFromLastPosition,_that.useGestureControls,_that.showSubtitlesByDefault,_that.keepScreenOn,_that.scanRootPaths,_that.defaultSortOrder,_that.libraryViewMode);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String themeMode,  double defaultPlaybackSpeed,  bool resumeFromLastPosition,  bool useGestureControls,  bool showSubtitlesByDefault,  bool keepScreenOn,  List<String> scanRootPaths,  String defaultSortOrder,  String libraryViewMode)?  $default,) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.themeMode,_that.defaultPlaybackSpeed,_that.resumeFromLastPosition,_that.useGestureControls,_that.showSubtitlesByDefault,_that.keepScreenOn,_that.scanRootPaths,_that.defaultSortOrder,_that.libraryViewMode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppSettings implements AppSettings {
  const _AppSettings({this.themeMode = 'light', this.defaultPlaybackSpeed = 1.0, this.resumeFromLastPosition = true, this.useGestureControls = true, this.showSubtitlesByDefault = true, this.keepScreenOn = false, final  List<String> scanRootPaths = const [], this.defaultSortOrder = 'name', this.libraryViewMode = 'grid'}): _scanRootPaths = scanRootPaths;
  factory _AppSettings.fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);

@override@JsonKey() final  String themeMode;
@override@JsonKey() final  double defaultPlaybackSpeed;
@override@JsonKey() final  bool resumeFromLastPosition;
@override@JsonKey() final  bool useGestureControls;
@override@JsonKey() final  bool showSubtitlesByDefault;
@override@JsonKey() final  bool keepScreenOn;
 final  List<String> _scanRootPaths;
@override@JsonKey() List<String> get scanRootPaths {
  if (_scanRootPaths is EqualUnmodifiableListView) return _scanRootPaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_scanRootPaths);
}

@override@JsonKey() final  String defaultSortOrder;
@override@JsonKey() final  String libraryViewMode;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSettingsCopyWith<_AppSettings> get copyWith => __$AppSettingsCopyWithImpl<_AppSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSettings&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.defaultPlaybackSpeed, defaultPlaybackSpeed) || other.defaultPlaybackSpeed == defaultPlaybackSpeed)&&(identical(other.resumeFromLastPosition, resumeFromLastPosition) || other.resumeFromLastPosition == resumeFromLastPosition)&&(identical(other.useGestureControls, useGestureControls) || other.useGestureControls == useGestureControls)&&(identical(other.showSubtitlesByDefault, showSubtitlesByDefault) || other.showSubtitlesByDefault == showSubtitlesByDefault)&&(identical(other.keepScreenOn, keepScreenOn) || other.keepScreenOn == keepScreenOn)&&const DeepCollectionEquality().equals(other._scanRootPaths, _scanRootPaths)&&(identical(other.defaultSortOrder, defaultSortOrder) || other.defaultSortOrder == defaultSortOrder)&&(identical(other.libraryViewMode, libraryViewMode) || other.libraryViewMode == libraryViewMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,themeMode,defaultPlaybackSpeed,resumeFromLastPosition,useGestureControls,showSubtitlesByDefault,keepScreenOn,const DeepCollectionEquality().hash(_scanRootPaths),defaultSortOrder,libraryViewMode);

@override
String toString() {
  return 'AppSettings(themeMode: $themeMode, defaultPlaybackSpeed: $defaultPlaybackSpeed, resumeFromLastPosition: $resumeFromLastPosition, useGestureControls: $useGestureControls, showSubtitlesByDefault: $showSubtitlesByDefault, keepScreenOn: $keepScreenOn, scanRootPaths: $scanRootPaths, defaultSortOrder: $defaultSortOrder, libraryViewMode: $libraryViewMode)';
}


}

/// @nodoc
abstract mixin class _$AppSettingsCopyWith<$Res> implements $AppSettingsCopyWith<$Res> {
  factory _$AppSettingsCopyWith(_AppSettings value, $Res Function(_AppSettings) _then) = __$AppSettingsCopyWithImpl;
@override @useResult
$Res call({
 String themeMode, double defaultPlaybackSpeed, bool resumeFromLastPosition, bool useGestureControls, bool showSubtitlesByDefault, bool keepScreenOn, List<String> scanRootPaths, String defaultSortOrder, String libraryViewMode
});




}
/// @nodoc
class __$AppSettingsCopyWithImpl<$Res>
    implements _$AppSettingsCopyWith<$Res> {
  __$AppSettingsCopyWithImpl(this._self, this._then);

  final _AppSettings _self;
  final $Res Function(_AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? themeMode = null,Object? defaultPlaybackSpeed = null,Object? resumeFromLastPosition = null,Object? useGestureControls = null,Object? showSubtitlesByDefault = null,Object? keepScreenOn = null,Object? scanRootPaths = null,Object? defaultSortOrder = null,Object? libraryViewMode = null,}) {
  return _then(_AppSettings(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as String,defaultPlaybackSpeed: null == defaultPlaybackSpeed ? _self.defaultPlaybackSpeed : defaultPlaybackSpeed // ignore: cast_nullable_to_non_nullable
as double,resumeFromLastPosition: null == resumeFromLastPosition ? _self.resumeFromLastPosition : resumeFromLastPosition // ignore: cast_nullable_to_non_nullable
as bool,useGestureControls: null == useGestureControls ? _self.useGestureControls : useGestureControls // ignore: cast_nullable_to_non_nullable
as bool,showSubtitlesByDefault: null == showSubtitlesByDefault ? _self.showSubtitlesByDefault : showSubtitlesByDefault // ignore: cast_nullable_to_non_nullable
as bool,keepScreenOn: null == keepScreenOn ? _self.keepScreenOn : keepScreenOn // ignore: cast_nullable_to_non_nullable
as bool,scanRootPaths: null == scanRootPaths ? _self._scanRootPaths : scanRootPaths // ignore: cast_nullable_to_non_nullable
as List<String>,defaultSortOrder: null == defaultSortOrder ? _self.defaultSortOrder : defaultSortOrder // ignore: cast_nullable_to_non_nullable
as String,libraryViewMode: null == libraryViewMode ? _self.libraryViewMode : libraryViewMode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
