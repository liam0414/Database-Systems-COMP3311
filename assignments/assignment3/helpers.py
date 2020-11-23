# COMP3311 20T3 Ass3 ... Python helper functions
# add here any functions to share between Python scripts 

# helper function for Q1
def getBestNMovies(top_N, cur):
    query = """
        SELECT rating, title, start_year 
        FROM Movies
        ORDER BY rating DESC, title
        LIMIT %s
    """
    cur.execute(query,[top_N])
    res = cur.fetchall()
    for tup in res:
        rating,title,start_year = tup
        print(f'{rating} {title} ({start_year})')

# helper function for Q2
def getMovieList(partial_title, cur):
    query = """
        SELECT title, start_year, id
        FROM Movies
        WHERE title ~* %s
        ORDER BY start_year, title
    """
    cur.execute(query,[partial_title])
    res=cur.fetchall()
    return res

def getMovieReleases(movieID, cur):
    query = """
        SELECT local_title, region, language, extra_info
        FROM Aliases
        WHERE movie_id=%s
        ORDER BY ordering
    """
    cur.execute(query,[movieID])
    res=cur.fetchall()
    return res

def printMovieList(res, partial_title):
    for tuple in res:
        title,start_year,id=tuple
        print(f"{title} ({start_year})")

def printMovieReleases(res):
    if res == '':
        return 0
    for tuple in res:
        local_title,region,language,extra_info=tuple
        if language and region:
            print(f"'{local_title}' (region: {region.strip()}, language: {language.strip()})")
        elif language and not region:
            print(f"'{local_title}' (language: {language.strip()})")
        elif region and not language:
            print(f"'{local_title}' (region: {region.strip()})")
        elif not region and not language and extra_info:
            print(f"'{local_title}' ({extra_info})")
        else:
            print(f"'{local_title}'")

# helper function for Q3
def getListAtGivenYear(partial_title, year, cur):
    query = """
        SELECT title, start_year, id
        FROM Movies
        WHERE title ~* %s AND start_year=%s
        ORDER BY title
    """
    cur.execute(query,[partial_title, year])
    res=cur.fetchall()
    return res

def getActors(movieID, cur):
    query = """
        SELECT n.name, a.played
        FROM Acting_roles a
            JOIN Movies m ON m.id=a.movie_id
            JOIN Names n ON n.id=a.name_id
            JOIN Principals p ON p.name_id=n.id
        WHERE a.movie_id = %s AND p.movie_id = a.movie_id
        ORDER BY p.ordering, a.played
    """
    cur.execute(query,[movieID])
    res=cur.fetchall()
    return res

def getCrews(movieID, cur):
    query = """
        SELECT n.name, regexp_replace(initcap(c.role), E'[^A-Za-z0-9]', ' ')
        FROM Crew_roles c
            JOIN Movies m ON m.id=c.movie_id
            JOIN Names n ON n.id=c.name_id
            JOIN Principals p ON p.name_id=n.id
        WHERE c.movie_id = %s AND p.movie_id = c.movie_id
        ORDER BY p.ordering, c.role
    """    
    cur.execute(query,[movieID])
    res=cur.fetchall()
    return res

def printActorsCrews(actors, crews):
    print("Starring")
    for actor in actors:
        name,played=actor
        print(f" {name} as {played}")
    print("and with")
    for crew in crews:
        name,role=crew
        print(f" {name}: {role.lower().capitalize()}")
# helper functions for Q4
def getBioUsingName(partial_name, cur):
    query = """
        SELECT name, birth_year, death_year, id
        FROM Names
        WHERE name ~* %s
        ORDER BY name, birth_year, id
    """
    cur.execute(query,[partial_name])
    res=cur.fetchall()
    return res

def getBioUsingNameYear(partial_name, year, cur):
    query = """
        SELECT name, birth_year, death_year, id
        FROM Names
        WHERE name ~* %s AND birth_year=%s
        ORDER BY name, birth_year, id
    """
    cur.execute(query,[partial_name, year])
    res=cur.fetchall()
    return res

def printBio(res):
    for tuple in res:
        name,birth_year,death_year,id=tuple
        if death_year is not None and birth_year is None:
            print(f"{name} (-{death_year})")
        elif birth_year is not None and death_year is None:
            print(f"{name} ({birth_year}-)")
        elif death_year is None and birth_year is None:
            print(f"{name} (???)")
        else:
            print(f"{name} ({birth_year}-{death_year})")

def getFilography(person_id, cur):
    query = """
        SELECT DISTINCT m.id, m.title, m.start_year
        FROM Movies m
            JOIN Acting_roles a ON a.movie_id=m.id
            JOIN Crew_roles c ON c.movie_id=m.id
            JOIN Principals p ON p.movie_id=m.id
        WHERE (a.name_id=%s OR c.name_id=%s) AND p.name_id=%s
        ORDER BY m.start_year, m.title
    """

    query1 = """
        SELECT a.played
        FROM Acting_roles a
            JOIN Movies m ON a.movie_id=m.id
        WHERE m.id=%s AND a.name_id=%s
        ORDER BY a.played
    """

    query2 = """
        SELECT regexp_replace(initcap(c.role), E'[^A-Za-z0-9]', ' ')
        FROM Crew_roles c
            JOIN Movies m ON c.movie_id=m.id
        WHERE m.id=%s AND c.name_id=%s
        ORDER BY c.role
    """

    cur.execute(query,[person_id,person_id,person_id])
    movieList=cur.fetchall()
    for movie in movieList:
        movieID,title,year=movie
        print(f"{title} ({year})")

        cur.execute(query1,[movieID,person_id])
        acting_roles=cur.fetchall()
        if acting_roles != []:
            for acting_role in acting_roles:
                print(f" playing {acting_role[0]}")
        
        cur.execute(query2,[movieID,person_id])
        crew_roles=cur.fetchall()
        if crew_roles != []:
            for crew_role in crew_roles:
                print(f" as {crew_role[0].lower().capitalize()}")

