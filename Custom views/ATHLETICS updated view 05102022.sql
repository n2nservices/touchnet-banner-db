WITH athleticFeesPaid (pidm, termcode) AS
    (SELECT
        arTransactionDetails.tbraccd_pidm,
        arTransactionDetails.tbraccd_term_code
     FROM
        tbraccd arTransactionDetails
     WHERE
        arTransactionDetails.tbraccd_detail_code = 'ATHR'
     GROUP BY
        arTransactionDetails.tbraccd_pidm,
        arTransactionDetails.tbraccd_term_code
     HAVING
        SUM(arTransactionDetails.tbraccd_amount) > 0
    ),
    academicYear (startDate, endDate) AS
    (select
        MIN(stvterm_start_date) startDate,
        max(stvterm_end_date) endDate
     from
        stvterm
     where
        mod(stvterm_code, 10) = 0
    group by stvterm_acyr_code
    ),
    gaqCompleted (studentid, activityDate) AS
    (select
        student_id, activity_date
     from
        (SELECT
            baseResponse.student_id,
            baseResponse.pass_fail,
            baseResponse.activity_date,
            baseResponse.surrogate_id,
            max(baseResponse.surrogate_id) OVER(partition by baseresponse.student_id order by baseresponse.activity_date desc) max_surrogate_id
         FROM
            academicYear
            JOIN parq.parq_response baseResponse ON baseResponse.activity_date BETWEEN academicYear.startdate AND academicYear.endDate)
     where
        surrogate_id = max_surrogate_id
        and pass_fail = 1
    )
SELECT
    generalPerson.spriden_id ID,
    generalPerson.spriden_last_name LASTNAME,
    georgian.gc_common_pkg.fw_get_preferred_first_name(generalPerson.spriden_id) FIRSTNAME,
    generalPerson.spriden_mi MIDDLENAME,
    studentGenRecord.sgbstdn_camp_code CAMPUS,
    coalesce(georgian.email_address.f_email_address(athleticFeesPaid.pidm,sys.odcivarchar2list('COLL')), georgian.email_address.persistentStudentAddress(athleticFeesPaid.pidm)) GEORGIANEMAILADDRESS,
    'Y' GAQ,
    termLookup.stvterm_start_date COURSESTARTDATE,
    termLookup.stvterm_end_date COURSEENDDATE,
    TRUNC(TRUNC(termLookup.stvterm_start_date,'MM')-1,'MM') ATHLETICS_STARTDATE,
    LAST_DAY(termLookup.stvterm_end_date) ATHLETICS_ENDDATE
FROM
    athleticFeesPaid
        JOIN saturn.spriden    generalPerson ON athleticFeesPaid.pidm = generalPerson.spriden_pidm
        JOIN saturn.sgbstdn    studentGenRecord ON studentGenRecord.sgbstdn_surrogate_id = georgian.curriculum.latest(generalPerson.spriden_pidm, athleticFeesPaid.termcode)
        JOIN saturn.spbpers    basicPerson ON basicPerson.spbpers_pidm = athleticFeesPaid.pidm
        JOIN saturn.stvcamp    campusLookup ON campusLookup.stvcamp_code = studentGenRecord.sgbstdn_camp_code
        JOIN saturn.stvterm    termLookup ON termLookup.stvterm_code = athleticFeesPaid.termcode
        JOIN gaqCompleted ON gaqCompleted.studentid = generalPerson.spriden_id AND gaqCompleted.activityDate BETWEEN termLookup.stvterm_start_date AND termLookup.stvterm_end_date
WHERE
        generalPerson.spriden_change_ind IS NULL
    AND campusLookup.stvcamp_ppp_indicator = 'N'
