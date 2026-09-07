# Copyright © 2025-26 Mark Summerfield. All rights reserved.

package require tooltip 2

const ::TOOLBAR_FRAME_OPTS "-relief ridge -borderwidth 3"

oo::define App method make_toolbars {} {
    my make_file_toolbar
    my make_reader_toolbar
    my make_group_toolbar
    my make_book_toolbar
}

oo::define App method make_file_toolbar {} {
    set tip tooltip::tooltip
    ttk::frame .mf.tb.ff1 {*}$::TOOLBAR_FRAME_OPTS
    ttk::button .mf.tb.ff1.file_save -style Toolbutton \
        -command [callback on_file_save] \
        -image [ui::icon document-save.svg $::ICON_SIZE]
    $tip .mf.tb.ff1.file_save "File Save"
    ttk::frame .mf.tb.ff2 {*}$::TOOLBAR_FRAME_OPTS
    ttk::button .mf.tb.ff2.file_collapse -style Toolbutton \
        -command [callback on_file_collapse] \
        -image [ui::icon collapse.svg $::ICON_SIZE]
    $tip .mf.tb.ff2.file_collapse "Collase All"
    ttk::button .mf.tb.ff2.file_expand -style Toolbutton \
        -command [callback on_file_expand] \
        -image [ui::icon expand.svg $::ICON_SIZE]
    $tip .mf.tb.ff2.file_expand "Expand All"
}

oo::define App method make_reader_toolbar {} {
    set tip tooltip::tooltip
    ttk::frame .mf.tb.uf1 {*}$::TOOLBAR_FRAME_OPTS
    ttk::button .mf.tb.uf1.reader_new -style Toolbutton \
        -command [callback on_reader_new] \
        -image [ui::icon reader-new.svg $::ICON_SIZE]
    $tip .mf.tb.uf1.reader_new "Reader New"
    ttk::button .mf.tb.uf1.reader_rename -style Toolbutton \
        -command [callback on_reader_rename] \
        -image [ui::icon reader-rename.svg $::ICON_SIZE]
    $tip .mf.tb.uf1.reader_rename "Reader Rename"
    ttk::frame .mf.tb.uf2 {*}$::TOOLBAR_FRAME_OPTS
    ttk::button .mf.tb.uf2.reader_move_top -style Toolbutton \
        -command [callback on_reader_move_first] \
        -image [ui::icon reader-go-top.svg $::ICON_SIZE]
    $tip .mf.tb.uf2.reader_move_top "Reader Move to First"
    ttk::button .mf.tb.uf2.reader_move_up -style Toolbutton \
        -command [callback on_reader_move_up] \
        -image [ui::icon reader-go-up.svg $::ICON_SIZE]
    $tip .mf.tb.uf2.reader_move_up "Reader Move Up"
    ttk::button .mf.tb.uf2.reader_move_down -style Toolbutton \
        -command [callback on_reader_move_down] \
        -image [ui::icon reader-go-down.svg $::ICON_SIZE]
    $tip .mf.tb.uf2.reader_move_down "Reader Move Down"
    ttk::button .mf.tb.uf2.reader_move_bottom -style Toolbutton \
        -command [callback on_reader_move_last] \
        -image [ui::icon reader-go-bottom.svg $::ICON_SIZE]
    $tip .mf.tb.uf2.reader_move_bottom "Reader Move to Last"
}

oo::define App method make_group_toolbar {} {
    set tip tooltip::tooltip
    ttk::frame .mf.tb.cf1 {*}$::TOOLBAR_FRAME_OPTS
    ttk::button .mf.tb.cf1.group_new -style Toolbutton \
        -command [callback on_group_new] \
        -image [ui::icon group-new.svg $::ICON_SIZE]
    $tip .mf.tb.cf1.group_new "Group New"
    ttk::button .mf.tb.cf1.group_rename -style Toolbutton \
        -command [callback on_group_rename] \
        -image [ui::icon group-rename.svg $::ICON_SIZE]
    $tip .mf.tb.cf1.group_rename "Group Rename"
    ttk::frame .mf.tb.cf2 {*}$::TOOLBAR_FRAME_OPTS
    ttk::button .mf.tb.cf2.group_move_top -style Toolbutton \
        -command [callback on_group_move_first] \
        -image [ui::icon go-top.svg $::ICON_SIZE]
    $tip .mf.tb.cf2.group_move_top "Group Move to First"
    ttk::button .mf.tb.cf2.group_move_up -style Toolbutton \
        -command [callback on_group_move_up] \
        -image [ui::icon go-up.svg $::ICON_SIZE]
    $tip .mf.tb.cf2.group_move_up "Group Move Up"
    ttk::button .mf.tb.cf2.group_move_down -style Toolbutton \
        -command [callback on_group_move_down] \
        -image [ui::icon go-down.svg $::ICON_SIZE]
    $tip .mf.tb.cf2.group_move_down "Group Move Down"
    ttk::button .mf.tb.cf2.group_move_bottom -style Toolbutton \
        -command [callback on_group_move_last] \
        -image [ui::icon go-bottom.svg $::ICON_SIZE]
    $tip .mf.tb.cf2.group_move_bottom "Group Move to Last"
    ttk::button .mf.tb.cf2.group_move_to_reader -style Toolbutton \
        -command [callback on_group_move_to_reader] \
        -image [ui::icon group-moveto.svg $::ICON_SIZE]
    $tip .mf.tb.cf2.group_move_to_reader "Group Move to Reader"
}

oo::define App method make_book_toolbar {} {
    set tip tooltip::tooltip
    ttk::frame .mf.tb.wf1 {*}$::TOOLBAR_FRAME_OPTS
    ttk::button .mf.tb.wf1.book_new -style Toolbutton \
        -command [callback on_book_new] \
        -image [ui::icon book-new.svg $::ICON_SIZE]
    $tip .mf.tb.wf1.book_new "Book New"
    ttk::button .mf.tb.wf1.book_edit -style Toolbutton \
        -command [callback on_book_edit] \
        -image [ui::icon book-edit.svg $::ICON_SIZE]
    $tip .mf.tb.wf1.book_edit "Book Edit"
    ttk::button .mf.tb.wf1.book_find -style Toolbutton \
        -command [callback on_book_find] \
        -image [ui::icon book-find.svg $::ICON_SIZE]
    $tip .mf.tb.wf1.book_find "Book Find"
    ttk::button .mf.tb.wf1.book_lookup -style Toolbutton \
        -command [callback on_book_lookup] \
        -image [ui::icon book-lookup.svg $::ICON_SIZE]
    $tip .mf.tb.wf1.book_lookup "Book Lookup"
    ttk::button .mf.tb.wf1.book_copy_clipboard -style Toolbutton \
        -command [callback on_book_copy_to_clipboard] \
        -image [ui::icon edit-copy.svg $::ICON_SIZE]
    $tip .mf.tb.wf1.book_copy_clipboard "Book Copy to Clipboard"
    ttk::button .mf.tb.wf1.book_duplicate -style Toolbutton \
        -command [callback on_book_duplicate] \
        -image [ui::icon book-copy.svg $::ICON_SIZE]
    $tip .mf.tb.wf1.book_duplicate "Book Duplicate"
    ttk::frame .mf.tb.wf2 {*}$::TOOLBAR_FRAME_OPTS
    ttk::button .mf.tb.wf2.book_move_top -style Toolbutton \
        -command [callback on_book_move_first] \
        -image [ui::icon book-go-top.svg $::ICON_SIZE]
    $tip .mf.tb.wf2.book_move_top "Book Move to First"
    ttk::button .mf.tb.wf2.book_move_up -style Toolbutton \
        -command [callback on_book_move_up] \
        -image [ui::icon book-go-up.svg $::ICON_SIZE]
    $tip .mf.tb.wf2.book_move_up "Book Move Up"
    ttk::button .mf.tb.wf2.book_move_down -style Toolbutton \
        -command [callback on_book_move_down] \
        -image [ui::icon book-go-down.svg $::ICON_SIZE]
    $tip .mf.tb.wf2.book_move_down "Book Move Down"
    ttk::button .mf.tb.wf2.book_move_bottom -style Toolbutton \
        -command [callback on_book_move_last] \
        -image [ui::icon book-go-bottom.svg $::ICON_SIZE]
    $tip .mf.tb.wf2.book_move_bottom "Book Move to Last"
    ttk::button .mf.tb.wf2.book_move_to_reader -style Toolbutton \
        -command [callback on_book_move_to_reader_group] \
        -image [ui::icon book-moveto.svg $::ICON_SIZE]
    $tip .mf.tb.wf2.book_move_to_reader "Book Move to Reader/Group"
}

oo::define App method make_toolbars_layout {} {
    my make_file_toolbar_layout
    my make_reader_toolbar_layout
    my make_group_toolbar_layout
    my make_book_toolbar_layout
}

oo::define App method make_file_toolbar_layout {} {
    pack .mf.tb.ff1.file_save -side left
    pack .mf.tb.ff2.file_collapse -side left
    pack .mf.tb.ff2.file_expand -side left
}

oo::define App method make_reader_toolbar_layout {} {
    pack .mf.tb.uf1.reader_new -side left
    pack .mf.tb.uf1.reader_rename -side left
    pack .mf.tb.uf2.reader_move_top -side left
    pack .mf.tb.uf2.reader_move_up -side left
    pack .mf.tb.uf2.reader_move_down -side left
    pack .mf.tb.uf2.reader_move_bottom -side left
}

oo::define App method make_group_toolbar_layout {} {
    pack .mf.tb.cf1.group_new -side left
    pack .mf.tb.cf1.group_rename -side left
    pack .mf.tb.cf2.group_move_top -side left
    pack .mf.tb.cf2.group_move_up -side left
    pack .mf.tb.cf2.group_move_down -side left
    pack .mf.tb.cf2.group_move_bottom -side left
    pack .mf.tb.cf2.group_move_to_reader -side left
}

oo::define App method make_book_toolbar_layout {} {
    const OPTS "-pady 3 -padx 3"
    set n 0
    pack .mf.tb.wf1.book_new -side left
    pack .mf.tb.wf1.book_edit -side left
    pack .mf.tb.wf1.book_find -side left
    pack .mf.tb.wf1.book_lookup -side left
    pack .mf.tb.wf1.book_copy_clipboard -side left
    pack .mf.tb.wf1.book_duplicate -side left
    pack .mf.tb.wf2.book_move_top -side left
    pack .mf.tb.wf2.book_move_up -side left
    pack .mf.tb.wf2.book_move_down -side left
    pack .mf.tb.wf2.book_move_bottom -side left
    pack .mf.tb.wf2.book_move_to_reader -side left
}

oo::define App method refresh_toolbars {} {
    set config [Config new]
    set width [winfo width .mf.tb]
    grid remove .mf.tb.ff1 .mf.tb.ff2 .mf.tb.uf1 .mf.tb.uf2 .mf.tb.cf1 \
                .mf.tb.cf2 .mf.tb.wf1 .mf.tb.wf2
    set row 0
    set column 0
    set show_toolbars 0
    if {[set show_file_toolbar [$config show_file_toolbar]]} {
        my show_toolbar 1 .mf.tb.ff1 width column row
        my show_toolbar 2 .mf.tb.ff2 width column row
        set show_toolbars 1
    }
    if {[set show_reader_toolbar [$config show_reader_toolbar]]} {
        my show_toolbar 2 .mf.tb.uf1 width column row
        my show_toolbar 4 .mf.tb.uf2 width column row
        set show_toolbars 1
    }
    if {[set show_group_toolbar [$config show_group_toolbar]]} {
        my show_toolbar 2 .mf.tb.cf1 width column row
        my show_toolbar 5 .mf.tb.cf2 width column row
        set show_toolbars 1
    }
    if {[set show_book_toolbar [$config show_book_toolbar]]} {
        my show_toolbar 6 .mf.tb.wf1 width column row
        my show_toolbar 5 .mf.tb.wf2 width column row
        set show_toolbars 1
    }
    if {$show_toolbars} {
        grid .mf.tb
    } else {
        grid remove .mf.tb
    }
}

oo::define App method show_toolbar {colspan tb width_ column_ row_} {
    upvar 1 $width_ width $column_ column $row_ row 
    set full_width [winfo width .mf.tb]
    set rwidth [winfo reqwidth $tb]
    if {$rwidth > $width} {
        set width $full_width
        set column 0
        incr row
    }
    grid $tb -row $row -column $column -columnspan $colspan -sticky w
    incr column $colspan
    incr width -$rwidth
}

