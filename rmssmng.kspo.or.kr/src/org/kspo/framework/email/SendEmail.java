package org.kspo.framework.email;

import org.kspo.framework.util.KSPOMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * SMTP 이메일 
 * @author 
 */
public class SendEmail {
	
	private static Logger log 			= LoggerFactory.getLogger(SendEmail.class);

	/**
	 * HTML 이메일 내용 생성
	 * 
	 * 메일내용 생성후에 EmailService.insertEmailLog() 호출후 TRMZ_EMAIL_L에 저장후에
	 * batch.kspo.or.kr프로젝트의 org.kspo.rmssmng.sendEmail.SendEmailCtl 배치에서 메일발송처리됨
	 * 
	 */
	public static void createEmailHtml(KSPOMap emailMap) throws Exception{
		
		try{
			
			String htmlObject = "";
			
			StringBuffer sBuff = new StringBuffer();
			sBuff.append("<!DOCTYPE html>\n");
			sBuff.append("		<html lang=\"ko\"  xml:lang=\"ko\">\n");
			sBuff.append("		<head>\n");
			sBuff.append("			<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />\n");
			sBuff.append("			<meta http-equiv=\"Content-Script-Type\" content=\"text/javascript\" />\n");
			sBuff.append("			<meta http-equiv=\"Content-Style-Type\" content=\"text/css\" />\n");
			sBuff.append("			<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\" />\n");
			sBuff.append("			<title>국민체육진흥공단 체육요원 복무관리시스템</title>\n");
			sBuff.append("		</head>\n");
			sBuff.append("		<body>\n");
			sBuff.append("			<div style=\"position:relative;width:720px;font-family:Dotum; border:2px solid #0142b8;\">\n");
			sBuff.append("				<div style=\"padding:45px 26px 5px; text-align:center; background-color:#f9f9f9;\">\n");
			sBuff.append("					<h2>\n");
			sBuff.append(emailMap.getStr("title"));
			sBuff.append("					</h2>\n");
			sBuff.append("				</div>\n");
			sBuff.append("				<div style=\"padding:36px;background-color:#f9f9f9;\">\n");
			sBuff.append("					<div style=\"padding:62px 20px 51px;text-align:center;background-color:#f0f0f9;\">\n");
			sBuff.append("						<p style=\"margin:0;font-size:17px;line-height:26px;color:#333;\">\n");
			sBuff.append("							안녕하세요. 국민체육진흥공단입니다.<br/><br/>\n");
			sBuff.append(emailMap.getStr("sendContents"));
			sBuff.append("						</p>\n");
			sBuff.append("					</div>\n");			
			sBuff.append("				</div>\n");
			sBuff.append("			</div>\n");
			sBuff.append("			<div style=\"width:664px;padding:10px 30px;background-color:#ddd;\">\n");
			sBuff.append("				<p style=\"margin:0;font-size:12px;line-height:17px;word-break:break-all; color:#666;\">본 메일은 발신 전용이므로 회신하실 수 없습니다.<br/>\n");
			sBuff.append("				05540 서울시 송파구 올림픽로 424 올림픽회관  &nbsp;   TEL  02-410-1114   &nbsp;  FAX  02-410-1219 <br/>\n");		
			sBuff.append("				COPYRIGHT ⓒ 2021 국민체육진흥공단. ALL RIGHT RESERVED.\n");			
			sBuff.append("				</p>\n");
			sBuff.append("			</div>\n");	
			sBuff.append("		</body>\n");
			sBuff.append("		</html>\n");
			
			htmlObject = sBuff.toString();
			
			htmlObject = htmlObject.replaceAll("#NAME", emailMap.getStr("APPL_NM"));
			
			emailMap.put("sendContents",htmlObject);
			
		}catch(Exception e){
			log.error(e.getMessage(),e);
			
		}
		
	}
	
}