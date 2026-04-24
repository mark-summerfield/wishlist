# Copyright © 2025-26 Mark Summerfield. All rights reserved.
# File format is newline-separated records of tab-separated fields in
# display order: Open Reader Group Title Author Note ID.
# The ttk::treeview Tree holds all the data.

package require book
package require textutil::string

oo::class create Database {
    variable Tree
    variable Filename
}

oo::define Database initialize {
    variable R 0
    variable G 0
    variable B 0
}

oo::define Database constructor {tree filename} {
    set Tree $tree
    set Filename $filename
    if {[file isfile $Filename]} {
        my load
    } else {
        my setup
    }
}

oo::define Database destructor { my save }

oo::define Database method tree {} { set Tree }

oo::define Database method filename {} { set Filename }

oo::define Database method load {} {
    classvariable R
    classvariable G
    classvariable B
    $Tree delete [$Tree children {}]
    set prev_reader ""
    set prev_group ""
    set rid {}
    set gid {}
    foreach line [split [readFile $Filename] \n] {
        if {$line eq "" || [string match Open* $line]} { continue }
        lassign [split $line \t] open reader group title author note isbn
        if {$reader eq "="} {
            set reader $prev_reader
        } else {
            set prev_reader $reader
            set rid [$Tree insert {} end -id R[incr R] -text $reader \
                    -open $open -tags reader]
        }
        if {$group ne ""} {
            if {$group eq "="} {
                set group $prev_group
            } else {
                set prev_group $group
                set gid [$Tree insert $rid end -id G[incr G] -text $group \
                        -open $open -tags group]
            }
            if {$title ne ""} {
                $Tree insert $gid end -id B[incr B] -text $title \
                    -values [list $author $note $isbn] -tags book
            }
        }
                
    }
    if {![llength [$Tree children {}]]} { my setup }
    my resize_columns
}

oo::define Database method setup {} {
    classvariable R
    classvariable G
    set reader [textutil::string::cap $::tcl_platform(user)]
    set rid [$Tree insert {} end -id R[incr R] -text $reader -open 1 \
            -tags reader]
    set gid [$Tree insert $rid end -id G[incr G] -text Fiction -tags group]
}

oo::define Database method save {} {
    set out [open $Filename w]
    puts $out "Open\tReader\tGroup\tBook\tAuthor\tNote\tISBN"
    try {
        foreach rid [$Tree children {}] {
            set open [$Tree item $rid -open]
            regsub {\s*[(]\d+[)]$} [$Tree item $rid -text] "" txt
            puts $out $open\t$txt
            foreach gid [$Tree children $rid] {
                set open [$Tree item $gid -open]
                regsub {\s*[(]\d+[)]$} [$Tree item $gid -text] "" txt
                puts $out $open\t=\t$txt
                foreach bid [$Tree children $gid] {
                    set open [$Tree item $bid -open]
                    set txt [$Tree item $bid -text]
                    lassign [$Tree item $bid -values] author note isbn
                    puts $out $open\t=\t=\t$txt\t$author\t$note\t$isbn
                }
            }
        }
    } finally {
        close $out
    }
}

oo::define Database method resize_columns {} {
    set author_width 0
    set note_width 0
    foreach rid [$Tree children {}] {
        set groups [$Tree children $rid]
        regsub {\s*[(]\d+[)]$} [$Tree item $rid -text] "" txt
        $Tree item $rid -text "$txt ([llength $groups])"
        foreach gid $groups {
            set books [$Tree children $gid]
            regsub {\s*[(]\d+[)]$} [$Tree item $gid -text] "" txt
            $Tree item $gid -text "$txt ([llength $books])"
            foreach bid $books {
                lassign [$Tree item $bid -values] author note _
                set width [font measure TkDefaultFont $author]
                if {$width > $author_width} { set author_width $width }
                set width [font measure TkDefaultFont $note]
                if {$width > $note_width} { set note_width $width }
            }
        }
    }
    if {[set width [$Tree column 0 -width]] > $author_width} {
        $Tree column 0 -width $author_width
    }
    if {[set width [$Tree column 1 -width]] > $note_width} {
        $Tree column 1 -width $note_width
    }
}


oo::define Database method collapse_all {} {
    my collapse_or_expand_all 0
}

oo::define Database method expand_all {} {
    my collapse_or_expand_all 1
}

oo::define Database method collapse_or_expand_all {expand} {
    foreach rid [$Tree children {}] {
        $Tree item $rid -open $expand
        foreach gid [$Tree children $rid] {
            $Tree item $gid -open $expand
        }
    }
}

oo::define Database method counts {} {
    set readers [$Tree children {}]
    set nreaders [llength $readers]
    set ngroups 0
    set nbooks 0
    foreach rid $readers {
        set groups [$Tree children $rid]
        incr ngroups [llength $groups]
        foreach gid $groups {
            set books [$Tree children $gid]
            incr nbooks [llength $books]
        }
    }
    list $nreaders $ngroups $nbooks
}

oo::define Database method item_text iid {
    regsub {\s*[(]\d+[)]$} [$Tree item $iid -text] ""
}

oo::define Database method select_item {{id {}}} {
    set children [$Tree children {}]
    if {[llength $children]} {
        if {$id eq {} || ![$Tree exists $id]} {
            set id [lindex $children 0]
        }
        $Tree selection set $id
        $Tree see $id
        $Tree focus $id
    }
}

oo::define Database method prev_or_next_of tid {
    if {[set id [$Tree prev $tid]] eq {}} {
        set id [$Tree next $tid]
    }
    set id
}

oo::define Database method reader_id_for_name reader {
    foreach rid [$Tree children {}] {
        set name [my item_text $rid]
        if {[string equal -nocase $name $reader]} { return $rid }
    }
}

oo::define Database method group_id_for_name {rid group} {
    foreach gid [$Tree children $rid] {
        set name [my item_text $gid]
        if {[string equal -nocase $name $group]} { return $gid }
    }
}

oo::define Database method reader_id {} {
    set tid [$Tree selection]
    if {[string match R* $tid]} { return $tid }
    set tid [$Tree parent $tid] ;# selected is Group or Book
    if {[string match R* $tid]} { return $tid }
    $Tree parent $tid ;# selected is Book
}

oo::define Database method group_id {} {
    set tid [$Tree selection]
    if {[string match R* $tid]} { return "" } ;# No Group selected
    if {[string match G* $tid]} { return $tid }
    $Tree parent $tid ;# selected is Book
}

oo::define Database method book_id {} {
    set tid [$Tree selection]
    if {[string match B* $tid]} { return $tid }
    return "" ;# No Book selected
}

oo::define Database method group_reader gid {
    set rid [$Tree parent $gid]
    regsub {\s*[(]\d+[)]$} [$Tree item $rid -text] "" txt
    list $rid $txt
}

oo::define Database method reader_names {{casefold 0}} {
    set readernames [list]
    foreach rid [$Tree children {}] {
        regsub {\s*[(]\d+[)]$} [$Tree item $rid -text] "" name
        if {$casefold} { set name [string tolower $name] }
        lappend readernames $name
    }
    set readernames
}

oo::define Database method reader_child_count rid {
    llength [$Tree children $rid]
}

oo::define Database method reader_add reader {
    classvariable R
    my select_item [$Tree insert {} end -id R[incr R] -text $reader \
                    -tags reader]
}

oo::define Database method reader_rename {rid reader} {
    $Tree item $rid -text $reader
    my resize_columns
}

oo::define Database method reader_move_first rid { $Tree move $rid {} 0 }

oo::define Database method reader_move_up rid {
    if {[set prev [$Tree prev $rid]] ne {}} {
        $Tree move $rid {} [$Tree index $prev]
    }
}

oo::define Database method reader_move_down rid {
    if {[set next [$Tree next $rid]] ne {}} {
        $Tree move $rid {} [$Tree index $next]
    }
}

oo::define Database method reader_move_last rid { $Tree move $rid {} end }

oo::define Database method reader_delete rid {
    set id [my prev_or_next_of $rid]
    $Tree delete $rid
    my select_item $id
    my resize_columns
}

oo::define Database method group_names {rid {casefold 0}} {
    set group_names [list]
    foreach gid [$Tree children $rid] {
        regsub {\s*[(]\d+[)]$} [$Tree item $gid -text] "" name
        if {$casefold} { set name [string tolower $name] }
        lappend group_names $name
    }
    set group_names
}

oo::define Database method group_child_count gid {
    llength [$Tree children $gid]
}

oo::define Database method group_add {rid name} {
    classvariable G
    my select_item [$Tree insert $rid end -id G[incr G] -text $name \
                    -tags group]
    my resize_columns
}

oo::define Database method group_rename {gid name} {
    $Tree item $gid -text $name
    my resize_columns
}

oo::define Database method group_move_first gid {
    $Tree move $gid [$Tree parent $gid] 0
}

oo::define Database method group_move_up gid {
    if {[set prev [$Tree prev $gid]] ne {}} {
        $Tree move $gid [$Tree parent $gid] [$Tree index $prev]
    }
}

oo::define Database method group_move_down gid {
    if {[set next [$Tree next $gid]] ne {}} {
        $Tree move $gid [$Tree parent $gid] [$Tree index $next]
    }
}

oo::define Database method group_move_last gid {
    $Tree move $gid [$Tree parent $gid] end
}

oo::define Database method group_move_to_reader {gid rid} {
    $Tree move $gid $rid end
    my resize_columns
}

oo::define Database method group_merge_to_reader {old_gid gid rid} {
    foreach bid [$Tree children $old_gid] {
        $Tree move $bid $gid end
    }
    $Tree delete $old_gid
    my resize_columns
}

oo::define Database method group_delete gid {
    set id [my prev_or_next_of $gid]
    $Tree delete $gid
    my select_item $id
    my resize_columns
}

oo::define Database method book bid {
    set title [$Tree item $bid -text]
    lassign [$Tree item $bid -values] author note isbn
    Book new $title $author $note $isbn
}

oo::define Database method books rid {
    set groups [dict create]
    foreach gid [$Tree children $rid] {
        set group [my item_text $gid]
        foreach bid [$Tree children $gid] {
            dict lappend groups $group [my book $bid]
        }
    }
    return $groups
}

oo::define Database method book_add {gid book} {
    classvariable B
    my select_item [$Tree insert $gid end -id B[incr B] \
        -text [$book title] -tags book \
        -values [list [$book author] [$book note] [$book isbn]]]
    my resize_columns
}

oo::define Database method book_update {gid bid book} {
    $Tree item $bid -text [$book title] \
        -values [list [$book author] [$book note] [$book isbn]]
    my resize_columns
}

oo::define Database method book_delete bid {
    set id [my prev_or_next_of $bid]
    $Tree delete $bid
    my select_item $id
    my resize_columns
}

oo::define Database method book_move_first bid {
    $Tree move $bid [$Tree parent $bid] 0
}

oo::define Database method book_move_up bid {
    if {[set prev [$Tree prev $bid]] ne {}} {
        $Tree move $bid [$Tree parent $bid] [$Tree index $prev]
    }
}

oo::define Database method book_move_down bid {
    if {[set next [$Tree next $bid]] ne {}} {
        $Tree move $bid [$Tree parent $bid] [$Tree index $next]
    }
}

oo::define Database method book_move_last bid {
    $Tree move $bid [$Tree parent $bid] end
}

oo::define Database method book_move_to_reader_group {gid bid} {
    $Tree move $bid $gid end
    my resize_columns
}

oo::define Database method book_find {find_text {find_id ""}} {
    if {$find_text eq ""} { return }
    set started [expr {$find_id eq "" ? 1 : 0}]
    foreach rid [$Tree children {}] {
        foreach gid [$Tree children $rid] {
            foreach bid [$Tree children $gid] {
                if {$started} {
                    set title [my item_text $bid]
                    lassign [$Tree item $bid -values] author note
                    if {[string match -nocase *$find_text* $title] || \
                            [string match -nocase *$find_text* $author] || \
                            [string match -nocase *$find_text* $note]} {
                        my select_item $bid
                        return $bid
                    }
                } else {
                    if {$bid eq $find_id} { set started 1 }
                }
            }
        }
    }
}
