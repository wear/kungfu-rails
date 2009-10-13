// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function invoce_items(){
	$("[name='attendee[need_invoice]']").each(function(){
	    if($(this).attr("checked") && $(this).val() == 1){
	      $('.invoce_item').show();
	      }
		else
			{$('.invoce_item').hide()}
	})
};  

function change_total_fee(){
	$("[name='attendee[join_party]']").each(function(){
	    if($(this).attr("checked") && $(this).val() == 1){
	      	$('#fee_notice').text('费用提示:你需要支付170购买门票,此门票已包含午餐和晚餐会费用');
	      }
		else
		 {
		  	$('#fee_notice').text('费用提示:你需要支付120元购买门票,此门票已包含午餐费用');
		 }
	})
};

