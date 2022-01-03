
// 패스워드 팝업 닫기
function pwpopClose () {
    $(".pw-change").removeClass("active")
    $("body").css("overflow","auto")
}

// 패스워드 팝업 열기
function pwpopOpen() {
    $(".pw-change").addClass("active")
    $("body").css("overflow","hidden")
}

// 담당자 배정 팝업 열기
function chagerOpen() {
    $(".charger-popup").addClass("active")
    $("body").css("overflow","hidden")
}

// 담당자 배정 팝업 닫기
function chagerClose() {
    $(".charger-popup").removeClass("active")
    $("body").css("overflow","auto")
}

//진행내역 팝업 열기
function progressOpen() {
    $(".running-progress").addClass("active")
    $("body").css("overflow","hidden")
}

//진행내역 팝업 닫기
function progressClose() {
    $(".running-progress").removeClass("active")
    $("body").css("overflow","auto")
}

//반려사유 팝업 열기
function returnOpen() {
    $(".return-pop").addClass("active")
    $("body").css("overflow","hidden")
}

//반려사유 팝업 닫기
function returnClose() {
    $(".return-pop").removeClass("active")
    $("body").css("overflow","auto")
}

// 프로젝트 수정 팝업 열기
function projectOpen(){
    $(".project-popup").addClass("active")
    $("body").css("overflow", "hidden")
}

//팝업 닫기
function popClose() {
    $(".cpt-popup").removeClass("active")
    $("body").css("overflow","auto")
}

$(function(){
    //20200203 추가
    $(".dim").click(popClose)
    $(".cpt-popup .pop-close").click(popClose)
    $(".cpt-popup .popclose-btn").click(popClose)

    //검수 팝업 open
    $(".btn.checking").click(function(){
        $(".assess-pop").addClass("active")
        $("body").css("overflow","hidden")
    })

    //처리단계 도움말 팝업 open
    $(".icon-info").click(function(){
        $(".process-pop").addClass("active")
        $("body").css("overflow","hidden")
    })

    //프로젝트 관리자 팝업
    $(".project-modify").click(projectOpen)

    //20200131 추가
    //header 공지
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

    $(".change-pw").click(pwpopOpen)
    $(".pop-close").click(pwpopClose)
    $(".dim").click(pwpopClose)

    $(".btn.charger").click(chagerOpen)
    $(".pop-close").click(chagerClose)
    $(".dim").click(chagerClose)

    $(".progressing.forc").click(progressOpen)
    $(".pop-close").click(progressClose)
    $(".dim").click(progressClose)

    $(".return").click(returnOpen)
    $(".pop-close").click(returnClose)
    $(".dim").click(returnClose)
    

    // 시스템 탭메뉴
    $(".com-tabmenu li").click(function(){
        var idx = $(this).index()
        $(".com-tabmenu li").removeClass("on")
        $(this).addClass("on")

        $(".tab-contents > li").removeClass("on")
        $(".tab-contents > li").eq(idx).addClass("on")
    })

    $(".user-list .table-grid tbody tr").click(function(){
        $(".user-list .table-grid tbody tr").removeClass("on")
        $(this).addClass("on")
    })


    // 데이터피커 한글화
    $(".datepick").datepicker();
    /*
    $("#datepicker").datepicker();
    $("#datepicker02-start").datepicker();
    $("#datepicker02-fin").datepicker();
    $("#datepicker03-start").datepicker();
    $("#datepicker03-fin").datepicker();
    $("#datepicker04-start").datepicker();
    $("#datepicker04-fin").datepicker();
    $("#datepicker05-start").datepicker();
    $("#datepicker05-fin").datepicker();
    $("#datepicker06-start").datepicker();
    $("#datepicker06-fin").datepicker();
    $("#datepicker07").datepicker();
    */
    $.datepicker.setDefaults({
        dateFormat: 'yymmdd',
        prevText: '이전 달',
        nextText: '다음 달',
        monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
        monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
        dayNames: ['일', '월', '화', '수', '목', '금', '토'],
        dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
        dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
        showMonthAfterYear: true,
        yearSuffix: '년'
    })

    // 파일첨부 input 변경
    //var uploadFile = $('.fileBox .uploadBtn');
    $(document).on('change','.fileBox .uploadBtn', function(){
        if(window.FileReader){
            var filename = $(this)[0].files[0].name;
        } else {
            var filename = $(this).val().split('/').pop().split('\\').pop();
        }
        $(this).siblings('.fileName').val(filename);
    });

    // 프로젝트 리스트
    $(".project-list li").click(function(){
        $(".project-list li").removeClass("on")
        $(this).addClass("on")
    })

    // 답글 리스트 open close
    $(".comt-num").click(function(){
        var Vew = $(this).parents(".com-reply-view").hasClass("view")

        if(Vew){
            $(this).parents(".com-reply-view").removeClass("view")
        } else {
            $(this).parents(".com-reply-view").addClass("view")
        }
    })


    /* ------------------------- 20201214 추가 ------------------------- */

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

    // 좌메뉴 드롭다운
    $('.menu-item').click(function(ev){
        ev.preventDefault();
        $('.menu-item').removeClass('on');
        $(this).addClass('on');
    });

    $('.sub-menu li a').click(function(ev){
        ev.preventDefault();
        $('.sub-menu li a').removeClass('on');
        $(this).addClass('on');
    });
    


})

