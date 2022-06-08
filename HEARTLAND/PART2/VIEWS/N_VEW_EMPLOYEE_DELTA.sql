--------------------------------------------------------
--  DDL for View N_VEW_EMPLOYEE_DELTA
--------------------------------------------------------

CREATE OR REPLACE FORCE VIEW "HEARTLAND"."N_VEW_EMPLOYEE_DELTA" ("ID", "FIRSTNAME", "LASTNAME", "CAMPUS", "Email", "LASTMODIFIEDDATE", "STATUS") AS 
select id as ID,
       firstname as FirstName,
       lastname as LastName,
       campus as Campus,
       emailaddress as Email,
       lastmodifieddate as LastModifiedDate,
       'Updated' Status
  from heartland.students t
minus
select t1.id,
       t1.firstname,
       t1.lastname,
       t1.campus,
       t1.emailaddress,
       t1.lastmodifieddate,
       'Updated' Status
  from heartland.n_mv_student t1
union
select id as ID,
       firstname as FirstName,
       lastname as LastName,
       campus as Campus,
       emailaddress as Email,
       lastmodifieddate as LastModifiedDate,
       'Deleted' Status
  from heartland.n_mv_student t
minus
select t1.id,
       t1.firstname,
       t1.lastname,
       t1.campus,
       t1.emailaddress,
       t1.lastmodifieddate,
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
