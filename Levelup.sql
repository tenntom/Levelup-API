SELECT * FROM levelupapi_game;
SELECT * FROM levelupapi_event;
SELECT * FROM levelupapi_eventgamer;
SELECT * FROM levelupapi_gamer;
SELECT * FROM auth_user;


SELECT
    u.first_name || ' ' || u.last_name AS full_name,
    gr.id as user_id,
    e.id,
    e.title,
    e.description,
    e.date,
    e.time,
    gm.name
FROM
    levelupapi_event e
JOIN
    levelupapi_eventgamer eg ON eg.event_id = e.id
JOIN
    levelupapi_gamer gr ON eg.gamer_id = gr.id
JOIN
    auth_user u ON gr.user_id = u.id
JOIN 
    levelupapi_game gm ON e.game_id = gm.id

INSERT INTO levelupapi_eventgamer values (null, 5, 2)
INSERT INTO levelupapi_gamer values (null, "Your Bio", 2)
INSERT INTO auth_user values (null, "password", null, 0, "you", "Bass", "you@you.com", 0, 1, 2020-08-28, "Bill");

CREATE VIEW GAMES_BY_USER AS
SELECT
    g.id,
    g.name,
    g.maker,
    g.game_type_id,
    g.number_of_players,
    u.id user_id,
    u.first_name || ' ' || u.last_name AS full_name
FROM
    levelupapi_game g
JOIN
    levelupapi_gamer gr ON g.gamer_id = gr.id
JOIN
    auth_user u ON gr.user_id = u.id
;

DROP VIEW GAMES_BY_USER;

CREATE VIEW EVENTS_BY_USER AS
    SELECT
        u.first_name || ' ' || u.last_name AS full_name,
        gr.id as user_id,
        e.id,
        e.title,
        e.description,
        e.date,
        e.time,
        gm.name
    FROM
        levelupapi_event e
        JOIN
        levelupapi_eventgamer eg ON eg.event_id = e.id
    JOIN
        levelupapi_gamer gr ON eg.gamer_id = gr.id
    JOIN
        auth_user u ON gr.user_id = u.id
    JOIN 
        levelupapi_game gm ON e.game_id = gm.id