# Copyright © 2025 Mark Summerfield. All rights reserved.

package require entry_form
package require message_form
package require yes_no_form

oo::define App method on_file_export {} {
    puts on_file_export ;# TODO
}

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
    [Config new] save
    exit
}

oo::define App method on_category_new {} {
    if {[set name [EntryForm show "New Category — [tk appname]" \
            "Enter a name for a new category" [$Wldb category_names 1]]] \
            ne ""} {
        set cid [$Wldb category_insert $name]
        my populate
        after idle [my select_category $cid]
    }
}

oo::define App method on_category_rename {} {
    set tcid [my get_tcid]
    if {[string match C* $tcid]} {
        set name [$Tree item $tcid -text]
        if {[set name [EntryForm show "Rename Category — [tk appname]" \
                "Enter a new name for category\n“$name”" \
                [$Wldb category_names 1] $name]] ne ""} {
            set cid [string range $tcid 1 end]
            $Wldb category_update $cid $name
            my populate
            after idle [my select_category $cid]
        }
    }
}

oo::define App method on_category_move_top {} {
    if {[set tcid [my get_tcid]] ne ""} {
        set cid [string range $tcid 1 end]
        $Wldb category_move_top $cid
        my populate
        after idle [my select_category $cid]
    }
}

oo::define App method on_category_move_up {} {
    if {[set tcid [my get_tcid]] ne ""} {
        set cid [string range $tcid 1 end]
        $Wldb category_move_up $cid
        my populate
        after idle [my select_category $cid]
    }
}

oo::define App method on_category_move_down {} {
    if {[set tcid [my get_tcid]] ne ""} {
        set cid [string range $tcid 1 end]
        $Wldb category_move_down $cid
        my populate
        after idle [my select_category $cid]
    }
}

oo::define App method on_category_move_bottom {} {
    if {[set tcid [my get_tcid]] ne ""} {
        set cid [string range $tcid 1 end]
        $Wldb category_move_bottom $cid
        my populate
        after idle [my select_category $cid]
    }
}

oo::define App method on_category_delete {} {
    set tcid [my get_tcid]
    if {$tcid in {C1 C2}} {
        MessageForm show "Delete Category — [tk appname]" \
            "Cannot delete either of the original two categories;
            they can be renamed though." OK warning
        return
    }
    if {[string match C* $tcid]} {
        set cid [string range $tcid 1 end]
        puts "tcid=$tcid cid=$cid [$Wldb wishes_in_category $cid]"
        if {[$Wldb wishes_in_category $cid]} {
            MessageForm show "Delete Category — [tk appname]" \
                "Cannot delete a nonempty category;
                delete its wishes first." OK warning
            return
        }
        set body "Delete category\n“[$Wldb category_name $cid]”?"
        if {[YesNoForm show "Delete Category — [tk appname]" $body no] \
                eq "yes"} {
            $Wldb category_delete $cid
            my populate
            after idle [my select_category C1]
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

oo::define App method on_wish_move_top {} {
    puts on_wish_move_top ;# TODO
}

oo::define App method on_wish_move_up {} {
    puts on_wish_move_up ;# TODO
}

oo::define App method on_wish_move_down {} {
    puts on_wish_move_down ;# TODO
}

oo::define App method on_wish_move_bottom {} {
    puts on_wish_move_bottom ;# TODO
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
