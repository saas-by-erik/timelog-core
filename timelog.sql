--
-- Copyright (c) 2015 Erik Nordstroem <erikn@LoBSD.org>
--
-- Permission to use, copy, modify, and distribute this software for any
-- purpose with or without fee is hereby granted, provided that the above
-- copyright notice and this permission notice appear in all copies.
--
-- THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
-- WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
-- MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
-- ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
-- WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
-- ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
-- OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
--

BEGIN;
-- The passwd_shim table is for integration with authentication system
CREATE TABLE passwd_shim (
  pw_name varchar(8) PRIMARY KEY,
  pw_uid  integer NOT NULL
);
CREATE TABLE categories (
  parent_id integer,

  id      serial PRIMARY KEY,
  name    varchar(255) NOT NULL,
  comment varchar(255),
  slug    char(32) NOT NULL,

  FOREIGN KEY (parent_id) REFERENCES categories  
);
CREATE TABLE entries (
  pw_name varchar(8) NOT NULL,
  catid   integer NOT NULL,

  id       serial PRIMARY KEY,
  t_begin  timestamp with time zone NOT NULL,
  tz_begin varchar(255) NOT NULL,
  t_end    timestamp with time zone,
  tz_end   varchar(255),
  comment  varchar(255),

  FOREIGN KEY (pw_name) REFERENCES passwd_shim,
  FOREIGN KEY (catid)   REFERENCES categories
);
COMMIT;