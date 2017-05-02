CREATE TABLE "taggables" (
  id INTEGER NOT NULL,
  bookmark_id INTEGER NOT NULL,
  tag_id INTEGER NOT NULL,
  PRIMARY KEY(id),
  FOREIGN KEY(bookmark_id) REFERENCES bookmarks(id),
  FOREIGN KEY(tag_id) REFERENCES tags(id),
  UNIQUE(bookmark_id, tag_id)
);
