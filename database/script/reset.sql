

drop schema  if exists `superme`;
create schema `superme` default character set utf8;



grant all on superme.* to superme_dba@'%' Identified by '1984702';
flush privileges;




