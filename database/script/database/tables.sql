
use `superme`;

drop table if exists `superme`.`users`;
create  table `superme`.`users` (

	`id` INT AUTO_INCREMENT NOT null ,
	`name` char(64) NOT null ,
	`email` char(64) NOT null ,
	`password` char(64) NOT null ,
	`created_at` timestamp NOT null ,
	`updated_at` timestamp NOT null ,

	primary key (`id`) ,
	unique key (`email`))
engine = InnoDB
character set = utf8;


