CREATE TABLE "bookmarks" (
  id INTEGER NOT NULL,
  title VARCHAR(255) NOT NULL,
  url TEXT NOT NULL,
  json TEXT NOT NULL,
  time_added INTEGER NOT NULL,
  PRIMARY KEY(id)
);
