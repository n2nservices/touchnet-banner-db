--------------------------------------------------------
--  DDL for View N_VEW_ATHLETICS_DELTA
--------------------------------------------------------

CREATE OR REPLACE FORCE VIEW "HEARTLAND"."N_VEW_ATHLETICS_DELTA" ("ID","LASTNAME","FIRSTNAME","MIDDLENAME","CAMPUS","GEORGIANEMAIL","GAQ","COURSESTARTDATE","COURSEENDDATE","ATHLETICSSTARTDATE","ATHLETICSENDDATE", "STATUS") AS 
select id as ID,
       lastname as LastName,
       firstname as FirstName,
       middlename as MiddleName,
       campus as Campus,
       georgianemailaddress as GeorgianEmail,
       gaq as Gaq,
       coursestartdate as CourseStartDate,
       courseenddate as CourseEndDate,
       athletics_startdate as AthleticsStartDate,
       athletics_enddate as AthleticsEndDate,
       'Updated' Status
  from heartland.athletics t
minus
select t1.id,
       t1.lastname,
       t1.firstname,
       t1.middlename,
       t1.campus,
       t1.georgianemailaddress,
       t1.gaq,
       t1.coursestartdate,
       t1.courseenddate,
       t1.athletics_startdate,
       t1.athletics_enddate,
       'Updated' Status
  from heartland.n_mv_athletics t1
union
select id as ID,
       lastname as LastName,
       firstname as FirstName,
       middlename as MiddleName,
       campus as Campus,
       georgianemailaddress as GeorgianEmail,
       gaq as Gaq,
       coursestartdate as CourseStartDate,
       courseenddate as CourseEndDate,
       athletics_startdate as AthleticsStartDate,
       athletics_enddate as AthleticsEndDate,
       'Deleted' Status
  from heartland.n_mv_athletics t
minus
select t1.id,
       t1.lastname,
       t1.firstname,
       t1.middlename,
       t1.campus,
       t1.georgianemailaddress,
       t1.gaq,
       t1.coursestartdate,
       t1.courseenddate,
       t1.athletics_startdate,
       t1.athletics_enddate,
       'Deleted' Status
  from heartland.athletics t1
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
