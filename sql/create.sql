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
    note TEXT, -- plain text, e.g., Pub date or Due date and/or comments
    cid INTEGER NOT NULL,
    pos INTEGER DEFAULT 0 NOT NULL,

    FOREIGN KEY(cid) REFERENCES Categories(cid),
    UNIQUE(cid, pos)
) WITHOUT ROWID;

CREATE VIEW CategoriesView AS
    SELECT cid, name, pos FROM Categories ORDER BY pos;

CREATE VIEW WishesView AS
    SELECT wid, name, note, cid, pos FROM Wishes ORDER BY cid, pos;

CREATE TRIGGER DeleteCategoryTrigger1 BEFORE DELETE ON Categories
    FOR EACH ROW WHEN (SELECT COUNT(*) FROM Categories) = 1
    BEGIN
        SELECT RAISE(ABORT, 'cannot delete the last category');
    END;

CREATE TRIGGER DeleteCategoryTrigger2 BEFORE DELETE ON Categories
    FOR EACH ROW
        WHEN (SELECT COUNT(*) FROM Wishes WHERE cid = OLD.cid) > 0
    BEGIN
        SELECT RAISE(ABORT, 'cannot delete a nonempty category;
delete its wishes first');
    END;

-- If no pos is specified in the insert it will be 0 (the default) in which
-- case this trigger will be applied and a correctly unique pos will be set.
CREATE TRIGGER InsertCategoryTrigger AFTER INSERT ON Categories
    FOR EACH ROW WHEN NEW.pos = 0
        BEGIN
            UPDATE Categories
                SET pos = (SELECT COALESCE(MAX(pos), 0) + 1 FROM Categories)
                WHERE cid = NEW.cid;
        END;

-- If no pos is specified in the insert it will be 0 (the default) in which
-- case this trigger will be applied and a correctly unique pos x cid will
-- be set.
CREATE TRIGGER InsertWishTrigger AFTER INSERT ON Wishes
    FOR EACH ROW WHEN NEW.pos = 0
        BEGIN
            UPDATE Wishes
                SET pos = (SELECT COALESCE(MAX(pos), 0) + 1 FROM Wishes
                           WHERE cid = NEW.cid)
                WHERE wid = NEW.wid AND cid = NEW.cid;
        END;

INSERT INTO Categories (name) VALUES ('Wishes');
