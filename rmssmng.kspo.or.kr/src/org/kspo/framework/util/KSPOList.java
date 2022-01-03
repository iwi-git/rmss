package org.kspo.framework.util;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

/**
 * @Since 2021. 3. 15.
 * @Author yunkidon@kspo.or.kr
 * @FileName : KSPOList.java
 * <pre>
 * DAO에서 View로 전달하기위한 객체로 List<Map> 형태의 객체이다.
 * 추가 및 수정 해서 사용하시기 바랍니다.
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. yunkidon@kspo.or.kr : 최초작성
 * 2021. 3. 15. LGH
 * </pre>
 */
public class KSPOList extends ArrayList<Object> {

	private static Logger log = LoggerFactory.getLogger(KSPOList.class);
	
    private static final long serialVersionUID = -961461052881634502L;
    
    private PaginationInfo pageInfo;
    
	/**
	 * <pre>
	 *    map 값을 string 형식으로 반환
	 * </pre>
	 * @param map
	 * @param key
	 * @return returnVal
	 * @exception Exception
	 */
	public static String getStr(Map<?, ?> map, String key) throws Exception {
		String returnVal = "";
		if (map != null) {
			if (map.get(key) != null) {
				if (map.get(key) instanceof String) {
					returnVal = (String) map.get(key);
				} else if (map.get(key) instanceof Integer) {
					returnVal = Integer.toString((Integer) map.get(key));
				} else if (map.get(key) instanceof Long) {
					returnVal = Long.toString((Long) map.get(key));
				} else if (map.get(key) instanceof BigDecimal) {
					returnVal = ((BigDecimal) map.get(key)).toString();
				} else if (map.get(key) instanceof Double) {
					returnVal = Double.toString((Double) map.get(key));
				} else {
					throw new Exception("\n This map " + '"' + key + '"' + " value can not cast String type");
				}
			}
		}
		
		return returnVal; 
	}    
    
	/**
     * <pre>
     *    index 번째 key 값을 얻어낸다.
     * </pre>
     * @param key - 사용할 키
     * @param index - 원하는 index
     * @return - index 번째 key 값, 의미가 없다면 null을 리턴한다.
     */
    public String get(int index, String key) {
    	String value = null;
		try {
			if(super.size() > 0) {
				value = getStr((Map) super.get(index), key);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			log.error("key = {}, index = {}",key,index);
		}
		
		return value;
    }

    /**
     * <pre>
     *    0번째 key에 대한 값을 얻어낸다.
     * </pre>
     * @param key - 사용할 키
     * @return - 0번째 key에 대응하는 값
     */
    public String get(String key) {
    	return get(0, key);
    }
    
    /**
     * <pre>
     *    0번째 key에 대한 값을 얻어낸다.
     * </pre>
     * @param key - 사용할 키
     * @return - 0번째 key에 대응하는 값
     */
    public String getStr(String key) {
    	return getStr(0, key);
    }	
    
    /**
     * <pre>
     *    index 번째 key 값을 얻어낸다.
     * </pre>
     * @param key - 사용할 키
     * @param index - 원하는 index
     * @return - index 번째 key 값
     */
    public String getStr(int index, String key) {
		String value = get(index, key);
		if (value == null) {
		    return "";
		}
	
		return value;
    }    
    
    /**
     * <pre>
     *    key의 0번째 값을 int로 변환하여 리턴한다.
     * </pre>
     * @param key - 사용할 키
     * @return - key의 0번째 값에 대한 BigDecimal
     */
    public int getInt(String key) {
    	return getInt(0, key);
    }

    /**
     * <pre>
     *    key의 index번째 값을 int로 변환하여 리턴한다.
     * </pre>
     * @param key - 사용할 키
     * @param index - index번째 요소
     * @return - key의 index번째 값에 대한 int
     */
    public int getInt(int index, String key) {
    	
    	if(StringUtil.isEmpty(this.get(index, key))) {
    		return 0;
    	}
    	
		int iValue = 0;
		
		try {
		    iValue = Integer.parseInt(this.get(index, key));
		} catch (NumberFormatException ex) {
		}
	
		return iValue;
    }
    
    /**
     * <pre>
     *    key의 0번째 값을 double로 변환하여 리턴한다.
     * </pre>
     * @param key - 사용할 키
     * @return - key의 0번째 값에 대한 double
     */
    public double getDouble(String key) {
    	return getDouble(0, key);
    }

    public double getDouble(int index, String key) {
		String value = this.get(index, key);
		if (value == null) {
		    return 0L;
		}
	
		if ("".equals(value)) {
		    return 0L;
		}

		double dValue = 0.0D;
		
		try {
		    dValue = Double.parseDouble(value);
		} catch (NumberFormatException ex) {
		}
	
		return dValue;
    }

    /**
     * <pre>
     *    key의 0번째 값을 long로 변환하여 리턴한다.
     * </pre>
     * @param key - 사용할 키
     * @return - key의 0번째 값에 대한 BigDecimal
     */
    public long getLong(String key) {
    	return getLong(0, key);
    }

    /**
     * <pre>
     *    key의 index번째 값을 long로 변환하여 리턴한다.
     * </pre>
     * @param key - 사용할 키
     * @param index - index번째 요소
     * @return - key의 index번째 값에 대한 int
     */
    public long getLong(int index, String key) {
		String value = get(index, key);
		if (value == null) {
		    return 0;
		}
	
		if ("".equals(value)) {
		    return 0;
		}
	
		long lValue = 0;
		
		try {
			lValue = Long.parseLong(value);
		} catch (NumberFormatException ex) {
		}
	
		return lValue;
    }
    
    /**
     * <pre>
     *    리스트의 index번째 요소에 해당 키값을 추가한다.
     * </pre>
     * @param index(추가할 index)
     * @param key(사용할 키값)
     * @param value(입력할 값)
     */
	public void addStr(int index, String key, String value) {
    	try {
    		KSPOMap rstList = new KSPOMap();
			
			if (null == key) {
				key = "";
			}
			
			if (null == value) {
				value = "";
			}
			
			if (this.size() > 0 && (this.size() - 1) >= index) {			
				rstList = (KSPOMap) this.get(index);
				rstList.put(key, value);			
				this.set(index, rstList);			
	    	} else {
				rstList.put(key, value);
				this.add(index, rstList.clone());
			}			
	    } catch (Exception ex) {
	    	ex.printStackTrace();
		}
    }
    
    /**
     * <pre>
     *    리스트의 0번째 요소에 해당 키값을 추가한다.
     * </pre>
     * @param index(추가할 index)
     * @param key(사용할 키값)
     * @param value(입력할 값)
     */
	public void addStr(String key, String value) {
    	int index = 0;
    	addStr(index, key, value);
    }


	/**
	 * @return
	 */
	public PaginationInfo getPageInfo() {
		
		PaginationInfo info = new PaginationInfo();

		if( getInt("CURRENT_PAGE_NO") != 0 ) {
			info.setCurrentPageNo(getInt("CURRENT_PAGE_NO"));				//현재 페이지 번호		
			info.setRecordCountPerPage(getInt("RECORD_COUNT_PER_PAGE"));	//한 폐이지당 게시되는 게시물 건 수
			info.setPageSize(getInt("PAGE_SIZE"));						//페이지 리스트에 게시되는 페이지 건수
			info.setTotalRecordCount(getInt("TOTAL_RECORD_COUNT"));		//전체 게시물 건 수
		} else {
			info.setCurrentPageNo(1);				//현재 페이지 번호		
			info.setRecordCountPerPage(10);	//한 폐이지당 게시되는 게시물 건 수
			info.setPageSize(10);						//페이지 리스트에 게시되는 페이지 건수
			info.setTotalRecordCount(getInt("TOTAL_RECORD_COUNT"));		//전체 게시물 건 수
		}
		
		return info;
	}
}
