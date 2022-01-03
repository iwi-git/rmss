

function fnswiperLoad(){
	var swiper = new Swiper('.swiper-container.head-notice', {
        direction: 'vertical',
        autoplay: {
            delay: 3000,
            disableOnInteraction: false,
        },
        navigation: {
            nextEl: '.swiper-button-next',
            prevEl: '.swiper-button-prev',
        },
        loop: true,
    });
}


$(function(){
    
    //header 공지
	fnswiperLoad();

    // 시스템 탭메뉴
	
	$(document).on("click",".com-tabmenu li",function(){
		var idx = $(this).index()
        $(".com-tabmenu li").removeClass("on");
        $(this).addClass("on");

        $(".tab-contents > li").removeClass("on");
        $(".tab-contents > li").eq(idx).addClass("on");

	});

    $(document).on("click", ".menu-item a", function(ev){
        $('.menu-item').removeClass('on');
        $(this).parents(".menu-item").addClass('on');
        if($(this).parents("li").find(".sub-menu").length == 0){
        	var menuUrl = $(this).data("menuurl");
        	var gMenuSn = $(this).data("menusn");
        	fn_movePage(menuUrl,gMenuSn);
        }
    });

    $('.sub-menu li a').click(function(ev){
        ev.preventDefault();
        $('.sub-menu li a').removeClass('on');
        $(this).addClass('on');
        if($(this).length != 0){
        	var menuUrl = $(this).data("menuurl");
        	var gMenuSn = $(this).data("menusn");
        	fn_movePage(menuUrl,gMenuSn);
        }
    });
    
 // 좌메뉴 open close
    $('.nav-btn button').click(function(){
        if($(this).hasClass('on')){
            console.log($(this));
            $(this).removeClass('on');
            $('.side-nav').css({display: 'table-cell'});
        }else{
            $(this).addClass('on');
            $('.side-nav').css({display: 'none'});
        }
    });

    $(document).on('change','.fileBox .uploadBtn', function(){
        if(window.FileReader){
            var filename = $(this)[0].files[0].name;
        } else {
            var filename = $(this).val().split('/').pop().split('\\').pop();
        }
        $(this).siblings('.fileName').val(filename);
    });
    
    $(document).on('change','.fileBox .uploadBtn2', function(){
        if(window.FileReader){
            var filename = $(this)[0].files[0].name;
        } else {
            var filename = $(this).val().split('/').pop().split('\\').pop();
        }
        $(this).siblings('.fileName2').val(filename);
    });
    
    // 데이터피커 한글화
    $("#datepicker").datepicker();
    $.datepicker.setDefaults({
    	changeMonth: true,
    	changeYear: true,
        yearRange: 'c-150:c+10',
        dateFormat: 'yymmdd',
        prevText: '이전 달',
        nextText: '다음 달',
        monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
        monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
        dayNames: ['일', '월', '화', '수', '목', '금', '토'],
        dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
        dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
        showMonthAfterYear: true
        
    })

});

//시작일과 종료일의 일자 차이를 반환한다.
//date_st : 시작일, date_ed : 종료일
var dateUtil = {
		getDiffDay : function(date_st, date_ed) {
			
			//일자를 Time으로 변환 후 일자로 재변환
			var days = (dateUtil.getTime(date_ed) - dateUtil.getTime(date_st)) / 60 / 60/ 24 / 1000;
			return days;
		},
		//입력받은 날짜를 Time으로 변환하여 반환한다.
		//date : 날짜 8자가 넘거나 작을 경우 입력받은 값 리턴
		getTime : function(date) {
			
			var temp = String(date);
			var return_val = null;
			
			if(temp.length != 8) {
				
				return_val = temp;
				
			} else {
				
				var objDate = new Date(temp.substring(0 , 4), temp.substring(4 , 6), temp.substring(6 , 8));
				return_val = objDate.getTime();
				
			}
			return return_val;
			
		}
};

//페이지 로드
function fnPageLoad(url,param){
	$("#content").load(url,param,function(response,status,xhr){
		if(status == "success"){
			$("#pageInfoFrm input[name=url]").val(url);
			$("#pageInfoFrm input[name=param]").val(param);
		}else{
			$("#content").html(response);
		}
	});
}


//페이지 이동
function fnGoPage(pageNo,formId){
	$(formId).find("input[name=pageNo]").val(pageNo);
	fnPageLoad($(formId).attr("action"),$(formId).serialize())
}
