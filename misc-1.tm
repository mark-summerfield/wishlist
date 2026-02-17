# Copyright © 2025 Mark Summerfield. All rights reserved.

package require util

proc get_db_filename {} {
    regsub {.ini$} [util::get_ini_filename] -[info hostname].bld
}

proc select_tree_item {tree id} {
    if {[llength [$tree children {}]]} {
        if {[$tree exists $id]} {
            $tree selection set $id
            $tree see $id
            $tree focus $id
        }
    }
}
