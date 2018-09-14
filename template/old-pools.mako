
# Default pool definition
Pool {
  Name = Default
  Pool Type = Backup
  Recycle = yes                       # Bacula can automatically recycle Volumes
  AutoPrune = yes                     # Prune expired volumes
  Volume Retention = 365 days         # one year
}

# File Pool definition
Pool {
  Name = File
  Pool Type = Backup
  Recycle = yes
  AutoPrune = yes
  Volume Retention = 365 days
  Maximum Volume Bytes = 100G
  Maximum Volumes = 100               # Limit number of Volumes in Pool
  LabelFormat = file
}

Pool {
  Name = common-pool_hummer
  Pool Type = Backup
  Volume Retention = 7 months
  Recycle = yes
  AutoPrune = yes
  LabelFormat = common-hummer-
  Maximum Volume Bytes = 100G
  Maximum Volume Jobs = 200
}

Pool {
  Name = common-pool_bacula
  Pool Type = Backup
  Volume Retention = 7 months
  Recycle = yes
  AutoPrune = yes
  LabelFormat = common-bacula-
  Maximum Volume Bytes = 100G
}
Pool {
  Name = 1year-pool-hummer
  Pool Type = Backup
  Volume Retention = 13 months
  Recycle = yes
  AutoPrune = yes
  LabelFormat = 1year-pool-hummer_
  Maximum Volume Bytes = 100G
}

# Scratch pool definition
Pool {
  Name = Scratch
  Pool Type = Backup
}
