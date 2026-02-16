# Copyright © 2025 Mark Summerfield. All rights reserved.

oo::define App method on_file_export {} {
    puts on_file_export
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
    puts on_category_new
}

oo::define App method on_category_rename {} {
    puts on_category_rename
}

oo::define App method on_category_move_top {} {
    puts on_category_move_top
}

oo::define App method on_category_move_up {} {
    puts on_category_move_up
}

oo::define App method on_category_move_down {} {
    puts on_category_move_down
}

oo::define App method on_category_move_bottom {} {
    puts on_category_move_bottom
}

oo::define App method on_category_delete {} {
    puts on_category_delete
}

oo::define App method on_wish_new {} {
    puts on_wish_new
}

oo::define App method on_wish_edit {} {
    puts on_wish_edit
}

oo::define App method on_wish_lookup {} {
    puts on_wish_lookup
}

oo::define App method on_wish_copy {} {
    puts on_wish_copy
}

oo::define App method on_wish_move_top {} {
    puts on_wish_move_top
}

oo::define App method on_wish_move_up {} {
    puts on_wish_move_up
}

oo::define App method on_wish_move_down {} {
    puts on_wish_move_down
}

oo::define App method on_wish_move_bottom {} {
    puts on_wish_move_bottom
}

oo::define App method on_wish_delete {} {
    puts on_wish_delete
}
