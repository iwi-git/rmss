package org.kspo.framework.global;

import org.kspo.framework.util.KSPOList;

/**
 * @Since 2021. 3. 15.
 * @Author LGH
 * @FileName : SystemConst.java
 * <pre>
 * 전역 상수 정의 클래스
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. yunkidon@kspo.or.kr : 최초작성
 * 2021. 3. 15. LGH
 * </pre>
 */
public class SystemConst {
	
    // 공통
    public static final String _SERV_DNS	= "_SERV_DNS";	// 서버타입(도메인) 
    public static final String _SERV_IP		= "_SERV_IP";	// 서버IP 
    public static final String _SERV_URI 	= "_SERV_URI";	// request uri
    public static final String _ClIENT_IP	= "_CLIENT_IP";	// 클라이언트 IP
    
    //Session
    public static final String _USER		= "USER";		// 사용자 순번
    public static final String _EMP_NO		= "EMP_NO";		// 사번
    public static final String _MNGR_NM		= "MNGR_NM";	// 사용자명
    public static final String _LOCGOV_NM	= "LOCGOV_NM";	// 소속
    public static final String _GRP_SN		= "GRP_SN";		// 권한 순번
    public static final String _MEMORG_SN	= "SESSION_MEMORG_SN";	// 가맹단체코드
    public static final String _USER_DV		= "USER_DV";	// 사용자구분        
    public static final String _GAME_CD		= "SESSION_GAME_CD";	// 가맹단체 종목        
    
    //Application
    public static final String _PAGING_DEF_ROW_CNT	= "recordCountPerPage";	// 페이징 로우 수
    public static final String _PAGING_DEF_LIST_CNT	= "pageSize";			// 표출 페이징 [1][2][3][4] 개수
    public static final String _PAGING_CURR_NO		= "currentPageNo";		// 현재 페이지 번호
    
    public static final int _LOGIN_INTERVAL_LIMIT = 300;		// 로그인 오류 시간 300초
    
    private static KSPOList leftMenu; //왼쪽 메뉴 저장

	public static KSPOList getLeftMenu() {
		return leftMenu;
	}

	public static void setLeftMenu(KSPOList leftMenu) {
		SystemConst.leftMenu = leftMenu;
	}

}
