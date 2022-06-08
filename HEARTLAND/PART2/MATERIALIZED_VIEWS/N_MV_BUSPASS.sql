--------------------------------------------------------
--  DDL for Materialized View N_MV_BUSPASS
--------------------------------------------------------

  CREATE MATERIALIZED VIEW "HEARTLAND"."N_MV_BUSPASS" REFRESH FORCE ON DEMAND
    AS SELECT * FROM HEARTLAND.BUSPASS_STUD where
			sysdate between buspass_startdate
				and buspass_expiredate
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
-- Reason for Change: Initial Deployment for Bus Pass API
;

   COMMENT ON MATERIALIZED VIEW "HEARTLAND"."N_MV_BUSPASS"  IS 'snapshot table for snapshot HEARTLAND.N_MV_BUSPASS';
