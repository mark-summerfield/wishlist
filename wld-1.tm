# Copyright © 2025 Mark Summerfield. All rights reserved.

package require sqlite3 3

oo::class create Wld {
    variable Filename
    variable Db
}

oo::define Wld initialize { variable N 0 }

oo::define Wld constructor filename {
    classvariable N
    set Filename $filename
    set Db Wldb#[incr N]
    set exists [file isfile $Filename]
    sqlite3 $Db $Filename
    $Db eval [readFile $::APPPATH/sql/prepare.sql] 
    $Db transaction {
        if {!$exists} {
            $Db eval [readFile $::APPPATH/sql/create.sql]
        }
    }
}

oo::define Wld destructor {
    $Db eval {VACUUM}
    $Db close
}

oo::define Wld method filename {} { return $Filename }

oo::define Wld method version {} { $Db eval {PRAGMA USER_VERSION} }

oo::define Wld method db {} { return $Db }

oo::define Wld method categories {} {
    set categories [list]
    $Db eval {SELECT cid, name, pos FROM CategoriesView} {
        lappend categories [list $cid $name $pos]
    }
    return $categories
}

oo::define Wld method category_name cid {
    $Db onecolumn {SELECT name FROM Categories WHERE cid = :cid}
}

oo::define Wld method category_names {{casefold 0}} {
    set categories [list]
    $Db eval {SELECT name FROM CategoriesView} {
        lappend categories [expr {$casefold ? [string tolower $name] \
                                            : $name}]
    }
    return $categories
}

oo::define Wld method category_insert name {
    $Db transaction {
        $Db eval {INSERT INTO Categories (name) VALUES (:name)}
        return [$Db last_insert_rowid]
    }
}

oo::define Wld method category_update {cid name} {
    $Db eval {UPDATE Categories SET name = :name WHERE cid = :cid}
}

oo::define Wld method category_delete cid {
    $Db eval {DELETE FROM Categories WHERE cid = :cid}
}

oo::define Wld method category_move_top cid {
    $Db transaction { while {[my category_move_up $cid]} {} }
}

oo::define Wld method category_move_up cid {
    $Db transaction {
        set pos [$Db onecolumn {SELECT pos FROM Categories
                                WHERE cid = :cid}]
        $Db eval {SELECT cid AS prev_cid, MAX(pos) AS prev_pos
                  FROM Categories WHERE cid != :cid AND pos < :pos} {}
        if {$prev_pos eq {}} { return 0 } ;# already first
        $Db eval {UPDATE Categories SET pos = -1 WHERE cid = :prev_cid}
        $Db eval {UPDATE Categories SET pos = :prev_pos WHERE cid = :cid}
        $Db eval {UPDATE Categories SET pos = :pos WHERE cid = :prev_cid}
        return 1
    }
}

oo::define Wld method category_move_down cid {
    $Db transaction {
        set pos [$Db onecolumn {SELECT pos FROM Categories
                                WHERE cid = :cid}]
        $Db eval {SELECT cid AS next_cid, MIN(pos) AS next_pos
                  FROM Categories WHERE cid != :cid AND pos > :pos} {}
        if {$next_pos eq {}} { return 0 } ;# already last
        $Db eval {UPDATE Categories SET pos = -1 WHERE cid = :next_cid}
        $Db eval {UPDATE Categories SET pos = :next_pos WHERE cid = :cid}
        $Db eval {UPDATE Categories SET pos = :pos WHERE cid = :next_cid}
        return 1
    }
}

oo::define Wld method category_move_bottom cid {
    $Db transaction { while {[my category_move_down $cid]} {} }
}

oo::define Wld method wishes {} {
    set wishes [list]
    $Db eval {SELECT wid, name, note, cid, pos FROM WishesView} {
        lappend wishes [list $wid $name $note $cid $pos]
    }
    return $wishes
}

oo::define Wld method wishes_in_category cid {
    $Db onecolumn {SELECT COUNT(*) FROM Wishes WHERE cid = :cid}
}
