USE data_scientist_project;

-- I. Calculating Total Minutes Watched in Q2 2021 and Q2 2022
SELECT 
    student_id,
    ROUND(SUM(seconds_watched) / 60, 2) AS minutes_watched
FROM
    student_video_watched
WHERE
    YEAR(date_watched) = 2021
GROUP BY student_id;

-- II. Creating a ‘paid’ Column
SELECT 
    a.student_id,
    a.minutes_watched,
    MAX(IF(i.date_start IS NULL,
        0,
        i.paid_q2_2022)) AS paid_in_q2
FROM
    (SELECT 
        student_id,
            ROUND(SUM(seconds_watched) / 60, 2) AS minutes_watched
    FROM
        student_video_watched
    WHERE
        YEAR(date_watched) = 2022
    GROUP BY student_id) a
        LEFT JOIN
    purchases_info i ON a.student_id = i.student_id
GROUP BY student_id
HAVING paid_in_q2 = 1;