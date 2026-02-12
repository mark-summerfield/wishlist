-- Copyright © 2026 Mark Summerfield. All Rights Reserved.

PRAGMA USER_VERSION = 1;

CREATE TABLE Categories (
    cid INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    name TEXT UNIQUE NOT NULL,
    pos INTEGER DEFAULT 0 UNIQUE NOT NULL
);

CREATE TABLE Wishes (
    wid TEXT PRIMARY KEY NOT NULL, -- ISBN for books
    name TEXT NOT NULL,
    note TEXT, -- plain text, e.g., Pub date or Due date or comments
    cid INTEGER NOT NULL,
    pos INTEGER DEFAULT 0 NOT NULL,

    FOREIGN KEY(cid) REFERENCES Categories(cid),
    UNIQUE(cid, pos)
) WITHOUT ROWID;

-- If no pos is specified in the insert it will be 0 (the default) in which
-- case this trigger will be applied and a correctly unique pos will be set.
CREATE TRIGGER InsertCategoryTrigger AFTER INSERT ON Categories
    FOR EACH ROW WHEN NEW.pos = 0
        BEGIN
            UPDATE Categories
                SET pos = (SELECT COALESCE(MAX(pos), 0) + 1 FROM Categories)
                WHERE cid = NEW.cid;
        END;

CREATE VIEW CategoriesView AS
    SELECT cid, name, pos FROM Categories ORDER BY pos;

CREATE VIEW WishesView AS
    SELECT wid, name, note, cid, pos FROM Wishes ORDER BY cid, pos;
