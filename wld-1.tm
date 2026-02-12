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
            $Db eval [readFile $::APPPATH/sql/insert.sql]
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

oo::define Wld method wishes {} {
    set wishes [list]
    $Db eval {SELECT wid, name, note, cid, pos FROM WishesView} {
        lappend wishes [list $wid $name $note $cid $pos]
    }
    return $wishes
}
