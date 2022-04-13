--------------------------------------------------------
--  DDL for Package Body N_PKG_SCHEDULER_TRACKING
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "HEARTLAND"."N_PKG_SCHEDULER_TRACKING" is

  lv_rowid_out varchar2(50);
  /*
  Illuminate SQL sample
  SELECT *
    FROM spriden
   where spriden_activity_Date >=
         nvl((select process_starttime
               from n_scheduler
              where job_name = 'STUDENT'),
             to_date('01/01/2000 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'));
  */
  procedure p_create(p_StartEndflag varchar2,
                     p_JobName      varchar2,
                     p_status       out varchar2,
                     p_status_msg   out varchar2) as
    lv_cnt number default 0;
  begin
  
    if p_jobname is null then
      p_status_msg := 'Job name missing.';
      p_status     := 'Failure';
      return;
    end if;
  
    if p_StartEndflag is null then
      p_status_msg := 'StartEnd Flag missing.';
      p_status     := 'Failure';
      return;
    end if;
  
   begin
      select count(*)
        into lv_cnt
        from n_scheduler
       where job_name = trim(upper(p_jobname));
      if lv_cnt <= 0 then
        p_status_msg := 'Invalid job name.';
        p_status     := 'Failure';
        return;
      end if;
    end ;
  
    if trim(upper(p_StartEndflag)) = 'START' or
       trim(upper(p_StartEndflag)) = 'END' then
      select count(*)
        into lv_cnt
        from n_scheduler
       where job_name = upper(trim(p_JobName));
    
      if trim(upper(p_StartEndflag)) = 'START' then
        if lv_cnt = 0 then
          insert into n_scheduler
            (process_starttime,
             scheduler_starttime,
             scheduler_endtime,
             job_name)
          values
            (null, sysdate, null, upper(trim(p_JobName)));
          commit;
        else
          update n_scheduler
             set scheduler_starttime = sysdate
           where job_name = upper(trim(p_JobName));
          commit;
        end if;
      else
        if lv_cnt = 0 then
          p_status_msg := 'Exception with scheduler start.';
          p_status     := 'Failure';
          return;
        else
          update n_scheduler
             set scheduler_endtime = sysdate,
                 process_starttime = scheduler_starttime
           where job_name = upper(trim(p_JobName));
          commit;
        end if;
      end if;
    else
      p_status_msg := 'Please enter proper value for StartEnd Flag ("Start" or "End").';
      p_status     := 'Failure';
      return;
    end if;
  
    p_status     := 'Success';
    p_status_msg := 'Process ' || trim(upper(p_StartEndflag)) ||
                    ' successfully.';
  exception
    when others then
      p_status_msg := sqlerrm;
      p_status     := 'Failure';
  end p_create;

  procedure p_create_job(p_JobName    varchar2,
                         p_status     out varchar2,
                         p_status_msg out varchar2) as
    lv_cnt number default 0;
  begin
    if p_jobname is null then
      p_status_msg := 'Job name missing.';
      p_status     := 'Failure';
      return;
    end if;
  
    select count(*)
      into lv_cnt
      from n_scheduler
     where job_name = upper(p_jobname);
    if lv_cnt > 0 then
      p_status_msg := 'Job name already exists.';
      p_status     := 'Failure';
      return;
    end if;
  
    insert into n_scheduler
      (process_starttime, scheduler_starttime, scheduler_endtime, job_name)
    values
      (null, null, null, upper(trim(p_JobName)));
    commit;
    p_status_msg := 'Job name created successfully.';
    p_status     := 'Success';
  exception
    when others then
      p_status_msg := sqlerrm;
      p_status     := 'Failure';
  end p_create_job;
end n_pkg_scheduler_tracking;

/
