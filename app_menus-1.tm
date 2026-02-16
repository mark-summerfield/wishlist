# Copyright © 2025 Mark Summerfield. All rights reserved.

oo::define App method make_menus {} {
    menu .menu
    my make_file_menu
    my make_category_menu
    my make_wish_menu
    . configure -menu .menu
}

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

oo::define App method make_category_menu {} {
    menu .menu.category
    .menu add cascade -menu .menu.category -label Category -underline 0
    .menu.category add command -command [callback on_category_new] \
        -label New… -underline 0 -compound left \
        -image [ui::icon category-new.svg $::MENU_ICON_SIZE]
    .menu.category add command -command [callback on_category_rename] \
        -label Rename… -underline 0 -compound left \
        -image [ui::icon category-rename.svg $::MENU_ICON_SIZE]
    .menu.category add separator
    .menu.category add command -command [callback on_category_move_top] \
        -label "Move to Top" -underline 8 -compound left \
        -image [ui::icon go-top.svg $::MENU_ICON_SIZE]
    .menu.category add command -command [callback on_category_move_up] \
        -label "Move Up" -underline 5 -compound left \
        -image [ui::icon go-up.svg $::MENU_ICON_SIZE]
    .menu.category add command -command [callback on_category_move_down] \
        -label "Move Down" -underline 0 -compound left \
        -image [ui::icon go-down.svg $::MENU_ICON_SIZE]
    .menu.category add command -command [callback on_category_move_bottom] \
        -label "Move to Bottom" -underline 8 -compound left \
        -image [ui::icon go-bottom.svg $::MENU_ICON_SIZE]
    .menu.category add separator
    .menu.category add command -command [callback on_category_delete] \
        -label Delete… -underline 0 -compound left \
        -image [ui::icon category-delete.svg $::MENU_ICON_SIZE]
}

oo::define App method make_wish_menu {} {
    menu .menu.wish
    .menu add cascade -menu .menu.wish -label Wish -underline 0
    .menu.wish add command -command [callback on_wish_new] \
        -label New… -underline 0 -compound left \
        -image [ui::icon wish-new.svg $::MENU_ICON_SIZE]
    .menu.wish add command -command [callback on_wish_edit] \
        -label Edit… -underline 0 -compound left \
        -image [ui::icon wish-edit.svg $::MENU_ICON_SIZE]
    .menu.wish add command -command [callback on_wish_lookup] \
        -label Lookup -underline 0 -compound left \
        -image [ui::icon wish-lookup.svg $::MENU_ICON_SIZE]
    .menu.wish add command -command [callback on_wish_copy] \
        -label "Copy to Clipboard" -underline 0 -compound left \
        -image [ui::icon edit-copy.svg $::MENU_ICON_SIZE]
    .menu.wish add separator
    .menu.wish add command -command [callback on_wish_move_top] \
        -label "Move to Top" -underline 8 -compound left \
        -image [ui::icon wish-go-top.svg $::MENU_ICON_SIZE]
    .menu.wish add command -command [callback on_wish_move_up] \
        -label "Move Up" -underline 5 -compound left \
        -image [ui::icon wish-go-up.svg $::MENU_ICON_SIZE]
    .menu.wish add command -command [callback on_wish_move_down] \
        -label "Move Down" -underline 0 -compound left \
        -image [ui::icon wish-go-down.svg $::MENU_ICON_SIZE]
    .menu.wish add command -command [callback on_wish_move_bottom] \
        -label "Move to Bottom" -underline 8 -compound left \
        -image [ui::icon wish-go-bottom.svg $::MENU_ICON_SIZE]
    .menu.wish add separator
    .menu.wish add command -command [callback on_wish_delete] \
        -label Delete… -underline 0 -compound left \
        -image [ui::icon wish-delete.svg $::MENU_ICON_SIZE]
}
