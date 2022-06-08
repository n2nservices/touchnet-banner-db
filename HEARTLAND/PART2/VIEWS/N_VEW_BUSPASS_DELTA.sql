--------------------------------------------------------
--  DDL for View N_VEW_BUSPASS_DELTA
--------------------------------------------------------

CREATE OR REPLACE FORCE VIEW "HEARTLAND"."N_VEW_BUSPASS_DELTA" ("ID", "FIRSTNAME", "LASTNAME", "MIDDLENAME", "CAMPUS", "GEORGIANEMAIL", "ELIGIBLE", "COURSESTARTDATE", "COURSEENDDATE", "BUSPASSSTARTDATE", " BUSPASSEXPIREDATE", "STATUS") AS 
select id as ID,
       firstname as FirstName,
       lastname as LastName,
       middlename as MiddleName,
       campus as Campus,
       georgianemailaddress as GeorgianEmail,
       buspass_eligible as Eligible,
	   coursestartdate as CourseStartDate,
	   courseenddate as CourseEndDate,
	   buspass_startdate as BuspassStartDate,
	   buspass_expiredate as BuspassExpireDate,
       'Updated' Status
  from heartland.buspass_stud t
  where sysdate between buspass_startdate and buspass_expiredate
minus
select t1.id,
       t1.firstname,
       t1.lastname,
       t1.middlename,
       t1.campus,
       t1.georgianemailaddress,
       t1.buspass_eligible,
	   t1.coursestartdate,
	   t1.courseenddate,
	   t1. buspass_startdate,
	   t1.buspass_expiredate,
       'Updated' Status
  from heartland.n_mv_buspass t1
union
select id as ID,
       firstname as FirstName,
       lastname as LastName,
       middlename as MiddleName,
       campus as Campus,
       georgianemailaddress as GeorgianEmail,
       buspass_eligible as Eligible,
	   coursestartdate as CourseStartDate,
	   courseenddate as CourseEndDate,
	   buspass_startdate as BuspassStartDate,
	   buspass_expiredate as BuspassExpireDate,
       'Deleted' Status
  from heartland.n_mv_buspass t
minus
select t1.id,
       t1.firstname,
       t1.lastname,
       t1.middlename,
       t1.campus,
       t1.georgianemailaddress,
       t1.buspass_eligible,
	   t1.coursestartdate,
	   t1.courseenddate,
	   t1. buspass_startdate,
	   t1.buspass_expiredate,
       'Deleted' Status
  from heartland.buspass_stud t1
  where sysdate between t1.buspass_startdate and t1.buspass_expiredate
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
-- Date Created : 06/08/2022
--
-- ***********
-- Audit Trail
-- -----------
-- Trail NO: 1
-- Date: 06/08/2022
-- User(s): Shalin Shah
-- Reason for Change: Initial development.
--******************************************************************************
;
