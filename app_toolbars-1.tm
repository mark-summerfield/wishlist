# Copyright © 2025 Mark Summerfield. All rights reserved.

package require tooltip 2

const ::TOOLBAR_FRAME_OPTS "-relief ridge -borderwidth 3"

oo::define App method make_toolbars {} {
    my make_category_toolbar
    my make_wish_toolbar
}

oo::define App method make_category_toolbar {} {
    set tip tooltip::tooltip
    ttk::frame .mf.tb.cf1 {*}$::TOOLBAR_FRAME_OPTS
    ttk::button .mf.tb.cf1.category_new -style Toolbutton \
        -command [callback on_category_new] \
        -image [ui::icon category-new.svg $::ICON_SIZE]
    $tip .mf.tb.cf1.category_new "Category New"
    ttk::button .mf.tb.cf1.category_rename -style Toolbutton \
        -command [callback on_category_rename] \
        -image [ui::icon category-rename.svg $::ICON_SIZE]
    $tip .mf.tb.cf1.category_rename "Category Rename"
    ttk::frame .mf.tb.cf2 {*}$::TOOLBAR_FRAME_OPTS
    ttk::button .mf.tb.cf2.category_move_top -style Toolbutton \
        -command [callback on_category_move_top] \
        -image [ui::icon go-top.svg $::ICON_SIZE]
    $tip .mf.tb.cf2.category_move_top "Category Move Top"
    ttk::button .mf.tb.cf2.category_move_up -style Toolbutton \
        -command [callback on_category_move_up] \
        -image [ui::icon go-up.svg $::ICON_SIZE]
    $tip .mf.tb.cf2.category_move_up "Category Move Up"
    ttk::button .mf.tb.cf2.category_move_down -style Toolbutton \
        -command [callback on_category_move_down] \
        -image [ui::icon go-down.svg $::ICON_SIZE]
    $tip .mf.tb.cf2.category_move_down "Category Move Down"
    ttk::button .mf.tb.cf2.category_move_bottom -style Toolbutton \
        -command [callback on_category_move_bottom] \
        -image [ui::icon go-bottom.svg $::ICON_SIZE]
    $tip .mf.tb.cf2.category_move_bottom "Category Move Bottom"
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
        -command [callback on_wish_move_top] \
        -image [ui::icon wish-go-top.svg $::ICON_SIZE]
    $tip .mf.tb.wf2.wish_move_top "Wish Move Top"
    ttk::button .mf.tb.wf2.wish_move_up -style Toolbutton \
        -command [callback on_wish_move_up] \
        -image [ui::icon wish-go-up.svg $::ICON_SIZE]
    $tip .mf.tb.wf2.wish_move_up "Wish Move Up"
    ttk::button .mf.tb.wf2.wish_move_down -style Toolbutton \
        -command [callback on_wish_move_down] \
        -image [ui::icon wish-go-down.svg $::ICON_SIZE]
    $tip .mf.tb.wf2.wish_move_down "Wish Move Down"
    ttk::button .mf.tb.wf2.wish_move_bottom -style Toolbutton \
        -command [callback on_wish_move_bottom] \
        -image [ui::icon wish-go-bottom.svg $::ICON_SIZE]
    $tip .mf.tb.wf2.wish_move_bottom "Wish Move Bottom"
}

oo::define App method make_toolbar_layout {} {
    my make_category_toolbar_layout
    my make_wish_toolbar_layout
}

oo::define App method make_category_toolbar_layout {} {
    const OPTS "-pady 3 -padx 3"
    set n 0
    pack .mf.tb.cf1 -side left
    pack .mf.tb.cf1.category_new -side left
    pack .mf.tb.cf1.category_rename -side left
    pack .mf.tb.cf2 -side left
    pack .mf.tb.cf2.category_move_top -side left
    pack .mf.tb.cf2.category_move_up -side left
    pack .mf.tb.cf2.category_move_down -side left
    pack .mf.tb.cf2.category_move_bottom -side left
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
