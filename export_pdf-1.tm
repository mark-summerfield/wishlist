# Copyright © 2026 Mark Summerfield. All rights reserved.

proc export_pdf {filename reader groups} {
    const TITLE_FONT "NewCenturySchoolbook 14"
    const GROUP_FONT "NewCenturySchoolbook 12"
    const BOOK_FONT "NewCenturySchoolbook 11"
    const TITLE "$reader’s Wishlist"
    const BLACK "-color {0 0 0}"
    const MARGIN 54 ;# ¾"
    const PAGE_WIDTH 595
    const PAGE_HEIGHT 842
    const WIDTH [expr {$PAGE_WIDTH - (2 * $MARGIN)}]
    const HEIGHT [expr {$PAGE_HEIGHT - (2 * $MARGIN)}]
    set y $MARGIN
    set x $MARGIN
    set cg [tclmcairo::new $PAGE_WIDTH $PAGE_HEIGHT -mode pdf \
            -file $filename]
    try {
        lassign [$cg font_measure $TITLE $TITLE_FONT] w ;# h
        set x [expr {$MARGIN + (($WIDTH / 2.0) - ($w / 2.0))}]
        $cg text $x $y $TITLE -anchor sw -font $TITLE_FONT {*}$BLACK
        incr y 20
        set x $MARGIN
        lassign [$cg font_measure n $BOOK_FONT] nwidth ;# h
        dict for {group books} $groups {
            set group "$group ([llength $books])"
            $cg text $x $y $group -anchor sw -font $GROUP_FONT {*}$BLACK
            incr y 16
            foreach book $books {
                set txt "  • [$book title] by [$book author]"
                if {[set note [$book note]] ne ""} {
                    set txt "$txt ($note)"
                }
                lassign [$cg font_measure $txt $BOOK_FONT] w ;# h
                if {$w <= $WIDTH} {
                    $cg text $x $y $txt -anchor sw -font $BOOK_FONT \
                        {*}$BLACK
                    incr y 13
                } else {
                    set indent [expr {int(round($nwidth * 2.5))}]
                    $cg text $x $y "  • " -anchor sw -font $BOOK_FONT \
                        {*}$BLACK
                    incr x $indent
                    foreach word [split [string range $txt 4 end]] {
                        if {[string trim $word] eq ""} { continue }
                        lassign [$cg font_measure "$word " $BOOK_FONT] w
                        $cg text $x $y $word -anchor sw -font $BOOK_FONT \
                            {*}$BLACK
                        incr x [expr {int(round($w + $nwidth))}]
                        if {$x >= $WIDTH} {
                            set x [expr {$MARGIN + $indent}]
                            incr y 13
                        }
                    }
                    set x $MARGIN
                    incr y 13
                }
            }
            incr y 8
            if {$y >= $HEIGHT} {
                $cg newpage
                set y $MARGIN
            }
        }
        $cg save $filename
        return 1
    } finally {
        $cg destroy
    }
    return 0
}
