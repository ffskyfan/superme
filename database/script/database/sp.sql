
use `star_game`;

delimiter //


drop procedure if exists create_player//
CREATE PROCEDURE create_player
(    player_name    CHAR(12),
     player_account CHAR(32),
     player_only_id BIGINT,
		 player_atb			TINYBLOB,
 OUT result         INT
 )
label_proc:
BEGIN
  DECLARE temp_only_id BIGINT;

  SELECT only_id INTO temp_only_id FROM `star_game`.`player` WHERE name = player_name;

  IF (temp_only_id IS NOT NULL) THEN
		set result = 1;
    LEAVE label_proc;

	END IF;


	SELECT only_id INTO temp_only_id FROM `star_game`.`player` WHERE account = player_account;

	IF (temp_only_id IS NOT NULL) THEN
		set result = 2;
		LEAVE label_proc;
	END IF;


	SELECT only_id INTO temp_only_id FROM `star_game`.`player` WHERE only_id = player_only_id;
	IF (temp_only_id IS NOT NULL) THEN
		set result = 3;
		LEAVE label_proc;
	END IF;


	INSERT INTO `star_game`.`player` (`only_id`, `account`, `name`,`atb`) VALUES (player_only_id, player_account, player_name,player_atb);

	set result = 0;
	LEAVE label_proc;





END label_proc//


drop procedure if exists save_player//
CREATE PROCEDURE save_player
(
	player_atb								TINYBLOB , 
	player_dword_flag					TINYBLOB ,
	player_word_flag					TINYBLOB ,
	player_halfword_flag			TINYBLOB ,
	player_bit_flag						TINYBLOB ,
	player_money_gold					INT UNSIGNED  ,
	player_money_rmb					INT UNSIGNED ,
	player_money_ticket				INT UNSIGNED ,
	player_completed_quest		BINARY(128) ,
	player_buildings					BINARY(64) ,
	player_daily_quest				BINARY(192) ,
	player_battle_team				BINARY(24) ,
	player_last_logout_time		BIGINT ,
	player_main_hero_only_id	BIGINT UNSIGNED,
	player_hero_train_slot		BINARY(72) ,
	player_pet_train_slot			BINARY(72) ,
	player_only_id						BIGINT UNSIGNED 
 )
label_proc:
BEGIN

	UPDATE `star_game`.`player` SET 
		atb=player_atb,
		dword_flag= player_dword_flag, 
		word_flag=player_word_flag, 
		halfword_flag=player_halfword_flag,
		bit_flag=player_bit_flag, 
		money_gold =player_money_gold,
		money_rmb =player_money_rmb,
		money_ticket =player_money_ticket,
		completed_quest=player_completed_quest,
		buildings=player_buildings,
		daily_quest=player_daily_quest,
		battle_team=player_battle_team,
		last_logout_time=player_last_logout_time, 
		main_hero_only_id = player_main_hero_only_id,
		hero_train_slot = player_hero_train_slot,
		pet_train_slot = player_pet_train_slot  
	WHERE only_id = player_only_id;

	LEAVE label_proc;


END label_proc//


drop procedure if exists save_hero//
CREATE  PROCEDURE `save_hero`(
	hero_only_id						BIGINT UNSIGNED,
	owner_id								BIGINT UNSIGNED,
	hero_atb								TINYBLOB,
	hero_final_atb					TINYBLOB,
	hero_equip_weapon				BIGINT UNSIGNED,
	hero_equip_helmet				BIGINT UNSIGNED, 
	hero_equip_armour				BIGINT UNSIGNED, 
	hero_equip_accessory		BIGINT UNSIGNED,
	hero_skill_point				BINARY(6),
	hero_talent							TINYBLOB,
	hero_equip_pet_top			BIGINT UNSIGNED,
	hero_equip_pet_bottom		BIGINT UNSIGNED,
	hero_talent_quest_id	  INT UNSIGNED,
	hero_talent_progress1		INT ,
	hero_talent_progress2		INT,
	hero_tactic							INT,
	hero_normal_bullet_atb	TINYBLOB,
	hero_hold_bullet_atb		TINYBLOB,
	hero_bomb_bullet_atb		TINYBLOB
)
label_proc:
BEGIN

	declare temp_only_id BIGINT UNSIGNED;  

	select only_id into temp_only_id from `star_game`.`hero` WHERE only_id = hero_only_id;   

	if (temp_only_id is not null) then
		update `star_game`.`hero` SET 
			atb=hero_atb,
			final_atb=hero_final_atb,
			equip_weapon=hero_equip_weapon, 
			equip_helmet= hero_equip_helmet, 
			equip_armour=hero_equip_armour,
			equip_accessory= hero_equip_accessory, 
			skill_point=hero_skill_point,
			talent = hero_talent,
			equip_pet_top=hero_equip_pet_top,
			equip_pet_bottom= hero_equip_pet_bottom,
			talent_quest_id=hero_talent_quest_id, 
			talent_progress1 =hero_talent_progress1,
			talent_progress2 =hero_talent_progress2,
			tactic=hero_tactic, 
			normal_bullet_atb = hero_normal_bullet_atb,
			hold_bullet_atb = hero_hold_bullet_atb,
			bomb_bullet_atb = hero_bomb_bullet_atb
		WHERE only_id = hero_only_id;

		LEAVE label_proc;
	else

		insert into `star_game`.`hero` 
			(`only_id`, 
			 `owner`,
			 `atb`,
			 `final_atb`,
			 `equip_weapon`,
			 `equip_helmet`,
			 `equip_armour`,
			 `equip_accessory`,
			 `skill_point`,
			 `talent`,
			 `equip_pet_top`,
			 `equip_pet_bottom`,
			 `talent_quest_id`,
			 `talent_progress1`,
			 `talent_progress2`,
			 `tactic`,
			 `normal_bullet_atb`,
			 `hold_bullet_atb`,
			 `bomb_bullet_atb`) 
			values 
			(hero_only_id,
			 owner_id,
			 hero_atb,
			 hero_final_atb,
			 hero_equip_weapon,
			 hero_equip_helmet, 
			 hero_equip_armour, 
			 hero_equip_accessory,
			 hero_skill_point,
			 hero_talent,
			 hero_equip_pet_top,
			 hero_equip_pet_bottom,
			 hero_talent_quest_id,
			 hero_talent_progress1,
			 hero_talent_progress2,
			 hero_tactic, 
			 hero_normal_bullet_atb,
			 hero_hold_bullet_atb,
			 hero_bomb_bullet_atb);
		LEAVE label_proc;

	end if;


END label_proc //



drop procedure if exists save_item//
create procedure save_item
(
	item_only_id		BIGINT UNSIGNED,
	owner_id				BIGINT UNSIGNED,
	item_exd_id			INT UNSIGNED,
	item_count			INT UNSIGNED,
	item_new				BOOL, 
	item_grade			INT UNSIGNED, 
	item_inlaid_gem BINARY(16) 
)
label_proc:
BEGIN
	declare temp_only_id BIGINT UNSIGNED;  

	if (item_count = 0) then
		delete from `star_game`.`item` WHERE only_id = item_only_id;
	else
	
		select only_id into temp_only_id from `star_game`.`item` WHERE only_id = item_only_id;   

		if (temp_only_id is not null) then
			update `star_game`.`item` SET count=item_count,new=item_new,grade=item_grade,inlaid_gem=item_inlaid_gem WHERE only_id = item_only_id;
			LEAVE label_proc;
		else
			insert into `star_game`.`item` (`only_id`, `owner`,`item_id`,`count`,`new`,`grade`,`inlaid_gem`) values (item_only_id,owner_id,item_exd_id,item_count,item_new,item_grade,item_inlaid_gem);

			LEAVE label_proc;

		end if;

	end if;



END label_proc //





drop procedure if exists save_pet//
create procedure save_pet
(
	pet_only_id		BIGINT UNSIGNED,
	owner_id		BIGINT UNSIGNED,
	pet_exd_id		INT UNSIGNED,
	pet_exp		INT,
	the_pet_level		INT,
	pet_new		BOOL
)
label_proc:
BEGIN
	declare temp_only_id BIGINT UNSIGNED;  


	select only_id into temp_only_id from `star_game`.`pet` WHERE only_id = pet_only_id;   

	if (temp_only_id is not null) then
		update `star_game`.`pet` SET exp=pet_exp,pet_level=the_pet_level,new=pet_new  WHERE only_id = pet_only_id;
		LEAVE label_proc;
	else
		insert into `star_game`.`pet` (`only_id`, `owner`,`pet_id`,`exp`,`pet_level`,`new`) values (pet_only_id,owner_id,pet_exd_id,pet_exp,the_pet_level,pet_new);
		LEAVE label_proc;

	end if;



END label_proc //

			

drop procedure if exists save_quest//
create procedure save_quest
(
	quest_only_id				BIGINT UNSIGNED,
	owner_id						BIGINT UNSIGNED,
	quest_group_id			INT UNSIGNED,
	quest_idx						INT UNSIGNED,
	quest_new						BOOL, 
	quest_progress1			INT UNSIGNED,
	quest_progress_rmb1			BOOL,
	quest_progress2			INT UNSIGNED,
	quest_progress_rmb2			BOOL,
	quest_progress3			INT UNSIGNED,
	quest_progress_rmb3			BOOL,
	quest_progress4			INT UNSIGNED,
	quest_progress_rmb4			BOOL
)
label_proc:
BEGIN
	declare temp_only_id BIGINT UNSIGNED;  


	select only_id into temp_only_id from `star_game`.`quest` WHERE only_id = quest_only_id;   

	if (temp_only_id is not null) then
		update `star_game`.`quest` SET idx=quest_idx,new=quest_new, progress1= quest_progress1, progress_rmb1=quest_progress_rmb1,progress2= quest_progress2, progress_rmb2=quest_progress_rmb2,progress3 = quest_progress3,progress_rmb3=quest_progress_rmb3,progress4= quest_progress4,progress_rmb4=quest_progress_rmb4 WHERE only_id = quest_only_id;
		LEAVE label_proc;
	else
		insert into `star_game`.`quest` (`only_id`, `owner`,`group_id`,`idx`,`new`,`progress1`,`progress_rmb1`,`progress2`,`progress_rmb2`,`progress3`,`progress_rmb3`,`progress4`,`progress_rmb4`) values (quest_only_id,owner_id,quest_group_id,quest_idx,quest_new, quest_progress1, quest_progress_rmb1,quest_progress2,quest_progress_rmb2,quest_progress3,quest_progress_rmb3,quest_progress4,quest_progress_rmb4);
		LEAVE label_proc;

	end if;



END label_proc //




drop procedure if exists save_cooldown//
create procedure save_cooldown
(
	cd_only_id		BIGINT UNSIGNED,
	owner_id			BIGINT UNSIGNED,
	cd_exd_id			INT UNSIGNED,
	cd_begin_time BIGINT UNSIGNED,
	cd_past_frame INT,
	cd_token			INT
)
label_proc:
BEGIN
	declare temp_only_id BIGINT UNSIGNED;  


	select only_id into temp_only_id from `star_game`.`cooldown` WHERE only_id = cd_only_id;   

	if (temp_only_id is not null) then
		update `star_game`.`cooldown` SET begin_time=cd_begin_time,past_frame=cd_past_frame, token= cd_token WHERE only_id = cd_only_id;
		LEAVE label_proc;
	else
		insert into `star_game`.`cooldown` (`only_id`, `owner`,`cd_id`,`begin_time`,`past_frame`,`token`) values (cd_only_id,owner_id,cd_exd_id,cd_begin_time,cd_past_frame, cd_token);
		LEAVE label_proc;

	end if;



END label_proc //




drop procedure if exists save_stage//
create procedure save_stage
(
	stage_onlyid	BIGINT UNSIGNED,
	stage_id			INT UNSIGNED,
	owner_id			BIGINT UNSIGNED,
	stage_rank		INT,
	stage_hero_id	INT,
	stage_open		INT,
	stage_new			BOOL
)
label_proc:
BEGIN
	declare temp_only_id BIGINT UNSIGNED;  
	
	select only_id into temp_only_id from `star_game`.`stage` WHERE only_id = stage_onlyid;   

	if (temp_only_id is not null) then
		update `star_game`.`stage` SET rank=stage_rank,hero_id=stage_hero_id, open= stage_open, new= stage_new WHERE only_id = stage_onlyid;
		LEAVE label_proc;
	else
		insert into `star_game`.`stage` (`only_id`,`id`, `owner`,`rank`,`hero_id`,`open`,`new`) values (stage_onlyid, stage_id,owner_id,stage_rank,stage_hero_id,stage_open, stage_new);
		LEAVE label_proc;

	end if;


END label_proc //




drop procedure if exists save_point_race_data//
create procedure save_point_race_data
(
	owner_id					BIGINT UNSIGNED,
	point_race_point	INT,
	point_race_rank		INT,
	point_race_group	INT,
	point_race_award	INT
)
label_proc:
BEGIN
	declare temp_only_id BIGINT UNSIGNED;  
	
	select only_id into temp_only_id from `star_game`.`point_race` WHERE only_id = owner_id;   

	if (temp_only_id is not null) then
		update `star_game`.`point_race` SET point=point_race_point,rank=point_race_rank,race_group=point_race_group, award=point_race_award WHERE only_id = owner_id;
		LEAVE label_proc;
	else
		insert into `star_game`.`point_race` (`only_id`, `point`,`rank`,`race_group`,`award`) values (owner_id,point_race_point,point_race_rank,point_race_group,point_race_award);
		LEAVE label_proc;

	end if;


END label_proc //





drop procedure if exists save_global_data//
create procedure save_global_data
(
	global_data_id						BIGINT UNSIGNED,
	global_value							INT
)
label_proc:
BEGIN
	declare temp_data_id BIGINT UNSIGNED;  
	
	select data_id into temp_data_id from `star_game`.`global_data` WHERE data_id = global_data_id;   

	if (temp_data_id is not null) then
		update `star_game`.`global_data` SET value=global_value WHERE data_id = global_data_id;
		LEAVE label_proc;
	else
		insert into `star_game`.`global_data` (`data_id`, `value`) values (global_data_id,global_value);
		LEAVE label_proc;

	end if;


END label_proc //

/*返回值说�?0,成功
1,这个玩家不存�?2,本ID的邮件已经存�?3,玩家邮件数量已经达到200�?4,对方屏蔽了自�?*/
drop procedure if exists add_new_mail//
create procedure add_new_mail
(
	mail_only_id				BIGINT UNSIGNED,
	mail_sender_name  	CHAR(12),
	mail_reciver_name 	CHAR(12),
	mail_title					VARCHAR(16),
	mail_text						VARCHAR(512),
	mail_accessory			BINARY(36),
	mail_is_system			BOOL,
	mail_max_mail_num		INT,
	mail_blacklist_type	INT,
	OUT result        	INT,
	OUT mail_reciver_id	BIGINT UNSIGNED
)
label_proc:
BEGIN
	declare temp_reciver_id BIGINT UNSIGNED;  
	declare temp_mail_id BIGINT UNSIGNED;  
	declare temp_mail_num INT UNSIGNED;  
	declare temp_blacklist_relation_id BIGINT UNSIGNED;  

	select only_id into temp_reciver_id from `star_game`.`player` WHERE name = mail_reciver_name;   
	if (temp_reciver_id is null) then
		set result = 1;
		LEAVE label_proc;
	end if;

	if mail_is_system is false then
		select COUNT(*) into temp_mail_num from `star_game`.`mail` WHERE owner = temp_reciver_id;   
		if temp_mail_num >= 200 then
			set result = 3;
			LEAVE label_proc;
		end if;
	end if;

	select only_id into temp_blacklist_relation_id from `star_game`.`relation` WHERE owner=temp_reciver_id and relation_type=mail_blacklist_type and target_name=mail_sender_name;
	if (temp_blacklist_relation_id is not null) then
		set result = 4;
		LEAVE label_proc;
	end if;


	select only_id into temp_mail_id from `star_game`.`mail` WHERE only_id = mail_only_id;   
	if (temp_mail_id is not null) then
		set result = 2;
		LEAVE label_proc;
	else

		insert into `star_game`.`mail` (`only_id`, `owner`, `sender`, `title`, `text`, `accessory`,`is_system` ) values (mail_only_id,temp_reciver_id,mail_sender_name,mail_title,mail_text,mail_accessory,mail_is_system );
		set result = 0;
		set mail_reciver_id = temp_reciver_id;
		LEAVE label_proc;
	end if;

END label_proc //


drop procedure if exists save_mail//
create procedure save_mail
(
	mail_only_id			BIGINT UNSIGNED,
	mail_readed				BOOL,
	mail_accessory		BINARY(36)
)
label_proc:
BEGIN
	declare temp_mail_id BIGINT UNSIGNED;  


	select only_id into temp_mail_id from `star_game`.`mail` WHERE only_id = mail_only_id;   
	if (temp_mail_id is null) then
		LEAVE label_proc;
	else
		update `star_game`.`mail` SET readed=mail_readed,accessory=mail_accessory  WHERE only_id = mail_only_id ;
		LEAVE label_proc;
	end if;


END label_proc //




drop procedure if exists save_relation//
create procedure save_relation
(
	`relation_only_id`					BIGINT UNSIGNED,
	`relation_owner`						BIGINT UNSIGNED,
	`relation_type`							INT UNSIGNED,
	`relation_target_only_id`		BIGINT UNSIGNED,
	`relation_target_name`			CHAR(12)
)
label_proc:
BEGIN
	declare temp_only_id BIGINT UNSIGNED;  
	
	select only_id into temp_only_id from `star_game`.`relation` WHERE only_id = relation_only_id;   

	if (temp_only_id is null) then
		insert into `star_game`.`relation` (`only_id`, `owner`,`relation_type`,`target_only_id`,`target_name`) values (relation_only_id,relation_owner,relation_type,relation_target_only_id,relation_target_name);
		LEAVE label_proc;
	else
		update `star_game`.`relation` SET relation_type=relation_type WHERE only_id = relation_only_id;
		LEAVE label_proc;

	end if;


END label_proc //



drop procedure if exists save_tournament_data//
create procedure save_tournament_data
(
	owner_id										BIGINT UNSIGNED,
	tournament_rank							INT,
	tournament_award						INT,
	tournament_winning_streak		INT,
	tournament_record						TINYBLOB 
)
label_proc:
BEGIN
	declare temp_only_id BIGINT UNSIGNED;  
	
	select only_id into temp_only_id from `star_game`.`tournament` WHERE only_id = owner_id;   

	if (temp_only_id is not null) then
		update `star_game`.`tournament` SET rank=tournament_rank, award_rank=tournament_award, record=tournament_record,winning_streak=tournament_winning_streak WHERE only_id = owner_id;
		LEAVE label_proc;
	else
		insert into `star_game`.`tournament` (`only_id`,`rank`,`award_rank`,`winning_streak`,`record`) values (owner_id,tournament_rank,tournament_award, tournament_winning_streak, tournament_record);
		LEAVE label_proc;

	end if;

END label_proc //




drop procedure if exists save_survival_stage//
create procedure save_survival_stage
(
	owner_id											BIGINT UNSIGNED,
	survival_top_score						INT,
	survival_top_score_hero				BIGINT UNSIGNED,
	survival_today_top_score			INT,
	survival_today_top_score_hero	BIGINT UNSIGNED, 
	survival_last_score						INT,
	survival_last_score_hero			BIGINT UNSIGNED,
	survival_today_time						BIGINT UNSIGNED
)
label_proc:
BEGIN
	declare temp_only_id BIGINT UNSIGNED;  
	
	select only_id into temp_only_id from `star_game`.`survival_stage` WHERE only_id = owner_id;   

	if (temp_only_id is not null) then

		update `star_game`.`survival_stage` SET 
			top_score						=survival_top_score, 
			top_score_hero			=survival_top_score_hero, 
			today_top_score			=survival_today_top_score,
			today_top_score_hero=survival_today_top_score_hero,
			last_score					=survival_last_score,
			last_score_hero			=survival_last_score_hero, 
			today_time					=survival_today_time 
		WHERE only_id = owner_id;
		LEAVE label_proc;

	else
		insert into `star_game`.`survival_stage` (
			`only_id`,
			`top_score`,								
			`top_score_hero`,
			`today_top_score`,
			`today_top_score_hero`,
			`last_score`,							
			`last_score_hero`,
			`today_time`)
		values (
			owner_id,
			survival_top_score,
			survival_top_score_hero, 
			survival_today_top_score, 
			survival_today_top_score_hero,
			survival_last_score,
			survival_last_score_hero,
			survival_today_time);

		LEAVE label_proc;

	end if;

END label_proc //




drop procedure if exists save_remote_event//
create procedure save_remote_event
(
	event_only_id				BIGINT UNSIGNED,
	event_call_module		INT,
	event_call_server		INT,
	event_excute_type		INT,
	event_excute_server	INT, 
	event_arguments			TINYBLOB,
	event_returns				TINYBLOB,
	event_father				BIGINT UNSIGNED,
	event_child					BIGINT UNSIGNED
)
label_proc:
BEGIN
	declare temp_only_id BIGINT UNSIGNED;  
	
	select only_id into temp_only_id from `star_game`.`remote_event` WHERE only_id = event_only_id;   

	if (temp_only_id is not null) then

		update `star_game`.`remote_event` SET 
			only_id				=	event_only_id,	
			call_module		=	event_call_module, 
			call_server		=	event_call_server,
			excute_type		=	event_excute_type,
			excute_server	=	event_excute_server,
			arguments			=	event_arguments, 
			returns				=	event_returns,				 
      father			  =	event_father,				
      child					=	event_child

		WHERE only_id = event_only_id;
		LEAVE label_proc;

	else
		insert into `star_game`.`remote_event` (
			`only_id`,
			`call_module`,								
			`call_server`,
			`excute_type`,
			`excute_server`,
			`arguments`,							
			`returns`,
			`father`,			
			`child`)				
		values (
			event_only_id,				
			event_call_module,
			event_call_server, 
			event_excute_type, 
			event_excute_server,
			event_arguments,
			event_returns,
			event_father,
      event_child);
		LEAVE label_proc;

	end if;

END label_proc //




drop procedure if exists save_mall_limit_items//
create procedure save_mall_limit_items
(
	mall_limit_item_only_id		BIGINT UNSIGNED,
	mall_limit_item_owner			BIGINT UNSIGNED,
	mall_limit_item_id				INT,
	mall_limit_item_count			INT
)
label_proc:
BEGIN
	declare temp_only_id BIGINT UNSIGNED;  
	
	select only_id into temp_only_id from `star_game`.`mall_limit_items` WHERE only_id = mall_limit_item_only_id;   

	if (temp_only_id is not null) then
		update `star_game`.`mall_limit_items` SET count=mall_limit_item_count WHERE only_id = mall_limit_item_only_id;
		LEAVE label_proc;
	else
		insert into `star_game`.`mall_limit_items` (`only_id`,`owner`,`mall_item_id`,`count`) values (mall_limit_item_only_id, mall_limit_item_owner, mall_limit_item_id, mall_limit_item_count);
		LEAVE label_proc;

	end if;

END label_proc //


/*返回值说�?0,成功
1,这个玩家不存�?*/
drop procedure if exists add_banned//
create procedure add_banned
(
	banned_name									CHAR(12),
	banned_end_time							BIGINT,
	banned_level								INT,
	OUT result									INT,
	OUT out_only_id							BIGINT UNSIGNED
)
label_proc:
BEGIN
	declare temp_only_id BIGINT UNSIGNED;  
	declare banned_only_id BIGINT UNSIGNED;  
	
	select only_id into temp_only_id from `star_game`.`player` WHERE name = banned_name;   

	if (temp_only_id is not null) then

		select only_id into banned_only_id from `star_game`.`banned` WHERE only_id = temp_only_id;   
		if (banned_only_id is not null) then
			update `star_game`.`banned` SET end_time=banned_end_time, ban_level=banned_level WHERE only_id = banned_only_id;
			set result = 0;
			set out_only_id = banned_only_id;
			LEAVE label_proc;
		else
			insert into `star_game`.`banned` (`only_id`,`end_time`,`ban_level`) values (temp_only_id,banned_end_time,banned_level);
			set result = 0;
			set out_only_id = temp_only_id;
			LEAVE label_proc;
		end if;

	else

		set result = 1;
		set out_only_id = 0;
		LEAVE label_proc;
	end if;

END label_proc //





/*返回值说�?0,成功
1,这个玩家不存�?*/
drop procedure if exists add_deny_login//
create procedure add_deny_login
(
	deny_login_name							CHAR(12),
	deny_login_end_time					BIGINT,
	OUT result									INT,
	OUT out_only_id							BIGINT UNSIGNED
)
label_proc:
BEGIN
	declare temp_only_id BIGINT UNSIGNED;  
	declare deny_login_only_id BIGINT UNSIGNED;  
	
	select only_id into temp_only_id from `star_game`.`player` WHERE name = deny_login_name;   

	if (temp_only_id is not null) then

		select only_id into deny_login_only_id from `star_game`.`deny_login` WHERE only_id = temp_only_id;   
		if (deny_login_only_id is not null) then
			update `star_game`.`deny_login` SET end_time=deny_login_end_time WHERE only_id = deny_login_only_id;
			set result = 0;
			set out_only_id = deny_login_only_id;
			LEAVE label_proc;
		else
			insert into `star_game`.`deny_login` (`only_id`,`end_time`) values (temp_only_id,deny_login_end_time);
			set result = 0;
			set out_only_id = temp_only_id;
			LEAVE label_proc;
		end if;

	else

		set result = 1;
		set out_only_id = 0;
		LEAVE label_proc;
	end if;

END label_proc //


/*返回值说�?0,成功
1,失败
*/
drop procedure if exists save_boss_stage//
create procedure save_boss_stage
(
	stage_only_id_p							BIGINT UNSIGNED,
	owner_p								BIGINT UNSIGNED,
	stage_id_p							INT,
	best_time_p							INT,
	hero_id_p							INT UNSIGNED
)
label_proc:
BEGIN
	declare temp_only_id BIGINT UNSIGNED;   

	select only_id into temp_only_id from `star_game`.`boss_stage` WHERE only_id = stage_only_id_p;   
		if (temp_only_id is not null) then
			update `star_game`.`boss_stage` SET owner=owner_p,stage_id=stage_id_p,best_time=best_time_p,hero_id=hero_id_p WHERE only_id = temp_only_id;
			LEAVE label_proc;
		else
			insert into `star_game`.`boss_stage` (`only_id`,`owner`,`stage_id`,`best_time`,`hero_id`) values (stage_only_id_p,owner_p,stage_id_p,best_time_p,hero_id_p);
			LEAVE label_proc;
		end if;

END label_proc //


/*返回值说�?0,成功
1,这个玩家不存�?2,本ID的邮件已经存�?3,charge num 重复
*/
drop procedure if exists add_7k7k_charge_mail//
create procedure add_7k7k_charge_mail
(
	mail_only_id					BIGINT UNSIGNED,
	mail_sender_name			CHAR(12),
	mail_reciver_account 	CHAR(32),
	mail_title						VARCHAR(16),
	mail_text							VARCHAR(512),
	mail_accessory				BINARY(36),
	mail_charge_num				TEXT,
	mail_is_system				BOOL,
	OUT result						INT,
	OUT mail_reciver_id		BIGINT UNSIGNED
)
label_proc:
BEGIN
	declare temp_reciver_id BIGINT UNSIGNED;  
	declare temp_mail_id BIGINT UNSIGNED;  
	declare temp_charge_num TEXT;  

	select only_id into temp_reciver_id from `star_game`.`player` WHERE account = mail_reciver_account;   
	if (temp_reciver_id is null) then
		set result = 1;
		LEAVE label_proc;
	end if;

	select only_id into temp_mail_id from `star_game`.`mail` WHERE only_id = mail_only_id;   
	if (temp_mail_id is not null) then
		set result = 2;
		LEAVE label_proc;
	end if;

	select num into temp_charge_num from `star_game`.`k7k7k_charge_number` WHERE num = mail_charge_num;   
	if (temp_charge_num is not null) then
		set result = 3;
		LEAVE label_proc;
	end if;

	insert into `star_game`.`mail` (`only_id`, `owner`, `sender`, `title`, `text`, `accessory`,`is_system` ) values (mail_only_id,temp_reciver_id,mail_sender_name,mail_title,mail_text,mail_accessory,mail_is_system );
	insert into `star_game`.`k7k7k_charge_number` (`num`) values (mail_charge_num);
	set result = 0;
	set mail_reciver_id = temp_reciver_id;

END label_proc //

/*返回值说�?0,成功
1,失败
*/
drop procedure if exists save_hero_atb_intensify//
create procedure save_hero_atb_intensify
(
	hero_only_id_t		BIGINT UNSIGNED,
	max_hp_t			INT UNSIGNED,
	phis_attack_t		INT UNSIGNED,
	magic_defense_t 	INT UNSIGNED,
	phis_defense_t		INT UNSIGNED,
	move_speed_t		INT UNSIGNED
)
label_proc:
BEGIN
	declare temp_only_id BIGINT UNSIGNED;  


	select hero_only_id into temp_only_id from `star_game`.`hero_atb_intensify` WHERE hero_only_id = hero_only_id_t ;   

	if (temp_only_id is not null) then
		update `star_game`.`hero_atb_intensify` SET max_hp=max_hp_t, phis_attack=phis_attack_t, magic_defense=magic_defense_t,phis_defense=phis_defense_t,move_speed=move_speed_t WHERE hero_only_id = temp_only_id;
		LEAVE label_proc;
	else
		insert into `star_game`.`hero_atb_intensify` (`hero_only_id`, `max_hp`,`phis_attack`,`magic_defense`,`phis_defense`,`move_speed`) values (hero_only_id_t,max_hp_t	,phis_attack_t,magic_defense_t,phis_defense_t,
	move_speed_t);
		LEAVE label_proc;

	end if;

END label_proc //



DELIMITER ;

