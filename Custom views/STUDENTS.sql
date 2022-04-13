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
        confirmedApplicants(pidm) AS
        (SELECT svroccc_pidm
         FROM saturn.svroccc ocasProgramChoice
         JOIN saturn.svroofr ocasOffer ON ocasProgramChoice.svroccc_pidm = ocasOffer.svroofr_pidm
            AND ocasProgramChoice.svroccc_ocas_appl_num = ocasOffer.svroofr_ocas_appl_num
            AND ocasProgramChoice.svroccc_oprg_code = ocasOffer.svroofr_oprg_code
            AND ocasProgramChoice.svroccc_term_code = ocasOffer.svroofr_term_code
            AND ocasProgramChoice.svroccc_sem_levl_applied_for = ocasOffer.svroofr_semester
            AND ocasProgramChoice.svroccc_ocmp_code = ocasOffer.svroofr_ocmp_code
         WHERE ocasProgramChoice.svroccc_status = 'A'
                AND ocasProgramChoice.svroccc_term_code >= georgian.gc_common_pkg.fGetCurrentTermCode
                AND ocasProgramChoice.svroccc_queue_type = 'O'
                AND ocasOffer.svroofr_offer_accep_ind = 'Y'
                AND ocasOffer.svroofr_status IN ( 'A', 'E' )
        ),
        activeONECardGCStudents (pidm) AS
        (SELECT sfrstca_pidm
         FROM saturn.sfrstca courseRegAudit
         JOIN saturn.stvrsts courseRegStatusLookup ON courseRegStatusLookup.stvrsts_code = courseRegAudit.sfrstca_rsts_code
         WHERE courseRegStatusLookup.stvrsts_incl_sect_enrl = 'Y'
            AND courseRegStatusLookup.stvrsts_withdraw_ind = 'N'
            AND courseRegAudit.sfrstca_error_flag IS NULL
            AND courseRegAudit.sfrstca_term_code BETWEEN (SELECT MIN(termCode) FROM activeONECardTermCodes)
                AND (SELECT MAX(termCode) FROM activeONECardTermCodes)
         UNION
         SELECT pidm
         FROM confirmedApplicants
        ),
        activeONECardPartnerStudents ( pidm ) AS
        (SELECT gwiden_pidm
         FROM georgian.gwiden partnership
         WHERE partnership.gwiden_contract_code IN ( 'UOIT', 'LAKE', 'LUCS' )
            AND TRUNC(partnership.gwiden_expiry_date) >= TRUNC(SYSDATE)
        )
SELECT generalPerson.spriden_id,
       generalPerson.spriden_last_name,
       COALESCE(basicPerson.spbpers_pref_first_name,generalPerson.spriden_first_name),
       generalPerson.spriden_mi,
       studentGenRecord.sgbstdn_majr_code_1,
       studentGenRecord.sgbstdn_camp_code,
       address.spraddr_city,
       address.spraddr_stat_code,
       address.spraddr_zip,
       nationLookup.stvnatn_nation,
       COALESCE(collegeEmailAddress.goremal_email_address, georgian.email_address.persistentStudentAddress(generalPerson.spriden_pidm)),
       preferredEmailAddress.goremal_email_address,
       basicPerson.spbpers_birth_date,
       DECODE(COALESCE(studentGenRecord.sgbstdn_resd_code, '~'), 'I', 'Y', 'N'),
       gc_common_pkg.fw_check_4_aboriginal(activeONECardGCStudents.pidm, studentGenRecord.sgbstdn_term_code_eff),
       gc_common_pkg.fw_isinresidence(address.spraddr_zip),
       greatest(generalPerson.spriden_activity_date, address.spraddr_activity_date, studentGenRecord.sgbstdn_activity_date, basicPerson.spbpers_activity_date, COALESCE(collegeEmailAddress.goremal_activity_date, TO_DATE('1/1/1900', 'mm/dd/yyyy')), COALESCE(preferredEmailAddress.goremal_activity_date, TO_DATE('1/1/1900', 'mm/dd/yyyy')))
FROM activeONECardGCStudents
JOIN saturn.spriden generalPerson ON generalPerson.spriden_pidm = activeONECardGCStudents.pidm
JOIN saturn.spraddr address ON address.spraddr_surrogate_id = georgian.address.latest(generalPerson.spriden_pidm, 'MA')
LEFT JOIN saturn.stvnatn nationLookup ON nationLookup.stvnatn_code = address.spraddr_natn_code
JOIN saturn.sgbstdn studentGenRecord ON studentGenRecord.sgbstdn_pidm = generalPerson.spriden_pidm
LEFT JOIN saturn.stvcamp campusLookup ON campusLookup.stvcamp_code = studentGenRecord.sgbstdn_camp_code
JOIN saturn.spbpers basicPerson ON basicPerson.spbpers_pidm = studentGenRecord.sgbstdn_pidm
LEFT JOIN general.goremal collegeEmailAddress ON collegeEmailAddress.goremal_surrogate_id = georgian.email_address.find(basicPerson.spbpers_pidm, SYS.OdciVarchar2List('COLL'))
LEFT JOIN general.goremal preferredEmailAddress ON preferredEmailAddress.goremal_surrogate_id = COALESCE(georgian.email_address.find(basicPerson.spbpers_pidm, SYS.OdciVarchar2List('PR'), 'A', 'Y'), georgian.email_address.find(basicPerson.spbpers_pidm, SYS.OdciVarchar2List('PR'), 'A'), georgian.email_address.find(basicPerson.spbpers_pidm, SYS.OdciVarchar2List(), 'A', 'Y'))
WHERE generalPerson.spriden_change_ind IS NULL
    AND
    studentGenRecord.sgbstdn_term_code_eff =
        (SELECT MAX(studentGenRecord2.sgbstdn_term_code_eff)
         FROM sgbstdn studentGenRecord2
         WHERE studentGenRecord2.sgbstdn_pidm = activeONECardGCStudents.pidm
         )
         AND campusLookup.stvcamp_ppp_indicator = 'N'
UNION
SELECT student.swrnvll_id,
       student.swrnvll_lname,
       COALESCE(basicPerson.spbpers_pref_first_name,generalPerson.spriden_first_name),
       generalPerson.spriden_mi,
       student.swrnvll_majr,
       student.swrnvll_camp,
       address.spraddr_city,
       address.spraddr_stat_code,
       address.spraddr_zip,
       nationLookup.stvnatn_nation,
       collegeEmailAddress.goremal_email_address,
       preferredEmailAddress.goremal_email_address,
       student.swrnvll_birth_date,
       student.swrnvll_international,
       0,
       gc_common_pkg.fw_isinresidence(address.spraddr_zip),
       greatest(generalPerson.spriden_activity_date, address.spraddr_activity_date, student.swrnvll_activity_date, basicPerson.spbpers_activity_date, COALESCE(collegeEmailAddress.goremal_activity_date, TO_DATE('1/1/1900', 'mm/dd/yyyy')), COALESCE(preferredEmailAddress.goremal_activity_date, TO_DATE('1/1/1900', 'mm/dd/yyyy')))
FROM activeONECardPartnerStudents
JOIN saturn.spriden generalPerson  ON generalPerson.spriden_pidm = activeONECardPartnerStudents.pidm
LEFT JOIN georgian.swrnvll student ON student.swrnvll_pidm = generalPerson.spriden_pidm
JOIN saturn.spbpers basicPerson ON basicPerson.spbpers_pidm = generalPerson.spriden_pidm
JOIN saturn.spraddr address ON address.spraddr_surrogate_id = georgian.address.latest(generalPerson.spriden_pidm, 'MA')
LEFT JOIN saturn.stvnatn nationLookup ON nationLookup.stvnatn_code = address.spraddr_natn_code
LEFT JOIN general.goremal collegeEmailAddress ON collegeEmailAddress.goremal_surrogate_id = georgian.email_address.find(address.spraddr_pidm, SYS.OdciVarchar2List('COLL'))
LEFT JOIN general.goremal preferredEmailAddress ON preferredEmailAddress.goremal_surrogate_id = COALESCE(georgian.email_address.find(address.spraddr_pidm, SYS.OdciVarchar2List('PR'), 'A', 'Y'), georgian.email_address.find(address.spraddr_pidm, SYS.OdciVarchar2List('PR'), 'A'), georgian.email_address.find(address.spraddr_pidm, SYS.OdciVarchar2List(), 'A', 'Y'))
WHERE generalPerson.spriden_change_ind IS NULL
