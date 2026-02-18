# Copyright © 2025 Mark Summerfield. All rights reserved.

package require tooltip 2

const ::TOOLBAR_FRAME_OPTS "-relief ridge -borderwidth 3"

oo::define App method make_toolbars {} {
    my make_user_toolbar
    my make_group_toolbar
    my make_wish_toolbar
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
}

oo::define App method make_toolbar_layout {} {
    my make_user_toolbar_layout
    my make_group_toolbar_layout
    my make_wish_toolbar_layout
}

oo::define App method make_user_toolbar_layout {} {
    const OPTS "-pady 3 -padx 3"
    set n 0
    pack .mf.tb.uf1 -side left
    pack .mf.tb.uf1.user_new -side left
    pack .mf.tb.uf1.user_rename -side left
    pack .mf.tb.uf2 -side left
    pack .mf.tb.uf2.user_move_top -side left
    pack .mf.tb.uf2.user_move_up -side left
    pack .mf.tb.uf2.user_move_down -side left
    pack .mf.tb.uf2.user_move_bottom -side left
}

oo::define App method make_group_toolbar_layout {} {
    const OPTS "-pady 3 -padx 3"
    set n 0
    pack .mf.tb.cf1 -side left
    pack .mf.tb.cf1.group_new -side left
    pack .mf.tb.cf1.group_rename -side left
    pack .mf.tb.cf2 -side left
    pack .mf.tb.cf2.group_move_top -side left
    pack .mf.tb.cf2.group_move_up -side left
    pack .mf.tb.cf2.group_move_down -side left
    pack .mf.tb.cf2.group_move_bottom -side left
}

oo::define App method make_wish_toolbar_layout {} {
    const OPTS "-pady 3 -padx 3"
    set n 0
    pack .mf.tb.wf1 -side left
    pack .mf.tb.wf1.wish_new -side left
    pack .mf.tb.wf1.wish_edit -side left
    pack .mf.tb.wf1.wish_lookup -side left
    pack .mf.tb.wf1.wish_copy -side left
    pack .mf.tb.wf2 -side left
    pack .mf.tb.wf2.wish_move_top -side left
    pack .mf.tb.wf2.wish_move_up -side left
    pack .mf.tb.wf2.wish_move_down -side left
    pack .mf.tb.wf2.wish_move_bottom -side left
}
