﻿<%@page session="false"%>
<%@page import="java.net.*,java.io.*,java.util.Date"%>
<%
try {
	String reqUrl = request.getParameter("url");
	URL url = new URL(reqUrl);
	HttpURLConnection con = (HttpURLConnection)url.openConnection();
	con.setDoOutput(true);
	con.setUseCaches(false);
	con.setRequestMethod(request.getMethod());
	if(request.getContentType() != null) {
	  con.setRequestProperty("Content-Type", request.getContentType());
	}
    con.setRequestProperty("Referer", request.getHeader("Referer"));
    
	out.clear();

    response.setContentType(con.getContentType());
    InputStream inStream = con.getInputStream();
    StringBuilder sb = new StringBuilder();
    String line;
    String resultHtml;
    try{
    	BufferedReader reader = new BufferedReader(new InputStreamReader(inStream,"UTF-8"));
    	while((line = reader.readLine()) !=null){
    		sb.append(line).append("\n");
    	}
    	resultHtml = sb.toString();
    	String startString = "<ul class=\"qy_list\">";
    	String endString = "</ul>";
    	int startIndex = resultHtml.indexOf(startString);
    	int lastIndex = resultHtml.indexOf(endString);

    	String str = resultHtml.substring(startIndex + startString.length(),lastIndex);
    	str = str.replaceAll("<li>","")
    			.replaceAll("</li>","")
    			.replaceAll("<span class=\"span1\">","")
    			.replaceAll("<span class=\"span2\">","")
    			.replaceAll("<span class=\"span3\">","")
    			.replaceAll("<span class=\"span4\">","")
    			.replaceAll("\t","")
    			.replaceAll("\n","")
                .replaceAll(" ","");
    	String[] strArray = str.split("</span>");
    	sb = new StringBuilder();
    	sb.append("{");
    	for(int i=0;i<strArray.length;i+=4){
    		if(strArray[i].equals("全路网"))
    			sb.append("\"All\":{");
    		else if(strArray[i].equals("二环内"))
    			sb.append("\"in2nd\":{");
    		else if(strArray[i].equals("二环至三环"))
    			sb.append("\"2ndTo3rd\":{");
    		else if(strArray[i].equals("三环至四环"))
    			sb.append("\"3rdTo4th\":{");
    		else if(strArray[i].equals("四环至五环"))
    			sb.append("\"4thTo5ve\":{");
    		else if(strArray[i].equals("东城区"))
    			sb.append("\"eastCity\":{");
    		else if(strArray[i].equals("西城区"))
    			sb.append("\"westCity\":{");
    		else if(strArray[i].equals("海淀区"))
    			sb.append("\"haiDian\":{");
    		else if(strArray[i].equals("朝阳区"))
    			sb.append("\"chaoYang\":{");
    		else if(strArray[i].equals("丰台区"))
    			sb.append("\"fengTai\":{");
    		else if(strArray[i].equals("石景山区"))
    			sb.append("\"siJingSan\":{");
			sb.append("\"congestionIndex\":");
			sb.append("\""+strArray[i+1]+"\",");
			sb.append("\"state\":");
			sb.append("\""+strArray[i+2]+"\",");
			sb.append("\"speed\":");
			sb.append("\""+strArray[i+3].replaceAll("km/h","")+"\"");
			sb.append("}");
			if(i<strArray.length-4)
				sb.append(",");
    	}
    	sb.append("}");	
    }
    catch(Exception ex)
    {
    	ex.printStackTrace();
    	sb = new StringBuilder();
    }
    finally{
    	inStream.close();
    	System.out.println("Get congestionIndex at "+(new Date())+"------------OK");
    	out.print(sb.toString());
    }
}
catch(Exception e) {
	System.out.println("Get congestionIndex at "+(new Date())+"------------ERROR");
	e.printStackTrace();
	response.setStatus(500);
}
%>