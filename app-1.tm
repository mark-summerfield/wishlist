# Copyright © 2025-26 Mark Summerfield. All rights reserved.

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
    variable ToolbarWidth
    variable RefreshToolbarsId
    variable TreeWidth
    variable RefreshTreeId
}

package require app_actions
package require app_menus
package require app_toolbars

oo::define App constructor {} {
    ui::wishinit
    tk appname Wishlists
    Config new
    set ToolbarWidth 0
    set RefreshToolbarsId ""
    set TreeWidth 0
    set RefreshTreeId ""
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
    my refresh_toolbars
    update
    set ToolbarWidth [winfo width .mf.tb]
    set Wldb [Wld new $Tree $::WISH_FILE]
    set TreeWidth [winfo width .mf.tf]
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
    wm minsize . 580 480
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
                -columns {author note isbn}]
    ui::apply_treeview_bindings $Tree
    $sa setwidget $Tree
    pack $sa -fill both -expand 1
    $Tree column #0 -stretch 1 -anchor w \
        -minwidth [font measure TkDefaultFont "Reader/Group/Book"]
    $Tree column 0 -stretch 1 -anchor w
    $Tree column 1 -stretch 1 -anchor w
    $Tree column 2 -stretch 0 -anchor e \
        -width [font measure TkDefaultFont "W123456789ABCD"]
    $Tree heading #0 -text Reader/Group/Book
    $Tree heading 0 -text Author
    $Tree heading 1 -text Note
    $Tree heading 2 -text ISBN
    $Tree tag configure reader -foreground #8A2CA1
    $Tree tag configure group -foreground #2047D8
    $Tree tag configure book -foreground #3A4F00
}

oo::define App method make_layout {} {
    my make_toolbars_layout
    grid .mf.tb -row 0 -column 0 -sticky we
    grid .mf.tf -row 1 -column 0 -sticky news
    grid rowconfigure .mf .mf.tf -weight 1
    grid columnconfigure .mf .mf.tf -weight 1
    pack .mf -fill both -expand 1
}

oo::define App method make_bindings {} {
    bind .mf.tf <Configure> [callback on_configure_tf %x %y %w %h]
    bind .mf.tf <<TreeResizedWidth>> [callback on_tree_resized_width]
    bind .mf.tb <Configure> [callback on_configure_tb %x %y %w %h]
    bind .mf.tb <<ToolbarResizedWidth>> [callback on_toolbar_resized_width]
    bind . <Control-e> [callback on_book_edit]
    bind . <Control-n> [callback on_book_new]
    bind . <Control-q> [callback on_quit]
    bind . <Control-s> [callback on_file_save]
    wm protocol . WM_DELETE_WINDOW [callback on_quit]
}
