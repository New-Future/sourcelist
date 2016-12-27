#!/usr/bin/env python

'''
auto
'''
from __future__ import print_function
import os

SITE_ROOT = 'docs/'


def read_list(fname):
    '''
    read source list
    @return dict
    '''
    with open(fname) as infile:
        source_list = {}
        for line in infile:
            line = line.strip()
            if not line or line.startswith('#'):
                continue

            data = line.split('#', 1)
            url = data[0].strip()

            if len(data) == 1:
                name = url.rstrip('/').rstrip('.cn').rstrip('.edu')
                name = name.rstrip('.org').rsplit('.', 1)[-1]
            else:
                name = data[1].strip()
                name = name.split(None, 1)[0].split('#,:', 1)[0].strip()
            if name in source_list:
                exit('ERROR: too many source named "{0}"\n\t{1}\n\t{2}'.format(
                    name, url, source_list[name]))
            else:
                source_list[name] = url
        return source_list


def read_template(fname):
    '''
    read template file
    '''
    with open(fname, 'r') as template:
        return template.read()


def save(fname, data):
    '''
    save file
    '''
    fname = SITE_ROOT + fname
    path = os.path.dirname(fname)
    if path and (not os.path.exists(path)):
        os.makedirs(path)
    with open(fname, 'w') as out:
        out.write(data)


def generate(source, prefix=''):
    '''
    generate source file
    '''
    slist = read_list(source)
    template_speed = read_template('template/speed.sh')
    template_list = read_template('template/list.sh')

    lst = []
    for (name, url) in slist.items():
        lst.append("'{0}' #{1}".format(url, name))
        script = template_list.replace('${FAST_SRC}', url)
        save(prefix + name + '.sh', script)

    source_list = "\n\t".join(lst)
    script = template_speed.replace('__SOURCE_LIST__', source_list)
    save(prefix + 'list.sh', script + template_list)


def generate_docker(source, prefix=''):
    '''
    generate source file for docker
    '''
    slist = read_list(source)
    template_speed = read_template('template/speed.sh')
    template_docker = read_template('template/docker.sh')

    lst = []
    for (name, url) in slist.items():
        lst.append("'{0}' #{1}".format(url, name))
        script = template_docker.replace('${FAST_SRC}', url)
        save(prefix + 'docker/' + name + '.sh', script)

    source_list = "\n\t".join(lst)
    script = template_speed.replace('__SOURCE_LIST__', source_list)
    save(prefix + 'docker.sh', script + template_docker)


def main():
    '''
    entry
    '''
    generate('source/ipv6.list', 'ipv6/')
    generate('source/all.list', 'all/')
    generate_docker('source/all.docker', 'all/')
    generate_docker('source/ipv6.docker', 'ipv6/')

if __name__ == '__main__':
    main()
