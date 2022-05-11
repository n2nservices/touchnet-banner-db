WITH activeONECardTermCodes (termCode) AS
        (SELECT stvterm_code
         FROM
             (SELECT termLookup.stvterm_code
              FROM saturn.stvterm termLookup
              WHERE TRUNC(termLookup.stvterm_start_date) <= TRUNC(SYSDATE)
              ORDER BY termLookup.stvterm_code DESC
             )
        WHERE ROWNUM <= 6
        ),
        activeONECardStudents (pidm) AS (
            SELECT
                svroccc_pidm
            FROM
                saturn.svroccc ocasProgramChoice
                JOIN saturn.svroofr ocasOffer ON ocasProgramChoice.svroccc_pidm = ocasOffer.svroofr_pidm
                AND ocasProgramChoice.svroccc_ocas_appl_num = ocasOffer.svroofr_ocas_appl_num
                AND ocasProgramChoice.svroccc_oprg_code = ocasOffer.svroofr_oprg_code
                AND ocasProgramChoice.svroccc_term_code = ocasOffer.svroofr_term_code
                AND ocasProgramChoice.svroccc_sem_levl_applied_for = ocasOffer.svroofr_semester
                AND ocasProgramChoice.svroccc_ocmp_code = ocasOffer.svroofr_ocmp_code
            WHERE
                ocasProgramChoice.svroccc_status = 'A'
                AND ocasProgramChoice.svroccc_term_code >= georgian.gc_common_pkg.fgetcurrenttermcode
                AND ocasProgramChoice.svroccc_queue_type = 'O'
                AND ocasOffer.svroofr_offer_accep_ind = 'Y'
                AND ocasOffer.svroofr_status IN ( 'A', 'E' )
            UNION
            SELECT
                sfrstca_pidm
            FROM
                saturn.sfrstca courseRegAudit
                JOIN saturn.stvrsts courseRegStatusLookup ON courseRegStatusLookup.stvrsts_code = courseRegAudit.sfrstca_rsts_code
            WHERE
                courseRegStatusLookup.stvrsts_incl_sect_enrl = 'Y'
                AND courseRegStatusLookup.stvrsts_withdraw_ind = 'N'
                AND courseRegAudit.sfrstca_error_flag IS NULL
                AND courseRegAudit.sfrstca_term_code BETWEEN (SELECT MIN(termCode) FROM activeONECardTermCodes)
                    AND (SELECT MAX(termCode) FROM activeONECardTermCodes)
            UNION
            SELECT
                gwiden_pidm
            FROM
                georgian.gwiden partnership
            WHERE
                partnership.gwiden_contract_code IN ( 'UOIT', 'LAKE', 'LUCS' )
                AND TRUNC(partnership.gwiden_expiry_date) >= TRUNC(SYSDATE)
          ),
          curriculum(pidm, major, campus, lastModified) AS (
           SELECT
                sgbstdn_pidm,
                sgbstdn_majr_code_1,
                sgbstdn_camp_code,
                sgbstdn_activity_date
            FROM
                (SELECT
                    studentGenRecord.sgbstdn_pidm,
                    studentGenRecord.sgbstdn_majr_code_1,
                    studentGenRecord.sgbstdn_camp_code,
                    studentGenRecord.sgbstdn_stst_code,
                    studentGenRecord.sgbstdn_activity_date,
                    ROW_NUMBER() OVER(PARTITION BY studentGenRecord.sgbstdn_pidm order by sgbstdn_term_code_eff desc) as rn
                FROM
                    sgbstdn studentGenRecord)
            JOIN
                saturn.stvcamp campusLookup ON campusLookup.stvcamp_code = sgbstdn_camp_code AND campusLookup.stvcamp_ppp_indicator = 'N'
            WHERE
                rn = 1
        )
SELECT
    generalPerson.spriden_id,
    generalPerson.spriden_last_name,
    COALESCE(basicPerson.spbpers_pref_first_name,generalPerson.spriden_first_name),
    generalPerson.spriden_mi,
    COAlESCE(curriculum.major, student.swrnvll_majr),
    COALESCE(curriculum.campus, student.swrnvll_camp),
    COALESCE(collegeEmailAddress.goremal_email_address, georgian.email_address.persistentStudentAddress(generalPerson.spriden_pidm)),
    greatest(generalPerson.spriden_activity_date, COALESCE(student.swrnvll_activity_date, curriculum.lastModified), basicPerson.spbpers_activity_date, COALESCE(collegeEmailAddress.goremal_activity_date, TO_DATE('1/1/1900', 'mm/dd/yyyy')))
FROM
    saturn.spriden generalPerson
    JOIN saturn.spbpers basicPerson ON basicPerson.spbpers_pidm = generalPerson.spriden_pidm
    LEFT JOIN curriculum on curriculum.pidm = generalPerson.spriden_pidm
    LEFT JOIN swrnvll student on student.entity_identification_id = generalPerson.spriden_surrogate_id
    LEFT JOIN saturn.stvcamp campusLookup ON campusLookup.stvcamp_code = student.swrnvll_camp
    LEFT JOIN general.goremal collegeEmailAddress ON collegeEmailAddress.goremal_surrogate_id = georgian.email_address.find(basicPerson.spbpers_pidm, SYS.OdciVarchar2List('COLL'))
WHERE
    generalPerson.spriden_change_ind IS NULL
   AND (curriculum.campus IS  NOT NULL OR (curriculum.campus is null AND student.swrnvll_camp IS NOT NULL AND campusLookup.stvcamp_ppp_indicator = 'N'))
    AND EXISTS (select 1 from activeONECardStudents WHERE pidm = generalPerson.spriden_pidm);
	