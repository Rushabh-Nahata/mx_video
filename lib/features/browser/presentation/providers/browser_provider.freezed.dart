// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'browser_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BrowserState {

 List<String> get pathStack; List<Object> get entries; bool get isLoading; String get searchQuery; List<FileNode> get searchResults; String? get error;
/// Create a copy of BrowserState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BrowserStateCopyWith<BrowserState> get copyWith => _$BrowserStateCopyWithImpl<BrowserState>(this as BrowserState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BrowserState&&const DeepCollectionEquality().equals(other.pathStack, pathStack)&&const DeepCollectionEquality().equals(other.entries, entries)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&const DeepCollectionEquality().equals(other.searchResults, searchResults)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(pathStack),const DeepCollectionEquality().hash(entries),isLoading,searchQuery,const DeepCollectionEquality().hash(searchResults),error);

@override
String toString() {
  return 'BrowserState(pathStack: $pathStack, entries: $entries, isLoading: $isLoading, searchQuery: $searchQuery, searchResults: $searchResults, error: $error)';
}


}

/// @nodoc
abstract mixin class $BrowserStateCopyWith<$Res>  {
  factory $BrowserStateCopyWith(BrowserState value, $Res Function(BrowserState) _then) = _$BrowserStateCopyWithImpl;
@useResult
$Res call({
 List<String> pathStack, List<Object> entries, bool isLoading, String searchQuery, List<FileNode> searchResults, String? error
});




}
/// @nodoc
class _$BrowserStateCopyWithImpl<$Res>
    implements $BrowserStateCopyWith<$Res> {
  _$BrowserStateCopyWithImpl(this._self, this._then);

  final BrowserState _self;
  final $Res Function(BrowserState) _then;

/// Create a copy of BrowserState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pathStack = null,Object? entries = null,Object? isLoading = null,Object? searchQuery = null,Object? searchResults = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
pathStack: null == pathStack ? _self.pathStack : pathStack // ignore: cast_nullable_to_non_nullable
as List<String>,entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<Object>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,searchResults: null == searchResults ? _self.searchResults : searchResults // ignore: cast_nullable_to_non_nullable
as List<FileNode>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BrowserState].
extension BrowserStatePatterns on BrowserState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BrowserState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BrowserState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BrowserState value)  $default,){
final _that = this;
switch (_that) {
case _BrowserState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BrowserState value)?  $default,){
final _that = this;
switch (_that) {
case _BrowserState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> pathStack,  List<Object> entries,  bool isLoading,  String searchQuery,  List<FileNode> searchResults,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BrowserState() when $default != null:
return $default(_that.pathStack,_that.entries,_that.isLoading,_that.searchQuery,_that.searchResults,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> pathStack,  List<Object> entries,  bool isLoading,  String searchQuery,  List<FileNode> searchResults,  String? error)  $default,) {final _that = this;
switch (_that) {
case _BrowserState():
return $default(_that.pathStack,_that.entries,_that.isLoading,_that.searchQuery,_that.searchResults,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> pathStack,  List<Object> entries,  bool isLoading,  String searchQuery,  List<FileNode> searchResults,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _BrowserState() when $default != null:
return $default(_that.pathStack,_that.entries,_that.isLoading,_that.searchQuery,_that.searchResults,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _BrowserState extends BrowserState {
  const _BrowserState({final  List<String> pathStack = const [], final  List<Object> entries = const [], this.isLoading = false, this.searchQuery = '', final  List<FileNode> searchResults = const [], this.error}): _pathStack = pathStack,_entries = entries,_searchResults = searchResults,super._();
  

 final  List<String> _pathStack;
@override@JsonKey() List<String> get pathStack {
  if (_pathStack is EqualUnmodifiableListView) return _pathStack;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pathStack);
}

 final  List<Object> _entries;
@override@JsonKey() List<Object> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  String searchQuery;
 final  List<FileNode> _searchResults;
@override@JsonKey() List<FileNode> get searchResults {
  if (_searchResults is EqualUnmodifiableListView) return _searchResults;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_searchResults);
}

@override final  String? error;

/// Create a copy of BrowserState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BrowserStateCopyWith<_BrowserState> get copyWith => __$BrowserStateCopyWithImpl<_BrowserState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BrowserState&&const DeepCollectionEquality().equals(other._pathStack, _pathStack)&&const DeepCollectionEquality().equals(other._entries, _entries)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&const DeepCollectionEquality().equals(other._searchResults, _searchResults)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_pathStack),const DeepCollectionEquality().hash(_entries),isLoading,searchQuery,const DeepCollectionEquality().hash(_searchResults),error);

@override
String toString() {
  return 'BrowserState(pathStack: $pathStack, entries: $entries, isLoading: $isLoading, searchQuery: $searchQuery, searchResults: $searchResults, error: $error)';
}


}

/// @nodoc
abstract mixin class _$BrowserStateCopyWith<$Res> implements $BrowserStateCopyWith<$Res> {
  factory _$BrowserStateCopyWith(_BrowserState value, $Res Function(_BrowserState) _then) = __$BrowserStateCopyWithImpl;
@override @useResult
$Res call({
 List<String> pathStack, List<Object> entries, bool isLoading, String searchQuery, List<FileNode> searchResults, String? error
});




}
/// @nodoc
class __$BrowserStateCopyWithImpl<$Res>
    implements _$BrowserStateCopyWith<$Res> {
  __$BrowserStateCopyWithImpl(this._self, this._then);

  final _BrowserState _self;
  final $Res Function(_BrowserState) _then;

/// Create a copy of BrowserState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pathStack = null,Object? entries = null,Object? isLoading = null,Object? searchQuery = null,Object? searchResults = null,Object? error = freezed,}) {
  return _then(_BrowserState(
pathStack: null == pathStack ? _self._pathStack : pathStack // ignore: cast_nullable_to_non_nullable
as List<String>,entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<Object>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,searchResults: null == searchResults ? _self._searchResults : searchResults // ignore: cast_nullable_to_non_nullable
as List<FileNode>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
