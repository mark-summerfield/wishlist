# Copyright © 2025 Mark Summerfield. All rights reserved.

package require util

proc get_db_filename {} {
    regsub {.ini$} [util::get_ini_filename] -[info hostname].bld
}

proc select_tree_item {tree {id {}}} {
    set children [$tree children {}]
    if {[llength $children]} {
        if {$id eq {} || ![$tree exists $id]} {
            set id [lindex $children 0]
        }
        $tree selection set $id
        $tree see $id
        $tree focus $id
    }
}
