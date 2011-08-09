#!/usr/bin/env python
# encoding: utf-8
"""
supplemental.py

Description: A set of supplemental functions used by other scripts in this directory.

Created by Drew Conway (drew.conway@nyu.edu) on 2011-08-09 
# Copyright (c) 2011, under the Simplified BSD License.  
# For more information on FreeBSD see: http://www.opensource.org/licenses/bsd-license.php
# All rights reserved.
"""

import sys
import os
import csv


def parse_congress(path, headers):
    """Returns a parsed csv as list of dicts"""
    reader = csv.DictReader(open(path, "rU"), fieldnames=headers)
    reader.next() # Pop headers
    return map(lambda row: row, reader)


if __name__ == '__main__':
	main()

