# Copyright © 2025-26 Mark Summerfield. All rights reserved.

package require book_form
package require entry_form
package require list_pick_form
package require message_form
package require move_book_form
package require util
package require yes_no_form

oo::define App method on_configure_tf {x y width height} {
    if {$TreeWidth != $width} {
        set TreeWidth $width
        event generate .mf.tf <<TreeResizedWidth>>
    }
}

oo::define App method on_tree_resized_width {} {
    after cancel $RefreshTreeId
    if {[info exists Db]} {
        set RefreshTreeId [after 100 [$Db resize_columns]]
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

oo::define App method on_file_save {} { $Db save }

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
    $Db save
    [Config new] save
    exit
}

oo::define App method on_reader_new {} {
    if {[set name [EntryForm show "New Reader — [tk appname]" \
            "Enter a new reader’s name" [$Db reader_names 1]]] ne ""} {
        $Db reader_add $name
    }
}

oo::define App method on_reader_rename {} {
    if {[set rid [$Db reader_id]] ne ""} {
        set name [$Tree item $rid -text]
        if {[set name [EntryForm show "Rename Reader — [tk appname]" \
                "Enter a new name for reader\n“$name”" \
                [$Db reader_names 1] $name]] ne ""} {
            $Db reader_rename $rid $name
        }
    }
}

oo::define App method on_reader_move_first {} {
    if {[set rid [$Db reader_id]] ne ""} {
        $Db reader_move_first $rid
    }
}

oo::define App method on_reader_move_up {} {
    if {[set rid [$Db reader_id]] ne ""} {
        $Db reader_move_up $rid
    }
}

oo::define App method on_reader_move_down {} {
    if {[set rid [$Db reader_id]] ne ""} {
        $Db reader_move_down $rid
    }
}

oo::define App method on_reader_move_last {} {
    if {[set rid [$Db reader_id]] ne ""} {
        $Db reader_move_last $rid
    }
}

oo::define App method on_reader_delete {} {
    if {[set rid [$Db reader_id]] ne ""} {
        set name [$Db item_text $rid]
        if {[set n [$Db reader_child_count $rid]]} {
            MessageForm show "Delete Reader — [tk appname]" \
                "Cannot delete reader “$name”.\nDelete all their Groups\
                first." OK warning
        } else {
            if {[YesNoForm show "Delete Reader — [tk appname]" \
                    "Delete reader “$name”?" no] eq "yes"} {
                $Db reader_delete $rid
            }
        }
    }
}

oo::define App method on_group_new {} {
    if {[set rid [$Db reader_id]] ne ""} {
        set reader [$Tree item $rid -text]
        if {[set name [EntryForm show "New Group — [tk appname]" \
                "Enter a new group name for reader\n“$reader”" \
                [$Db group_names $rid 1]]] ne ""} {
            $Db group_add $rid $name
        }
    }
}

oo::define App method on_group_rename {} {
    if {[set gid [$Db group_id]] ne ""} {
        set name [$Db item_text $gid]
        if {[set name [EntryForm show "Rename Group — [tk appname]" \
                "Enter a new name for group\n“$name”" \
                [$Db group_names [$Tree parent $gid] 1] $name]] ne ""} {
            $Db group_rename $gid $name
        }
    }
}

oo::define App method on_group_move_first {} {
    if {[set gid [$Db group_id]] ne ""} {
        $Db group_move_first $gid
    }
}

oo::define App method on_group_move_up {} {
    if {[set gid [$Db group_id]] ne ""} {
        $Db group_move_up $gid
    }
}

oo::define App method on_group_move_down {} {
    if {[set gid [$Db group_id]] ne ""} {
        $Db group_move_down $gid
    }
}

oo::define App method on_group_move_last {} {
    if {[set gid [$Db group_id]] ne ""} {
        $Db group_move_last $gid
    }
}

oo::define App method on_group_move_to_reader {} {
    if {[set gid [$Db group_id]] ne ""} {
        set group [$Db item_text $gid]
        lassign [$Db group_reader $gid] rid reader
        set readers [$Db reader_names]
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
                set new_rid [$Db reader_id_for_name $new_reader]
                if {[set existing_gid [$Db group_id_for_name $new_rid \
                        $group]] ne {}} {
                    $Db group_merge_to_reader $gid $existing_gid $new_rid
                } else {
                    $Db group_move_to_reader $gid $new_rid
                }
            }
        }
    }
}

oo::define App method on_group_delete {} {
    if {[set gid [$Db group_id]] ne ""} {
        set name [$Db item_text $gid]
        if {[set n [$Db group_child_count $gid]]} {
            MessageForm show "Delete Group — [tk appname]" \
                "Cannot delete group “$name”.\nDelete all their Wishes\
                first." OK warning
        } else {
            if {[YesNoForm show "Delete Group — [tk appname]" \
                    "Delete group “$name”?" no] eq "yes"} {
                $Db group_delete $gid
            }
        }
    }
}

oo::define App method on_book_new {} {
    if {[set gid [$Db group_id]] ne ""} {
        set group [$Db item_text $gid]
        lassign [$Db group_reader $gid] _ reader
        set book [Book new]
        if {[BookForm show $reader $group $book]} {
            $Db book_add $gid $book
        }
        $book destroy
    }
}

oo::define App method get_book_details {} {
    if {[set gid [$Db group_id]] ne ""} {
        set group [$Db item_text $gid]
        lassign [$Db group_reader $gid] _ reader
        if {[set bid [$Db book_id]] ne ""} {
            return [list $gid $group $reader $bid]
        }
    }
}

oo::define App method on_book_edit {} {
    lassign [my get_book_details] gid group reader bid
    if {[info exists bid] && $bid ne ""} {
        set book [$Db book $bid]
        if {[BookForm show $reader $group $book]} {
            $Db book_update $gid $bid $book
        }
    }
}

oo::define App method on_book_lookup {} {
    if {[set bid [$Db book_id]] ne ""} {
        set book [$Db book $bid]
        set isbn [$book isbn]
        foreach url $::URLS {
            regsub -all {<ISBN>} $url $isbn url
            try {
                util::open_url $url
            } on error err {
                puts "failed to lookup $url: $err"
            }
        }
    }
}

oo::define App method on_book_copy_to_clipboard {} {
    if {[set bid [$Db book_id]] ne ""} {
        set book [$Db book $bid]
        clipboard clear
        clipboard append "[$book title] [$book author] [$book isbn]"
    }
}

oo::define App method on_book_move_first {} {
    if {[set bid [$Db book_id]] ne ""} {
        $Db book_move_first $bid
    }
}

oo::define App method on_book_move_up {} {
    if {[set bid [$Db book_id]] ne ""} {
        $Db book_move_up $bid
    }
}

oo::define App method on_book_move_down {} {
    if {[set bid [$Db book_id]] ne ""} {
        $Db book_move_down $bid
    }
}

oo::define App method on_book_move_last {} {
    if {[set bid [$Db book_id]] ne ""} {
        $Db book_move_last $bid
    }
}

oo::define App method on_book_move_to_reader_group {} {
    if {[set bid [$Db book_id]] ne ""} { MoveBookForm show $Db $bid }
}

oo::define App method on_book_delete {} {
    if {[set bid [$Db book_id]] ne ""} {
        set book [$Db book $bid]
        if {[YesNoForm show "Delete Book — [tk appname]" \
                "Delete\n“[$book title]”\nby\n“[$book author]”?"] \
                eq "yes"} {
            $Db book_delete $bid
        }
    }
}
