#!/usr/bin/env python

'''
generate index
'''
from __future__ import print_function

import os

SITE_ROOT = 'https://source.newfuture.xyz/'
TEMPLATE = '''
# {title}

{subsection}

# All Links

{links}

---

Auto generate from [github.com/NewFuture/sourcelist](https://github.com/NewFuture/sourcelist) update at {{site.time}}\n\n

[Need helps or find bugs click here ](https://github.com/NewFuture/sourcelist/issues)

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
    return '* [{0}]({1}{0}) : `curl {2}{1}{0} -#L|bash`'.format(
        url, prefix, SITE_ROOT)


def save(fname, data):
    '''
    save file
    '''
    with open(fname, 'w') as out:
        print('generate: ', fname)
        out.write(data)


def generate(path):
    '''
     auto generate index for input folder
    '''
    [files, dirs] = list_dirs(path)

    if dirs:
        sublinks = '\n## Sub Path\n'
        sublinks += reduce('{0}\n* [{1}]({1}/)'.format, dirs, '')
    else:
        sublinks = ''
    links = reduce(lambda x, y: x + '\n' + link(y), files, '')
    readme = TEMPLATE.format(title=path, subsection=sublinks, links=links)
    save(os.path.join(path, 'README.md'), readme)

    for sub in dirs:
        generate(os.path.join(path, sub))

generate('docs')
