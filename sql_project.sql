/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:


https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

SELECT DISTINCT name FROM Facilities WHERE membercost > 0

name
Tennis Court 1
Tennis Court 2
Massage Room 1
Massage Room 2
Squash Court

/* Q2: How many facilities do not charge a fee to members? */

SELECT COUNT(DISTINCT name) FROM Facilities WHERE membercost = 0

COUNT(DISTINCT name)
4

/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, name, membercost, monthlymaintenance
FROM Facilities
WHERE membercost>0
AND membercost < (0.2*monthlymaintenance)


facid	name	           membercost	  monthlymaintenance
1	Tennis Court 2	   5	          200
0	Tennis Court 1	   5	          200
3	Table Tennis	   0	          10
6	Squash Court	   3.5	          80
7	Snooker Table	   0	          15
8	Pool Table	   0	          15
5	Massage Room 2	   9.9	          3000
4	Massage Room 1	   9.9	          3000
2	Badminton Court	   0	          50


/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

SELECT * FROM Facilities WHERE facid IN ('1','5')

facid	name	          membercost	guestcost  initialoutlay   monthlymaintenance
1	Tennis Court 2	  5	        25	   8000            200
5	Massage Room 2	  9.9	        80	   4000	           3000


/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

SELECT name, 
       monthlymaintenance,
       CASE WHEN monthlymaintenance < 100 THEN 'cheap'
            ELSE 'expensive' END AS affordability
FROM Facilities

name	        monthlymaintenance	affordability
Tennis Court 1  200                     expensive
Tennis Court 2  200                     expensive
Badminton Court 50                      cheap
Table Tennis    10                      cheap
Massage Room 1  3000                    expensive
Massage Room 2  3000                    expensive
Squash Court    80                      cheap
Snooker Table   15	                cheap
Pool Table      15                      cheap
 

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

SELECT firstname,
       surname,
       joindate
  FROM `Members`
 WHERE joindate = (SELECT MAX(joindate) FROM `Members`)


firstname	surname
Henry           Worthington-Smyth


/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT DISTINCT Facilities.name,
                CONCAT(Members.firstname,' ',Members.surname) AS member_name      
FROM Bookings
JOIN Facilities
ON Bookings.facid = Facilities.facid
JOIN Members
ON Bookings.memid = Members.memid
WHERE Facilities.name LIKE '%Tennis Court%'
ORDER BY member_name

name	        member_name
Tennis Court 1  Anna Mackenzie
Tennis Court 2  Anna Mackenzie
Tennis Court 1  Anne Baker
Tennis Court 2  Anne Baker
Tennis Court 1  Burton Tracy
Tennis Court 2  Burton Tracy
Tennis Court 1  Charles Owen
Tennis Court 2  Charles Owen
Tennis Court 1  Darren Smith
Tennis Court 2  Darren Smith
Tennis Court 2  David Farrell
Tennis Court 1  David Farrell
Tennis Court 2  David Jones
Tennis Court 1  David Jones
Tennis Court 1  David Pinker
Tennis Court 2  David Pinker
Tennis Court 2  Douglas Jones
Tennis Court 1  Douglas Jones
Tennis Court 1  Erica Crumpet
Tennis Court 2  Erica Crumpet
Tennis Court 1  Florence Bader
Tennis Court 2  Florence Bader
Tennis Court 2  Gerald Butters
Tennis Court 1  Gerald Butters
Tennis Court 1  GUEST GUEST
Tennis Court 2  GUEST GUEST
Tennis Court 1  Henrietta Rumney
Tennis Court 2  Henrietta Rumney
Tennis Court 1  Henry Worthington-Smyth
Tennis Court 2  Henry Worthington-Smyth
Tennis Court 1  Hyacinth Tupperware
Tennis Court 2  Hyacinth Tupperware
Tennis Court 1  Jack Smith
Tennis Court 2  Jack Smith
Tennis Court 1  Janice Joplette
Tennis Court 2  Janice Joplette
Tennis Court 2  Jemima Farrell
Tennis Court 1  Jemima Farrell
Tennis Court 2  Joan Coplin
Tennis Court 1  Joan Coplin
Tennis Court 2  John Hunt
Tennis Court 1  John Hunt
Tennis Court 2  Matthew Genting
Tennis Court 1  Matthew Genting
Tennis Court 2  Millicent Purview
Tennis Court 1  Millicent Purview
Tennis Court 2  Nancy Dare
Tennis Court 1  Nancy Dare
Tennis Court 2  Ponder Stibbons
Tennis Court 1  Ponder Stibbons
Tennis Court 1  Ramnaresh Sarwin
Tennis Court 2  Ramnaresh Sarwin
Tennis Court 1  Tim Boothe
Tennis Court 2  Tim Boothe
Tennis Court 2  Tim Rownam
Tennis Court 1  Tim Rownam
Tennis Court 1  Timothy Baker
Tennis Court 2  Timothy Baker
Tennis Court 1  Tracy Smith
Tennis Court 2  Tracy Smith



/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT fac.name,
       CONCAT(mem.firstname, ' ', mem.surname) AS "Name",
       CASE WHEN mem.memid = 0 THEN book.slots * fac.guestcost
            ELSE book.slots * fac.membercost END AS "Cost"
  FROM `Members` mem
  JOIN `Bookings` book
    ON mem.memid = book.memid
  JOIN `Facilities` fac
    ON book.facid = fac.facid
 WHERE 30 < CASE WHEN mem.memid = 0 THEN book.slots * fac.guestcost
                 ELSE book.slots * fac.membercost END
   AND book.starttime LIKE '2012-09-14%'
ORDER BY Cost DESC

name	        member_name	cost
Massage Room 2	GUEST GUEST	320
Massage Room 1	GUEST GUEST	160
Massage Room 1	GUEST GUEST	160
Massage Room 1	GUEST GUEST	160
Tennis Court 2	GUEST GUEST	150
Tennis Court 1	GUEST GUEST	75
Tennis Court 1	GUEST GUEST	75
Tennis Court 2	GUEST GUEST	75
Squash Court	GUEST GUEST	70
Massage Room 1	Jemima Farrell	39.6
Squash Court	GUEST GUEST	35
Squash Court	GUEST GUEST	35



/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT combined.facility_name,
       combined.member_name,
       combined.booking_cost
  FROM (SELECT b.starttime,
               CONCAT(m.firstname, ' ', m.surname) AS member_name,
               f.name AS facility_name,
               CASE WHEN m.memid = 0
                    THEN f.guestcost
                    ELSE f.membercost END AS booking_cost
          FROM `Bookings` b
          JOIN `Facilities` f
            ON f.facid = b.facid
          JOIN `Members` m
            ON m.memid = b.memid) combined
 WHERE combined.starttime LIKE '2012-09-14%'
   AND combined.booking_cost > 30
 ORDER BY 3 DESC
 

name	        member_name	cost
Massage Room 2	GUEST GUEST	320
Massage Room 1	GUEST GUEST	160
Massage Room 1	GUEST GUEST	160
Massage Room 1	GUEST GUEST	160
Tennis Court 2	GUEST GUEST	150
Tennis Court 1	GUEST GUEST	75
Tennis Court 1	GUEST GUEST	75
Tennis Court 2	GUEST GUEST	75
Squash Court	GUEST GUEST	70
Massage Room 1	Jemima Farrell	39.6
Squash Court	GUEST GUEST	35
Squash Court	GUEST GUEST	35


/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT name,
       SUM(fee * slots) AS revenue
FROM (SELECT CASE WHEN Bookings.memid = 0 THEN guestcost
             ELSE membercost END AS fee,
             slots,
             name
      FROM Bookings
      JOIN Facilities
      ON Bookings.facid = Facilities.facid) AS Booking_Fees
GROUP BY name
HAVING revenue < 1000
ORDER BY revenue


name           revenue
Table Tennis   180.0
Snooker Table  240.0
Pool Table     270.0