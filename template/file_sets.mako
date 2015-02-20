
FileSet {
  Name = etc-root-home
  Include {
    File = /etc
    File = /home
    File = /root
    Options {
    }
  }
}

FileSet {
  Name = etc-root-home-backup
  Include {
    File = /etc
    File = /home
    File = /root
    File = /var/backup
    Options {
    }
  }
  Exclude {
    File = /var/backup/vz-backup
  }
}

FileSet {
  Name = var-vz-backup
  Include {
    File = /var/backup/vz-backup
    Options {
    }
  }
}

FileSet {
  Name = www_compr
  Include {
    File = /var/www
    File = /usr/lib/cgi-bin
    Options {
  Compression = GZIP4
    }
  }
}

FileSet {
  Name = corp-www-compr
  Include {
    File = /var/www/corp/
    Options {
      Compression = GZIP4
    }
  }
  Exclude {
    File = /var/www/corp/wwwroot/UPLOAD
    File = /var/www/corp/wwwroot/links/UPLOAD
  }
}

FileSet {
  Name = finity-home-var
  Include {
    File = /usr/home
    File = /var
    Options {
    }
  }
  Exclude {
    File = /var/finity_root.tgz
  }
}

FileSet {
  Name = etc-usrLocalEtc
  Include {
    File = /etc
    File = /usr/local/etc
    Options {
    }
  }
}

FileSet {
  Name = root-home
  Include {
    File = /root
    File = /home
    Options {
    }
  }
}

FileSet {
  Name = etc
  Include {
    File = /etc
    Options {
    }
  }
}

FileSet {
  Name = var-backup
  Include {
    File = /var/backup
    Options {
    }
  }
  Exclude {
    File = /var/backup/vz-backup
  }
}

FileSet {
  Name = root-home-backup
  Include {
    File = /root
    File = /home
    File = /var/backup
    Options {
    }
  }
  Exclude {
    File = /var/backup/vz-backup
  }
}