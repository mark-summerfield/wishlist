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
    classvariable W
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
        if {$group ne ""} {
            if {$group eq "="} {
                set group $prev_group
            } else {
                set prev_group $group
                set gid [$Tree insert $uid end -id G[incr G] -text $group \
                        -open $open]
            }
            if {$wish ne ""} {
                $Tree insert $gid end -id W[incr W] -text $wish \
                    -values [list $note $id]
            }
        }
                
    }
    if {![llength [$Tree children {}]]} {
        my setup
    }
    my resize_columns
}

oo::define Wld method setup {} {
    classvariable U
    classvariable G
    set user [textutil::string::cap $::tcl_platform(user)]
    set uid [$Tree insert {} end -id U[incr U] -text $user -open 1]
    set gid [$Tree insert $uid end -id G[incr G] -text Fiction]
    my resize_columns
}

oo::define Wld method resize_columns {} {
    puts resize_columns ;# TODO
}

oo::define Wld method save {} {
    set out [open $Filename w]
    puts $out "Open\tUser\tGroup\tWish\tNote\tID"
    try {
        foreach user [$Tree children {}] {
            set open [$Tree item $user -open]
            set text [$Tree item $user -text]
            puts $out $open\t$text
            foreach group [$Tree children $user] {
                set open [$Tree item $group -open]
                set text [$Tree item $group -text]
                puts $out $open\t=\t$text
                foreach wish [$Tree children $group] {
                    set open [$Tree item $wish -open]
                    set text [$Tree item $wish -text]
                    lassign [$Tree item $wish -values] note id
                    puts $out $open\t=\t=\t$text\t$note\t$id
                }
            }
        }
    } finally {
        close $out
    }
}

oo::define Wld method select_item {{id {}}} {
    set children [$Tree children {}]
    if {[llength $children]} {
        if {$id eq {} || ![$Tree exists $id]} {
            set id [lindex $children 0]
        }
        $Tree selection set $id
        $Tree see $id
        $Tree focus $id
    }
}

oo::define Wld method get_prev_or_next_of tid {
    if {[set id [$Tree prev $tid]] eq {}} {
        set id [$Tree next $tid]
    }
    return $id
}

oo::define Wld method get_user_id {} {
    set tid [$Tree selection]
    if {[string match U* $tid]} { return $tid }
    set tid [$Tree parent $tid] ;# selected is Group or Wish
    if {[string match U* $tid]} { return $tid }
    $Tree parent $tid ;# selected is Wish
}

oo::define Wld method get_group_id {} {
    set tid [$Tree selection]
    if {[string match U* $tid]} { return "" } ;# No Group selected
    if {[string match G* $tid]} { return $tid }
    $Tree parent $tid ;# selected is Wish
}

oo::define Wld method get_wish_id {} {
    set tid [$Tree selection]
    if {[string match W* $tid]} { return $tid }
    return "" ;# No Wish selected
}

oo::define Wld method get_item_text iid { $Tree item $iid -text }

oo::define Wld method user_names {{casefold 0}} {
    set usernames [list]
    foreach user [$Tree children {}] {
        set name [$Tree item $user -text]
        if {$casefold} { set name [string tolower $name] }
        lappend usernames $name
    }
    return $usernames
}

oo::define Wld method user_child_count uid { llength [$Tree children $uid] }

oo::define Wld method user_add user {
    classvariable U
    my select_item [$Tree insert {} end -id U[incr U] -text $user]
}

oo::define Wld method user_rename {uid user} { $Tree item $uid -text $user }

oo::define Wld method user_move_first uid { $Tree move $uid {} 0 }

oo::define Wld method user_move_up uid {
    if {[set prev [$Tree prev $uid]] ne {}} {
        $Tree move $uid {} [$Tree index $prev]
    }
}

oo::define Wld method user_move_down uid {
    if {[set next [$Tree next $uid]] ne {}} {
        $Tree move $uid {} [$Tree index $next]
    }
}

oo::define Wld method user_move_last uid { $Tree move $uid {} end }

oo::define Wld method user_delete uid {
    set id [my get_prev_or_next_of $uid]
    $Tree delete $uid
    my select_item $id
}

# TODO NOTE: for Group & Wish moves the parent is *not* {} so must be set!
