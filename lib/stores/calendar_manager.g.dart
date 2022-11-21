// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_manager.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CalendarManager on _CalendarManager, Store {
  late final _$servicesAtom =
      Atom(name: '_CalendarManager.services', context: context);

  @override
  List<Service> get services {
    _$servicesAtom.reportRead();
    return super.services;
  }

  @override
  set services(List<Service> value) {
    _$servicesAtom.reportWrite(value, super.services, () {
      super.services = value;
    });
  }

  late final _$loadListAsyncAction =
      AsyncAction('_CalendarManager.loadList', context: context);

  @override
  Future<void> loadList() {
    return _$loadListAsyncAction.run(() => super.loadList());
  }

  late final _$clearAsyncAction =
      AsyncAction('_CalendarManager.clear', context: context);

  @override
  Future<void> clear() {
    return _$clearAsyncAction.run(() => super.clear());
  }

  late final _$clearDatabaseAsyncAction =
      AsyncAction('_CalendarManager.clearDatabase', context: context);

  @override
  Future<void> clearDatabase() {
    return _$clearDatabaseAsyncAction.run(() => super.clearDatabase());
  }

  @override
  String toString() {
    return '''
services: ${services}
    ''';
  }
}
