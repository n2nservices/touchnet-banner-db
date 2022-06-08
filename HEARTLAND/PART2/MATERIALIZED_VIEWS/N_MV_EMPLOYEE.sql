--------------------------------------------------------
--  DDL for Materialized View N_MV_EMPLOYEE
--------------------------------------------------------

  CREATE MATERIALIZED VIEW "HEARTLAND"."N_MV_EMPLOYEE" REFRESH FORCE ON DEMAND
    AS SELECT * FROM HEARTLAND.EMPLOYEES
--******************************************************************************
-- N2N Services Inc
--
-- Copy Right info:
-- -------------------
-- All Rights Reserved. No part of this code or any of its contents may be reproduced or copied
-- without the prior written consent of the company N2N Services Inc.
-- Program Unit Name :
-- -------------------
-- ***********
-- Audit Trail
-- ----------------------
-- Trail NO: 1
-- Date: 06/08/2022
-- User(s): Shalin Shah
-- Reason for Change: Initial Deployment for EMPLOYEES API
;

   COMMENT ON MATERIALIZED VIEW "HEARTLAND"."N_MV_EMPLOYEE"  IS 'snapshot table for snapshot HEARTLAND.N_MV_EMPLOYEE';
