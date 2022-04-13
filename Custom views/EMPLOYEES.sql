SELECT a.hr_employee_id,
           a.hr_last_name,
           a.hr_first_name,
           a.email,
           a.hr_location,
           a.hr_birth_date,
           a.hr_activity_date
    FROM swrhrad_tbl a
    WHERE a.hr_location IS NOT NULL
    AND a.hr_ad_status = 'A'
    AND NOT EXISTS
            (SELECT 1
             FROM swrnvll b
             WHERE b.swrnvll_id = a.hr_employee_id)