# Copyright © 2026 Mark Summerfield. All rights reserved.

proc export_pdf {filename reader groups} {
    const TITLE_FONT "NewCenturySchoolbook 14"
    const TITLE "$reader’s Wishlist"
    const INK "-color {0 0 0}"
    const MARGIN 54 ;# ¾"
    const PAGE_WIDTH 595
    const PAGE_HEIGHT 842
    const WIDTH [expr {$PAGE_WIDTH - (2 * $MARGIN)}]
    const HEIGHT [expr {$PAGE_HEIGHT - (2 * $MARGIN)}]
    const SPAN [expr {$WIDTH + ($MARGIN / 2.0)}]
    set cg [tclmcairo::new $PAGE_WIDTH $PAGE_HEIGHT -mode pdf \
            -file $filename]
    try {
        lassign [$cg font_measure $TITLE $TITLE_FONT] w ;# h
        set x [expr {$MARGIN + (($WIDTH / 2.0) - ($w / 2.0))}]
        set y $MARGIN
        $cg text $x $y $TITLE -anchor sw -font $TITLE_FONT {*}$INK
        incr y 20
        set x $MARGIN
        write_books $cg $groups $x $y $HEIGHT $SPAN $MARGIN $INK
        $cg save $filename
        return 1
    } finally {
        $cg destroy
    }
    return 0
}

proc write_books {cg groups x y height span margin ink} {
    const GROUP_FONT "NewCenturySchoolbook 12"
    const BOOK_FONT "NewCenturySchoolbook 11"
    lassign [$cg font_measure n $BOOK_FONT] nwidth ;# h
    set nwidth [expr {$nwidth * 0.8}]
    const INDENT [expr {int(round($nwidth * 3))}]
    dict for {group books} $groups {
        set group "$group ([llength $books])"
        $cg text $x $y $group -anchor sw -font $GROUP_FONT {*}$ink
        incr y 16
        foreach book $books {
            write_book $cg $book $x y $nwidth $INDENT $span $margin \
                $BOOK_FONT $ink
            set x $margin
            incr y 13
        }
        incr y 8
        if {$y >= $height} {
            $cg newpage
            set y $margin
        }
    }
}

proc write_book {cg book x y_ nwidth indent span margin book_font ink} {
    upvar 1 $y_ y
    $cg text $x $y "  • " -anchor sw -font $book_font {*}$ink
    incr x $indent
    set words [split [$book title]]
    const BY [llength $words]
    lappend words by {*}[split [$book author]]
    if {[set note [$book note]] ne ""} {
        lappend words [split ($note)]
    }
    write_words $cg $words $x y $BY $nwidth $indent $span $margin \
        $book_font $ink
}

proc write_words {cg words x y_ by nwidth indent span margin book_font \
        ink} {
    upvar 1 $y_ y
    const BOOK_ITALIC_FONT "NewCenturySchoolbook Italic 11"
    set newline 0
    foreach word $words i [lseq [llength $words]] {
        if {[string trim $word] eq ""} { continue }
        if {$newline} {
            set newline 0
            incr y 13
        }
        set font $book_font
        if {$by == $i} { set font $BOOK_ITALIC_FONT }
        lassign [$cg font_measure $word $font] w
        $cg text $x $y $word -anchor sw -font $font {*}$ink
        incr x [expr {int(round($w + $nwidth))}]
        if {$x > $span} {
            set x [expr {$margin + $indent}]
            set newline 1
        }
    }
}
