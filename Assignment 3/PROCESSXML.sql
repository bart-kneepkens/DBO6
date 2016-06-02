CREATE OR REPLACE PROCEDURE PROCESSXML(P_XML XMLTYPE)
AS 
  LASTUPDATE  TIMESTAMP;
  LASTUPDATE_STR VARCHAR2(400);
  TEMPERATURE NUMBER;
BEGIN
  -- Get the timestamp as a string
  LASTUPDATE_STR := P_XML.EXTRACT('//current/lastupdate/@value').GETSTRINGVAL();
  -- Its in ISO 8061, hence has a 'T', replace this by '-'
  LASTUPDATE_STR := REPLACE(LASTUPDATE_STR, 'T', '-');
  -- Convert the string to timestamp according to format
  LASTUPDATE := TO_TIMESTAMP(LASTUPDATE_STR, 'YYYY-MM-DD-HH24:MI:SS');
  
  
  -- The DB is in european mode :( replace the dot(.) with a comma(,) 
  -- Only accepts comma numbers
  TEMPERATURE := TO_NUMBER(REPLACE(P_XML.EXTRACT('//current/temperature/@value').GETSTRINGVAL(), '.', ','));
  
  -- Convert the temperature in Kelvin to Celsius
  TEMPERATURE := TEMPERATURE - 273.15;
  
  EXECUTE IMMEDIATE 'INSERT INTO TEMPERATURES_EINDHOVEN VALUES(' || ''''|| LASTUPDATE || ''''|| ',' || '''' || TEMPERATURE || ''''|| ')';
  COMMIT;
END PROCESSXML;