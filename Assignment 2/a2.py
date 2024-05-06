"""CSC343 Assignment 2

=== CSC343 Winter 2024 ===
Department of Computer Science,
University of Toronto

This code is provided solely for the personal and private use of
students taking the CSC343 course at the University of Toronto.
Copying for purposes other than this use is expressly prohibited.
All forms of distribution of this code, whether as given or with
any changes, are expressly prohibited.

Authors: Diane Horton, Marina Tawfik, Jacqueline Smith

All of the files in this directory and all subdirectories are:
Copyright (c) 2024 Diane Horton and Jacqueline Smith

=== Module Description ===

This file contains the Library class and some simple testing functions.
"""
import psycopg2 as pg
import psycopg2.extensions as pg_ext
import psycopg2.extras as pg_extras
from typing import Optional, List
import subprocess


class Library:
    """A class that can work with data conforming to the schema
    in a2_library_schema.ddl.

    === Instance Attributes ===
    connection: connection to a PostgreSQL database of a library management
    system.

    Representation invariants:
    - The database to which connection is established conforms to the schema
      in a2_library_schema.ddl.
    """
    connection: Optional[pg_ext.connection]

    def __init__(self):
        """Initialize this Library instance, with no database connection yet.
        """
        self.connection = None

    def connect(self, dbname: str, username: str, password: str) -> bool:
        """Establish a connection to the database <dbname> using the
        username <username> and password <password>, and assign it to the
        instance attribute 'connection'. In addition, set the search path
        to library, public.

        Return True if the connection was made successfully, False otherwise.
        I.e., do NOT throw an error if making the connection fails.

        >>> ww = Library()
        >>> # The following example will only work if you change the dbname
        >>> # and password to your own credentials.
        >>> ww.connect("postgres", "postgres", "password")
        True
        >>> # In this example, the connection cannot be made.
        >>> ww.connect("invalid", "nonsense", "incorrect")
        False
        """
        try:
            self.connection = pg.connect(
                dbname=dbname, user=username, password=password,
                options="-c search_path=Library,public"
            )
            return True
        except pg.Error:
            return False

    def disconnect(self) -> bool:
        """Close the database connection.

        Return True if closing the connection was successful, False otherwise.
        I.e., do NOT throw an error if closing the connection failed.

        >>> a2 = Library()
        >>> # The following example will only work if you change the dbname
        >>> # and password to your own credentials.
        >>> a2.connect("postgres", "postgres", "password")
        True
        >>> a2.disconnect()
        True
        """
        try:
            if self.connection and not self.connection.closed:
                self.connection.close()
            return True
        except pg.Error:
            return False

    def search(self, last_name: str, branch: str) -> List[str]:
        """Return the titles of all holdings at the library with the unique code
        <branch>, by any contributor with the last name <last_name>.
        Return an empty list if no matches are found.
        If two different holdings happen to have the same title, return both
        titles.
        However, don't return the same holding twice.

        Your method must NOT throw an error. Return an empty list if an error
        occurs.
        """
        cursor = self.connection.cursor()
        try:
            cursor.execute("""
                SELECT DISTINCT h.title
                FROM Holding h
                JOIN HoldingContributor hc ON h.id = hc.holding
                JOIN Contributor c ON hc.contributor = c.id
                JOIN LibraryCatalogue lc ON h.id = lc.holding
                JOIN LibraryBranch lb ON lc.library = lb.code
                WHERE c.last_name = %s AND lb.code = %s
            """, (last_name, branch))
            titles = [row[0] for row in cursor.fetchall()]
        except pg.Error as e:
            titles = []
            self.connection.rollback()
        finally:
            cursor.close()
        return titles

    def register(self, card_number: str, event_id: int) -> bool:
        """Record the registration of the patron with the card number
        <card_number> signing up for the event identified by <event_id>.

        Return True iff
            (1) The card number and event ID provided are both valid
            (2) This patron is not already registered for this event
            (3) The patron is not already registered for an event that overlaps
        Otherwise, return False.
        
        Two events that are consecutive, e.g. one ends at 14:00:00 and the 
        other begins at 14:00:00, are not considered overlapping. 

        Return True if the operation was successful (as per the above criteria),
        and False otherwise. Your method must NOT throw an error.
        """
        cur = self.connection.cursor()
        try:
            # Check if card number and event ID provided are both valid
            cur.execute("SELECT * FROM Patron WHERE card_number = %s", (card_number,))
            patron_cnt = 0            
            for patron in cur:
                patron_cnt += 1
              
            cur.execute("SELECT * FROM LibraryEvent WHERE id = %s", (event_id,))
            event_cnt = 0
            for event in cur:
                event_cnt += 1

            if not (patron_cnt > 0 and event_cnt>0):
                cur.close()
                return False  # Invalid card number or event ID

            # Check if the patron is already registered for this event
            cur.execute("SELECT * FROM EventSignUp WHERE patron = %s AND event = %s", (card_number, event_id))
            registered_cnt = 0
            for occurence in cur:
                registered_cnt += 1
            if registered_cnt > 0:
                cur.close()
                return False  # Patron already registered for this event

            # # Check for overlapping events
            cur.execute("""
                SELECT *
                FROM EventSchedule es1
                CROSS JOIN EventSchedule es2
                WHERE es1.edate = es2.edate
                AND es1.event != es2.event
                AND ((es1.start_time, es1.end_time) OVERLAPS (es2.start_time, es2.end_time))
                AND (es1.event = %s OR es2.event = %s)
                AND (SELECT COUNT(*) FROM EventSignUp WHERE patron = %s AND event IN (es1.event, es2.event)) > 0
            """, (event_id, event_id, card_number))
            overlaps_cnt = 0
            for overlap in cur:
                overlaps_cnt += 1
            if overlaps_cnt > 0:
                cur.close()
                return False  # Overlapping events

            # Register the patron for the event
            cur.execute("INSERT INTO EventSignUp (patron, event) VALUES (%s, %s)", (card_number, event_id))
            cur.close()
            return True
        except pg.Error as e:
            print("error!")
            cur.close()
            self.connection.rollback()
            return False

    def return_item(self, checkout: int) -> float:
        """Record that the checked-out library item, with the checkout id
        <checkout> was returned at the current time and return the fines 
        incurred on that item.

        Do so by inserting a row in the Return table

        Use the same due date rules as the SQL queries.

        The fines incurred are calculated as follows: for everyday overdue
        i.e. past the due date:
            books and audiobooks incur a $0.50 charge
            other holding types incur a $1.00 charge

        A return operation is considered successful iff all the following
        criteria are satisfied:
            (1) The checkout id <checkout> provided is valid.
            (2) A return has not already been recorded for this checkout.

        If the return operation is successful, make all necessary modifications
        (indicated above) and return the amount of fines incurred.
        Otherwise, the db instance should NOT be modified at all and a value of
        -1.0 should be returned. Your method must NOT throw an error.
        """
        cursor = self.connection.cursor()
        try:
            # Check if the checkout id is valid
            cursor.execute("SELECT copy FROM Checkout WHERE id = %s", (checkout,))
            result = cursor.fetchone()
            if not result:
                return -1.0  # Invalid checkout id
            barcode = result[0]

            # Check if a return has already been recorded for this checkout
            cursor.execute("SELECT 1 FROM Return WHERE checkout = %s", (checkout,))
            if cursor.fetchone():
                return -1.0  # Return already recorded

            # Calculate due date based on holding type
            fines = 0
            cursor.execute("SELECT htype FROM Holding WHERE id = (SELECT holding FROM LibraryHolding WHERE barcode = %s)", (barcode,))
            holding_type = cursor.fetchone()[0]
            if holding_type in ['books', 'audiobooks']:
                cursor.execute("SELECT (CURRENT_DATE - DATE((SELECT checkout_time FROM Checkout c WHERE c.id = %s)) - 21) as overdue", (checkout,))
                days_overdue = cursor.fetchone()[0]
                if days_overdue > 0:
                    fines = 0.5 * days_overdue
            else:
                cursor.execute("SELECT (CURRENT_DATE - DATE((SELECT checkout_time FROM Checkout c WHERE c.id = %s)) - 7) as overdue", (checkout,))
                days_overdue = cursor.fetchone()[0]
                if days_overdue > 0:
                    fines = 1.0 * days_overdue

            # Record the return in the Return table
            cursor.execute("INSERT INTO Return (checkout, return_time) VALUES (%s, NOW())", (checkout,))
            return fines
        except pg.Error as e:
            print("error fuck!")
            print(e)
            self.connection.rollback()
            return -1.0
        finally:
            cursor.close()

def test_preliminary() -> None:
    """Test preliminary aspects of the A2 methods.
    
    We have provided this function to you to give you some examples of what
    testing your code could look like. You should do much more thorough testing
    yourself before submitting to make sure your code works correctly. 
    """
    # TODO: Change the values of the following variables to connect to your
    #  own database:
    dbname = "csc343h-sahakhsh"
    user = "sahakhsh"
    password = "KhalidIbnWalid@313"

    a2 = Library()
    try:
        connected = a2.connect(dbname, user, password)

        # The following is an assert statement. It checks that the value for
        # connected is True. The message after the comma will be printed if
        # that is not the case (connected is False).
        # Use the same notation to thoroughly test the methods we have provided
        assert connected, f"[Connect] Expected True | Got {connected}."

        # TODO: Test one or more methods here, or better yet, make more testing
        #   functions, with each testing a different aspect of the code.

        # The following function will set up the testing environment by loading
        # a fresh copy of the schema and the sample data we have provided into
        # your database. You can create more sample data files and use the same
        # function to load them into your database.

        # ------------------------- Testing search ----------------------------#

        expected_titles = ["Willy Wonka and the chocolate factory"]
        returned_titles = a2.search("Stuart", "DM")
        # We don't really need to use set here, but you might find it useful
        # in your own testing since we don't care about the order of the
        # returned items.
        assert set(returned_titles) == set(expected_titles), \
            f"[Search] Expected:\n{expected_titles}\n Got:\n{returned_titles}"

        # ------------------------ Testing register ---------------------------#

        # Invalid card number, valid event id
        # You should also check that no modifications were made to the db
        registered = a2.register("1", 100)
        assert not registered, "[Register] Invalid card number, valid " \
                               "event id: should return False. " \
                               f"Returned {registered}"
        # Valid card number, Invalid event id
        # You should also check that no modifications were made to the db
        registered = a2.register("5309015788", 200)
        assert not registered, "[Register] Valid card number, Invalid " \
                               "event id: should return False. " \
                               f"Returned {registered}"
        # Valid card number and event id
        # You should also check that the following row has been added to
        # the EventSignup relation:
        #   ("02953575718", 77)
        registered = a2.register("02953575718", 77)
        assert registered, "[Register] Valid card number, valid event id: " \
                           f"should return True. Returned {registered}"

        # ----------------------- Testing return_item -------------------------#

        # Invalid checkout id
        # You should also check that no modifications were made to the db
        returned = a2.return_item(2020)
        assert returned == -1.0, "[Return] Invalid checkout id:" \
                                 f"should return -1.0. Returned {returned}"

        # Valid checkout id, but has already been returned
        # returned = a2.return_item(94)
        # assert returned == -1.0, "[Return] Already returned checkout id:" \
        #                          f"should return -1.0. Returned {returned}"

    finally:
        a2.disconnect()


if __name__ == '__main__':
    # Un comment-out the next two lines if you would like to run the doctest
    # examples (see ">>>" in the methods connect and disconnect)
    # import doctest
    # doctest.testmod()

    # TODO: Put your testing code here, or call testing functions such as
    #   this one:
    test_preliminary()
