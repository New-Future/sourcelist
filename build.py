#!/usr/bin/env python

'''
auto
'''
from __future__ import print_function
import os

SITE_ROOT = 'docs/'
TMPLATE_DIR = 'template/'
LIST_DIR = 'source/'
LIST_EXT = '.txt'


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
        print('save to: ', fname)
        out.write(data)


def generate_bash(name, prefix):
    '''
    generate source file for docker
    save scripts to files
    return script with speed testing
    '''
    slist = read_list(LIST_DIR + prefix + '/' + name + LIST_EXT)
    template_source = read_template(TMPLATE_DIR + name + '.sh')

    lst = []
    for (key, url) in slist.items():
        lst.append("'{0}' #{1}".format(url, key))
        script = template_source.replace('${FAST_SRC}', url)
        output_file = '{0}/{1}/{2}.sh'.format(prefix, name, key)
        save(output_file, script)

    source_list = "\n\t".join(lst)
    template_speed = read_template(TMPLATE_DIR + 'speed.sh')
    script = template_speed.replace('__SOURCE_LIST__', source_list)
    script += template_source
    save(prefix + '/' + name + '.sh', script)
    return script


def generate():
    '''
     auto generate from  input folder
    '''
    for folder in os.listdir(LIST_DIR):
        # print(folder)
        path = os.path.join(LIST_DIR, folder)
        if not os.path.isdir(path):
            continue
        script = ''
        for name in os.listdir(path):
            name, ext = os.path.splitext(name)
            if ext != LIST_EXT:
                continue
            script += generate_bash(name, folder)
        save(os.path.join(folder, 'all.sh'), script)


# def main():
#     '''
#     entry
#     '''
#     generate('source/')


if __name__ == '__main__':
    generate()
