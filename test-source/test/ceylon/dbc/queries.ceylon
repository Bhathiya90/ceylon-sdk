import ceylon.test {
    ...
}
import java.util { Date }
import ceylon.dbc { Row }

test void queryTests() {
    sql.Insert("INSERT INTO test1(name,when,count) VALUES (?, ?, ?)")
            .execute("First", Date(), 1);
    sql.Insert("INSERT INTO test1(name,when,count,price,flag) VALUES (?, ?, ?, ?, ?)")
            .execute("Third", Date(), 3, 12.34, true);
    sql.Insert("INSERT INTO test1(name,when,count) VALUES (?, ?, ?)")
            .execute("Second", Date(0), 2);
    
    value q1 = sql.Select("SELECT * FROM test1 WHERE name=?");
    q1.forEachRow("Third")((Row row) => print(row["count"]));
    assertEquals(q1.execute("Second").size, 1);
    try (r1 = q1.Results("First")) {
        assertTrue(r1.size==1, "Rows with 'First'");
        for (row in r1) {
            assertTrue(row.size==7);
        }
    }
    try (r2 = q1.Results("Second")) {
        assertTrue(r2.size==1, "Rows with 'Second'");
    }
    try (r3 = q1.Results("whatever")) {
        assertTrue(r3.empty, "'whatever' should return empty");
    }
    
    value q2 = sql.Select("SELECT * FROM test1");
    try (r4 = q2.Results()) {
        assertTrue(r4.size==3, "all rows");
    }
    q2.limit=2;
    try (r5 = q2.Results()) {
        assertTrue(r5.size==2, "2 rows");
    }
    q2.limit=1;
    try (r6 = q2.Results()) {
        assertTrue(r6.size==1, "1 row");
    }
    
}
