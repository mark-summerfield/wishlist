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
