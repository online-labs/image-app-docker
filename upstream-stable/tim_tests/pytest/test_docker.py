'''
Copyright (C) 2017 Scaleway. All rights reserved.
Use of this source code is governed by a MIT-style
license that can be found in the LICENSE file.
'''


def test_docker(host):
    res = host.run('docker --version')
    assert res.rc == 0
