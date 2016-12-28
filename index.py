#!/usr/bin/env python

'''
generate index
'''
from __future__ import print_function

import os

SITE_ROOT = 'https://source.newfuture.xyz/'
TEMPLATE = '''
# {title}

{section}

---

# All Links
{links}
'''

FOOTER = '''
---

[![Build Status](https://travis-ci.org/NewFuture/sourcelist.svg?branch=master)](https://travis-ci.org/NewFuture/sourcelist)
auto generate via [github.com/NewFuture/sourcelist](https://github.com/NewFuture/sourcelist) at {{ site.time }}

[Need helps or find bugs click here](https://github.com/NewFuture/sourcelist/issues)
'''


def list_dirs(list_path, show_path=''):
    '''
     auto generate index for input folder
    '''
    dirs, files = [], []
    for name in os.listdir(list_path):
        new_dir = os.path.join(show_path, name)
        real_path = os.path.join(list_path, name)
        if os.path.isdir(real_path):
            dirs.append(new_dir)
            files.extend(list_dirs(real_path, new_dir)[0])
        else:
            files.append(new_dir)
    return files, dirs


def link(url, prefix=''):
    '''
    generate markdown link
    '''
    return '\n* [{0}]({0}) : `curl {2}{1}{0} -#L|bash`'.format(
        url, prefix, SITE_ROOT)


def save_index(path, data):
    '''
    save file
    '''
    with open(os.path.join(path, 'README.md'), 'w') as out:
        print('generate README.md: ', path)
        out.write(data)
    with open(os.path.join(path, 'index.md'), 'w') as out:
        print('generate index: ', path)
        out.write(data + FOOTER)


def generate(path, prefix=''):
    '''
     auto generate index for input folder
    '''
    [files, dirs] = list_dirs(path)

    if dirs:
        sublinks = '## Sub Path\n'
        sublinks += reduce('{0}\n* [{1}]({1}/)'.format, dirs, '')
    else:
        sublinks = ''
    links = reduce(lambda x, y: x + link(y, prefix), files, '')
    readme = TEMPLATE.format(title=path, section=sublinks, links=links)
    save_index(path, readme)

    for sub in dirs:
        generate(os.path.join(path, sub), prefix + sub + '/')

generate('docs')
