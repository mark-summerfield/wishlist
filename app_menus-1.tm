# Copyright © 2025 Mark Summerfield. All rights reserved.

oo::define App method make_menus {} {
    menu .menu
    my make_file_menu
    my make_category_menu
    my make_wish_menu
    . configure -menu .menu
}

# &File:
#   &Export... (.txt,.html,.csv); &Config...; &About; &Quit ^C
oo::define App method make_file_menu {} {
    menu .menu.file
    .menu add cascade -menu .menu.file -label File -underline 0
    .menu.file add command -command [callback on_file_export] \
        -label Export… -underline 0 -compound left \
        -image [ui::icon export.svg $::MENU_ICON_SIZE]
    .menu.file add separator
    .menu.file add command -command [callback on_config] -label Config… \
        -underline 0 -compound left \
        -image [ui::icon preferences-system.svg $::MENU_ICON_SIZE]
    .menu.file add command -command [callback on_about] -label About \
        -underline 0 -compound left \
        -image [ui::icon about.svg $::MENU_ICON_SIZE]
    .menu.file add separator
    .menu.file add command -command [callback on_quit] -label Quit \
        -underline 0 -accelerator Ctrl+Q  -compound left \
        -image [ui::icon quit.svg $::MENU_ICON_SIZE]
}

# &Category:
#   &New...; &Rename...;
#   Move to &Top; Move &Up; &Move Down; Move to &Bottom;
#   &Delete...
oo::define App method make_category_menu {} {
    menu .menu.category
    .menu add cascade -menu .menu.category -label Category -underline 0
    puts make_category_menu ;# TODO
}

# &Wish:
#   &New... ^N; &Edit... ^E; &Lookup* ^L; &Copy to Clipboard;
#   Move to &Top; Move &Up; &Move Down; Move to &Bottom;
#   &Delete...
oo::define App method make_wish_menu {} {
    menu .menu.wish
    .menu add cascade -menu .menu.wish -label Wish -underline 0
    puts make_wish_menu ;# TODO
}

oo::define App method make_widgets {} {
    set config [Config new]
    ttk::frame .mf ;# main frame
    ttk::frame .mf.tb ;# toolbar
    ttk::frame .mf.tf ;# tree frame
    my make_tree
}

oo::define App method make_tree {} {
    set sa [scrollutil::scrollarea .mf.tf.sa]
    set Tree [ttk::treeview .mf.tf.sa.tree -selectmode browse -striped 1 \
                -columns {name note wid}]
    $sa setwidget $Tree
    pack $sa -fill both -expand 1
    $Tree column #0 -stretch 0
    $Tree column 0 -stretch 1
    $Tree column 1 -stretch 1
    $Tree column 2 -stretch 0
    $Tree heading #0 -text Category
    $Tree heading 0 -text Name/Title
    $Tree heading 1 -text Note
    $Tree heading 2 -text ID/ISBN
}

oo::define App method make_layout {} {
    const opts "-pady 3 -padx 3"
    pack .mf.tb -fill x -side top {*}$opts
    pack .mf.tf -fill both -expand 1 {*}$opts
    pack .mf -fill both -expand 1
}

oo::define App method make_bindings {} {
    bind . <Alt-a> [callback on_about]
    bind . <Alt-c> [callback on_config]
    bind . <Control-q> [callback on_quit]
    bind . <Escape> [callback on_quit]
    wm protocol . WM_DELETE_WINDOW [callback on_quit]
}

oo::define App method populate {} {
    $Tree delete [$Tree children {}]
    set width 0
    foreach category [$Wldb categories] {
        lassign $category cid name _
        $Tree insert {} end -id C$cid -text $name
        if {[set w [font measure TkDefaultFont WW$name]] > $width} {
            set width $w
        }
    }
    $Tree column #0 -width $width
    set name_width 0
    set wid_width 0
    foreach wish [$Wldb wishes] {
        lassign $wish wid name note cid _
        # TODO
        puts "cid=$cid name='$name' note='$note' wid=$wid"
    }
}
