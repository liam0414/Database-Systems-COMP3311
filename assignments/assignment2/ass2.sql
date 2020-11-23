CREATE OR REPLACE VIEW Q1(unswid,name) AS 
SELECT p.unswid, p.name 
FROM people p 
    JOIN course_enrolments c ON c.student = p.id 
GROUP BY p.unswid, p.name 
HAVING COUNT(c.course) > 65;
---------------------------------Q1 Above---------------------------------
---------------------------------Q2 Below---------------------------------
CREATE OR REPLACE VIEW Q2 (nstudents, nstaff, nboth) AS 
SELECT *
FROM
    (
        SELECT COUNT(s1.id) 
        FROM Students s1 
            LEFT JOIN Staff s2 ON s1.id = s2.id 
        WHERE s2 IS NULL 
    )
    AS col1,
    (
        SELECT COUNT(s2.id)
        FROM Staff s2 
            LEFT JOIN Students s1 ON s1.id = s2.id 
        WHERE s1 IS NULL 
    )
    AS col2,
    (
        SELECT COUNT(s1.id) 
        FROM Students s1 
            INNER JOIN Staff s2 ON s1.id = s2.id 
    )
    AS col3;
---------------------------------Q2 Above---------------------------------
---------------------------------Q3 Below---------------------------------
CREATE OR REPLACE VIEW LIC(name, ncourses) AS 
SELECT p.name, COUNT(p.name) 
FROM People p 
    JOIN Course_staff cs ON cs.staff = p.id 
    JOIN staff_roles sr ON sr.id = cs.role 
GROUP BY p.name, sr.name 
HAVING sr.name LIKE 'Course Convenor';

CREATE OR REPLACE VIEW Q3(name,ncourses) AS 
SELECT * 
FROM lic 
WHERE ncourses = (SELECT MAX(ncourses) FROM lic);
---------------------------------Q3 Above---------------------------------
---------------------------------Q4 Below---------------------------------
CREATE OR REPLACE VIEW Q4a(id, name) AS
SELECT p.unswid, p.name 
FROM People p 
    JOIN students s ON s.id = p.id 
    JOIN Program_enrolments pe ON pe.student = s.id 
    JOIN Programs p1 ON pe.program = p1.id 
    JOIN Terms t ON t.id = pe.term 
WHERE
    substr(t.YEAR::text, 3, 2) = '05'
    AND LOWER(t.session) = 's2'
    AND p1.code LIKE '3978';

CREATE OR REPLACE VIEW Q4b(id, name) AS 
SELECT p.unswid, p.name 
FROM
    People p 
    JOIN students s ON s.id = p.id 
    JOIN Program_enrolments pe ON pe.student = s.id 
    JOIN Programs p1 ON pe.program = p1.id 
    JOIN Terms t ON t.id = pe.term
WHERE
    substr(t.YEAR::text, 3, 2) = '17'
    AND LOWER(t.session) = 's1'
    AND p1.code LIKE '3778';
---------------------------------Q4 Above---------------------------------
---------------------------------Q5 Below---------------------------------
CREATE OR REPLACE VIEW Committee_Faculty(name, parent) AS 
SELECT l.id, COUNT(l.id) 
FROM (
    SELECT ou.name, facultyof(ou.id) AS id 
    FROM OrgUnits ou 
        JOIN OrgUnit_types ou_t ON ou.utype = ou_t.id 
    WHERE ou_t.name = 'Committee' 
    ) AS l 
GROUP BY
    l.id,
    facultyof(l.id);

CREATE OR REPLACE VIEW Q5(name) AS 
SELECT ou.name 
FROM OrgUnits ou 
    JOIN Committee_Faculty ON Committee_Faculty.name = ou.id 
WHERE parent = (SELECT MAX(parent) FROM Committee_Faculty);
---------------------------------Q5 Above---------------------------------
---------------------------------Q6 Below---------------------------------
CREATE OR REPLACE FUNCTION Q6(id integer) RETURNS text AS $$ 
SELECT name 
FROM people 
WHERE people.unswid = $1 OR people.id = $1;
$$ LANGUAGE SQL;
---------------------------------Q6 Above---------------------------------
---------------------------------Q7 Below---------------------------------
CREATE OR REPLACE FUNCTION Q7(subject text) RETURNS TABLE (subject text, term text, convenor text) AS $$ 
SELECT sb.code::text, termName(c.term), p.name 
FROM People p 
    JOIN staff s ON p.id = s.id 
    JOIN Course_staff cs ON cs.staff = s.id 
    JOIN staff_roles sr ON sr.id = cs.role 
    JOIN Courses c ON c.id = cs.course 
    JOIN Subjects sb ON sb.id = c.subject 
WHERE
    sr.name = 'Course Convenor' 
    AND sb.code = $1;
$$ LANGUAGE SQL;
---------------------------------Q7 Above---------------------------------
---------------------------------Q8 Below---------------------------------
CREATE OR REPLACE FUNCTION Q8(zid integer) RETURNS setof TranscriptRecord
AS $$ 
DECLARE
    tr TranscriptRecord;
    UOCtotal integer := 0;
    UOCpassed integer := 0;
    weightedSumOfMarks integer := 0;
    wamValue NUMERIC := 0.0;
BEGIN
    --base case, if student is not valid, raise exception
    IF NOT EXISTS (
        SELECT s.id
        FROM Students s 
            JOIN People p ON (s.id = p.id) 
        WHERE p.unswid = zid) THEN
        RAISE EXCEPTION 'Invalid student %', zid;
    END IF;
    -- for every record IN the records
    FOR tr IN (
        SELECT DISTINCT
            s.code,
            termName(c.term),
            pg.code,
            substr(s.name, 1, 20),
            ce.mark,
            ce.grade,
            s.uoc 
        FROM People p 
            JOIN Students stu ON (p.id = stu.id) 
            JOIN Program_enrolments pge ON (pge.student = p.id) 
            JOIN Programs pg ON (pg.id = pge.program) 
            JOIN Course_enrolments ce ON (ce.student = stu.id) 
            JOIN Courses c ON (c.id = ce.course) 
            JOIN Subjects s ON (c.subject = s.id) 
            JOIN Terms t ON (c.term = t.id) 
        WHERE p.unswid = zid AND c.term = pge.term 
        ORDER BY termName(c.term))
    LOOP
        IF tr.grade IN ('PT','PC','PS','CR','DN','HD','A','B','C') THEN
            UOCpassed := UOCpassed + tr.uoc;
            UOCtotal := UOCtotal + tr.uoc;
            weightedSumOfMarks := weightedSumOfMarks + (tr.mark * tr.uoc);
        ELSIF tr.grade IN ('SY', 'XE', 'T', 'PE', 'RC', 'RS') THEN
            UOCpassed := UOCpassed + tr.uoc;
        ELSE
            IF (tr.mark IS NOT NULL AND tr.uoc IS NOT NULL) THEN -- capture fl grade
                weightedSumOfMarks := weightedSumOfMarks + (tr.mark * tr.uoc);
                UOCtotal := UOCtotal + tr.uoc;
            END IF;
                tr.uoc = NULL;
        END IF;
        RETURN NEXT tr;
    END LOOP;
    IF (UOCpassed = 0 OR weightedSumOfMarks = 0) THEN
        tr := (NULL, NULL, NULL, 'No WAM available', NULL, NULL, NULL);
    ELSE
        wamValue := round(weightedSumOfMarks::real / UOCtotal);
        tr := (NULL, NULL, NULL, 'Overall WAM/UOC', wamValue, NULL, UOCpassed);
    END IF;
    RETURN NEXT tr;
END;
$$ LANGUAGE plpgsql;
---------------------------------Q8 Above---------------------------------
---------------------------------Q9 Below---------------------------------
-- A helper function which decodes the enumerated def academic group
-- all three subtypes, subject, program, and stream, follow the same pattern
/*
    Parameters:
        (str) gtype: group type IN (subject, stream, program)
        (integer) gid: primary key which defines the group

    Returns:
        (setof text): all the _objcode IN the group
*/
CREATE OR REPLACE FUNCTION enum(gtype text, gid integer) RETURNS setof text
AS $$
DECLARE
    _objcode text;
BEGIN
    FOR _objcode IN
        EXECUTE 
                'select a.code from '|| $1 ||'s a'
                ||' join '||$1||'_group_members b on a.id=b.'||$1
                ||' join acad_object_groups c on c.id=b.ao_group'
                ||' where c.id='|| $2
        USING gtype, gid
    LOOP
        RETURN NEXT _objcode;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- A helper function which finds the children of a given group
/*
    Parameters:
        (integer) gid: primary key which defines the group

    Returns:
        (setof integer): all the children id 
                        OR the gid itself it doesn't have child
*/
CREATE OR REPLACE FUNCTION findChild(gid integer) RETURNS setof integer
AS $$ 
DECLARE
    _gid integer;
BEGIN
    FOR _gid IN 
        (SELECT id FROM acad_object_groups WHERE parent = gid) UNION (SELECT id FROM acad_object_groups WHERE id = gid)
    LOOP
        RETURN NEXT _gid;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Main Function for Q9
/*
    it takes IN a gid and returns all the academic group IN it,
    including groups IN its children if given gid is a parent)

    Parameters:
        (integer) gid: primary key which defines the group

    Returns:
        (setof AcObjRecord): all tuples (objtype, objcode)
*/
CREATE OR REPLACE FUNCTION Q9(gid integer) RETURNS setof AcObjRecord
AS $$ 
DECLARE
    ar AcObjRecord;
    _gdefby text;
    _gtype text;
    _objcodelist text;
    _objcode text;
    _negated BOOLEAN;
    _gidchild integer;
BEGIN
    -- base case
    IF NOT EXISTS (SELECT * FROM acad_object_groups WHERE id = gid) THEN
        raise EXCEPTION 'No such group %', gid;
    END IF;
    FOR _gidchild IN EXECUTE 'select findChild($1)' USING gid
    LOOP
        SELECT gdefby, gtype, definition, negated INTO _gdefby, _gtype, _objcodelist, _negated 
        FROM acad_object_groups 
        WHERE id = _gidchild;
        -- handle exceptions
        IF (_negated = TRUE OR
            SUBSTRING(_objcodelist, 'FREE') IS NOT NULL OR
            SUBSTRING(_objcodelist, 'GEN') IS NOT NULL OR
            SUBSTRING(_objcodelist, 'F=') IS NOT NULL) THEN
            RETURN;
        ELSE
            IF LOWER(_gdefby) = 'pattern' THEN
                IF LOWER(_gtype) = 'subject' THEN
                    FOR _objcode IN 
                        SELECT DISTINCT code 
                        FROM subjects 
                        WHERE code ~* REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(_objcodelist, ';', ','), '{', ''), '}', ''), '#', '.'), ',', '|')
                    LOOP
                        ar := (_gtype,_objcode);
                        RETURN NEXT ar;
                    END LOOP;
                ELSIF LOWER(_gtype) = 'program' THEN
                    FOR _objcode IN 
                        SELECT DISTINCT * 
                        FROM regexp_split_to_table(_objcodelist, ',')
                    LOOP
                        ar := (_gtype,_objcode);
                        RETURN NEXT ar;
                    END LOOP;
                ELSE
                    RETURN NEXT ar;
                END IF;
            ELSIF LOWER(_gdefby) = 'enumerated' THEN
                FOR _objcode IN
                    EXECUTE 'select enum($1, $2)' USING _gtype, _gidchild LOOP ar := (_gtype, _objcode);
                    RETURN NEXT ar;
                END LOOP;
            ELSE
                -- any groups defined using a query (gdefby='query')
                RETURN NEXT ar;
            END IF;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;
---------------------------------Q9  Above---------------------------------
---------------------------------Q10 Below---------------------------------
CREATE OR REPLACE FUNCTION findParent(code text) RETURNS setof text AS $$ 
DECLARE
    _code text;
    _id integer;
    _ruleid integer;
    _subjectid integer;
BEGIN
    FOR _id IN 
        SELECT id
        FROM acad_object_groups
        WHERE SUBSTRING(definition, code) IS NOT NULL
    LOOP 
        SELECT id INTO _ruleid 
        FROM rules 
        WHERE ao_group = _id AND type = 'RQ';
        IF _ruleid IS NOT NULL THEN
            SELECT subject INTO _subjectid 
            FROM subject_prereqs 
            WHERE rule = _ruleid;

            SELECT subjects.code INTO _code
            FROM subjects 
            WHERE id = _subjectid;
            RETURN NEXT _code;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION Q10(code text) RETURNS setof text AS $$ 
DECLARE
    _code text;
BEGIN
    FOR _code IN SELECT DISTINCT * FROM findParent(code)
    LOOP
        RETURN NEXT _code;
    END LOOP;
END;
$$ LANGUAGE plpgsql;


-- Recursive version
-- CREATE OR REPLACE FUNCTION findChild2(gid integer) returns setof integer
-- as $$
-- declare
--     _gid integer;
-- begin
--     for _gid IN
--         with RECURSIVE test(parent, id) as(
--             (select aog.parent, aog.id
--             from acad_object_groups aog
--             where parent=gid)
--             union
--             (select aog1.parent, aog1.id
--             from acad_object_groups aog1, test
--                 where aog1.parent=test.id
--             )
--         )
--         select id from test
--     LOOP
--         return NEXT _gid;
--     end LOOP;
-- end;
-- $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION Q9(gid integer) RETURNS setof AcObjRecord
AS $$ 
DECLARE
    ar AcObjRecord;
    _gdefby         text;
    _gtype          text;
    _objcodelist    text;
    _objcode        text;
    _negated        boolean;
    _gidchild       integer;
    _temp           text;
BEGIN
    -- base case
    IF NOT EXISTS (SELECT * FROM acad_object_groups WHERE id = gid) THEN
        raise EXCEPTION 'No such group %', gid;
    END IF;
    FOR _gidchild IN EXECUTE 'select findChild($1)' USING gid
    LOOP
        SELECT gdefby, gtype, definition, negated INTO _gdefby, _gtype, _objcodelist, _negated 
        FROM acad_object_groups 
        WHERE id = _gidchild;
        -- handle exceptions
        IF _negated = TRUE THEN
            RETURN;
        ELSE
            IF LOWER(_gdefby) = 'pattern' THEN
                IF LOWER(_gtype) = 'subject' THEN
                    _objcodelist := REPLACE(REPLACE(REPLACE(REPLACE(_objcodelist, ';', ','), '{', ''), '}', ''), '#', '.');
                    FOR _objcode IN 
                        SELECT DISTINCT * 
                        FROM regexp_split_to_table(_objcodelist, ',')
                    LOOP
                        IF _objcode ~ '[A-Z]{4}[0-9]{4}' AND SUBSTRING(_objcode, 'FREE') IS NULL AND SUBSTRING(_objcode, 'GEN') IS NULL THEN
                            ar := (_gtype,_objcode);
                            RETURN NEXT ar;
                        ELSE
                            FOR _temp IN
                                SELECT DISTINCT code
                                FROM Subjects
                                Where code ~ _objcode AND
                                    SUBSTRING(_objcode, 'FREE') IS NULL AND
                                    SUBSTRING(_objcode, 'GEN') IS NULL AND
                                    SUBSTRING(_objcode, 'F=') IS NULL
                            LOOP
                                ar := (_gtype,_temp);
                                RETURN NEXT ar;
                            END LOOP;
                        END IF;
                    END LOOP;
                ELSIF LOWER(_gtype) = 'program' THEN
                    FOR _objcode IN 
                        SELECT DISTINCT * 
                        FROM regexp_split_to_table(_objcodelist, ',')
                    LOOP
                        ar := (_gtype,_objcode);
                        RETURN NEXT ar;
                    END LOOP;
                ELSE
                    RETURN NEXT ar;
                END IF;
            ELSIF LOWER(_gdefby) = 'enumerated' THEN
                FOR _objcode IN
                    EXECUTE 'select enum($1, $2)' USING _gtype, _gidchild LOOP ar := (_gtype, _objcode);
                    RETURN NEXT ar;
                END LOOP;
            ELSE
                -- any groups defined using a query (gdefby='query')
                RETURN NEXT ar;
            END IF;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;