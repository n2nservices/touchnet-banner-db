--------------------------------------------------------
--  DDL for Package Body N_PKG_REFRESH_MV
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "HEARTLAND"."N_PKG_REFRESH_MV" IS

  PROCEDURE p_refresh(p_mv_name    IN VARCHAR2,
                      p_status_msg OUT VARCHAR2,
                      p_status     OUT VARCHAR2) IS
  
  BEGIN
  
    if trim(p_mv_name) is null then
      p_status_msg := 'View name is missing';
      p_status     := 'Failure';
      return;
    end if;
  
    if upper(trim(p_mv_name)) = 'ATHLETICS' or
       upper(trim(p_mv_name)) = 'STUDENTS' then
    
      if upper(trim(p_mv_name)) = 'ATHLETICS' then
        dbms_mview.refresh('N_MV_ATHLETICS', 'C');
      elsif upper(trim(p_mv_name)) = 'STUDENTS' then
        dbms_mview.refresh('N_MV_STUDENT', 'C');
      end if;
    
      p_status_msg := 'Refresh successfully.';
      p_status     := 'Success';
    
    else
      p_status_msg := 'Invalid Materialized view name';
      p_status     := 'Failure';
      return;
    end if;
  EXCEPTION
    WHEN OTHERS THEN
      p_status_msg := 'Error while refreshing the Materialized view' ||
                      SQLERRM;
      p_status     := 'Failure';
  END;

END n_pkg_refresh_mv;

/
