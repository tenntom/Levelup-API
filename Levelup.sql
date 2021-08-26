SELECT * FROM levelupapi_game;

SELECT
    e.id,
    e.title,
    e.description,
    e.date,
    e.time,
    e.attendee
    gr.id user_id,
    u.first_name || ' ' || u.last_name AS full_name
FROM
    levelupapi_event e
JOIN
    levelupapi_gamer gr ON e.host_id = gr.id
JOIN
    auth_user u ON gr.user_id = u.id

                    