"""Module for generating events by user report"""
import sqlite3
from django.shortcuts import render
from levelupapi.models import Game, Event, event
from levelupreports.views import Connection


def userevent_list(request):
    """Function to build an HTML report of events by user"""
    if request.method == 'GET':
        with sqlite3.connect(Connection.db_path) as conn:
            conn.row_factory = sqlite3.Row
            db_cursor = conn.cursor()

            db_cursor.execute("""
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
            """)

            dataset = db_cursor.fetchall()

            # Take the flat data from the database, and build the
            # following data structure for each gamer.
            #
            # {
            #     1: {
            #         "id": 1,
            #         "full_name": "Admina Straytor",
            #         "games": [
            #             {
            #                 "id": 1,
            #                 "title": "Foo",
            #                 "maker": "Bar Games",
            #                 "skill_level": 3,
            #                 "number_of_players": 4,
            #                 "game_type_id": 2
            #             }
            #         ]
            #     }
            # }

            events_by_user = {}

            for row in dataset:
                uid = row['user_id']
                if uid in events_by_user:
                    events_by_user[uid]['events'].append({
                        "id": row['id'],
                        "title": row['title'],
                        "description": row['description'],
                        "date": row['date'],
                        "time": row['time'],
                        "game_name": row["name"]
                    })
                else:
                    events_by_user[uid] = {
                        "gamer_id": uid,
                        "full_name": row['full_name'],
                        "events": [{
                            "id": row['id'],
                            "title": row['title'],
                            "description": row['description'],
                            "date": row['date'],
                            "time": row['time'],
                            "game_name": row["name"]
                        }]
                    }

        events = events_by_user.values()  

        template = 'users/list_with_events.html'
        context = {
            'userevent_list': events
        }

        return render(request, template, context)