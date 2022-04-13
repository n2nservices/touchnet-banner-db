WITH athleticFeesPaid (
                       pidm,
                       termcode
    ) AS (
    SELECT
        tb.tbraccd_pidm,
        tb.tbraccd_term_code
    FROM
        (
            SELECT
                tbraccd_pidm,
                tbraccd_term_code,
                SUM(tbraccd_amount) AS total_balance
            FROM
                taismgr.tbraccd
            WHERE
                    tbraccd_detail_code = 'ATHR'
            GROUP BY
                tbraccd_pidm,
                tbraccd_term_code
        ) tb
    WHERE
            tb.total_balance > '0'
), gaqResponse (
                studentid,
                indicator,
                activityDate
    ) AS (
    SELECT
        gaqResponse.student_id,
        gaqResponse.pass_fail,
        gaqResponse.activity_date
    FROM
        (select MIN(stvterm_start_date) startDate, max(stvterm_end_date) endDate from stvterm where mod(stvterm_code, 10) = 0 group by stvterm_acyr_code) academicYear
            JOIN parq.parq_response gaqResponse ON gaqResponse.activity_date BETWEEN academicYear.startdate AND academicYear.endDate
    WHERE
            gaqResponse.surrogate_id = (
            SELECT
                MAX(surrogate_id)
            FROM
                parq.parq_response
            WHERE
                    student_id = gaqResponse.student_id
              AND parq.parq_response.activity_date BETWEEN academicYear.startdate AND academicYear.endDate
        )
)
SELECT
    generalPerson.spriden_id ID,
    generalPerson.spriden_last_name LASTNAME,
    georgian.gc_common_pkg.fw_get_preferred_first_name(generalPerson.spriden_id) FIRSTNAME,
    generalPerson.spriden_mi MIDDLENAME,
    studentGenRecord.sgbstdn_majr_code_1 MAJOR,
    studentGenRecord.sgbstdn_camp_code CAMPUS,
    georgian.gc_common_pkg.fw_get_goremal_email_address(athleticFeesPaid.pidm, 'COLL') GEORGIANEMAILADDRESS,
    georgian.email_address.f_email_address(athleticFeesPaid.pidm, sys.odcivarchar2list('PR')) PREFERREDEMAILADDRESS,
    basicPerson.spbpers_birth_date BIRTHDATE,
    decode(coalesce(studentGenRecord.sgbstdn_resd_code, '~'), 'I', 'Y', 'N') INTERNATIONAL,
    decode(coalesce(gaqResponse.indicator, 0), 1, 'Y', 0, 'N') GAQ,
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
        LEFT JOIN gaqResponse ON gaqResponse.studentid = generalPerson.spriden_id AND gaqResponse.activityDate BETWEEN termLookup.stvterm_start_date AND termLookup.stvterm_end_date
WHERE
        generalPerson.spriden_change_ind IS NULL
    AND campusLookup.stvcamp_ppp_indicator = 'N'