# Copyright © 2026 Mark Summerfield. All rights reserved.

oo::class create Book {
    variable Title
    variable Author
    variable Note
    variable Isbn
}

oo::define Book constructor {{title ""} {author ""} {note ""} {isbn ""}} {
    set Title $title
    set Author $author
    set Note $note
    set Isbn $isbn
}

oo::define Book method is_valid {} { expr {$Title ne ""} }

oo::define Book method title {} { return $Title }
oo::define Book method set_title title { set Title $title }

oo::define Book method author {} { return $Author }
oo::define Book method set_author author { set Author $author }

oo::define Book method note {} { return $Note }
oo::define Book method set_note note { set Note $note }

oo::define Book method isbn {} { return $Isbn }
oo::define Book method set_isbn isbn { set Isbn $isbn }

oo::define Book method to_string {} {
    return "Book new $Title $Author $Note $Isbn"
}
