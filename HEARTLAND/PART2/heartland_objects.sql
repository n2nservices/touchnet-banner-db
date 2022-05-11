--------------------------------------------------------
--  HEARTLAND Objects   
--------------------------------------------------------
set define off
spool heartland_objects.log
set serveroutput off
ALTER SESSION SET PLSQL_OPTIMIZE_LEVEL = 2;
@PACKAGES/N_PKG_SCHEDULER_TRACKING.sql
@PACKAGES/N_PKG_REFRESH_MV.sql
@TABLES/N_SCHEDULER.sql
begin
dbms_utility.compile_schema(schema =>  'HEARTLAND',compile_all => true);
end;
/
@VIEWS/N_VEW_ATHLETICS_DELTA.sql
@VIEWS/N_VEW_STUDENT_DELTA.sql
@PACKAGE_BODIES/N_PKG_REFRESH_MV.sql
@PACKAGE_BODIES/N_PKG_SCHEDULER_TRACKING.sql
begin
dbms_utility.compile_schema(schema =>  'HEARTLAND',compile_all => true);
end;
/
@MATERIALIZED_VIEWS/N_MV_ATHLETICS.sql
@MATERIALIZED_VIEWS/N_MV_STUDENT.sql
begin
dbms_utility.compile_schema(schema =>  'HEARTLAND',compile_all => true);
end;
/
spool off