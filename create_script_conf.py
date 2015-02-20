#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os.path


def directory_scan(credentils_dir):
    """return a dictionary, like this:
    {'mon': { 'address': '12.123.231.123', 'password': 'asdfadsfad'},
     'sql': { 'address': '12.123.231.124', 'password': 'asdfasdfasdf'}}"""
    import os
    result = {}
    for dir in os.listdir(credentils_dir):
        fd_passwd = open(os.path.join(credentils_dir, dir, "bacula-fd-passwd")).readline().strip()
        result[dir.lower()] = {'address': "%s.mariinsky.ru"%dir, 'password': fd_passwd}
    return result


def get_section(section_name, text):
    import re
    # get content contained withing the section. "Job { (result) }"
    section_body = re.compile(r"(?:^\s*%s\s+{)(.*?)(?:})" % section_name, re.DOTALL | re.IGNORECASE | re.MULTILINE).findall(text)
    result = []
    for frag in section_body:
        # split any strings by pairs.
        res_raw = re.compile(r"(?:^\s*)([\w\-_ ]+) = (?:\")?([\w\-_\.\" ]+(?:[^#\"]\w|\d))",
                                 re.DOTALL | re.MULTILINE).findall(frag)
        res = map(lambda x: (x[0].lower(), x[1]), res_raw)
        result.append(dict(res))
    return result


def bacula_config_scan(bacula_conf):
    import re
    conf_fl = open(bacula_conf).read()
    result = {}

    jobs = get_section("job", conf_fl)
    job_type_by_client = {}
    for job in jobs:
        if job.has_key('client'):
            client_name = job['client'].lower()
            if not job_type_by_client.has_key(job['client']):
                job_type_by_client[client_name] = []
            job_name = re.compile(r"(?:[_-])(.*)").findall(job['name'])
            if job_name:
                job_type_by_client[client_name].append(job_name[0])

    clients = get_section("client", conf_fl)
    for client in clients:
        if client.has_key('name'):
            client_name = client['name'].lower()
            if job_type_by_client.has_key(client_name) and len(job_type_by_client[client_name]) > 0:
                job_type_by_client_str = ", ".join(job_type_by_client[client_name])
            else:
                job_type_by_client_str = "none"
            result[client['name'].lower()] = dict(address=client['address'],
                                                  password=client['password'],
                                                  storage='hummer',
                                                  type=job_type_by_client_str)
        else:
            #raise ValueError("name does not specified in %s" % repr(client))
            continue
    return result


def config_create(config_file, config_arr):
    import ConfigParser
    if os.path.isfile(config_file):
        config = ConfigParser.ConfigParser()
        config.read(config_file)
    else:
        config = ConfigParser.ConfigParser()
    for client in config_arr.keys():
        if not config.has_section(client):
            config.add_section(client)
        for key in config_arr[client].keys():
            config.set(client, key, config_arr[client][key])
    with open(config_file, 'wb') as configfile:
        config.write(configfile)


if __name__ == "__main__":
    import sys
    import optparse
    options = optparse.OptionParser()
    options.add_option("-d", "--credentials-dir", dest="credentils_dir", metavar="DIRECTORY",
                       help="directory where bacula credentials store")
    options.add_option("-b", "--bacula-config", dest="bacula_conf", metavar="FILE", help="bacula file locations")
    options.add_option("-c", "--config", dest="config", metavar="FILE",
                       help="where the config should be located. If this parameter is set, then programm will try to update existed values. "
                            "If not set, result will be printed into stdout.")
    (options, arguments) = options.parse_args()

    if options.credentils_dir and options.bacula_conf:
        raise ValueError("you should select only one source for the config creation")
    elif not options.credentils_dir and not options.bacula_conf:
        raise ValueError("you should select at least one source for the config creation")

    if options.credentils_dir:
        conf_raw = directory_scan(options.credentils_dir)
    elif options.bacula_conf:
        conf_raw = bacula_config_scan(options.bacula_conf)

    if options.config:
        config_create(options.config, conf_raw)
    else:
        for client in conf_raw.keys():
            sys.stdout.write("[%s]\n" % client)
            for key in conf_raw[client].keys():
                sys.stdout.write("%s = %s\n" % (key, conf_raw[client][key]))
            sys.stdout.write("\n")