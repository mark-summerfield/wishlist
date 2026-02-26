# Copyright © 2025 Mark Summerfield. All rights reserved.

package require tooltip 2

const ::TOOLBAR_FRAME_OPTS "-relief ridge -borderwidth 3"

oo::define App method make_toolbars {} {
    my make_file_toolbar
    my make_user_toolbar
    my make_group_toolbar
    my make_wish_toolbar
}

oo::define App method make_file_toolbar {} {
    set tip tooltip::tooltip
    ttk::frame .mf.tb.ff1 {*}$::TOOLBAR_FRAME_OPTS
    ttk::button .mf.tb.ff1.file_save -style Toolbutton \
        -command [callback on_file_save] \
        -image [ui::icon document-save.svg $::ICON_SIZE]
    $tip .mf.tb.ff1.file_save "File Save"
}

oo::define App method make_user_toolbar {} {
    set tip tooltip::tooltip
    ttk::frame .mf.tb.uf1 {*}$::TOOLBAR_FRAME_OPTS
    ttk::button .mf.tb.uf1.user_new -style Toolbutton \
        -command [callback on_user_new] \
        -image [ui::icon user-new.svg $::ICON_SIZE]
    $tip .mf.tb.uf1.user_new "User New"
    ttk::button .mf.tb.uf1.user_rename -style Toolbutton \
        -command [callback on_user_rename] \
        -image [ui::icon user-rename.svg $::ICON_SIZE]
    $tip .mf.tb.uf1.user_rename "User Rename"
    ttk::frame .mf.tb.uf2 {*}$::TOOLBAR_FRAME_OPTS
    ttk::button .mf.tb.uf2.user_move_top -style Toolbutton \
        -command [callback on_user_move_first] \
        -image [ui::icon user-go-top.svg $::ICON_SIZE]
    $tip .mf.tb.uf2.user_move_top "User Move to First"
    ttk::button .mf.tb.uf2.user_move_up -style Toolbutton \
        -command [callback on_user_move_up] \
        -image [ui::icon user-go-up.svg $::ICON_SIZE]
    $tip .mf.tb.uf2.user_move_up "User Move Up"
    ttk::button .mf.tb.uf2.user_move_down -style Toolbutton \
        -command [callback on_user_move_down] \
        -image [ui::icon user-go-down.svg $::ICON_SIZE]
    $tip .mf.tb.uf2.user_move_down "User Move Down"
    ttk::button .mf.tb.uf2.user_move_bottom -style Toolbutton \
        -command [callback on_user_move_last] \
        -image [ui::icon user-go-bottom.svg $::ICON_SIZE]
    $tip .mf.tb.uf2.user_move_bottom "User Move to Last"
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
    ttk::button .mf.tb.cf2.group_move_to_user -style Toolbutton \
        -command [callback on_group_move_to_user] \
        -image [ui::icon group-moveto.svg $::ICON_SIZE]
    $tip .mf.tb.cf2.group_move_to_user "Group Move to User"
}

oo::define App method make_wish_toolbar {} {
    set tip tooltip::tooltip
    ttk::frame .mf.tb.wf1 {*}$::TOOLBAR_FRAME_OPTS
    ttk::button .mf.tb.wf1.wish_new -style Toolbutton \
        -command [callback on_wish_new] \
        -image [ui::icon wish-new.svg $::ICON_SIZE]
    $tip .mf.tb.wf1.wish_new "Wish New"
    ttk::button .mf.tb.wf1.wish_edit -style Toolbutton \
        -command [callback on_wish_edit] \
        -image [ui::icon wish-edit.svg $::ICON_SIZE]
    $tip .mf.tb.wf1.wish_edit "Wish Edit"
    ttk::button .mf.tb.wf1.wish_lookup -style Toolbutton \
        -command [callback on_wish_lookup] \
        -image [ui::icon wish-lookup.svg $::ICON_SIZE]
    $tip .mf.tb.wf1.wish_lookup "Wish Lookup"
    ttk::button .mf.tb.wf1.wish_copy -style Toolbutton \
        -command [callback on_wish_copy] \
        -image [ui::icon edit-copy.svg $::ICON_SIZE]
    $tip .mf.tb.wf1.wish_copy "Wish Copy to Clipboard"
    ttk::frame .mf.tb.wf2 {*}$::TOOLBAR_FRAME_OPTS
    ttk::button .mf.tb.wf2.wish_move_top -style Toolbutton \
        -command [callback on_wish_move_first] \
        -image [ui::icon wish-go-top.svg $::ICON_SIZE]
    $tip .mf.tb.wf2.wish_move_top "Wish Move to First"
    ttk::button .mf.tb.wf2.wish_move_up -style Toolbutton \
        -command [callback on_wish_move_up] \
        -image [ui::icon wish-go-up.svg $::ICON_SIZE]
    $tip .mf.tb.wf2.wish_move_up "Wish Move Up"
    ttk::button .mf.tb.wf2.wish_move_down -style Toolbutton \
        -command [callback on_wish_move_down] \
        -image [ui::icon wish-go-down.svg $::ICON_SIZE]
    $tip .mf.tb.wf2.wish_move_down "Wish Move Down"
    ttk::button .mf.tb.wf2.wish_move_bottom -style Toolbutton \
        -command [callback on_wish_move_last] \
        -image [ui::icon wish-go-bottom.svg $::ICON_SIZE]
    $tip .mf.tb.wf2.wish_move_bottom "Wish Move to Last"
    ttk::button .mf.tb.wf2.wish_move_to_user -style Toolbutton \
        -command [callback on_wish_move_to_user_group] \
        -image [ui::icon wish-moveto.svg $::ICON_SIZE]
    $tip .mf.tb.wf2.wish_move_to_user "Wish Move to User/Group"
}

oo::define App method make_toolbars_layout {} {
    my make_file_toolbar_layout
    my make_user_toolbar_layout
    my make_group_toolbar_layout
    my make_wish_toolbar_layout
}

oo::define App method make_file_toolbar_layout {} {
    pack .mf.tb.ff1.file_save -side left
}

oo::define App method make_user_toolbar_layout {} {
    pack .mf.tb.uf1.user_new -side left
    pack .mf.tb.uf1.user_rename -side left
    pack .mf.tb.uf2.user_move_top -side left
    pack .mf.tb.uf2.user_move_up -side left
    pack .mf.tb.uf2.user_move_down -side left
    pack .mf.tb.uf2.user_move_bottom -side left
}

oo::define App method make_group_toolbar_layout {} {
    pack .mf.tb.cf1.group_new -side left
    pack .mf.tb.cf1.group_rename -side left
    pack .mf.tb.cf2.group_move_top -side left
    pack .mf.tb.cf2.group_move_up -side left
    pack .mf.tb.cf2.group_move_down -side left
    pack .mf.tb.cf2.group_move_bottom -side left
    pack .mf.tb.cf2.group_move_to_user -side left
}

oo::define App method make_wish_toolbar_layout {} {
    const OPTS "-pady 3 -padx 3"
    set n 0
    pack .mf.tb.wf1.wish_new -side left
    pack .mf.tb.wf1.wish_edit -side left
    pack .mf.tb.wf1.wish_lookup -side left
    pack .mf.tb.wf1.wish_copy -side left
    pack .mf.tb.wf2.wish_move_top -side left
    pack .mf.tb.wf2.wish_move_up -side left
    pack .mf.tb.wf2.wish_move_down -side left
    pack .mf.tb.wf2.wish_move_bottom -side left
    pack .mf.tb.wf2.wish_move_to_user -side left
}

oo::define App method refresh_toolbars {} {
    set config [Config new]
    set width [winfo width .mf.tb]
    grid remove .mf.tb.ff1 .mf.tb.uf1 .mf.tb.uf2 .mf.tb.cf1 .mf.tb.cf2 \
                .mf.tb.wf1 .mf.tb.wf2
    set row 0
    set column 0
    set show_toolbars 0
    if {[set show_file_toolbar [$config show_file_toolbar]]} {
        my show_toolbar 1 .mf.tb.ff1 width column row
        set show_toolbars 1
    }
    if {[set show_user_toolbar [$config show_user_toolbar]]} {
        my show_toolbar 2 .mf.tb.uf1 width column row
        my show_toolbar 4 .mf.tb.uf2 width column row
        set show_toolbars 1
    }
    if {[set show_group_toolbar [$config show_group_toolbar]]} {
        my show_toolbar 2 .mf.tb.cf1 width column row
        my show_toolbar 4 .mf.tb.cf2 width column row
        set show_toolbars 1
    }
    if {[set show_wish_toolbar [$config show_wish_toolbar]]} {
        my show_toolbar 4 .mf.tb.wf1 width column row
        my show_toolbar 4 .mf.tb.wf2 width column row
        set show_toolbars 1
    }
    if {$show_toolbars} {
        grid .mf.tb
    } else {
        grid remove .mf.tb
    }
}

oo::define App method show_toolbar {colspan tb width column row} {
    upvar 1 $width width_ $column column_ $row row_ 
    set full_width [winfo width .mf.tb]
    set rwidth [winfo reqwidth $tb]
    if {$rwidth > $width_} {
        set width_ $full_width
        set column_ 0
        incr row_
    }
    grid $tb -row $row_ -column $column_ -columnspan $colspan -sticky w
    incr column_ $colspan
    incr width_ -$rwidth
}

