# Copyright © 2025 Mark Summerfield. All rights reserved.

package require util

proc get_db_filename {} {
    regsub {.ini$} [util::get_ini_filename] -[info hostname].bld
}
