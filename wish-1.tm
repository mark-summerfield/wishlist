# Copyright © 2026 Mark Summerfield. All rights reserved.

oo::class create Wish {
    variable Name
    variable Note
    variable Id
}

oo::define Wish constructor {{name ""} {note ""} {id ""}} {
    set Name $name
    set Note $note
    set Id $id
}

oo::define Wish method is_valid {} { expr {$Name ne ""} }

oo::define Wish method name {} { return $Name }
oo::define Wish method set_name name { set Name $name }

oo::define Wish method note {} { return $Note }
oo::define Wish method set_note note { set Note $note }

oo::define Wish method id {} { return $Id }
oo::define Wish method set_id id { set Id $id }

oo::define Wish method to_string {} { return "Wish new $Name $Note $Id" }
