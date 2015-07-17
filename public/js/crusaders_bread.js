/**
 * Created by love is life on 2015/7/16.
 */

BREAD_COUNT_EACH_GROUP = 6;

CRITICAL_POINT_MAX = 100;

//因为我们的计算是越接近0越好，所以越接近0的权值越好
ZERO_OVERFLOW_WEIGHT            = 0.2;
POSITIVE_OVERFLOW_WEIGHT        = 0.6;
NEGATIVE_OVERFLOW_WEIGHT        = 0.9;
EXP_WIGHT                       = 1000.0;      //经验的权重
EXP_WIGHT_AFTER_CRITICAL_FULL   = 0.01;      //经验在暴击满了之后的权重
CRITICAL_WIGHT                  = 0.01;  //暴击的权重
CRITICAL_WIGHT_AFTER_FULL       = 100;   //暴击的满了以后的权重
EXP_MULTI                       = 1;    //经验的倍率
EXP_MULTI_AFTER_FULL            = 1.5;  //暴击的满了以后的经验倍率

function add_bread_number(bread_name)
{

    var selector_name = "input#"+bread_name+"_count.form-control";
    var number = parseInt( $(selector_name).val() );
    var number_str = String(number+1);

    $(selector_name).val(number_str );

}


function reduce_bread_number(bread_name)
{

    var selector_name = "input#"+bread_name+"_count.form-control";
    var number = parseInt( $(selector_name).val() );
    number--;
    if(number<0){
        number=0;
    }
    var number_str = String(number);

    $(selector_name).val(number_str );

}

function compute_exp(all_breads, eaten_bread)
{
    var exp_all = 0;
    var bread_count = eaten_bread.length;

    var compute_times = bread_count/BREAD_COUNT_EACH_GROUP + (bread_count%BREAD_COUNT_EACH_GROUP==0?0:1);

    for(var i=0; i<compute_times; i++){

        var exp     = 0;
        var critical= 0;
        for(var j=i*BREAD_COUNT_EACH_GROUP; j<bread_count && j<i*BREAD_COUNT_EACH_GROUP+6; j++){
            var bread_idx = eaten_bread[j];
            var bread = all_breads[bread_idx];
            critical += bread.critical;
            exp += bread.exp;
        }

        if(critical>=CRITICAL_POINT_MAX){
            exp = exp*1.5;
        }

        exp_all += exp;
    }

    return exp_all;

}

function compute_weight(bread, critical_point,  exp_added, exp_need)
{
    var exp_wight = EXP_WIGHT; //经验的权重
    var critical_wight = CRITICAL_WIGHT;//暴击的权重

    var exp_multi = EXP_MULTI;
    if (critical_point >= CRITICAL_POINT_MAX) {
        exp_multi = EXP_MULTI_AFTER_FULL;
        exp_wight = EXP_WIGHT_AFTER_CRITICAL_FULL;
        critical_wight = CRITICAL_WIGHT_AFTER_FULL;//如果暴击值已经吃够100，那暴击尽量不要加，权重为负数
    }

    var left_critical_point = CRITICAL_POINT_MAX - critical_point;
    var left_exp = exp_need - (exp_added * exp_multi);

    var critical_overflow = left_critical_point - bread.critical; //暴击溢出值，正数时，越接近0越好， 负数时，越接近0越好， 但是，正数的权重比负数低，就是说吃超了也比没吃满强
    var critical_overflow_weight = 0;
    if(critical_overflow>0){
        critical_overflow_weight = critical_overflow * POSITIVE_OVERFLOW_WEIGHT * critical_wight ;
    }else if(critical_overflow==0){
        critical_overflow_weight =  critical_overflow * ZERO_OVERFLOW_WEIGHT * critical_wight;
    }else{
        critical_overflow_weight = Math.abs(critical_overflow) * NEGATIVE_OVERFLOW_WEIGHT * critical_wight;
    }

    var exp_overflow = left_exp - bread.exp; //经验溢出值，正数时，越接近0越好， 负数时，越接近0越好， 但是，正数的权重比负数低，就是说吃超了也比没吃满强
    var exp_overflow_weight = 0;
    if(exp_overflow>0){
        exp_overflow_weight = exp_overflow * POSITIVE_OVERFLOW_WEIGHT * exp_wight;
    }else if(exp_overflow==0){
        exp_overflow_weight =  exp_overflow * ZERO_OVERFLOW_WEIGHT * exp_wight;
    }else{
        exp_overflow_weight = Math.abs(exp_overflow) * NEGATIVE_OVERFLOW_WEIGHT * exp_wight;
    }

    var weight = critical_overflow_weight*exp_overflow_weight;
    return weight;
}

function find_best_bread(all_breads, bread_type_count, exp_need, critical_point, exp_added)
{
    var prepare_eat_bread_idx = 0;

    for(var i=1; i<=bread_type_count; i++) {

        var bread = all_breads[i];
        if(bread.count == 0) continue;

        if(prepare_eat_bread_idx == 0) {
            prepare_eat_bread_idx = i;
            continue;
        }

        var prepare_eat_bread = all_breads[prepare_eat_bread_idx];
        var prepare_eat_bread_weight = compute_weight(prepare_eat_bread, critical_point,  exp_added, exp_need);

        var bread_weight = compute_weight(bread, critical_point,  exp_added, exp_need);

        if(bread_weight < prepare_eat_bread_weight ){
            prepare_eat_bread_idx = i;
        }
    }

    return prepare_eat_bread_idx;
}


function find_optimal_group(all_breads, bread_type_count, exp_need, eaten_breads)
{
    var critical_point = 0;
    for(var i=0; i<BREAD_COUNT_EACH_GROUP; i++){
        if(is_stored_bread_empty(all_breads, bread_type_count)) break;
        var all_exp = compute_exp(all_breads, eaten_breads);
        if(all_exp >= exp_need) break;

        var exp_added = compute_exp(all_breads, eaten_breads);
        var best_bread_idx = find_best_bread(all_breads, bread_type_count, exp_need, critical_point, exp_added);

        var bread = all_breads[best_bread_idx];
        bread.count--;
        critical_point+=bread.critical;
        eaten_breads.push(best_bread_idx);
    }
}


function is_stored_bread_empty(all_breads, bread_type_count)
{
    for(var i=1; i<bread_type_count;i++){
        if(all_breads[i].count != 0) return false;
    }

    return true;
}



function find_optimal_solution(all_breads, bread_type_count, exp_need)
{
    var solution = [];

    for(;;){
        if(is_stored_bread_empty(all_breads, bread_type_count)) break;
        var all_exp = compute_exp(all_breads, solution);
        if(all_exp >= exp_need) break;

        find_optimal_group(all_breads, bread_type_count, exp_need, solution);
    }

    return solution;
}


function show_result(all_breads, eaten_breads)
{
    var bread_count = eaten_breads.length;
    var compute_times = Math.ceil(bread_count/BREAD_COUNT_EACH_GROUP);

    for(var i=0; i<compute_times; i++){

        var result_group_id = 'result_group_'+String(i);
        var div_str = '<div class="row  well "  id="' +result_group_id +'"></div>';
        $("div#result").append(div_str);

        var exp     = 0;
        var critical= 0;
        for(var j=i*BREAD_COUNT_EACH_GROUP; j<bread_count && j<i*BREAD_COUNT_EACH_GROUP+6; j++){
            var bread_idx = eaten_breads[j];
            var bread = all_breads[bread_idx];

            var img_str = '<img  src="/image/'+bread.image+'" >';
            $("div#"+result_group_id).append(img_str);

            var critical_span_str = '<span   class="label  label-info ">'+bread.critical+'</span>';
            $("div#"+result_group_id).append(critical_span_str);

            var exp_span_str = '<span   class="label  label-warning ">'+bread.exp+'</span>';
            $("div#"+result_group_id).append(exp_span_str);

            critical += bread.critical;
            exp += bread.exp;
        }

        if(critical>=CRITICAL_POINT_MAX){
            exp = exp*1.5;
        }

        var result_group_text = "经验:"+String(exp)+";暴击:"+String(critical);
        $("div#"+result_group_id).append(result_group_text);

    }


}



function compute_bread()
{
    $("div#result").empty();

    var bread_type_count = $("input#bread_type_count").val();
    console.log(bread_type_count);

    var all_breads={};
    for(var i=1; i<=bread_type_count; i++){
        var idx_str = String(i);
        var id = 'bread_'+idx_str;

        var bread_count = parseInt( $("input#"+id+"_count.form-control").val() );
        var bread_exp =  parseInt( $("input#"+id+"_exp:hidden").val() );
        var bread_critical = parseInt( $("input#"+id+"_critical:hidden").val() );
        var bread_image =  $("input#"+id+"_image:hidden").val() ;

        all_breads[i] = {};
        all_breads[i].count     =  bread_count;
        all_breads[i].exp       =  bread_exp;
        all_breads[i].critical  =  bread_critical;
        all_breads[i].image     =  bread_image;
    }
    console.log(all_breads);

    var exp_need = $("input#exp_need.form-control").val();
    console.log(exp_need)

    var solution = find_optimal_solution(all_breads, bread_type_count, exp_need);
    console.log(solution);

    show_result(all_breads, solution);

}

