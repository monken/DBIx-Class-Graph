-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Sat Sep 11 10:56:37 2010
-- 

BEGIN TRANSACTION;

--
-- Table: complex
--
CREATE TABLE complex (
  title character varying NOT NULL,
  id_foo INTEGER PRIMARY KEY NOT NULL
);

--
-- Table: simple
--
CREATE TABLE simple (
  title character varying NOT NULL,
  vaterid integer,
  id INTEGER PRIMARY KEY NOT NULL
);

CREATE INDEX simple_idx_vaterid ON simple (vaterid);

--
-- Table: simple_succ
--
CREATE TABLE simple_succ (
  title character varying NOT NULL,
  childid integer,
  id INTEGER PRIMARY KEY NOT NULL
);

CREATE INDEX simple_succ_idx_childid ON simple_succ (childid);

--
-- Table: complex_map
--
CREATE TABLE complex_map (
  id INTEGER PRIMARY KEY NOT NULL,
  child integer NOT NULL,
  parent integer NOT NULL
);

CREATE INDEX complex_map_idx_child ON complex_map (child);

CREATE INDEX complex_map_idx_parent ON complex_map (parent);

CREATE UNIQUE INDEX complex_map_child_parent ON complex_map (child, parent);

COMMIT;
