# Copyright © 2025 Mark Summerfield. All rights reserved.
# File format is newline-separated records of tab-separated fields in
# display order: Open User Group Wish Note ID.
# The ttk::treeview Tree holds all the data.

package require textutil::string

oo::class create Wld {
    variable Tree
    variable Filename
}

oo::define Wld initialize {
    variable U 0
    variable G 0
    variable W 0
}

oo::define Wld constructor {tree filename} {
    set Tree $tree
    set Filename $filename
    if {[file isfile $Filename]} {
        my load
    } else {
        my setup
    }
}

oo::define Wld destructor { my save }

oo::define Wld method tree {} { return $Tree }

oo::define Wld method filename {} { return $Filename }

oo::define Wld method load {} {
    classvariable U
    classvariable G
    $Tree delete [$Tree children {}]
    set prev_user ""
    set prev_group ""
    set uid {}
    set gid {}
    foreach line [split [readFile $Filename] \n] {
        if {$line eq "" || [string match Open* $line]} { continue }
        lassign [split $line \t] open user group wish note id
        if {$user eq "="} {
            set user $prev_user
        } else {
            set prev_user $user
            set uid [$Tree insert {} end -id U[incr U] -text $user \
                    -open $open]
        }
        if {$group eq "="} {
            set group $prev_group
        } else {
            set prev_group $group
            set gid [$Tree insert $uid end -id G[incr G] -text $group \
                    -open $open]
        }
        $Tree insert $gid end -id W[incr W] -text $wish \
            -values [list $note $id]
            
    }
    if {![llength [$Tree children {}]]} {
        my setup
    }
}

oo::define Wld method setup {} {
    classvariable U
    classvariable G
    set user [textutil::string::cap $::tcl_platform(user)]
    set uid [$Tree insert {} end -id U[incr U] -text $user -open 1]
    set gid [$Tree insert $uid end -id G[incr G] -text Fiction]
}

oo::define Wld method save {} {
    set out [open $Filename w]
    puts $out "Open\tUser\tGroup\tWish\tNote\tID"
    try {
        set in_user 0
        foreach user [$Tree children {}] {
            set in_group 0
            foreach group [$Tree children $user] {
                foreach wish [$Tree children $group] {
                    if $in_user {
                        set uname =
                    } else {
                        set uname $user
                        set in_user 0
                    }
                    if $in_group {
                        set gname =
                    } else {
                        set gname $group
                        set in_group 0
                    }
                    set open [$Tree item $wish -open]
                    set text [$Tree item $wish -text]
                    lassign [$Tree item $wish -values] note id
                    puts $out $open\t$uname\t$gname\t$text\t$note\t$id
                }
            }
        }
    } finally {
        close $out
    }
}
