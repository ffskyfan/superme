

drop schema  if exists `superme`;
create schema `superme` default character set utf8;


use `superme`;
source D:/Apache24/htdocs/supreme/database/script/database/tables.sql;
source D:/Apache24/htdocs/supreme/database/script/database/sp.sql;


grant select,insert,update,delete,execute on superme.* to superme_dba@'%' Identified by '1984702';
flush privileges;




