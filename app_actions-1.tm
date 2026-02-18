# Copyright © 2025 Mark Summerfield. All rights reserved.

package require entry_form
package require message_form
package require yes_no_form

oo::define App method on_file_save {} { $Wldb save }

oo::define App method on_config {} {
    set config [Config new]
    set ok [Ref new 0]
    set family [$config family]
    set size [$config size]
    set form [ConfigForm new $ok]
    tkwait window [$form form]
    if {[$ok get]} {
        if {$family ne [$config family] || $size != [$config size]} {
            my make_fonts
        }
    }
}

oo::define App method on_about {} {
    AboutForm new Wishlists https://github.com/mark-summerfield/wishlists
}

oo::define App method on_quit {} {
    $Wldb save
    [Config new] save
    exit
}

oo::define App method on_user_new {} {
    puts on_user_new ; return ;# TODO
    if {[set name [EntryForm show "New User — [tk appname]" \
            "Enter a name for a new user" [$Wldb user_names 1]]] \
            ne ""} {
        set cid [$Wldb user_insert $name]
        my populate
        after idle [my select_user $cid]
    }
}

oo::define App method on_user_rename {} {
    puts on_user_rename ; return ;# TODO
    set tcid [my get_tcid]
    if {[string match C* $tcid]} {
        set name [$Tree item $tcid -text]
        if {[set name [EntryForm show "Rename User — [tk appname]" \
                "Enter a new name for user\n“$name”" \
                [$Wldb user_names 1] $name]] ne ""} {
            set cid [string range $tcid 1 end]
            $Wldb user_update $cid $name
            my populate
            after idle [my select_user $cid]
        }
    }
}

oo::define App method on_user_move_first {} {
    puts on_user_move_first ; return ;# TODO
    if {[set tcid [my get_tcid]] ne ""} {
        set cid [string range $tcid 1 end]
        $Wldb user_move_first $cid
        my populate
        after idle [my select_user $cid]
    }
}

oo::define App method on_user_move_up {} {
    puts on_user_move_up ; return ;# TODO
    if {[set tcid [my get_tcid]] ne ""} {
        set cid [string range $tcid 1 end]
        $Wldb user_move_up $cid
        my populate
        after idle [my select_user $cid]
    }
}

oo::define App method on_user_move_down {} {
    puts on_user_move_down ; return ;# TODO
    if {[set tcid [my get_tcid]] ne ""} {
        set cid [string range $tcid 1 end]
        $Wldb user_move_down $cid
        my populate
        after idle [my select_user $cid]
    }
}

oo::define App method on_user_move_last {} {
    puts on_user_move_last ; return ;# TODO
    if {[set tcid [my get_tcid]] ne ""} {
        set cid [string range $tcid 1 end]
        $Wldb user_move_last $cid
        my populate
        after idle [my select_user $cid]
    }
}

oo::define App method on_user_delete {} {
    puts on_user_delete ; return ;# TODO
    if {[$Wldb user_count] == 1} {
        MessageForm show "Delete User — [tk appname]" \
            "Cannot delete the last user." OK warning
        return
    }
    set tcid [my get_tcid]
    if {[string match C* $tcid]} {
        set cid [string range $tcid 1 end]
        if {[$Wldb wishes_in_user $cid]} {
            MessageForm show "Delete User — [tk appname]" \
                "Cannot delete a nonempty user;
                delete its wishes first." OK warning
            return
        }
        set body "Delete user\n“[$Wldb user_name $cid]”?"
        if {[YesNoForm show "Delete User — [tk appname]" $body no] \
                eq "yes"} {
            $Wldb user_delete $cid
            my populate
            after idle [list select_tree_item $Tree]
        }
    }
}

oo::define App method on_group_new {} {
    puts on_group_new ; return ;# TODO
    if {[set name [EntryForm show "New Group — [tk appname]" \
            "Enter a name for a new group" [$Wldb group_names 1]]] \
            ne ""} {
        set cid [$Wldb group_insert $name]
        my populate
        after idle [my select_group $cid]
    }
}

oo::define App method on_group_rename {} {
    puts on_group_rename ; return ;# TODO
    set tcid [my get_tcid]
    if {[string match C* $tcid]} {
        set name [$Tree item $tcid -text]
        if {[set name [EntryForm show "Rename Group — [tk appname]" \
                "Enter a new name for group\n“$name”" \
                [$Wldb group_names 1] $name]] ne ""} {
            set cid [string range $tcid 1 end]
            $Wldb group_update $cid $name
            my populate
            after idle [my select_group $cid]
        }
    }
}

oo::define App method on_group_move_first {} {
    puts on_group_move_first ; return ;# TODO
    if {[set tcid [my get_tcid]] ne ""} {
        set cid [string range $tcid 1 end]
        $Wldb group_move_first $cid
        my populate
        after idle [my select_group $cid]
    }
}

oo::define App method on_group_move_up {} {
    puts on_group_move_up ; return ;# TODO
    if {[set tcid [my get_tcid]] ne ""} {
        set cid [string range $tcid 1 end]
        $Wldb group_move_up $cid
        my populate
        after idle [my select_group $cid]
    }
}

oo::define App method on_group_move_down {} {
    puts on_group_move_down ; return ;# TODO
    if {[set tcid [my get_tcid]] ne ""} {
        set cid [string range $tcid 1 end]
        $Wldb group_move_down $cid
        my populate
        after idle [my select_group $cid]
    }
}

oo::define App method on_group_move_last {} {
    puts on_group_move_last ; return ;# TODO
    if {[set tcid [my get_tcid]] ne ""} {
        set cid [string range $tcid 1 end]
        $Wldb group_move_last $cid
        my populate
        after idle [my select_group $cid]
    }
}

oo::define App method on_group_delete {} {
    puts on_group_delete ; return ;# TODO
    if {[$Wldb group_count] == 1} {
        MessageForm show "Delete Group — [tk appname]" \
            "Cannot delete the last group." OK warning
        return
    }
    set tcid [my get_tcid]
    if {[string match C* $tcid]} {
        set cid [string range $tcid 1 end]
        if {[$Wldb wishes_in_group $cid]} {
            MessageForm show "Delete Group — [tk appname]" \
                "Cannot delete a nonempty group;
                delete its wishes first." OK warning
            return
        }
        set body "Delete group\n“[$Wldb group_name $cid]”?"
        if {[YesNoForm show "Delete Group — [tk appname]" $body no] \
                eq "yes"} {
            $Wldb group_delete $cid
            my populate
            after idle [list select_tree_item $Tree]
        }
    }
}

oo::define App method on_wish_new {} {
    puts on_wish_new ;# TODO
}

oo::define App method on_wish_edit {} {
    puts on_wish_edit ;# TODO
}

oo::define App method on_wish_lookup {} {
    puts on_wish_lookup ;# TODO
}

oo::define App method on_wish_copy {} {
    puts on_wish_copy ;# TODO
}

oo::define App method on_wish_move_first {} {
    puts on_wish_move_first ;# TODO
}

oo::define App method on_wish_move_up {} {
    puts on_wish_move_up ;# TODO
}

oo::define App method on_wish_move_down {} {
    puts on_wish_move_down ;# TODO
}

oo::define App method on_wish_move_last {} {
    puts on_wish_move_last ;# TODO
}

oo::define App method on_wish_delete {} {
    puts on_wish_delete ;# TODO
}

oo::define App method get_tcid {} {
    if {[string match W* [set tcid [$Tree selection]]]} {
        set tcid [$Tree parent $tcid]
    }
    return $tcid
}
