#!/bin/bash
nagelfar.sh \
    | grep -v Unknown.command \
    | grep -v Unknown.variable \
    | grep -v No.info.on.package.*found \
    | grep -v Variable.*is.never.read \
    | grep -v Unknown.subcommand..home..to..file \
    | grep -v Unknown.subcommand..show \
    | grep -v Bad.option.-placeholder.to..ttk::entry \
    | grep -v Found.constant.*which.is.also.a.variable
du -sh .git
ls -sh .*.str
clc -s -l tcl
str s
git st
