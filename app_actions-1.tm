# Copyright © 2025 Mark Summerfield. All rights reserved.

package require entry_form
package require message_form
package require list_pick_form
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
    if {[set name [EntryForm show "New User — [tk appname]" \
            "Enter a new user’s name" [$Wldb user_names 1]]] ne ""} {
        $Wldb user_add $name
    }
}

oo::define App method on_user_rename {} {
    if {[set uid [$Wldb get_user_id]] ne ""} {
        set name [$Tree item $uid -text]
        if {[set name [EntryForm show "Rename User — [tk appname]" \
                "Enter a new name for user\n“$name”" \
                [$Wldb user_names 1] $name]] ne ""} {
            $Wldb user_rename $uid $name
        }
    }
}

oo::define App method on_user_move_first {} {
    if {[set uid [$Wldb get_user_id]] ne ""} {
        $Wldb user_move_first $uid
    }
}

oo::define App method on_user_move_up {} {
    if {[set uid [$Wldb get_user_id]] ne ""} {
        $Wldb user_move_up $uid
    }
}

oo::define App method on_user_move_down {} {
    if {[set uid [$Wldb get_user_id]] ne ""} {
        $Wldb user_move_down $uid
    }
}

oo::define App method on_user_move_last {} {
    if {[set uid [$Wldb get_user_id]] ne ""} {
        $Wldb user_move_last $uid
    }
}

oo::define App method on_user_delete {} {
    if {[set uid [$Wldb get_user_id]] ne ""} {
        set name [$Wldb get_item_text $uid]
        if {[set n [$Wldb user_child_count $uid]]} {
            MessageForm show "Delete User — [tk appname]" \
                "Cannot delete user “$name”.\nDelete all their Groups\
                first." OK warning
        } else {
            if {[YesNoForm show "Delete User — [tk appname]" \
                    "Delete user “$name”?" no] eq "yes"} {
                $Wldb user_delete $uid
            }
        }
    }
}

oo::define App method on_group_new {} {
    if {[set uid [$Wldb get_user_id]] ne ""} {
        set user [$Tree item $uid -text]
        if {[set name [EntryForm show "New Group — [tk appname]" \
                "Enter a new group name for user\n“$user”" \
                [$Wldb group_names $uid 1]]] ne ""} {
            $Wldb group_add $uid $name
        }
    }
}

oo::define App method on_group_rename {} {
    if {[set gid [$Wldb get_group_id]] ne ""} {
        set name [$Wldb get_item_text $gid]
        if {[set name [EntryForm show "Rename Group — [tk appname]" \
                "Enter a new name for group\n“$name”" \
                [$Wldb group_names [$Tree parent $gid] 1] $name]] ne ""} {
            $Wldb group_rename $gid $name
        }
    }
}

oo::define App method on_group_move_first {} {
    if {[set gid [$Wldb get_group_id]] ne ""} {
        $Wldb group_move_first $gid
    }
}

oo::define App method on_group_move_up {} {
    if {[set gid [$Wldb get_group_id]] ne ""} {
        $Wldb group_move_up $gid
    }
}

oo::define App method on_group_move_down {} {
    if {[set gid [$Wldb get_group_id]] ne ""} {
        $Wldb group_move_down $gid
    }
}

oo::define App method on_group_move_last {} {
    if {[set gid [$Wldb get_group_id]] ne ""} {
        $Wldb group_move_last $gid
    }
}

oo::define App method on_group_move_to_user {} {
    if {[set gid [$Wldb get_group_id]] ne ""} {
        set group [$Wldb get_item_text $gid]
        lassign [$Wldb get_group_user $gid] uid user
        set users [$Wldb user_names]
        if {[set i [lsearch -nocase $users $user]] > -1} {
            set users [lremove $users $i]
        }
        if {![llength $users]} {
            MessageForm show "Move Group to User — [tk appname]" \
                "Cannot move group\n“$group”\nto another user, since\
                there is no other user to move it to." OK warning
        } else {
            if {[set new_user [ListPickForm show \
                    "Pick User — [tk appname]" \
                    "Move user\n“$user”’s\n“$group”\ngroup to:" $users]] \
                    ne ""} {
                # TODO
                # if user already has a group of this name, then
                #       move any wishes from this group to that group
                #       (excluding any already there);
                # otherwise
                #       just move this group to that user
                puts "uid=$uid user=$user gid=$gid new_user=$new_user"
            }
        }
    }
}

oo::define App method on_group_delete {} {
    if {[set gid [$Wldb get_group_id]] ne ""} {
        set name [$Wldb get_item_text $gid]
        if {[set n [$Wldb group_child_count $gid]]} {
            MessageForm show "Delete Group — [tk appname]" \
                "Cannot delete group “$name”.\nDelete all their Wishes\
                first." OK warning
        } else {
            if {[YesNoForm show "Delete Group — [tk appname]" \
                    "Delete group “$name”?" no] eq "yes"} {
                $Wldb group_delete $gid
            }
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

oo::define App method on_wish_move_to_user_group {} {
    puts on_wish_move_to_user_group ;# TODO
}

oo::define App method on_wish_delete {} {
    puts on_wish_delete ;# TODO
}
