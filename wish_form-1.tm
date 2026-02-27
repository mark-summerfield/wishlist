# Copyright © 2025 Mark Summerfield. All rights reserved.

package require abstract_form
package require tooltip 2
package require ui
package require valtype::isbn 1
package require wish

oo::class create WishForm {
    superclass AbstractForm

    variable Ok
    variable Wish
}

oo::define WishForm classmethod show {user group wish} {
    set Ok [Ref new 0]
    set form [WishForm new $Ok $user $group $wish]
    tkwait window .wish_form
    $Ok get
}

oo::define WishForm constructor {ok user group wish} {
    set Ok $ok
    set Wish $wish
    my make_widgets $user $group
    my make_layout
    my make_bindings
    my prepare
    next .wish_form [callback on_cancel]
    my show_modal .wish_form.mf.name_entry
}

oo::define WishForm method make_widgets {user group} {
    tk::toplevel .wish_form
    wm resizable .wish_form 0 0
    set which [expr {[$Wish is_valid] ? "Edit" : "New"}]
    wm title .wish_form "[tk appname] — $which Wish"
    ttk::frame .wish_form.mf
    set tip tooltip::tooltip
    ttk::label .wish_form.mf.place_label_label -text "User/Group"
    ttk::label .wish_form.mf.place_label -text "$user/$group" \
        -relief sunken -foreground #505050
    ttk::label .wish_form.mf.name_label -text Name -underline 0
    ttk::entry .wish_form.mf.name_entry -placeholder "Name or title" \
        -validate key -validatecommand [callback on_validate_name %P]
    ui::apply_edit_bindings .wish_form.mf.name_entry
    ttk::label .wish_form.mf.note_label -text Note -underline 2
    ttk::entry .wish_form.mf.note_entry -placeholder Note
    ui::apply_edit_bindings .wish_form.mf.note_entry
    if {[$Wish is_valid]} { .wish_form.mf.note_entry insert 0 [$Wish note] }
    ttk::label .wish_form.mf.id_label -text ID/ISBN -underline 0
    ttk::entry .wish_form.mf.id_entry -placeholder "ID or ISBN" \
        -validate key -validatecommand [callback on_validate_id %P]
    ui::apply_edit_bindings .wish_form.mf.id_entry
    if {[$Wish is_valid]} { .wish_form.mf.id_entry insert 0 [$Wish id] }
    ttk::label .wish_form.mf.isbn_label -text ?
    ttk::frame .wish_form.mf.bf
    ttk::button .wish_form.mf.bf.ok_button -text OK -underline 0 \
        -compound left -image [ui::icon ok.svg $::ICON_SIZE] \
        -command [callback on_ok]
    ttk::button .wish_form.mf.bf.cancel_button -text Cancel \
        -compound left -command [callback on_cancel] \
        -image [ui::icon gtk-cancel.svg $::ICON_SIZE]
}

oo::define WishForm method prepare {} {
    if {[$Wish is_valid]} {
        .wish_form.mf.name_entry insert 0 [$Wish name]
    } else {
        my on_validate_name ""
    }
}

oo::define WishForm method make_layout {} {
    const opts "-padx 3 -pady 3"
    grid .wish_form.mf.place_label_label -row 0 -column 0 -sticky w {*}$opts
    grid .wish_form.mf.place_label -row 0 -column 1 -columnspan 2 \
        -sticky we {*}$opts
    grid .wish_form.mf.name_label -row 1 -column 0 -sticky w {*}$opts
    grid .wish_form.mf.name_entry -row 1 -column 1 -columnspan 2 \
        -sticky we {*}$opts
    grid .wish_form.mf.note_label -row 2 -column 0 -sticky w {*}$opts
    grid .wish_form.mf.note_entry -row 2 -column 1 -columnspan 2 \
        -sticky we {*}$opts
    grid .wish_form.mf.id_label -row 3 -column 0 -sticky w {*}$opts
    grid .wish_form.mf.id_entry -row 3 -column 1 -sticky we {*}$opts
    grid .wish_form.mf.isbn_label -row 3 -column 2 -sticky w {*}$opts
    grid .wish_form.mf.bf -row 9 -column 0 -columnspan 3 \
        -sticky we
    pack [ttk::frame .wish_form.mf.bf.pad1] -side left -expand 1
    pack .wish_form.mf.bf.ok_button -side left {*}$opts
    pack .wish_form.mf.bf.cancel_button -side left {*}$opts
    pack [ttk::frame .wish_form.mf.bf.pad2] -side right -expand 1
    grid columnconfigure .wish_form.mf 1 -weight 1
    pack .wish_form.mf -fill both -expand 1
}

oo::define WishForm method make_bindings {} {
    bind .wish_form <Escape> [callback on_cancel]
    bind .wish_form <Return> [callback on_ok]
    bind .wish_form <Alt-i> {focus .wish_form.mf.id_entry}
    bind .wish_form <Alt-n> {focus .wish_form.mf.name_entry}
    bind .wish_form <Alt-o> [callback on_ok]
    bind .wish_form <Alt-t> {focus .wish_form.mf.note_entry}
}

oo::define WishForm method on_validate_name txt {
    .wish_form.mf.bf.ok_button configure \
        -state [expr {$txt eq "" ? "disabled" : "normal"}]
    return 1
}

oo::define WishForm method on_validate_id txt {
    if {[string trim $txt] eq ""} {
        .wish_form.mf.isbn_label configure -text ?
    } else {
        set id [regsub {[-\s]+} $txt ""]
        try {
            valtype::isbn validate $id
            .wish_form.mf.isbn_label configure -text ✔
        } on error err {
            .wish_form.mf.isbn_label configure -text ✘
        }
    }
    return 1
}

oo::define WishForm method on_ok {} {
    $Wish set_name [string trim [.wish_form.mf.name_entry get]]
    $Wish set_note [string trim [.wish_form.mf.note_entry get]]
    set id [regsub {[-\s]+} [.wish_form.mf.id_entry get] ""]
    catch { set id [valtype::isbn validate $id] }
    $Wish set_id $id
    $Ok set 1
    my delete
}

oo::define WishForm method on_cancel {} { my delete }
