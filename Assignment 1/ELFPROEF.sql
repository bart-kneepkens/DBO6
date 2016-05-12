--------------------------------------------------------
--  File created - donderdag-mei-12-2016   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Function ELFPROEF
--------------------------------------------------------
/* The elfproef (translation: eleven-test) is a test for BSN's (Government's person ID's) */
  CREATE OR REPLACE EDITIONABLE FUNCTION "ELFPROEF" 
(
  ORIGINAL IN VARCHAR2 
) RETURN NUMBER AS 
total NUMBER := 0;
in_num NUMBER;
product NUMBER;
BEGIN
  FOR CNT IN 1..LENGTH(ORIGINAL)
  LOOP
      -- Get the next number from the end of the Original
      in_num := TO_NUMBER(SUBSTR(ORIGINAL, LENGTH(ORIGINAL) - CNT + 1, 1));
      
      -- The first character (the last in the total string) should be multiplied with -1
      -- The rest is incremential from 2->9
      -- The product is the current calculation
      IF(CNT = 1) THEN
        product := -1 * in_num;
      ELSE
        product := CNT * in_num;
      END IF;
      
      total := total + product;
  
  END LOOP;
  
  -- If the grand total is a multiplication of 11
  IF MOD(total, 11) = 0 THEN
    RETURN 1;
  ELSE
    RETURN 0;
  END IF;
END ELFPROEF;
