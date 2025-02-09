# Query #1: Retrieve Customer Information
SELECT Title, FirstName, LastName, DateOfBirth FROM Customer;

#Query #2: Count Customers by Group
SELECT CustomerGroup, COUNT(*) AS TotalCustomers FROM Customer
GROUP BY CustomerGroup;

#Query #3: Add Currency Code to Customer Data
SELECT C.*, A.CurrencyCode FROM Customer C
JOIN Account A ON C.CustId = A.CustId;

#Query #4: Summarize Bets by Product and Day
SELECT B.Product, DATE(B.BetDate) AS BetDay, SUM(B.Bet_Amt) AS TotalBetAmount FROM Betting B
GROUP BY B.Product, DATE(B.BetDate)
ORDER BY BetDay, B.Product;

#Query #5: Filter Bets by Date and Product
SELECT B.Product, DATE(B.BetDate) AS BetDay, SUM(B.Bet_Amt) AS TotalBetAmount
FROM Betting B
WHERE B.Product = 'Sportsbook' AND B.BetDate >= '2023-11-01'
GROUP BY B.Product, DATE(B.BetDate)
ORDER BY BetDay, B.Product;

#Query #6: Split Products by Currency Code and Customer Group
SELECT C.CustomerGroup, A.CurrencyCode, B.Product, SUM(B.Bet_Amt) AS TotalBetAmount
FROM Betting B
JOIN Account A ON B.AccountNo = A.AccountNo
JOIN Customer C ON A.CustId = C.CustId
WHERE B.BetDate >= '2023-12-01'
GROUP BY C.CustomerGroup, A.CurrencyCode, B.Product;

#Query #7: Summarize Bets for All Players in November
SELECT C.Title, C.FirstName, C.LastName, SUM(B.Bet_Amt) AS TotalBetAmount
FROM Customer C
LEFT JOIN Account A ON C.CustId = A.CustId
LEFT JOIN Betting B ON A.AccountNo = B.AccountNo AND B.BetDate BETWEEN '2023-11-01' AND '2023-11-30'
GROUP BY C.Title, C.FirstName, C.LastName;

#Query #8: Count Players by Number of Products Played
SELECT A.CustId, COUNT(DISTINCT B.Product) AS NumberOfProducts
FROM Account A
JOIN Betting B ON A.AccountNo = B.AccountNo
GROUP BY A.CustId;

#Query #9: Show Players Who Only Play Sportsbook
SELECT A.CustId, SUM(B.Bet_Amt) AS TotalBetAmount
FROM Account A
JOIN Betting B ON A.AccountNo = B.AccountNo
WHERE B.Product = 'Sportsbook' AND B.Bet_Amt > 0
GROUP BY A.CustId
HAVING COUNT(DISTINCT B.Product) = 1;

#Query #10: Identify Player’s Favorite Product
SELECT A.CustId, B.Product, SUM(B.Bet_Amt) AS TotalBetAmount
FROM Account A
JOIN Betting B ON A.AccountNo = B.AccountNo
GROUP BY A.CustId, B.Product
ORDER BY TotalBetAmount DESC;

#Query #11: Find Top 5 Students by GPA
SELECT student_name, GPA
FROM Student_school
ORDER BY GPA DESC
LIMIT 5;

#Query #12: Count Students in Each School
SELECT school_id, COUNT(student_id) AS NumberOfStudents
FROM Student_school
GROUP BY school_id;

#Query #13: Find Top 3 GPA Students per University
SELECT school_id, student_name, GPA
FROM (
    SELECT school_id, student_name, GPA,
           ROW_NUMBER() OVER (PARTITION BY school_id ORDER BY GPA DESC) AS rn
    FROM Student_school
) AS subquery
WHERE rn <= 3;
