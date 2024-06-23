USE data_scientist_project;
    
-- I. Studying Minutes Watched and Certificates Issued
-- Sub-query
SELECT 
    student_id, 
    COUNT(student_id) AS certificates_issued
FROM
    student_certificates
GROUP BY student_id;

-- Join tables
SELECT 
    a.student_id,
    a.certificates_issued,
    ROUND(SUM(IF(w.seconds_watched IS NULL,
                0,
                seconds_watched)) / 60,
            2) AS minutes_watched
FROM
    (SELECT 
        student_id, COUNT(student_id) AS certificates_issued
    FROM
        student_certificates
    GROUP BY student_id) a
        LEFT JOIN
    student_video_watched w ON a.student_id = w.student_id
GROUP BY student_id;