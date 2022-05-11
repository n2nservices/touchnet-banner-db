--------------------------------------------------------
--  DDL for Package N_PKG_REFRESH_MV
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "HEARTLAND"."N_PKG_REFRESH_MV" IS

  --******************************************************************************
  -- N2N Services Inc
  --
  -- Copy Right info:
  -- -------------------
  -- All Rights Reserved. No part of this code or any of its contents may be reproduced or copied
  -- without the prior written consent of the company N2N Services Inc.
  -- Program Unit Name: N_PKG_REFRESH_MV
  --
  -- Process Associated :(optional)
  --
  -- Date Created : 05-11-2022
  -- ***********
  -- Audit Trail
  -- -----------
  -- Trail NO: 1
  -- Date: 05-11-2022
  -- User(s): Shalin Shah
  -- Reason for Change: Initial development to refresh the Materialized view.
  --******************************************************************************

  PROCEDURE p_refresh(p_mv_name    IN VARCHAR2,
                      p_status_msg OUT VARCHAR2,
                      p_status     OUT VARCHAR2);

END n_pkg_refresh_mv;

/
