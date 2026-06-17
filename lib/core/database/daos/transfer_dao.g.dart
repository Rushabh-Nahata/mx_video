// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_dao.dart';

// ignore_for_file: type=lint
mixin _$TransferDaoMixin on DatabaseAccessor<AppDatabase> {
  $TransferJobsTable get transferJobs => attachedDatabase.transferJobs;
  TransferDaoManager get managers => TransferDaoManager(this);
}

class TransferDaoManager {
  final _$TransferDaoMixin _db;
  TransferDaoManager(this._db);
  $$TransferJobsTableTableManager get transferJobs =>
      $$TransferJobsTableTableManager(_db.attachedDatabase, _db.transferJobs);
}
