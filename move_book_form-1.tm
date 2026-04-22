# Copyright © 2025-26 Mark Summerfield. All rights reserved.

package require abstract_form
package require tooltip 2
package require ui

oo::class create MoveBookForm {
    superclass AbstractForm

    variable Ok
    variable Db
    variable Rid
    variable Gid
    variable Bid
}

oo::define MoveBookForm classmethod show {db bid} {
    set Ok [Ref new 0]
    set form [MoveBookForm new $Ok $db $bid]
    tkwait window .move_book_form
    $Ok get
}

oo::define MoveBookForm constructor {ok db bid} {
    set Ok $ok
    set Db $db
    set Rid [$Db reader_id]
    set Gid [$Db group_id]
    set Bid $bid
    my make_widgets
    my make_layout
    my make_bindings
    next .move_book_form [callback on_cancel]
    my show_modal .move_book_form.mf.reader_combobox
}

oo::define MoveBookForm method make_widgets {} {
    tk::toplevel .move_book_form
    wm minsize .move_book_form 560 140
    wm title .move_book_form "[tk appname] — Move Book to Reader/Group"
    ttk::frame .move_book_form.mf
    set tip tooltip::tooltip
    ttk::label .move_book_form.mf.reader_label -text Reader -underline 0
    ttk::combobox .move_book_form.mf.reader_combobox \
        -values [$Db reader_names]
    # TODO select current reader
    ttk::label .move_book_form.mf.group_label -text Group -underline 0
    ttk::combobox .move_book_form.mf.group_combobox \
        -values [$Db group_names $Rid]
    # TODO select current group
    ttk::label .move_book_form.mf.book_label_label -text Book
    # TODO Title by Author
    ttk::label .move_book_form.mf.book_label -text ""
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
    grid .move_book_form.mf.reader_combobox -row 0 -column 1 -columnspan 2 \
        -sticky we {*}$opts
    grid .move_book_form.mf.group_label -row 1 -column 0 -sticky w {*}$opts
    grid .move_book_form.mf.group_combobox -row 1 -column 1 -columnspan 2 \
        -sticky we {*}$opts
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
    # TODO if reader changes update group names combobox & choose Gid if
    # present otherwise choose first group
    bind .move_book_form <Escape> [callback on_cancel]
    bind .move_book_form <Return> [callback on_ok]
    bind .move_book_form <Alt-g> {focus .move_book_form.mf.group_combobox}
    bind .move_book_form <Alt-r> {focus .move_book_form.mf.reader_combobox}
    bind .move_book_form <Alt-o> [callback on_ok]
}

oo::define MoveBookForm method on_ok {} {
    $Db book_move_to_reader_group $Rid $Gid $Bid
    $Ok set 1
    my delete
}

oo::define MoveBookForm method on_cancel {} { my delete }
