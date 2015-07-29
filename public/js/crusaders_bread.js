/**
 * Created by love is life on 2015/7/16.
 */

BREAD_COUNT_EACH_GROUP = 6;

CRITICAL_POINT_MAX = 100;

ZERO_CRITICAL_OVERFLOW_WEIGHT       = 0;
POSITIVE_CRITICAL_OVERFLOW_WEIGHT   = 0.2;
NEGATIVE_CRITICAL_OVERFLOW_WEIGHT   = 0.1;

ZERO_EXP_OVERFLOW_WEIGHT            = 0;
POSITIVE_EXP_OVERFLOW_WEIGHT        = 0.2;
NEGATIVE_EXP_OVERFLOW_WEIGHT        = 0.1;


EXP_MULTI                           = 1;    //经验的倍率
EXP_MULTI_AFTER_FULL                = 1.5;  //暴击的满了以后的经验倍率

EXP_THRESHOLD_WHEN_CRITICAL_FULL    = 150;  //当暴击满的时候使用经验的阀值



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

function compute_weight(bread, critical_point,  exp_added, exp_need, times)
{
    var exp_multi = EXP_MULTI;
    if (critical_point >= CRITICAL_POINT_MAX) {
        exp_multi = EXP_MULTI_AFTER_FULL;
    }

    var left_critical_point = CRITICAL_POINT_MAX - critical_point;
    var left_exp = exp_need - exp_added;

    var critical_overflow = left_critical_point - bread.critical; //暴击溢出值，正数时，越接近0越好， 负数时，越接近0越好， 但是，正数的权重比负数差，就是说吃超了也比没吃满强
    var critical_overflow_weight = 0;
    if (critical_overflow > 0) {
        critical_overflow_weight =   POSITIVE_CRITICAL_OVERFLOW_WEIGHT ;
    } else if (critical_overflow == 0) {
        critical_overflow_weight = ZERO_CRITICAL_OVERFLOW_WEIGHT ;
    } else {
        critical_overflow_weight = NEGATIVE_CRITICAL_OVERFLOW_WEIGHT ;
    }

    var final_critical_weight  = 0 ;
    if(left_critical_point == 0){
        if(bread.exp >= EXP_THRESHOLD_WHEN_CRITICAL_FULL){//如果经验值超过阀值，那就正常计算，这样可以不使用价值较高的面包
            final_critical_weight = (Math.abs(critical_overflow)/left_critical_point) * critical_overflow_weight ;
        }else{
            final_critical_weight = 0;
        }
    }else{
        final_critical_weight = (Math.abs(critical_overflow)/left_critical_point) * critical_overflow_weight ;
    }



    var exp_overflow = left_exp - (bread.exp*exp_multi); //经验溢出值，正数时，越接近0越好， 负数时，越接近0越好， 但是，正数的权重比负数差，就是说吃超了也比没吃满强
    var exp_overflow_weight = 0;
    if(exp_overflow>0){
        exp_overflow_weight = POSITIVE_EXP_OVERFLOW_WEIGHT ;
    }else if(exp_overflow==0){
        exp_overflow_weight = ZERO_EXP_OVERFLOW_WEIGHT ;
    }else{
        exp_overflow_weight =  NEGATIVE_EXP_OVERFLOW_WEIGHT ;
    }
    var final_exp_weight = (Math.abs(exp_overflow)/left_exp) * exp_overflow_weight ;

    var weight = {'critical':final_critical_weight,'exp':final_exp_weight};
    return weight;
}


function find_lowest_critical_weight_breads(all_weight)
{
    var critical_breads = {};
    for (var idx in all_weight){
        var weight = all_weight[idx];

        if(critical_breads[weight.critical]==null){
            critical_breads[weight.critical] =[];
        }

        critical_breads[weight.critical].push(idx);
    }

    var critical_keys = [];
    for (var critical in critical_breads) {
        if (critical_breads.hasOwnProperty(critical)) {
            critical_keys.push(critical);
        }
    }
    critical_keys.sort();

    var lowest_critical_key = critical_keys[0];
    var lowest_critical_breads = critical_breads[lowest_critical_key];

    return lowest_critical_breads;
}

function sort_exp_weight(a,b)
{
    return parseFloat(a) -parseFloat(b);
}

function find_best_bread(all_breads, bread_type_count, exp_need, critical_point, exp_added, times)
{
    var all_weight = {}
    for(var i=1; i<=bread_type_count; i++) {

        var bread = all_breads[i];
        if(bread.count == 0) continue;

        var bread_weight = compute_weight(bread, critical_point,  exp_added, exp_need, times);
        all_weight[i] = bread_weight;
    }

    var lowest_critical_breads = find_lowest_critical_weight_breads(all_weight);

    var lowest_exp_weight_breads = {}
    for(var idx in lowest_critical_breads){
        var bread_idx = lowest_critical_breads[idx];
        var weight = all_weight[bread_idx];
        if(lowest_exp_weight_breads[weight.exp]==null){
            lowest_exp_weight_breads[weight.exp] =[];
        }

        lowest_exp_weight_breads[weight.exp].push(bread_idx);
    }

    var exp_keys = [];
    for (var exp in lowest_exp_weight_breads) {
        if (lowest_exp_weight_breads.hasOwnProperty(exp)) {
            exp_keys.push(exp);
        }
    }
    exp_keys.sort(sort_exp_weight);

    var best_bread_idx = lowest_exp_weight_breads[exp_keys[0]][0];

    return best_bread_idx;
}


function find_optimal_group(all_breads, bread_type_count, exp_need, eaten_breads)
{
    var critical_point = 0;
    for(var i=0; i<BREAD_COUNT_EACH_GROUP; i++){
        if(is_stored_bread_empty(all_breads, bread_type_count)) break;
        var all_exp = compute_exp(all_breads, eaten_breads);
        if(all_exp >= exp_need) break;

        var exp_added = compute_exp(all_breads, eaten_breads);
        var best_bread_idx = find_best_bread(all_breads, bread_type_count, exp_need, critical_point, exp_added, i);

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


function show_result(all_breads, eaten_breads, exp_need)
{
    var bread_count = eaten_breads.length;
    var compute_times = Math.ceil(bread_count/BREAD_COUNT_EACH_GROUP);

    var result_need_exp_id = 'result_need_exp';
    var result_need_exp_str = '<div class="row  well "  id="' +result_need_exp_id +'"></div>';
    $("div#result").append(result_need_exp_str);
    var result_need_exp_text = ' <span   class="label  label-default ">需求经验:'+String(exp_need)+'</span>';
    $("div#"+result_need_exp_id).prepend(result_need_exp_text);

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

            var exp_span_str = '<span   class="label  label-warning ">'+bread.exp+'</span>';
            $("div#"+result_group_id).append(exp_span_str);

            var critical_span_str = '<span   class="label  label-info ">'+bread.critical+'</span>';
            $("div#"+result_group_id).append(critical_span_str);

            critical += bread.critical;
            exp += bread.exp;
        }

        if(critical>=CRITICAL_POINT_MAX){
            exp = exp*1.5;
        }

        var result_group_text = ' <span   class="label  label-default ">经验:'+String(exp)+'   暴击:'+String(critical)+'</span>';
        $("div#"+result_group_id).prepend(result_group_text);
    }

    var result_summarize_id = 'result_group_summarize';
    var div_summarize_str = '<div class="row  well "  id="' +result_summarize_id +'"></div>';
    $("div#result").append(div_summarize_str);

    var all_exp = compute_exp(all_breads, eaten_breads)
    var result_group_text = ' <span   class="label  label-default ">总计：经验:'+String(all_exp)+'</span>';
    $("div#"+result_summarize_id).prepend(result_group_text);


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
        all_breads[i].idx       =  i;
        all_breads[i].count     =  bread_count;
        all_breads[i].exp       =  bread_exp;
        all_breads[i].critical  =  bread_critical;
        all_breads[i].image     =  bread_image;
    }
    console.log(all_breads);

    var exp_had = $("input#exp_had.form-control").val();
    console.log(exp_had)

    var exp_max = $("input#exp_max.form-control").val();
    console.log(exp_max)

    var exp_need = exp_max-exp_had;
    console.log(exp_need)

    var solution = find_optimal_solution(all_breads, bread_type_count, exp_need);
    console.log(solution);

    show_result(all_breads, solution, exp_need);

}

