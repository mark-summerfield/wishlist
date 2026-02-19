# Copyright © 2025 Mark Summerfield. All rights reserved.

oo::define App method make_menus {} {
    menu .menu
    my make_file_menu
    my make_user_menu
    my make_group_menu
    my make_wish_menu
    . configure -menu .menu
}

oo::define App method make_file_menu {} {
    menu .menu.file
    .menu add cascade -menu .menu.file -label File -underline 0
    .menu.file add command -command [callback on_file_save] \
        -label Save -underline 0 -accelerator Ctrl+S -compound left \
        -image [ui::icon document-save.svg $::MENU_ICON_SIZE]
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

oo::define App method make_user_menu {} {
    menu .menu.user
    .menu add cascade -menu .menu.user -label User -underline 0
    .menu.user add command -command [callback on_user_new] \
        -label New… -underline 0 -compound left \
        -image [ui::icon user-new.svg $::MENU_ICON_SIZE]
    .menu.user add command -command [callback on_user_rename] \
        -label Rename… -underline 0 -compound left \
        -image [ui::icon user-rename.svg $::MENU_ICON_SIZE]
    .menu.user add separator
    .menu.user add command -command [callback on_user_move_first] \
        -label "Move to First" -underline 8 -compound left \
        -image [ui::icon user-go-top.svg $::MENU_ICON_SIZE]
    .menu.user add command -command [callback on_user_move_up] \
        -label "Move Up" -underline 0 -compound left \
        -image [ui::icon user-go-up.svg $::MENU_ICON_SIZE]
    .menu.user add command -command [callback on_user_move_down] \
        -label "Move Down" -underline 5 -compound left \
        -image [ui::icon user-go-down.svg $::MENU_ICON_SIZE]
    .menu.user add command -command [callback on_user_move_last] \
        -label "Move to Last" -underline 8 -compound left \
        -image [ui::icon user-go-bottom.svg $::MENU_ICON_SIZE]
    .menu.user add separator
    .menu.user add command -command [callback on_user_delete] \
        -label Delete… -underline 4 -compound left \
        -image [ui::icon user-delete.svg $::MENU_ICON_SIZE]
}

oo::define App method make_group_menu {} {
    menu .menu.group
    .menu add cascade -menu .menu.group -label Group -underline 0
    .menu.group add command -command [callback on_group_new] \
        -label New… -underline 0 -compound left \
        -image [ui::icon group-new.svg $::MENU_ICON_SIZE]
    .menu.group add command -command [callback on_group_rename] \
        -label Rename… -underline 0 -compound left \
        -image [ui::icon group-rename.svg $::MENU_ICON_SIZE]
    .menu.group add separator
    .menu.group add command -command [callback on_group_move_first] \
        -label "Move to First" -underline 8 -compound left \
        -image [ui::icon go-top.svg $::MENU_ICON_SIZE]
    .menu.group add command -command [callback on_group_move_up] \
        -label "Move Up" -underline 0 -compound left \
        -image [ui::icon go-up.svg $::MENU_ICON_SIZE]
    .menu.group add command -command [callback on_group_move_down] \
        -label "Move Down" -underline 5 -compound left \
        -image [ui::icon go-down.svg $::MENU_ICON_SIZE]
    .menu.group add command -command [callback on_group_move_last] \
        -label "Move to Last" -underline 8 -compound left \
        -image [ui::icon go-bottom.svg $::MENU_ICON_SIZE]
    .menu.group add command -command [callback on_group_move_to_user] \
        -label "Move to User…" -underline 8 -compound left \
        -image [ui::icon group-moveto.svg $::MENU_ICON_SIZE]
    .menu.group add separator
    .menu.group add command -command [callback on_group_delete] \
        -label Delete… -underline 4 -compound left \
        -image [ui::icon group-delete.svg $::MENU_ICON_SIZE]
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
        -label Lookup -underline 3 -compound left \
        -image [ui::icon wish-lookup.svg $::MENU_ICON_SIZE]
    .menu.wish add command -command [callback on_wish_copy] \
        -label "Copy to Clipboard" -underline 0 -compound left \
        -image [ui::icon edit-copy.svg $::MENU_ICON_SIZE]
    .menu.wish add separator
    .menu.wish add command -command [callback on_wish_move_first] \
        -label "Move to First" -underline 8 -compound left \
        -image [ui::icon wish-go-top.svg $::MENU_ICON_SIZE]
    .menu.wish add command -command [callback on_wish_move_up] \
        -label "Move Up" -underline 0 -compound left \
        -image [ui::icon wish-go-up.svg $::MENU_ICON_SIZE]
    .menu.wish add command -command [callback on_wish_move_down] \
        -label "Move Down" -underline 5 -compound left \
        -image [ui::icon wish-go-down.svg $::MENU_ICON_SIZE]
    .menu.wish add command -command [callback on_wish_move_last] \
        -label "Move to Last" -underline 8 -compound left \
        -image [ui::icon wish-go-bottom.svg $::MENU_ICON_SIZE]
    .menu.wish add command -command [callback on_wish_move_to_user_group] \
        -label "Move to User/Group…" -underline 8 -compound left \
        -image [ui::icon wish-moveto.svg $::MENU_ICON_SIZE]
    .menu.wish add separator
    .menu.wish add command -command [callback on_wish_delete] \
        -label Delete… -underline 4 -compound left \
        -image [ui::icon wish-delete.svg $::MENU_ICON_SIZE]
}
