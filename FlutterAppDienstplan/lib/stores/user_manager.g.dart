// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_manager.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserManager on _UserManager, Store {
  Computed<int>? _$userIdComputed;

  @override
  int get userId => (_$userIdComputed ??=
          Computed<int>(() => super.userId, name: '_UserManager.userId'))
      .value;

  late final _$usersAtom = Atom(name: '_UserManager.users', context: context);

  @override
  List<User> get users {
    _$usersAtom.reportRead();
    return super.users;
  }

  @override
  set users(List<User> value) {
    _$usersAtom.reportWrite(value, super.users, () {
      super.users = value;
    });
  }

  late final _$activeUserAtom =
      Atom(name: '_UserManager.activeUser', context: context);

  @override
  User? get activeUser {
    _$activeUserAtom.reportRead();
    return super.activeUser;
  }

  @override
  set activeUser(User? value) {
    _$activeUserAtom.reportWrite(value, super.activeUser, () {
      super.activeUser = value;
    });
  }

  late final _$loadUsersAsyncAction =
      AsyncAction('_UserManager.loadUsers', context: context);

  @override
  Future<void> loadUsers() {
    return _$loadUsersAsyncAction.run(() => super.loadUsers());
  }

  late final _$switchArchiveModeAsyncAction =
      AsyncAction('_UserManager.switchArchiveMode', context: context);

  @override
  Future<void> switchArchiveMode() {
    return _$switchArchiveModeAsyncAction.run(() => super.switchArchiveMode());
  }

  late final _$setNotificationIdAsyncAction =
      AsyncAction('_UserManager.setNotificationId', context: context);

  @override
  Future<void> setNotificationId(String id) {
    return _$setNotificationIdAsyncAction
        .run(() => super.setNotificationId(id));
  }

  late final _$addUserAsyncAction =
      AsyncAction('_UserManager.addUser', context: context);

  @override
  Future<User> addUser(User user) {
    return _$addUserAsyncAction.run(() => super.addUser(user));
  }

  late final _$removeUserAsyncAction =
      AsyncAction('_UserManager.removeUser', context: context);

  @override
  Future<void> removeUser() {
    return _$removeUserAsyncAction.run(() => super.removeUser());
  }

  late final _$_UserManagerActionController =
      ActionController(name: '_UserManager', context: context);

  @override
  void switchUser(User newUser) {
    final _$actionInfo = _$_UserManagerActionController.startAction(
        name: '_UserManager.switchUser');
    try {
      return super.switchUser(newUser);
    } finally {
      _$_UserManagerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setActiveUser(String notificationId) {
    final _$actionInfo = _$_UserManagerActionController.startAction(
        name: '_UserManager.setActiveUser');
    try {
      return super.setActiveUser(notificationId);
    } finally {
      _$_UserManagerActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
users: ${users},
activeUser: ${activeUser},
userId: ${userId}
    ''';
  }
}
