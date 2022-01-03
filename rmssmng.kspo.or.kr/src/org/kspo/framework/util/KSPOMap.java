package org.kspo.framework.util;

import java.math.BigDecimal;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.kspo.framework.global.SystemConst;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import egovframework.rte.psl.dataaccess.util.CamelUtil;

/**
 * @Since 2021. 3. 15.
 * @Author yunkidon@kspo.or.kr
 * @FileName : KSPOMap.java
 * <pre>
 * View에서 DAO로 전달하기위한 객체로 Map<List> 형태의 객체이다.
 * 추가 및 수정 해서 사용하시기 바랍니다.
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. yunkidon@kspo.or.kr : 최초작성
 * 2021. 3. 15. LGH
 * </pre>
 */
public class KSPOMap extends HashMap<String, Object> {
	
	private static final long serialVersionUID = -1358522602608463578L;

	private static Logger log = LoggerFactory.getLogger(KSPOMap.class);
	
	public KSPOMap() {}
	
	public KSPOMap(HttpServletRequest request) {
		
		try {
			
			/*
			 * get request parameter
			 */
			setParamMap(request);
			
			/**
			 * get session values
			 */
			setSessionMap(request);
			
			/**
			 * 접속주소, 클라이언트 IP 등을 담는다.
			 */
			setETCMap(request);
			/**
			 * 페이지 정보
			 * */
			setPageInfo(request);
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error("{}",e.toString());
		}
	}
	
	/**
	 * <pre>
	 *    key값을 얻어낸다
	 * </pre>
	 * @param key
	 * @return value
	 */
	public String getStr(String key) {	
		if (get(key) == null) {
			return "";
		} else if (get(key) instanceof String[]) {
			if (((String[]) get(key)).length == 1) {
				return ((String[]) get(key))[0];
			}else{
				StringBuilder builder = new StringBuilder();
				StringBuilder logbuilder = new StringBuilder();
				logbuilder.append("\nPlease use the getStringArry(String " + key + ").\n The values of " + key + " are\n");
				
				for (String str : (String[]) get(key)) {
					builder.append(str);
					logbuilder.append(str + ",");
				}
				//log.error(logbuilder.toString());
				
				return builder.toString();
			}
		} else if (get(key) instanceof String) {
			// return (String) get(key);
			return ((String) get(key) == null) ? "" : (String) get(key);			
		}  else if (get(key) instanceof Integer) {
			
			return Integer.toString((Integer) get(key));			
		} else if (get(key) instanceof Long) {
			
			return Long.toString((Long) get(key));			
		} else if (get(key) instanceof BigDecimal) {
			
			return ((BigDecimal) get(key)).toString();			
		} else if (get(key) instanceof Double) {
			
			return Double.toString((Double) get(key));			
		} else {
			
			return "Unidentify Type";
		}
    }
	
	/**
	 * <pre>
	 *    key 와 값을 입력한다. 
	 * </pre>
	 * @param key
	 * @return value
	 */
	@Override
	public Object put(String key, Object value) {
		
		if(key == null){
			key = "";
		}
		if(value == null){
			value = "";
		}
		
		return super.put(key, value);
//		return this.put(key, value,false);
	}
	

	/**
	 * 
	 * @param String key
	 * @param Object value
	 * @param booean convert2CamelCase key를 낙타등표기여부. true : yes, false : no
	 * @return Object value
	 */
//	public Object put(String key, Object value, boolean convert2CamelCase) {
//		if(key == null){
//			key = "";
//		}
//		if(value == null){
//			value = "";
//		}
//		
//		if(convert2CamelCase) {
//			return super.put(CamelUtil.convert2CamelCase(key), value);
//		}else {
//			return super.put(key , value);
//		}
//		
//		
//	}	
	
	
	public Object get(String key) {
		return super.get(key);
	}
	
	/**
	 * <pre>
	 *    요청 키에 대한 배열을 리턴한다.
	 * </pre>
	 * @param key
	 * @return values of the key
	 */
	public String[] getStrArry(String key) {

		String [] value = new String[1];
	
		if (get(key) instanceof String[]) {
			value = (String[]) get(key);
		} else if (get(key) instanceof String) {
			value[0] = ((String) get(key) == null) ? "" : (String) get(key);			
		}
		
		return value;
	}
	
	/**
	 * <pre>
	 *    요청 키에 대한 arrayList을 리턴한다.
	 * </pre>
	 * @param key
	 * @return values of the key
	 */
	@SuppressWarnings("unchecked")
	public List<String> getStrArrayList(String key) {
		return (List<String>) get(key);
	}
	
	/**
     * 저장된 정보 제거
     */
    public void clear() {
    	super.clear();
    }

    /**
     * <pre>
     *    저장된 특정 정보 제거
     * </pre>
     * @param key - 특정 정보에 대한 키
     */
    public void clear(String key) {
    	super.remove(key);
    }	
	
    /**
     * <pre>
     *    요청 정보들에 대한 키를 리턴한다.
     * </pre>
     * @return - 키들의 배열
     */
    public String[] getKeys() {
		int iSize = size();

		String[] keys = new String[iSize];
		Set<?> set = keySet();
		Iterator<?> it = set.iterator();
		int i = 0;
		while (it.hasNext()) {
		    keys[i++] = (String) it.next();
		}
	
		return keys;
    }
    
    
    /** 테스트 부탁합니다.
     * key의 길이 기준으로 전체 key의 내용을 조회해서  KSPOList형태로 가공한다.
     * @param key - 기준이 되는 key
     * @return KSPOList - 기준 key의 개수만큼 map를 생성하여 List에 넣어서 전달한다.
     */    
    public KSPOList getMapInList(String key) {
    	
		KSPOList list = new KSPOList();

		String standardkey[] = getStrArry(key);

		String Totalkey[] = this.getKeys();

		KSPOMap kspoMap = new KSPOMap();

		for (int i = 0; i < standardkey.length; i++) {

			for (int k = 0; k < Totalkey.length; k++) {

				try {
					String[] value = null;

					if (get(Totalkey[k]) instanceof String[]) {
						value = getStrArry(Totalkey[k]);
					} else {
						value = new String[1];
						value[0] = getStr(Totalkey[k]);
					}

					kspoMap.put(Totalkey[k], value.length > i ? value[i] : value[0]);

				} catch (Exception e) {
					e.printStackTrace();
					log.error("{}", e.getMessage());
				}
			}

			list.add(kspoMap.clone());
			kspoMap.clear();
		}

		return list;
    }    
    
    /** 테스트 부탁합니다.
     * key에 해당하는 KSPOList를 구한다
     * @param key
     * @return KSPOList - key의 List를 반환한다.
     */    
    public KSPOList getList(String key) {
    	
    	 KSPOList list = new KSPOList();
    	
//    	 String temp[] = getKeys();
    	 String temp[] = this.getStrArry(key);
    	 
    	 for(int i=0; i < temp.length; i++) {
    		 list.add(temp[i]);    	
    	 }

    	 return list;
    }    
    
    
    /**
     * <pre>
     *    특정 key에 해당하는 데이터의 갯수를 리턴한다.
     * </pre>
     * @param key - 관심있는 키
     * @return - 키에 관련된 값들의 갯수
     */
    public int size(String key) {
	
		String temp[] = getStrArry(key);
		
		if (temp == null) {
		    return (int) 0;
		}
	
		return temp.length;
    }
    
    
    /**
     * <pre>
     *    index 번째 key 값을 얻어낸다.
     * </pre>
     * @param key - 사용할 키
     * @param index - 원하는 index 0부터 시작한다.
     * @return - index 번째 key 값, 의미가 없다면 null을 리턴한다.
     */
    public String get(String key, int index){
		String temp[] = getStrArry(key);
		String value = null;
		if (temp == null) {
		    return (String) null;
		}

		try {
		    value = temp.length >= index ? temp[index] : null;
		} catch (Exception ex) {
			System.out.println("key = " + key + ", index = " + index + "\n" + ex);
			ex.printStackTrace();
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
    	//return getInt(key, 0);
    	return getStr(key) == "" ? 0 : Integer.parseInt(getStr(key));
    }

    /**
     * <pre>
     *    key의 index번째 값을 int로 변환하여 리턴한다.
     * </pre>
     * @param key - 사용할 키
     * @param index - index번째 요소
     * @return - key의 index번째 값에 대한 int
     */
    public int getInt(String key, int index) {
		String value = this.get(key, index);
		if (value == null) {
		    return 0;
		}
	
		if (value.equals("")) {
		    return 0;
		}
	
		int iValue = 0;
		try {
		    iValue = Integer.parseInt(value);
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
    	return getDouble(key, 0);
    }

    /**
     * <pre>
     *    key의 index번째 값을 double로 변환하여 리턴한다.
     * </pre>
     * @param key - 사용할 키
     * @param index - index번째 요소
     * @return - key의 index번째 값에 대한 int
     */
    public double getDouble(String key, int index) {
    	String value = get(key, index);
    	if (value == null) {
    		return 0L;
    	}

    	if (value.equals("")) {
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
    	//return getLong(key, 0);
    	return Long.parseLong(getStr(key));
    }

    /**
     * <pre>
     *    key의 index번째 값을 long로 변환하여 리턴한다.
     * </pre>
     * @param key - 사용할 키
     * @param index - index번째 요소
     * @return - key의 index번째 값에 대한 int
     */
    public long getLong(String key, int index) {
    	String value = get(key, index);
		if (value == null) {
			return 0;
		}
	
		if (value.equals("")) {
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
     *    Map이 저장하고 있는 내용을 보여준다.
     * </pre>
     * @return - contents of Map
     */
    public String toString() {    	
    	String tmpStr ="";
    	//tmpStr = "\n" + super.toString().replaceAll("}, ", "}, \n") + "\n";
    	tmpStr = super.toString().replaceAll("=\\[\\{", "=\\[\n\\{").replaceAll("\\], ", "\\],\n").replaceAll("\\}, \\{", "\\},\n\\{");
    	return tmpStr;
    }
   
    /**
     * key에 대한 값들에 대한 문자열
     * @param key - 관심 key
     * @return - key와 관련된 값들의 문자열
     */
    @SuppressWarnings("unused")
	private String toString(String key) {
    	StringBuffer buffer = new StringBuffer();
    	String temp[] = getStrArry(key);
    	String svalue = null;
	
    	for (int j = 0; j < temp.length; j++) {
    		svalue = temp[j] != null ? temp[j] : "{null}";
    		buffer.append("\t").append(svalue).append("\n");
    	}

    	return buffer.toString();
    }
    
    
	/**
	 * <pre>
	 *    request 변수 hashmap에 바인딩 hashmap<String, String> 형태로 넣는다.)
	 *    변수명 끝에 '[]' 들어있으면 배열이라 판단하고 hashmap<String, ArrayList> 형태로 담는다.
	 * </pre> 
	 * @param request
	 */
	private void setParamMap(HttpServletRequest request) {
		
		Enumeration<?> em = request.getParameterNames();
		
        String key = null;
        String[] values = null;
		
        while (em.hasMoreElements()) {
            key = (String) em.nextElement();
            values = request.getParameterValues(key);
            if (values != null) {
            	put(key, (values.length > 1) ? values : values[0]);
            }
        }		
		

	}

	
	/**
	 * 세션정보를 Request parameter와 함게 담는다.
	 * @param request
	 */
	private void setSessionMap(HttpServletRequest request) {
		
		HttpSession session = request.getSession(true);

		Enumeration<String> em = session.getAttributeNames();

        String key = null;

        /**
         * 향후 로직 변경 필요
         */
        while (em.hasMoreElements()) {
            key = (String) em.nextElement();

            if((session.getAttribute(key) instanceof String)) {
                String values = (String) session.getAttribute(key);
                if (values != null) {
                	try {
                		this.put(key, values);
					} catch (Exception e) {
						e.printStackTrace();
						log.error("{}",e.getMessage());
					}
                }
            }else if((session.getAttribute(key) instanceof String[])) {
                String[] values = (String[]) session.getAttribute(key);
                if (values != null) {
                	this.put(key, (values.length > 1) ? values : values[0]);
                }
            }else if(session.getAttribute(key) instanceof KSPOMap){
            	KSPOMap values = (KSPOMap) session.getAttribute(key);
            	String[] keys = values.getKeys();
        		if(keys != null) {
        			for (int k = 0; k < keys.length; k++) {
        				switch(keys[k]) {
        					case SystemConst._USER :		this.put(SystemConst._USER,      values.getStr(keys[k]));	break;
        					case SystemConst._EMP_NO :		this.put(SystemConst._EMP_NO,      values.getStr(keys[k]));	break;
        					case SystemConst._MNGR_NM :		this.put(SystemConst._MNGR_NM,   values.getStr(keys[k]));	break;
        					case SystemConst._GRP_SN :		this.put(SystemConst._GRP_SN,    values.getStr(keys[k]));	break;
        					case SystemConst._USER_DV :		this.put(SystemConst._USER_DV,    values.getStr(keys[k]));	break;        					
        					case SystemConst._GAME_CD :		this.put(SystemConst._GAME_CD,    values.getStr(keys[k]));	break;
        					case SystemConst._MEMORG_SN :	this.put(SystemConst._MEMORG_SN,   values.getStr(keys[k])); break;
        				}
        			}
        		}
            } else {
            	log.error("\nKSPOMap에 프레임웍에서 자동으로 담는 세션(key={})은/는 String 타입만 지원 합니다. ",key);
            }

        }
		
	}	
	
	
	/**
	 * 서버주소, 접속자 IP등의 기타 정보를 담는다.
	 * @param request
	 */
	private void setETCMap(HttpServletRequest request) {
		this.put(SystemConst._SERV_DNS, request.getServerName());
		this.put(SystemConst._SERV_IP, ServerUtil.getLocalServerIp());//서버 아이피
		this.put(SystemConst._SERV_URI, request.getRequestURI());
		this.put(SystemConst._ClIENT_IP, request.getRemoteAddr());
	}

	/**
	 * 페이지 정보 로드
	 * @param request
	 */
	private void setPageInfo(HttpServletRequest request) {
		// 페이징 로우 수
		this.put(SystemConst._PAGING_DEF_ROW_CNT, getInt("recordCountPerPage") == 0 ? PropertiesUtil.getInt("PAGING_DEF_ROW_CNT") : getInt("recordCountPerPage")); 
		// 표출 페이징 [1][2][3][4] 개수
		this.put(SystemConst._PAGING_DEF_LIST_CNT, Integer.parseInt(PropertiesUtil.getString("PAGING_DEF_LIST_CNT")));		
		// 현재 페이지 번호
		this.put(SystemConst._PAGING_CURR_NO, getInt("pageNo") == 0 ? 1 : getInt("pageNo"));
	}

}
