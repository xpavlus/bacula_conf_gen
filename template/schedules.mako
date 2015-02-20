Schedule {
  Name = "WeeklyCycle"
  Run = Full 1st sun at 23:05
  Run = Differential 2nd-5th sun at 23:05
  Run = Incremental mon-sat at 23:05
}

Schedule {
  Name = "WeeklyCycle-2"
  Run = Full 1st sun at 02:05
  Run = Differential 2nd-5th sun at 02:05
  Run = Incremental mon-sat at 02:05
}

Schedule {
  Name = "WeeklyCycle-4"
  Run = Full 1st sun at 04:05
  Run = Differential 2nd-5th sun at 04:05
  Run = Incremental mon-sat at 04:05
}

Schedule {
  Name = "WeeklyCycleAfterBackup"
  Run = Full sun-sat at 23:10
}

Schedule {
  Name = common-vz-backup
  Run = Level=Full Pool=common-pool_hummer sun at 00:35
  Run = Level=Incremental Pool=common-pool_hummer mon-sat at 00:35
}

