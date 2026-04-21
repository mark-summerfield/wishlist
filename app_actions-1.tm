# Copyright © 2025-26 Mark Summerfield. All rights reserved.

package require book_form
package require entry_form
package require list_pick_form
package require message_form
package require yes_no_form

oo::define App method on_configure_tf {x y width height} {
    if {$TreeWidth != $width} {
        set TreeWidth $width
        event generate .mf.tf <<TreeResizedWidth>>
    }
}

oo::define App method on_tree_resized_width {} {
    after cancel $RefreshTreeId
    if {[info exists Wldb]} {
        set RefreshTreeId [after 100 [$Wldb resize_columns]]
    }
}

oo::define App method on_configure_tb {x y width height} {
    if {$ToolbarWidth != $width} {
        set ToolbarWidth $width
        event generate .mf.tb <<ToolbarResizedWidth>>
    }
}

oo::define App method on_toolbar_resized_width {} {
    after cancel $RefreshToolbarsId
    set RefreshToolbarsId [after 100 [callback refresh_toolbars]]
}

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
        my refresh_toolbars
    }
}

oo::define App method on_about {} {
    AboutForm new "Book wishlists" \
        https://github.com/mark-summerfield/wishlists
}

oo::define App method on_quit {} {
    $Wldb save
    [Config new] save
    exit
}

oo::define App method on_reader_new {} {
    if {[set name [EntryForm show "New Reader — [tk appname]" \
            "Enter a new reader’s name" [$Wldb reader_names 1]]] ne ""} {
        $Wldb reader_add $name
    }
}

oo::define App method on_reader_rename {} {
    if {[set rid [$Wldb reader_id]] ne ""} {
        set name [$Tree item $rid -text]
        if {[set name [EntryForm show "Rename Reader — [tk appname]" \
                "Enter a new name for reader\n“$name”" \
                [$Wldb reader_names 1] $name]] ne ""} {
            $Wldb reader_rename $rid $name
        }
    }
}

oo::define App method on_reader_move_first {} {
    if {[set rid [$Wldb reader_id]] ne ""} {
        $Wldb reader_move_first $rid
    }
}

oo::define App method on_reader_move_up {} {
    if {[set rid [$Wldb reader_id]] ne ""} {
        $Wldb reader_move_up $rid
    }
}

oo::define App method on_reader_move_down {} {
    if {[set rid [$Wldb reader_id]] ne ""} {
        $Wldb reader_move_down $rid
    }
}

oo::define App method on_reader_move_last {} {
    if {[set rid [$Wldb reader_id]] ne ""} {
        $Wldb reader_move_last $rid
    }
}

oo::define App method on_reader_delete {} {
    if {[set rid [$Wldb reader_id]] ne ""} {
        set name [$Wldb item_text $rid]
        if {[set n [$Wldb reader_child_count $rid]]} {
            MessageForm show "Delete Reader — [tk appname]" \
                "Cannot delete reader “$name”.\nDelete all their Groups\
                first." OK warning
        } else {
            if {[YesNoForm show "Delete Reader — [tk appname]" \
                    "Delete reader “$name”?" no] eq "yes"} {
                $Wldb reader_delete $rid
            }
        }
    }
}

oo::define App method on_group_new {} {
    if {[set rid [$Wldb reader_id]] ne ""} {
        set reader [$Tree item $rid -text]
        if {[set name [EntryForm show "New Group — [tk appname]" \
                "Enter a new group name for reader\n“$reader”" \
                [$Wldb group_names $rid 1]]] ne ""} {
            $Wldb group_add $rid $name
        }
    }
}

oo::define App method on_group_rename {} {
    if {[set gid [$Wldb group_id]] ne ""} {
        set name [$Wldb item_text $gid]
        if {[set name [EntryForm show "Rename Group — [tk appname]" \
                "Enter a new name for group\n“$name”" \
                [$Wldb group_names [$Tree parent $gid] 1] $name]] ne ""} {
            $Wldb group_rename $gid $name
        }
    }
}

oo::define App method on_group_move_first {} {
    if {[set gid [$Wldb group_id]] ne ""} {
        $Wldb group_move_first $gid
    }
}

oo::define App method on_group_move_up {} {
    if {[set gid [$Wldb group_id]] ne ""} {
        $Wldb group_move_up $gid
    }
}

oo::define App method on_group_move_down {} {
    if {[set gid [$Wldb group_id]] ne ""} {
        $Wldb group_move_down $gid
    }
}

oo::define App method on_group_move_last {} {
    if {[set gid [$Wldb group_id]] ne ""} {
        $Wldb group_move_last $gid
    }
}

oo::define App method on_group_move_to_reader {} {
    if {[set gid [$Wldb group_id]] ne ""} {
        set group [$Wldb item_text $gid]
        lassign [$Wldb group_reader $gid] rid reader
        set readers [$Wldb reader_names]
        if {[set i [lsearch -nocase $readers $reader]] > -1} {
            set readers [lremove $readers $i]
        }
        if {![llength $readers]} {
            MessageForm show "Move Group to Reader — [tk appname]" \
                "Cannot move group\n“$group”\nto another reader, since\
                there is no other reader to move it to." OK warning
        } else {
            if {[set new_reader [ListPickForm show \
                    "Pick Reader — [tk appname]" \
                    "Move reader\n“$reader”’s\n“$group”\ngroup to:" \
                    $readers]] ne ""} {
                set new_rid [$Wldb reader_id_for_name $new_reader]
                if {[set existing_gid [$Wldb group_id_for_name $new_rid \
                        $group]] ne {}} {
                    $Wldb group_merge_to_reader $gid $existing_gid $new_rid
                } else {
                    $Wldb group_move_to_reader $gid $new_rid
                }
            }
        }
    }
}

oo::define App method on_group_delete {} {
    if {[set gid [$Wldb group_id]] ne ""} {
        set name [$Wldb item_text $gid]
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

oo::define App method on_book_new {} {
    if {[set gid [$Wldb group_id]] ne ""} {
        set group [$Wldb item_text $gid]
        lassign [$Wldb group_reader $gid] _ reader
        set book [Book new]
        if {[BookForm show $reader $group $book]} {
            $Wldb book_add $gid $book
        }
        $book destroy
    }
}

oo::define App method get_book_details {} {
    if {[set gid [$Wldb group_id]] ne ""} {
        set group [$Wldb item_text $gid]
        lassign [$Wldb group_reader $gid] _ reader
        if {[set bid [$Wldb book_id]] ne ""} {
            return [list $gid $group $reader $bid]
        }
    }
}

oo::define App method on_book_edit {} {
    lassign [my get_book_details] gid group reader bid
    if {[info exists bid]} {
        set book [$Wldb book $bid]
        if {[BookForm show $reader $group $book]} {
            $Wldb book_update $gid $bid $book
        }
    }
}

oo::define App method on_book_lookup {} {
    puts on_book_lookup ;# TODO (2)
}

oo::define App method on_book_copy_to_clipboard {} {
    if {[set bid [$Wldb book_id]] ne ""} {
        set book [$Wldb book $bid]
        clipboard clear
        clipboard append "[$book title] [$book author] [$book isbn]"
    }
}

oo::define App method on_book_move_first {} {
    if {[set bid [$Wldb book_id]] ne ""} {
        $Wldb book_move_first $bid
    }
}

oo::define App method on_book_move_up {} {
    if {[set bid [$Wldb book_id]] ne ""} {
        $Wldb book_move_up $bid
    }
}

oo::define App method on_book_move_down {} {
    if {[set bid [$Wldb book_id]] ne ""} {
        $Wldb book_move_down $bid
    }
}

oo::define App method on_book_move_last {} {
    if {[set bid [$Wldb book_id]] ne ""} {
        $Wldb book_move_last $bid
    }
}

oo::define App method on_book_move_to_reader_group {} {
    puts on_book_move_to_reader_group ;# TODO (1)
}

oo::define App method on_book_delete {} {
    if {[set bid [$Wldb book_id]] ne ""} {
        set book [$Wldb book $bid]
        if {[YesNoForm show "Delete Book — [tk appname]" \
                "Delete\n“[$book title]”\nby\n“[$book author]”?"] \
                eq "yes"} {
            $Wldb book_delete $bid
        }
    }
}
