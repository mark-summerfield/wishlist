# Copyright © 2025-26 Mark Summerfield. All rights reserved.

package require abstract_form
package require tooltip 2
package require ui

oo::class create MoveBookForm {
    superclass AbstractForm

    variable Db
    variable Bid
    variable ReaderCombo
    variable GroupCombo
}

oo::define MoveBookForm classmethod show {db bid} {
    set form [MoveBookForm new $db $bid]
    tkwait window .move_book_form
}

oo::define MoveBookForm constructor {db bid} {
    set Db $db
    set Bid $bid
    my make_widgets
    my make_layout
    my make_bindings
    my on_change_reader
    next .move_book_form [callback on_cancel]
    my show_modal $ReaderCombo
}

oo::define MoveBookForm method make_widgets {} {
    tk::toplevel .move_book_form
    wm minsize .move_book_form 560 140
    wm title .move_book_form "[tk appname] — Move Book to Reader/Group"
    ttk::frame .move_book_form.mf
    set tip tooltip::tooltip
    ttk::label .move_book_form.mf.reader_label -text Reader -underline 0
    set ReaderCombo [ttk::combobox .move_book_form.mf.reader_combobox \
        -state readonly -values [$Db reader_names]]
    $ReaderCombo set [$Db item_text [$Db reader_id]]
    ttk::label .move_book_form.mf.group_label -text Group -underline 0
    set GroupCombo [ttk::combobox .move_book_form.mf.group_combobox \
        -state readonly]
    ttk::label .move_book_form.mf.book_label_label -text Book
    set book [$Db book $Bid]
    try {
        ttk::label .move_book_form.mf.book_label \
            -text "“[$book title]” by “[$book author]”"
    } finally {
        $book destroy
    }
    ttk::frame .move_book_form.mf.bf
    ttk::button .move_book_form.mf.bf.ok_button -text OK -underline 0 \
        -compound left -image [ui::icon ok.svg $::ICON_SIZE] \
        -command [callback on_ok]
    ttk::button .move_book_form.mf.bf.cancel_button -text Cancel \
        -compound left -command [callback on_cancel] \
        -image [ui::icon gtk-cancel.svg $::ICON_SIZE]
}

oo::define MoveBookForm method make_layout {} {
    const opts "-padx 3 -pady 3"
    grid .move_book_form.mf.reader_label -row 0 -column 0 -sticky w {*}$opts
    grid $ReaderCombo -row 0 -column 1 -columnspan 2 -sticky we {*}$opts
    grid .move_book_form.mf.group_label -row 1 -column 0 -sticky w {*}$opts
    grid $GroupCombo -row 1 -column 1 -columnspan 2 -sticky we {*}$opts
    grid .move_book_form.mf.book_label_label -row 2 -column 0 -sticky w \
        {*}$opts
    grid .move_book_form.mf.book_label -row 2 -column 1 -columnspan 2 \
        -sticky we {*}$opts
    grid .move_book_form.mf.bf -row 9 -column 0 -columnspan 3 \
        -sticky we
    pack [ttk::frame .move_book_form.mf.bf.pad1] -side left -expand 1
    pack .move_book_form.mf.bf.ok_button -side left {*}$opts
    pack .move_book_form.mf.bf.cancel_button -side left {*}$opts
    pack [ttk::frame .move_book_form.mf.bf.pad2] -side right -expand 1
    grid columnconfigure .move_book_form.mf 1 -weight 1
    pack .move_book_form.mf -fill both -expand 1
}

oo::define MoveBookForm method make_bindings {} {
    bind $ReaderCombo <<ComboboxSelected>> [callback on_change_reader]
    bind .move_book_form <Escape> [callback on_cancel]
    bind .move_book_form <Return> [callback on_ok]
    bind .move_book_form <Alt-g> {focus .move_book_form.mf.group_combobox}
    bind .move_book_form <Alt-o> [callback on_ok]
    bind .move_book_form <Alt-r> {focus .move_book_form.mf.reader_combobox}
}

oo::define MoveBookForm method on_change_reader {} {
    set reader [$ReaderCombo get]
    set rid [$Db reader_id_for_name $reader]
    set groups [$Db group_names $rid]
    $GroupCombo configure -values $groups
    set group [$Db item_text [$Db group_id]]
    if {[set i [lsearch -exact $groups $group]] == -1} { set i 0 }
    set group [lindex $groups $i]
    $GroupCombo set $group
}

oo::define MoveBookForm method on_ok {} {
    set rid [$Db reader_id_for_name [$ReaderCombo get]]
    set gid [$Db group_id_for_name $rid [$GroupCombo get]]
    $Db book_move_to_reader_group $rid $gid $Bid
    my delete
}

oo::define MoveBookForm method on_cancel {} { my delete }
