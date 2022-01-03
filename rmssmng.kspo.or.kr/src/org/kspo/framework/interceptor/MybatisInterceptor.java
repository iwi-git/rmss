package org.kspo.framework.interceptor;

import java.lang.reflect.Field;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.apache.commons.lang3.time.StopWatch;
import org.apache.ibatis.cache.CacheKey;
import org.apache.ibatis.executor.Executor;
import org.apache.ibatis.mapping.BoundSql;
import org.apache.ibatis.mapping.MappedStatement;
import org.apache.ibatis.mapping.ParameterMapping;
import org.apache.ibatis.plugin.Interceptor;
import org.apache.ibatis.plugin.Intercepts;
import org.apache.ibatis.plugin.Invocation;
import org.apache.ibatis.plugin.Plugin;
import org.apache.ibatis.plugin.Signature;
import org.apache.ibatis.session.ResultHandler;
import org.apache.ibatis.session.RowBounds;
import org.kspo.framework.util.PropertiesUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @Since 2021. 3. 15.
 * @Author yunkidon@kspo.or.kr
 * @FileName : MybatisInterceptor.java
 * <pre>
 * 수행 시간이 오래걸리는 쿼리 로깅 및 특정 쿼리아이디 쿼리 로깅
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. yunkidon@kspo.or.kr : 최초작성
 * </pre>
 */
@Intercepts({ @Signature(type = Executor.class, method = "update", args = { MappedStatement.class, Object.class }),
		@Signature(type = Executor.class, method = "query", args = { MappedStatement.class, Object.class,
				RowBounds.class, ResultHandler.class, CacheKey.class, BoundSql.class }),
		@Signature(type = Executor.class, method = "query", args = { MappedStatement.class, Object.class,
				RowBounds.class, ResultHandler.class }) })
public class MybatisInterceptor implements Interceptor {

	private static Logger log = LoggerFactory.getLogger(MybatisInterceptor.class);

	private static String PARAM_BIND_FAIL = "**PARAM BIND FAIL**";
	
	
	/**
	 * 특정이상 시간 걸리는 Query 모니터링용으로  0이면 모두 로깅이다. Spring의 properties가 static 지원을 않함.
	 */	
	private int QUERY_OVERTIME = PropertiesUtil.getInt("MYBATIS_QUERY_OVERTIME_MILLIS");
	
	/**
	 * <pre>
	 *    mybatis plugin에서 제공하는 인터셉터에 쿼리와 파라메터를 추출하여 로그 출력
	 * </pre>
	 * 
	 * @author 이지홍
	 * @param invocation
	 * @return result
	 */
	@Override
	public Object intercept(Invocation invocation) throws Throwable {

		Object result = null;

		MappedStatement ms = null;

		BoundSql boundSql = null;

		// 쿼리 원본
		String sql = null;

		// 바인드된 쿼리
		String bindedSql = null;

		String paramStr = null;

		// The namespace of mapper + id
		String queryId = "";

		StopWatch stopWatch = new StopWatch();
		stopWatch.start();

		try {

			Object[] args = invocation.getArgs();
			ms = (MappedStatement) args[0];
			queryId = ms.getId();

			// 쿼리실행시 맵핑되는 파라메터
			Object params = (Object) args[1];

			// 쿼리 추출
			boundSql = ms.getBoundSql(params);
			sql = boundSql.getSql();

			// 쿼리실행시 맵핑되는 파라메터 스트링 변환
			paramStr = params != null ? params.toString() : "";
			bindedSql = paramBindSql(sql, params, boundSql);

			result = invocation.proceed();

		} catch (Exception e) {
			log.error("\n at MybatisInterceptor.intercept() \n" + e.toString());
			queryLogging(queryId, sql, bindedSql, paramStr, stopWatch, result);
			log.error("***************************SQL EXCEPTION TRACE : \n", e);
			//e.printStackTrace();
		} finally {

			stopWatch.stop();
			
			if (stopWatch.getTime() >= QUERY_OVERTIME ) {
					queryLogging(queryId, sql, bindedSql, paramStr, stopWatch, result);
			}
		}

		return result;
	}

	/**
	 * do Query logging
	 * 
	 * @param queryId
	 *            - The id in namespace of query mapper
	 * @param sql
	 * @param bindedSql
	 * @param paramStr
	 * @param tTime
	 * @param result
	 */
	private void queryLogging(String queryId, String sql, String bindedSql, String paramStr, StopWatch stopWatch, Object result) {
		StringBuffer sb = new StringBuffer();
		
		// 쿼리 수행시간, 쿼리, 파라미터 로그
		if (stopWatch.isStopped() == false) {
			sb.append(
					"\n\n\n\n**********************************QUERY EXCEPTION !!!!!******************************************");
		} else {
			sb.append(
					"\n\n\n\n********************************** Tunning the Query! ******************************************"
					+ "\n\n query execution Time(" + queryId + ") : " + stopWatch.toString());
		}
		
		if (bindedSql.indexOf(PARAM_BIND_FAIL) > -1) {
			// 파라메터 바인드가 실패한경우 로그
			sb.append("\n\n********************************** PARAM_BIND_FAIL ************************************\n"
					+ sql);
			sb.append(
					"\n********************************** look params at PARAM_BIND_FAIL ******************************\n"
					+ paramStr.replaceAll(",", ",\n"));
		} else {
			// 파라메터 바인드 성공한 경우 로그
			sb.append("\n\n********************************** params ******************************\n"
					+ paramStr.replaceAll(",", ",\n"));
			sb.append("\n********************************** binded params in sql************************************\n"
					+ bindedSql);
		}

		if (result == null) {
			sb.append("\n\n***************************** ResultSet is nothing *****************************\n");
		} else {
			//sb.append("\n\n***************************** ResultSet is  *****************************\n"
			//+ result.toString().replaceAll("}, ", "}\n"));
		}
		
		log.error(sb.toString());		
	}

	/**
	 * <pre>
	 *    sql구문에 파라메터를 바인드한다.
	 * </pre>
	 * 
	 * @author 이지홍
	 * @param sql
	 * @param params
	 * @param boundSql
	 * @return sql
	 */
	private String paramBindSql(String sql, Object params, BoundSql boundSql) {
		try {
			if (params == null) {
				sql = sql.replaceFirst("\\?", "''");
			} else {
				if (params instanceof Integer || params instanceof Long || params instanceof Float
						|| params instanceof Double) {
					// 파라미터가 Integer, Long, Float, Double 타입인경우
					sql = sql.replaceFirst("\\?", params.toString());
				} else if (params instanceof String) {
					// 파라미터가 String 타입인경우
					sql = sql.replaceFirst("\\?", "'" + params + "'");
				} else if (params instanceof Map) {
					// 파라미터가 Map 타입인경우
					List<ParameterMapping> paramMap = boundSql.getParameterMappings();

					for (ParameterMapping mapping : paramMap) {
						String mapKey = mapping.getProperty(); // 키 추출
						Object value = ((Map<?, ?>) params).get(mapKey); // 값 추출

						if (value == null) {
							sql = sql.replaceFirst("\\?", "'" + "@null@" + "'");
						} else {
							if (value instanceof String) {
								sql = sql.replaceFirst("\\?", "'" + value + "'");
							} else {
								sql = sql.replaceFirst("\\?", value.toString());
							}
						}
					}
				} else {
					// 파라메터가 그외 클래스인 경우 따로 구현필요
					// sql = "\n " + PARAM_BIND_FAIL + "\n 파라메터가 기본 클래스 이외의 경우임 추가 구현필요\n" + sql;
					List<ParameterMapping> paramMapping = boundSql.getParameterMappings();
					Class<? extends Object> paramClass = params.getClass();

					for (ParameterMapping mapping : paramMapping) {
						String propValue = mapping.getProperty();

						log.debug("\n\n\n\nkey is "+propValue+" = "+propValue);
						
						Field field = null;
							
						Class<?> javaType = null;
						
												
						try {
							field = paramClass.getDeclaredField(propValue);
							
							field.setAccessible(true);
							javaType = mapping.getJavaType();
							
							if (String.class == javaType) {
								sql = sql.replaceFirst("\\?", "'" + field.get(params) + "'");
							} else {
									sql = sql.replaceFirst("\\?", field.get(params).toString());
							}						
							
						} catch (NoSuchFieldException ne) {
							
							//log.info(ne.toString());
							
							field = paramClass.getSuperclass().getDeclaredField(propValue);
							
							field.setAccessible(true);
							javaType = mapping.getJavaType();
							
							if (String.class == javaType) {
								sql = sql.replaceFirst("\\?", "'" + field.get(params) + "'");
							} else {
									sql = sql.replaceFirst("\\?", field.get(params).toString());
							}	
						} catch (Exception e) {
							log.info(e.toString());
						}
					}
				}
			}
		} catch (Exception ex) {
			log.info(ex.toString());
			//ex.printStackTrace();
		}

		return sql;
	}

	@Override
	public Object plugin(Object target) {
		return Plugin.wrap(target, this);
	}

	@Override
	public void setProperties(Properties arg0) {
	}

}

