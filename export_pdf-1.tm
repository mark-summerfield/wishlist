# Copyright © 2026 Mark Summerfield. All rights reserved.

proc export_pdf {filename reader groups} {
    const TITLE_FONT "Century_Schoolbook Bold 13"
    const TITLE "$reader’s Wishlist"
    const WIDTH 595
    const HEIGHT 842
    set Y 36
    set X 36
    set cg [tclmcairo::new $WIDTH $HEIGHT -mode pdf -file $filename]
    $cg clear 1 1 1
    lassign [$cg font_measure $TITLE $TITLE_FONT] w h
    set x [expr {($WIDTH / 2.0) - ($w / 2.0)}]
    set y $Y
    $cg text $x $y $TITLE -color {0 0 0} -anchor sw -font $TITLE_FONT
    incr Y 13
    # TODO print rows of books (may span pages; hence track Y)
    $cg stroke
    $cg save $filename
    $cg destroy
    return 1
}
