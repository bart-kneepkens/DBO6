CREATE OR REPLACE PROCEDURE GET_WEATHER
AS
  REQ UTL_HTTP.REQ;
  RES UTL_HTTP.RESP;
  URL VARCHAR2(4000) := 'http://api.openweathermap.org/data/2.5/weather?q=Eindhoven&APPID=863474c6cbf1707519890a0cbe1608c8&mode=xml';
  BUFFER VARCHAR2(4000);
  V_XML XMLTYPE;
  
BEGIN
  REQ := UTL_HTTP.BEGIN_REQUEST(URL, 'GET',' HTTP/1.1');
  RES := UTL_HTTP.GET_RESPONSE(REQ);
  
  -- Read the XML into a string buffer
  UTL_HTTP.READ_LINE(RES, BUFFER);
  
  -- Create XML from the buffer
  V_XML := XMLTYPE.CREATEXML(BUFFER);
  
  -- Insert into XML table
  INSERT INTO XML_TABLE VALUES (V_XML);
  
  -- Call function to extract data and insert in table
  PROCESSXML(V_XML);
  
  -- End HTTP request
  UTL_HTTP.END_RESPONSE(RES);

  -- End HTTP request on any exception
  EXCEPTION
    WHEN OTHERS
    THEN
    UTL_HTTP.END_RESPONSE(RES);

END GET_WEATHER;