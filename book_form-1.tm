# Copyright © 2025-26 Mark Summerfield. All rights reserved.

package require abstract_form
package require book
package require http 2
package require json 1
package require tooltip 2
package require ui
package require valtype::isbn 1

oo::class create BookForm {
    superclass AbstractForm

    variable Ok
    variable Book
}

oo::define BookForm classmethod show {reader group book} {
    set Ok [Ref new 0]
    set form [BookForm new $Ok $reader $group $book]
    tkwait window .book_form
    $Ok get
}

oo::define BookForm constructor {ok reader group book} {
    set Ok $ok
    set Book $book
    my make_widgets $reader $group
    my make_layout
    my make_bindings
    my prepare
    next .book_form [callback on_cancel]
    my show_modal .book_form.mf.title_entry
}

oo::define BookForm method make_widgets {reader group} {
    tk::toplevel .book_form
    wm minsize .book_form 560 210
    set action [expr {[$Book is_valid] ? "Edit" : "New"}]
    wm title .book_form "[tk appname] — $action Book"
    ttk::frame .book_form.mf
    set tip tooltip::tooltip
    ttk::label .book_form.mf.place_label_label -text "Reader/Group"
    ttk::label .book_form.mf.place_label -text "$reader/$group" \
        -relief sunken -foreground #505050
    ttk::label .book_form.mf.title_label -text Title -underline 0
    ttk::entry .book_form.mf.title_entry -placeholder Title -validate key
    ui::apply_edit_bindings .book_form.mf.title_entry
    if {[$Book is_valid]} {
        .book_form.mf.title_entry insert 0 [$Book title]
    }
    ttk::label .book_form.mf.author_label -text Author -underline 0
    ttk::entry .book_form.mf.author_entry -placeholder Author
    ui::apply_edit_bindings .book_form.mf.author_entry
    if {[$Book is_valid]} {
        .book_form.mf.author_entry insert 0 [$Book author]
    }
    ttk::label .book_form.mf.note_label -text Note -underline 0
    ttk::entry .book_form.mf.note_entry -placeholder Note
    ui::apply_edit_bindings .book_form.mf.note_entry
    if {[$Book is_valid]} {
        .book_form.mf.note_entry insert 0 [$Book note]
    }
    ttk::label .book_form.mf.isbn_label -text ISBN -underline 0
    ttk::entry .book_form.mf.isbn_entry -placeholder ISBN -validate key
    ui::apply_edit_bindings .book_form.mf.isbn_entry
    if {[$Book is_valid]} { .book_form.mf.isbn_entry insert 0 [$Book isbn] }
    ttk::label .book_form.mf.isbn_flag_label -text ?
    ttk::frame .book_form.mf.bf
    ttk::button .book_form.mf.bf.complete_button -text Complete \
        -underline 0 -compound left \
        -image [ui::icon complete.svg $::ICON_SIZE] \
        -command [callback on_complete]
    if {[$Book title] ne "" && [$Book author] ne ""} {
        .book_form.mf.bf.complete_button configure -state disabled
    }
    ttk::button .book_form.mf.bf.ok_button -text OK -underline 0 \
        -compound left -image [ui::icon ok.svg $::ICON_SIZE] \
        -command [callback on_ok]
    ttk::button .book_form.mf.bf.cancel_button -text Cancel \
        -compound left -command [callback on_cancel] \
        -image [ui::icon gtk-cancel.svg $::ICON_SIZE]
}

oo::define BookForm method prepare {} {
    .book_form.mf.title_entry configure \
        -validatecommand [callback on_validate_title %P]
    .book_form.mf.isbn_entry configure \
        -validatecommand [callback on_validate_id %P]
    if {[$Book is_valid]} {
        my on_validate_id [$Book isbn]
    } else {
        my on_validate_title ""
    }
}

oo::define BookForm method make_layout {} {
    const opts "-padx 3 -pady 3"
    grid .book_form.mf.place_label_label -row 0 -column 0 -sticky w {*}$opts
    grid .book_form.mf.place_label -row 0 -column 1 -columnspan 2 \
        -sticky we {*}$opts
    grid .book_form.mf.title_label -row 1 -column 0 -sticky w {*}$opts
    grid .book_form.mf.title_entry -row 1 -column 1 -columnspan 2 \
        -sticky we {*}$opts
    grid .book_form.mf.author_label -row 2 -column 0 -sticky w {*}$opts
    grid .book_form.mf.author_entry -row 2 -column 1 -columnspan 2 \
        -sticky we {*}$opts
    grid .book_form.mf.note_label -row 3 -column 0 -sticky w {*}$opts
    grid .book_form.mf.note_entry -row 3 -column 1 -columnspan 2 \
        -sticky we {*}$opts
    grid .book_form.mf.isbn_label -row 4 -column 0 -sticky w {*}$opts
    grid .book_form.mf.isbn_entry -row 4 -column 1 -sticky we {*}$opts
    grid .book_form.mf.isbn_flag_label -row 4 -column 2 -sticky w {*}$opts
    grid .book_form.mf.bf -row 9 -column 0 -columnspan 3 \
        -sticky we
    pack [ttk::frame .book_form.mf.bf.pad1] -side left -expand 1
    pack .book_form.mf.bf.complete_button -side left {*}$opts
    pack .book_form.mf.bf.ok_button -side left {*}$opts
    pack .book_form.mf.bf.cancel_button -side left {*}$opts
    pack [ttk::frame .book_form.mf.bf.pad2] -side right -expand 1
    grid columnconfigure .book_form.mf 1 -weight 1
    pack .book_form.mf -fill both -expand 1
}

oo::define BookForm method make_bindings {} {
    bind .book_form <Escape> [callback on_cancel]
    bind .book_form <Return> [callback on_ok]
    bind .book_form <Alt-a> {focus .book_form.mf.author_entry}
    bind .book_form <Alt-c> [callback on_complete]
    bind .book_form <Alt-i> {focus .book_form.mf.isbn_entry}
    bind .book_form <Alt-n> {focus .book_form.mf.note_entry}
    bind .book_form <Alt-o> [callback on_ok]
    bind .book_form <Alt-t> {focus .book_form.mf.title_entry}
}

oo::define BookForm method on_validate_title txt {
    .book_form.mf.bf.ok_button configure \
        -state [expr {$txt eq "" ? "disabled" : "normal"}]
    return 1
}

oo::define BookForm method on_validate_id txt {
    if {[string trim $txt] eq ""} {
        .book_form.mf.isbn_flag_label configure -text ?
    } else {
        set isbn [regsub {[-\s]+} $txt ""]
        try {
            valtype::isbn validate $isbn
            .book_form.mf.isbn_flag_label configure -text ✔
        } on error err {
            .book_form.mf.isbn_flag_label configure -text ✘
        }
    }
    return 1
}

oo::define BookForm method on_complete {} {
    tk busy .book_form
    try {
        if {[set isbn [string trim [.book_form.mf.isbn_entry get]]] ne ""} {
            set isbn [regsub {[-\s]+} $isbn ""]
            set url https://openlibrary.org/isbn/${isbn}.json
            lassign [get_title_authors $url] title authors
            if {[info exists title] && $title ne ""} {
                .book_form.mf.title_entry delete 0 end
                .book_form.mf.title_entry insert 0 $title
            }
            if {[info exists authors]} {
                .book_form.mf.author_entry delete 0 end
                .book_form.mf.author_entry insert 0 [join $authors " & "]
            }
        }
    } finally {
        tk busy forget .book_form
        .book_form.mf.bf.complete_button configure -state disabled
    }
}

oo::define BookForm method on_ok {} {
    $Book set_title [string trim [.book_form.mf.title_entry get]]
    $Book set_author [string trim [.book_form.mf.author_entry get]]
    $Book set_note [string trim [.book_form.mf.note_entry get]]
    set isbn [regsub {[-\s]+} [.book_form.mf.isbn_entry get] ""]
    catch { set isbn [valtype::isbn validate $isbn] }
    $Book set_isbn $isbn
    $Ok set 1
    my delete
}

oo::define BookForm method on_cancel {} { my delete }

proc get_url_json url {
    set token [http::geturl $url]
    if {[set ncode [http::ncode $token]] in {301 302}} {
        set d [http::meta $token]
        if {[set location [dict getdef $d location ""]] eq ""} {
            if {[set location [dict getdef $d Location ""]] eq ""} {
                http::cleanup $token
                return
            }
        }
        http::cleanup $token
        return [get_url_json $location]
    }
    if {[http::status $token] eq "ok"} {
        set data [http::data $token]
        http::cleanup $token
        return $data
    }
}

proc get_title_authors url {
    set title ""
    set authors [list]
    if {[set jdata [get_url_json $url]] ne ""} {
        set d [json::json2dict $jdata]
        try {
            set title [dict getdef $d title ""]
        } on error _ {
            return
        }
        foreach pathdata [dict getdef $d authors {}] {
            set path [dict getdef $pathdata key ""]
            set url https://openlibrary.org$path.json
            set jdata [get_url_json $url]
            set a [json::json2dict $jdata]
            if {[set author [dict getdef $a name ""]] ne ""} {
                lappend authors $author
            }
        }
    }
    list $title $authors
}
