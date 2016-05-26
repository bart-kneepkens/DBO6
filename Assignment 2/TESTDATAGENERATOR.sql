create or replace PROCEDURE TESTDATAGENERATOR(
    TABLENAME    IN VARCHAR2 ,
    AMOUNTOFROWS IN NUMBER )
AS
  QUERY                VARCHAR2(32700) := 'INSERT INTO ' || TABLENAME || ' VALUES(';
  VAL                  VARCHAR2(255);
  EXCCOUNTER           NUMBER := AMOUNTOFROWS;
TYPE namesarray IS     VARRAY(5) OF VARCHAR2(10);
TYPE lastnamesarray IS VARRAY(5) OF VARCHAR2(10);
names namesarray;
lastnames lastnamesarray;
BEGIN
  names     := namesarray('Bob', 'Piet', 'Freek', 'Kees', 'Klaas');
  lastnames := lastnamesarray('Jansen', 'Henksma', 'Borkink', 'Vos', 'Kneepkens');
  FOR CNT IN 1..AMOUNTOFROWS
  LOOP
    BEGIN
      EPRINT('INSERTING A ROW TRY: ' || CNT);
      FOR COLUMN IN
      (SELECT COLUMN_NAME,
        DATA_TYPE,
        DATA_LENGTH,
        DATA_PRECISION,
        DATA_SCALE
      FROM USER_TAB_COLS
      WHERE TABLE_NAME = TABLENAME
      ORDER BY COLUMN_ID
      )
      LOOP
        IF(COLUMN.DATA_TYPE LIKE '%VARCHAR2%') THEN
          IF(COLUMN.COLUMN_NAME LIKE '%EMAIL%') THEN
            VAL := '''' || DBMS_RANDOM.STRING('U', 10) || '@test.test' || '''';
          ELSIF(COLUMN.COLUMN_NAME LIKE '%FIRSTNAME%') THEN
            VAL := '''' || names(DBMS_RANDOM.VALUE(1,5))|| ROUND(DBMS_RANDOM.VALUE(1,10)) || '''';
          ELSIF(COLUMN.COLUMN_NAME LIKE '%LASTNAME%') THEN
            VAL := '''' || lastnames(DBMS_RANDOM.VALUE(1,5))|| ROUND(DBMS_RANDOM.VALUE(1,10)) || '''';
          ELSIF(COLUMN.COLUMN_NAME LIKE '%DESCRIPTION%' OR COLUMN.COLUMN_NAME LIKE '%DETAILS%') THEN
            VAL := '''' || 'lorem ipsum dolor sit amet' || '''';
          ELSE
            VAL := '''' || DBMS_RANDOM.STRING('U', 10) || '''' ;
          END IF;
        ELSIF(COLUMN.DATA_TYPE LIKE '%NUMBER%') THEN
          IF(COLUMN.DATA_PRECISION = 1) THEN  
          VAL := ROUND(DBMS_RANDOM.VALUE(0,1));
          ELSE
          VAL := ROUND(CNT, COLUMN.DATA_SCALE);    
          END IF;
        ELSIF(COLUMN.DATA_TYPE LIKE '%TIMESTAMP%') THEN
          VAL := '''' || TO_CHAR(SYSTIMESTAMP, 'dd/mm/yyyy hh:mm:ss') || '''';
        ELSE
          VAL := '''NULL''';
        END IF;
        QUERY := QUERY || VAL || ',';
      END LOOP;
      QUERY := SUBSTR(QUERY, 0, LENGTH(QUERY) - 1) || ')';
      EPRINT(QUERY);
      EXECUTE IMMEDIATE QUERY;
      COMMIT;
      QUERY := 'INSERT INTO ' || TABLENAME || ' VALUES(';
    EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      EPRINT('DUPLICATE VALUE EXCEPTION IN QUERY:');
      EPRINT(QUERY);
      QUERY        := 'INSERT INTO ' || TABLENAME || ' VALUES(';
      EXCCOUNTER   := EXCCOUNTER - 1;
      IF(EXCCOUNTER = 0) THEN
        EPRINT('TOO MANY DUPLICATE EXCEPTIONS CAUGHT -> EXITING PROGRAM');
        EXIT;
      END IF;
    END;
  END LOOP;
END TESTDATAGENERATOR;