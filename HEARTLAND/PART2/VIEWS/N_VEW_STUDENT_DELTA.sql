--------------------------------------------------------
--  DDL for View N_VEW_STUDENT_DELTA
--------------------------------------------------------

CREATE OR REPLACE FORCE VIEW "HEARTLAND"."N_VEW_STUDENT_DELTA" ("ID", "FIRSTNAME", "LASTNAME", "MIDDLENAME", "CAMPUS", "GEORGIANEMAIL", "MAJOR", "STATUS") AS 
select id as ID,
       firstname as FirstName,
       lastname as LastName,
       middlename as MiddleName,
       campus as Campus,
       georgianemailaddress as GeorgianEmail,
       major as Major,
       'Updated' Status
  from heartland.students t
minus
select t1.id,
       t1.firstname,
       t1.lastname,
       t1.middlename,
       t1.campus,
       t1.georgianemailaddress,
       t1.major,
       'Updated' Status
  from heartland.n_mv_student t1
union
select id as ID,
       firstname as FirstName,
       lastname as LastName,
       middlename as MiddleName,
       campus as Campus,
       georgianemailaddress as GeorgianEmail,
       major as Major,
       'Deleted' Status
  from heartland.n_mv_student t
minus
select t1.id,
       t1.firstname,
       t1.lastname,
       t1.middlename,
       t1.campus,
       t1.georgianemailaddress,
       t1.major,
       'Deleted' Status
  from heartland.students t1
--******************************************************************************
-- N2N Services Inc
--
-- Copy Right info:
-- -------------------
-- All Rights Reserved. No part of this code or any of its contents may be reproduced or copied
-- without the prior written consent of the company N2N Services Inc.
-- Program Unit Name :
--
-- Process Associated :
--
-- Date Created : 05/11/2022
--
-- ***********
-- Audit Trail
-- -----------
-- Trail NO: 1
-- Date: 05/11/2022
-- User(s): Shalin Shah
-- Reason for Change: Initial development.
--******************************************************************************
;
