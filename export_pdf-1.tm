# Copyright © 2026 Mark Summerfield. All rights reserved.

proc export_pdf {filename reader groups} {
    const TITLE_FONT "NewCenturySchoolbook Bold 13"
    const TITLE "$reader’s Wishlist"
    const BLACK "-color {0 0 0}"
    const WIDTH 595
    const HEIGHT 842
    set Y 54 ;# ¾" margin
    set X 54
    set cg [tclmcairo::new $WIDTH $HEIGHT -mode pdf -file $filename]
    try {
        lassign [$cg font_measure $TITLE $TITLE_FONT] w h
        set x [expr {($WIDTH / 2.0) - ($w / 2.0)}]
        set y $Y
        $cg text $x $y $TITLE -anchor sw -font $TITLE_FONT {*}$BLACK
        incr Y 13
        # TODO print rows of books (may span pages; hence track Y)
        # $cg stroke ;# only needed for graphics
        $cg save $filename
        return 1
    } finally {
        $cg destroy
    }
    return 0
}
