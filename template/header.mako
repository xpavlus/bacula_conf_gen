Director { 
  Name = bacula-dir
  DIRport = 9101
  QueryFile = "/etc/bacula/scripts/query.sql"
  WorkingDirectory = "/var/lib/bacula"
  PidDirectory = "/var/run/bacula"
  Maximum Concurrent Jobs = 1
  Password = "Z_aovT0WThgQmuiT-O90qwNchB2hwkdS8"
  Messages = Daemon
  DirAddress = 0.0.0.0
}

JobDefs {
  Name = "DefaultJob"
  Type = Backup
  Level = Incremental
  Client = bacula-fd
  FileSet = "Full Set"
  Schedule = "WeeklyCycle"
  Storage = File
  Messages = Standard
  Pool = File
  Priority = 10
  Write Bootstrap = "/var/lib/bacula/%c.bsr"
}

Job {
  Name = "BackupClient1"
  JobDefs = "DefaultJob"
}

Job {
  Name = "BackupCatalog"
  JobDefs = "DefaultJob"
  Level = Full
  FileSet="Catalog"
  Schedule = "WeeklyCycleAfterBackup"
  RunBeforeJob = "/etc/bacula/scripts/make_catalog_backup.pl MyCatalog"
  RunAfterJob  = "/etc/bacula/scripts/delete_catalog_backup"
  Write Bootstrap = "/var/lib/bacula/%n.bsr"
  Priority = 11                   # run after main backup
}

Job {
  Name = RestoreFiles
  Type = Restore
  Client = bacula-fd
  FileSet = "Full Set"
  Storage = File
  Pool = File
  Messages = Standard
  Where = /nonexistant/path/to/file/archive/dir/bacula-restores
}

FileSet {
  Name = "Full Set"
  Include {
    Options {
      signature = MD5
    }
    File = /usr/sbin
  }
  Exclude {
    File = /var/lib/bacula
    File = /nonexistant/path/to/file/archive/dir
    File = /proc
    File = /tmp
    File = /.journal
    File = /.fsck
  }
}

FileSet {
  Name = "Catalog"
  Include {
    Options {
      signature = MD5
    }
    File = "/var/lib/bacula/bacula.sql"
  }
}

Catalog {
  Name = MyCatalog
  dbname = "bacula"; DB Address = ""; dbuser = "bacula"; dbpassword = "ofGFICzKiP4d"
}

Messages {
  Name = Standard
  mailcommand = "/usr/sbin/bsmtp -8 -h smtp.mariinsky.ru:25 -f bacula@mariinsky.ru -s \"Bacula: %t %e of %c %l\" %r"
  operatorcommand = "/usr/sbin/bsmtp -8 -h smtp.mariinsky.ru:25  -f \"\(Bacula\) \<bacula@mariinsky.ru\>\" -s \"Bacula: Intervention needed for %j\" %r"
#  mail = pavel@mariinsky.ru = all, !skipped            
  mail = pavel@mariinsky.ru = error, fatal
#  mail = backup@mariinsky.ru = error, fatal
#  operator = backup@mariinsky.ru = mount
  operator = pavel@mariinsky.ru = mount
  console = all, !skipped, !saved
  append = "/var/log/bacula/bacula.log" = all, !skipped
  catalog = all
}


Messages {
  Name = Daemon
  mailcommand = "/usr/sbin/bsmtp -h localhost -f \"\(Bacula\) ${"\<%r\>\\"} -s \"Bacula daemon message\" %r"
  mail = root = all, !skipped            
  console = all, !skipped, !saved
  append = "/var/log/bacula/bacula.log" = all, !skipped
}

Console {
  Name = bacula-mon
  Password = "NwpeeWLb9LtxRFq1Ow8lW9e2VTEL9TYla"
  CommandACL = status, .status
}