# Copyright © 2025 Mark Summerfield. All rights reserved.

package require about_form
package require config
package require config_form
package require ref
package require scrollutil_tile 2
package require ui
package require wld

oo::singleton create App {
    variable Tree
    variable Wldb
}

package require app_actions
package require app_menus
package require app_toolbars

oo::define App constructor {} {
    ui::wishinit
    tk appname Wishlists
    Config new
    my make_fonts
    my make_ui
}

oo::define App method show {} {
    wm deiconify .
    set config [Config new]
    wm geometry . [$config geometry]
    raise .
    update
    after idle [callback on_startup]
}

oo::define App method on_startup {} {
    set Wldb [Wld new $Tree $::WISH_FILE]
    focus $Tree
    $Wldb select_item
}

oo::define App method make_ui {} {
    my prepare_ui
    my make_menus
    my make_widgets
    my make_layout
    my make_bindings
}

oo::define App method prepare_ui {} {
    wm title . [tk appname]
    wm iconname . [tk appname]
    wm iconphoto . -default [ui::icon icon.svg]
    wm minsize . 640 480
}

oo::define App method make_fonts {} {
    set config [Config new]
    set family [$config family]
    set size [$config size]
    foreach name {Sans Bold Italic BoldItalic} {
        catch { font delete $name }
    }
    font create Sans -family $family -size $size
    font create Bold -family $family -size $size -weight bold
    font create Italic -family $family -size $size -slant italic
    font create BoldItalic -family $family -size $size -weight bold \
        -slant italic
}

oo::define App method make_widgets {} {
    set config [Config new]
    ttk::frame .mf ;# main frame
    ttk::frame .mf.tb ;# toolbar
    ttk::frame .mf.tf ;# tree frame
    my make_toolbars
    my make_tree
}

oo::define App method make_tree {} {
    set sa [scrollutil::scrollarea .mf.tf.sa]
    set Tree [ttk::treeview .mf.tf.sa.tree -selectmode browse -striped 1 \
                -columns {name note wid}]
    ui::apply_treeview_bindings $Tree
    $sa setwidget $Tree
    pack $sa -fill both -expand 1
    $Tree column #0 -stretch 1
    $Tree column 0 -stretch 1
    $Tree column 1 -stretch 0
    $Tree heading #0 -text User/Group/Wish
    $Tree heading 0 -text Note
    $Tree heading 1 -text ID/ISBN
}

oo::define App method make_layout {} {
    const opts "-pady 3 -padx 3"
    pack .mf.tb -fill x -side top {*}$opts
    my make_toolbar_layout
    pack .mf.tf -fill both -expand 1 {*}$opts
    pack .mf -fill both -expand 1
}

oo::define App method make_bindings {} {
    bind . <Control-q> [callback on_quit]
    bind . <Control-s> [callback on_file_save]
    wm protocol . WM_DELETE_WINDOW [callback on_quit]
}
