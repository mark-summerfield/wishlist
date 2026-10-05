# Copyright © 2025-26 Mark Summerfield. All rights reserved.

oo::define App method make_menus {} {
    menu .menu
    my make_file_menu
    my make_reader_menu
    my make_group_menu
    my make_book_menu
    $Toolbars new_menu .menu {File Tree "Edit Reader" "Move Reader" \
            "Edit Group" "Move Group" "Edit Book" "Move Book"}
    . configure -menu .menu
}

oo::define App method make_file_menu {} {
    menu .menu.file
    .menu add cascade -menu .menu.file -label File -underline 0
    .menu.file add command -command [callback on_file_save] \
        -label Save -underline 0 -accelerator Ctrl+S -compound left \
        -image [ui::icon document-save.svg $::MENU_ICON_SIZE]
    .menu.file add separator
    .menu.file add command -command [callback on_file_collapse] \
        -label "Collapse All" -underline 1 -compound left \
        -image [ui::icon collapse.svg $::MENU_ICON_SIZE]
    .menu.file add command -command [callback on_file_expand] \
        -label "Expand All" -underline 0 -compound left \
        -image [ui::icon expand.svg $::MENU_ICON_SIZE]
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

oo::define App method make_reader_menu {} {
    menu .menu.reader
    .menu add cascade -menu .menu.reader -label Reader -underline 0
    .menu.reader add command -command [callback on_reader_new] \
        -label New… -underline 0 -compound left \
        -image [ui::icon reader-new.svg $::MENU_ICON_SIZE]
    .menu.reader add command -command [callback on_reader_rename] \
        -label Rename… -underline 0 -compound left \
        -image [ui::icon reader-rename.svg $::MENU_ICON_SIZE]
    .menu.reader add separator
    if {$::CAIRO} {
        .menu.reader add command -command [callback on_reader_export_pdf] \
            -label "Export to PDF…" -underline 1 -compound left \
            -image [ui::icon pdf.svg $::MENU_ICON_SIZE]
        .menu.reader add separator
    }
    .menu.reader add command -command [callback on_reader_move_first] \
        -label "Move to First" -underline 8 -compound left \
        -image [ui::icon reader-go-top.svg $::MENU_ICON_SIZE]
    .menu.reader add command -command [callback on_reader_move_up] \
        -label "Move Up" -underline 5 -compound left \
        -image [ui::icon reader-go-up.svg $::MENU_ICON_SIZE]
    .menu.reader add command -command [callback on_reader_move_down] \
        -label "Move Down" -underline 5 -compound left \
        -image [ui::icon reader-go-down.svg $::MENU_ICON_SIZE]
    .menu.reader add command -command [callback on_reader_move_last] \
        -label "Move to Last" -underline 8 -compound left \
        -image [ui::icon reader-go-bottom.svg $::MENU_ICON_SIZE]
    .menu.reader add separator
    .menu.reader add command -command [callback on_reader_delete] \
        -label Delete… -underline 4 -compound left \
        -image [ui::icon reader-delete.svg $::MENU_ICON_SIZE]
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
        -label "Move Up" -underline 5 -compound left \
        -image [ui::icon go-up.svg $::MENU_ICON_SIZE]
    .menu.group add command -command [callback on_group_move_down] \
        -label "Move Down" -underline 5 -compound left \
        -image [ui::icon go-down.svg $::MENU_ICON_SIZE]
    .menu.group add command -command [callback on_group_move_last] \
        -label "Move to Last" -underline 8 -compound left \
        -image [ui::icon go-bottom.svg $::MENU_ICON_SIZE]
    .menu.group add command -command [callback on_group_move_to_reader] \
        -label "Move to Reader…" -underline 0 -compound left \
        -image [ui::icon group-moveto.svg $::MENU_ICON_SIZE]
    .menu.group add separator
    .menu.group add command -command [callback on_group_delete] \
        -label Delete… -underline 4 -compound left \
        -image [ui::icon group-delete.svg $::MENU_ICON_SIZE]
}

oo::define App method make_book_menu {} {
    menu .menu.book
    .menu add cascade -menu .menu.book -label Book -underline 0
    .menu.book add command -command [callback on_book_new] \
        -label New… -underline 0 -compound left -accelerator Ctrl+N \
        -image [ui::icon book-new.svg $::MENU_ICON_SIZE]
    .menu.book add command -command [callback on_book_edit] \
        -label Edit… -underline 0 -compound left -accelerator Ctrl+E \
        -image [ui::icon book-edit.svg $::MENU_ICON_SIZE]
    .menu.book add command -command [callback on_book_find] \
        -label Find -underline 1 -compound left -accelerator Ctrl+F \
        -image [ui::icon book-find.svg $::MENU_ICON_SIZE]
    .menu.book add command -command [callback on_book_find_again] \
        -label "Find Again" -underline 5 -compound left -accelerator F3 \
        -image [ui::icon book-find-again.svg $::MENU_ICON_SIZE]
    .menu.book add command -command [callback on_book_lookup] \
        -label Lookup -underline 1 -compound left -accelerator Ctrl+L \
        -image [ui::icon book-lookup.svg $::MENU_ICON_SIZE]
    .menu.book add command -command [callback on_book_copy_to_clipboard] \
        -label "Copy to Clipboard" -underline 0 -compound left \
        -image [ui::icon edit-copy.svg $::MENU_ICON_SIZE]
    .menu.book add command -command [callback on_book_duplicate] \
        -label Duplicate -underline 2 -compound left \
        -image [ui::icon book-copy.svg $::MENU_ICON_SIZE]
    .menu.book add separator
    .menu.book add command -command [callback on_book_move_first] \
        -label "Move to First" -underline 8 -compound left \
        -image [ui::icon book-go-top.svg $::MENU_ICON_SIZE]
    .menu.book add command -command [callback on_book_move_up] \
        -label "Move Up" -underline 5 -compound left \
        -image [ui::icon book-go-up.svg $::MENU_ICON_SIZE]
    .menu.book add command -command [callback on_book_move_down] \
        -label "Move Down" -underline 5 -compound left \
        -image [ui::icon book-go-down.svg $::MENU_ICON_SIZE]
    .menu.book add command -command [callback on_book_move_last] \
        -label "Move to Last" -underline 8 -compound left \
        -image [ui::icon book-go-bottom.svg $::MENU_ICON_SIZE]
    .menu.book add command \
        -command [callback on_book_move_to_reader_group] \
        -label "Move to Reader/Group…" -underline 0 -compound left \
        -image [ui::icon book-moveto.svg $::MENU_ICON_SIZE]
    .menu.book add separator
    .menu.book add command -command [callback on_book_delete] \
        -label Delete… -underline 4 -compound left \
        -image [ui::icon book-delete.svg $::MENU_ICON_SIZE]
}
