--------------------------------------------------------
--  DDL for Package N_PKG_SCHEDULER_TRACKING
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "HEARTLAND"."N_PKG_SCHEDULER_TRACKING" is

  --******************************************************************************
  -- N2N Services Inc
  --
  -- Copy Right info:
  -- -------------------
  -- All Rights Reserved. No part of this code or any of its contents may be reproduced or copied
  -- without the prior written consent of the company N2N Services Inc.
  -- Program Unit Name : n_pkg_scheduler_tracking 
  --
  -- Process Associated :(optional)
  --
  -- ***********
  -- Audit Trail
  -- ------------------
  -- Trail NO: 1
  -- Date: 04/11/2022
  -- User(s): Shalin Shah
  -- Reason for Change: Initial development for tracking scheduler times
  --******************************************************************************
  procedure p_create(p_StartEndflag varchar2,
                     p_JobName      varchar2,
                     p_status       out varchar2,
                     p_status_msg   out varchar2);

  procedure p_create_job(p_JobName    varchar2,
                         p_status     out varchar2,
                         p_status_msg out varchar2);

end n_pkg_scheduler_tracking;

/
