CREATE TABLE "bookmarks" (
  id INTEGER NOT NULL,
  title VARCHAR(255) NOT NULL,
  url TEXT NOT NULL,
  json TEXT NOT NULL,
  time_added INTEGER NOT NULL,
  PRIMARY KEY(id)
);
CREATE TABLE "tags" (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  name VARCHAR(100) NOT NULL UNIQUE
);
CREATE TABLE "taggables" (
  id INTEGER NOT NULL,
  bookmark_id INTEGER NOT NULL,
  tag_id INTEGER NOT NULL,
  PRIMARY KEY(id),
  FOREIGN KEY(bookmark_id) REFERENCES bookmarks(id),
  FOREIGN KEY(tag_id) REFERENCES tags(id),
  UNIQUE(bookmark_id, tag_id)
);
CREATE TABLE "variables" (
  name VARCHAR(50) NOT NULL,
  value INTEGER NOT NULL,
  PRIMARY KEY(name)
);
