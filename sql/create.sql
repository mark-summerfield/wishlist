-- Copyright © 2026 Mark Summerfield. All Rights Reserved.

PRAGMA USER_VERSION = 1;

CREATE TABLE Categories (
    cid INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    name TEXT NOT NULL
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

CREATE VIEW WishesByCidPosView AS
    SELECT wid, name, note, cid, pos FROM Wishes ORDER BY cid, pos;

INSERT INTO Categories (name) VALUES ('Fiction');
INSERT INTO Categories (name) VALUES ('Tech');
INSERT INTO Categories (name) VALUES ('Bio');
INSERT INTO Categories (name) VALUES ('History');
INSERT INTO Categories (name) VALUES ('Non-Fiction');
INSERT INTO Categories (name) VALUES ('Long Shots');
INSERT INTO Categories (name) VALUES ('Off Quota');
INSERT INTO Categories (name) VALUES ('Andrea');
INSERT INTO Categories (name) VALUES ('Domestic');
