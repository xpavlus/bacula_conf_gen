#!/usr/bin/env python
# -*- coding: utf-8 -*-

__author__ = 'pavel'

if __name__ == "__main__":
    import os.path
    import optparse
    import ConfigParser
    import mako.lookup
    import sys

    options = optparse.OptionParser()
    options.add_option("-c", "--script-conf", dest="conf", metavar="FILE",
                       help="locations of the script config")

    (options, arguments) = options.parse_args()
    if os.path.isfile(options.conf):
        config = ConfigParser.ConfigParser()
        config.read(options.conf)
    else:
        raise ValueError("Please specify correct config location")
    clients = []
    for client in config.sections():
        cl_raw = dict(config.items(client))
        cl_raw.update(dict(name=client))
        clients.append(cl_raw)
    mylookup = mako.lookup.TemplateLookup(directories=['./template'], module_directory="/tmp/mako-module")
    mytemplate = mylookup.get_template('base.mako')
    sys.stdout.write(mytemplate.render(clients=clients))