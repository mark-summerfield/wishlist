# Copyright © 2025 Mark Summerfield. All rights reserved.
# File format is newline-separated records of tab-separated fields in
# display order: Open Reader Group Title Author Note ID.
# The ttk::treeview Tree holds all the data.

package require textutil::string

oo::class create Wld {
    variable Tree
    variable Filename
}

oo::define Wld initialize {
    variable R 0
    variable G 0
    variable B 0
}

oo::define Wld constructor {tree filename} {
    set Tree $tree
    set Filename $filename
    if {[file isfile $Filename]} {
        my load
    } else {
        my setup
    }
}

oo::define Wld destructor { my save }

oo::define Wld method tree {} { set Tree }

oo::define Wld method filename {} { set Filename }

oo::define Wld method load {} {
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
                    -open $open]
        }
        if {$group ne ""} {
            if {$group eq "="} {
                set group $prev_group
            } else {
                set prev_group $group
                set gid [$Tree insert $rid end -id G[incr G] -text $group \
                        -open $open]
            }
            if {$title ne ""} {
                $Tree insert $gid end -id B[incr B] -text $title \
                    -values [list $author $note $isbn]
            }
        }
                
    }
    if {![llength [$Tree children {}]]} { my setup }
    my resize_columns
}

oo::define Wld method setup {} {
    classvariable R
    classvariable G
    set reader [textutil::string::cap $::tcl_platform(user)]
    set rid [$Tree insert {} end -id R[incr R] -text $reader -open 1]
    set gid [$Tree insert $rid end -id G[incr G] -text Fiction]
}

oo::define Wld method save {} {
    set out [open $Filename w]
    puts $out "Open\tReader\tGroup\tBook\tAuthor\tNote\tISBN"
    try {
        foreach reader [$Tree children {}] {
            set open [$Tree item $reader -open]
            set text [$Tree item $reader -text]
            puts $out $open\t$text
            foreach group [$Tree children $reader] {
                set open [$Tree item $group -open]
                set text [$Tree item $group -text]
                puts $out $open\t=\t$text
                foreach book [$Tree children $group] {
                    set open [$Tree item $book -open]
                    set text [$Tree item $book -text]
                    lassign [$Tree item $book -values] author note isbn
                    puts $out $open\t=\t=\t$text\t$author\t$note\t$isbn
                }
            }
        }
    } finally {
        close $out
    }
}

oo::define Wld method resize_columns {} {
    set author_width 0
    set note_width 0
    foreach rid [$Tree children {}] {
        foreach gid [$Tree children $rid] {
            foreach bid [$Tree children $gid] {
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

oo::define Wld method select_item {{id {}}} {
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

oo::define Wld method prev_or_next_of tid {
    if {[set id [$Tree prev $tid]] eq {}} {
        set id [$Tree next $tid]
    }
    set id
}

oo::define Wld method reader_id_for_name reader {
    foreach rid [$Tree children {}] {
        set name [my item_text $rid]
        if {[string equal -nocase $name $reader]} { return $rid }
    }
}

oo::define Wld method group_id_for_name {rid group} {
    foreach gid [$Tree children $rid] {
        set name [my item_text $gid]
        if {[string equal -nocase $name $group]} { return $gid }
    }
}

oo::define Wld method reader_id {} {
    set tid [$Tree selection]
    if {[string match R* $tid]} { return $tid }
    set tid [$Tree parent $tid] ;# selected is Group or Book
    if {[string match R* $tid]} { return $tid }
    $Tree parent $tid ;# selected is Book
}

oo::define Wld method group_id {} {
    set tid [$Tree selection]
    if {[string match R* $tid]} { return "" } ;# No Group selected
    if {[string match G* $tid]} { return $tid }
    $Tree parent $tid ;# selected is Book
}

oo::define Wld method book_id {} {
    set tid [$Tree selection]
    if {[string match B* $tid]} { return $tid }
    return "" ;# No Book selected
}

oo::define Wld method item_text iid { $Tree item $iid -text }

oo::define Wld method group_reader gid {
    set rid [$Tree parent $gid]
    list $rid [$Tree item $rid -text]
}

oo::define Wld method reader_names {{casefold 0}} {
    set readernames [list]
    foreach reader [$Tree children {}] {
        set name [$Tree item $reader -text]
        if {$casefold} { set name [string tolower $name] }
        lappend readernames $name
    }
    set readernames
}

oo::define Wld method reader_child_count rid {
    llength [$Tree children $rid]
}

oo::define Wld method reader_add reader {
    classvariable R
    my select_item [$Tree insert {} end -id R[incr R] -text $reader]
}

oo::define Wld method reader_rename {rid reader} {
    $Tree item $rid -text $reader
}

oo::define Wld method reader_move_first rid { $Tree move $rid {} 0 }

oo::define Wld method reader_move_up rid {
    if {[set prev [$Tree prev $rid]] ne {}} {
        $Tree move $rid {} [$Tree index $prev]
    }
}

oo::define Wld method reader_move_down rid {
    if {[set next [$Tree next $rid]] ne {}} {
        $Tree move $rid {} [$Tree index $next]
    }
}

oo::define Wld method reader_move_last rid { $Tree move $rid {} end }

oo::define Wld method reader_delete rid {
    set id [my prev_or_next_of $rid]
    $Tree delete $rid
    my select_item $id
}

oo::define Wld method group_names {rid {casefold 0}} {
    set group_names [list]
    foreach gid [$Tree children $rid] {
        set name [$Tree item $gid -text]
        if {$casefold} { set name [string tolower $name] }
        lappend group_names $name
    }
    set group_names
}

oo::define Wld method group_child_count gid {
    llength [$Tree children $gid]
}

oo::define Wld method group_add {rid name} {
    classvariable G
    my select_item [$Tree insert $rid end -id G[incr G] -text $name]
}

oo::define Wld method group_rename {gid name} {
    $Tree item $gid -text $name
}

oo::define Wld method group_move_first gid {
    $Tree move $gid [$Tree parent $gid] 0
}

oo::define Wld method group_move_up gid {
    if {[set prev [$Tree prev $gid]] ne {}} {
        $Tree move $gid [$Tree parent $gid] [$Tree index $prev]
    }
}

oo::define Wld method group_move_down gid {
    if {[set next [$Tree next $gid]] ne {}} {
        $Tree move $gid [$Tree parent $gid] [$Tree index $next]
    }
}

oo::define Wld method group_move_last gid {
    $Tree move $gid [$Tree parent $gid] end
}

oo::define Wld method group_move_to_reader {gid rid} {
    $Tree move $gid $rid end
}

oo::define Wld method group_merge_to_reader {old_gid gid rid} {
    foreach bid [$Tree children $old_gid] {
        $Tree move $bid $gid end
    }
    $Tree delete $old_gid
}

oo::define Wld method group_delete gid {
    set id [my prev_or_next_of $gid]
    $Tree delete $gid
    my select_item $id
}

oo::define Wld method book_add {gid book} {
    classvariable B
    my select_item [$Tree insert $gid end -id B[incr B] \
        -text [$book title] \
        -values [list [$book author] [$book note] [$book isbn]]]
    my resize_columns
}

# TODO NOTE: book_edit & book_delete: call resize_columns

# TODO NOTE: for Group & book moves the parent is *not* {} so must be set!
