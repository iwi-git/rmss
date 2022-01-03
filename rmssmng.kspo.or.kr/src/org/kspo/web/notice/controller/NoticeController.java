package org.kspo.web.notice.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.kspo.framework.global.BaseController;
import org.kspo.framework.resolver.ReqMap;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
import org.kspo.framework.util.PropertiesUtil;
import org.kspo.web.account.service.AccountService;
import org.kspo.web.file.service.FileService;
import org.kspo.web.notice.service.NoticeService;
import org.kspo.web.sms.service.SmsService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @Since 2021. 3. 15.
 * @Author SCY
 * @FileName : NoticeController.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. SCY : 최초작성
 * </pre>
 */
@Controller
@RequestMapping("/notice")
public class NoticeController extends BaseController{
	
	protected static String WEB_FILE_EXT   = PropertiesUtil.getString("WEB_FILE_EXT");		//파일확장자
	
	//게시판
	@Resource
	private NoticeService noticeService;

	//첨부파일
	@Resource
	private FileService fileService;
	
	//체육단체 계정관리
	@Resource
	private AccountService accountService;
	
	//SMS
	@Resource
	private SmsService smsService;
		
	/**
	 * 게시판 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectNoticeList.kspo")
	public String selectNoticeList(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		KSPOMap paramMap  = reqMap.getReqMap();

		//게시판 조회
		KSPOList selectNoticeList = noticeService.selectNoticeList(paramMap);
		
		model.addAttribute("noticeList",selectNoticeList);
		model.addAttribute("pageInfo",selectNoticeList.getPageInfo());//페이지 정보
		
		return "web/notice/notice";
	}
	
	/**
	 * 게시판 상세 페이지
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectNoticeDetail.kspo")
	public String selectNoticeDetail(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		// 게시판 상세 정보 조회한다.
		KSPOMap selectNoticeDetail = noticeService.selectNoticeDetail(paramMap);
		model.addAttribute("detail", selectNoticeDetail);
			
		KSPOList file = noticeService.selectNoticeFileList(paramMap);
		model.addAttribute("file",file);

		//게시글 확인 시 조회수 +1
		noticeService.updateNoticeReadNumJs(paramMap);
		
		return "web/notice/noticeDetail";
	}
	
	/**
	 * 게시판 글쓰기
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectNoticeAdd.kspo")
	public String selectNoticeAdd(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		if(!"".equals(paramMap.getStr("BRD_DTL_SN"))) {
		
			// 게시판 상세 정보 조회한다.
			KSPOMap selectNoticeDetail = noticeService.selectNoticeDetail(paramMap);
			
			KSPOList file = noticeService.selectNoticeFileList(paramMap);
			
			model.addAttribute("detail", selectNoticeDetail);
			model.addAttribute("file",file);
		}
		
		return "web/notice/noticeAdd";
	}
	
	/**
	 * 게시판 게시글 등록
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertNoticeJs.kspo")
	public String insertNoticeJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{

		KSPOMap paramMap  = reqMap.getReqMap();
		
		//게시판 상세 등록
		noticeService.insertNoticeDJs(paramMap);
		
		//파일업로드
		KSPOList noticeFileList = fileService.fileUpload(request,"/notice","TRMB_BOARD_FILE_F","BRD_FILE_SN", WEB_FILE_EXT);
			
		if(!noticeFileList.isEmpty()){ //업로드 파일 있을경우
		  for(int i=0; i<noticeFileList.size(); i++){ 
			  
			  KSPOMap fileMap = (KSPOMap) noticeFileList.get(i);
			  
			  fileMap.put("EMP_NO",paramMap.getStr("EMP_NO"));
			  fileMap.put("BRD_DTL_SN",paramMap.getStr("BRD_DTL_SN"));
			  
			  noticeService.insertNoticeFileJs(fileMap);
	  
	  		}
	  	}
		
		/**********************
		 * SMS 전송처리 시작
		 **********************/
		if("Y".equals(paramMap.getStr("SMS_YN"))) {
			
			KSPOList selectAccountDtl = accountService.selectAccountExcelList(paramMap);
			for(int i=0; i < selectAccountDtl.size(); i++) {
				KSPOMap dtlMap = (KSPOMap) selectAccountDtl.get(i);
				
				if(!"".equals(dtlMap.getStr("CPNO"))) {
					/**********************
					 * SMS 전송처리
					 * 필수 패러미터
					 * USERCODE		: 유저코드
					 * REQNAME		: 발송자명
					 * REQPHONE		: 회신번호
					 * CALLNAME		: 수신자명
					 * CALLPHONE	: 수신번호
					 * MSG			: 메세지내용
					 * TEMPLATECODE	: 알림톡 템플릿 코드
					 **********************/
					KSPOMap smsMap  = reqMap.getReqMap();
					
					String pMsg = "[체육요원복무관리시스템] \r\n"
					+ "안녕하세요. 국민체육진흥공단입니다. \r\n"
					+ "공지사항 게시판에 복무관리 업무 관련 중요 공지가 등록되었습니다.\r\n"
					+ "-\"#{변수}\"\r\n"
					+ "시스템 공지사항 게시판에서 확인 후 업무에 참고하시길 바랍니다.\r\n"
					+ "감사합니다.";
					
					pMsg = pMsg.replace("#{변수}", paramMap.getStr("SUBJECT"));
					
					smsMap.put("usercode", PropertiesUtil.getString("USERCODE"));
					smsMap.put("deptcode",PropertiesUtil.getString("DEPTCODE"));
					smsMap.put("yellowidKey",PropertiesUtil.getString("YELLOWKEY"));
					smsMap.put("reqname","국민체육진흥공단");
					smsMap.put("reqphone",PropertiesUtil.getString("REQPHONE"));
					smsMap.put("callname",dtlMap.getStr("MNGR_NM"));
					smsMap.put("callphone",dtlMap.getStr("CPNO"));
					smsMap.put("msg",pMsg); //문자내용
					smsMap.put("templatecode","rmss_003"); //템플릿 코드
					
					smsService.insertSmsLog(smsMap);
					smsService.insertSms(smsMap);
				}
					
			}
			
		}
		/**********************
		 * SMS 전송처리 종료
		 **********************/
		
		return "jsonView";
	}
	
	/**
	 * 게시판 수정 페이지
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateNoticeJs.kspo")
	public String selectNoticeEdit(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		//게시판 상세 수정
		noticeService.updateNoticeDJs(paramMap);
		
		//파일 업로드
		KSPOList noticeFileList = fileService.fileUpload(request,"/notice","TRMB_BOARD_FILE_F","BRD_FILE_SN", WEB_FILE_EXT);
			
		if(!noticeFileList.isEmpty()){ 
		  for(int i=0; i<noticeFileList.size(); i++){
			  
			  KSPOMap fileMap = (KSPOMap) noticeFileList.get(i);
			  
			  fileMap.put("EMP_NO",paramMap.getStr("EMP_NO"));
			  fileMap.put("BRD_DTL_SN",paramMap.getStr("BRD_DTL_SN"));
	
			  noticeService.insertNoticeFileJs(fileMap);
	  
	  		}
	  
	  	}
		
		return "jsonView";
	}
	
	/**
	 * 게시판 삭제
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/deleteNoticeJs.kspo")
	public String deleteNoticeJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{

		KSPOMap paramMap  = reqMap.getReqMap();
		
		noticeService.txDeleteNoticeDJs(paramMap);
		
		return "jsonView";
	}
	
	/**
	 * 게시판 첨부파일 삭제
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/deleteNoticeFileJs.kspo")
	public String deleteNoticeFileJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{

		KSPOMap paramMap  = reqMap.getReqMap();
		//게시판 메인테이블의 게시물 삭제
		noticeService.deleteNoticeFileJs(paramMap);
				
		return "jsonView";
	}
	
	/**
	 * 공지사항 메인 긴급공지 조회
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectTopNoticeListJs.kspo")
	public String selectTopNoticeListJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		KSPOList noticeList= noticeService.selectTopNoticeList();
		model.addAttribute("noticeList", noticeList);//상단 긴급공지 리스트
		return "jsonView";
	}
}
