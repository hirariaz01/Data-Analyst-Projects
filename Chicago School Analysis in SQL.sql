
/*
Chicago Public School Data Analysis in SQL
 */

-- list average of safety score,school type identified as Elementary,Middle, HighSchool

SELECT AVG(Safety_Score),School_Type
 FROM Chicago_Public_Schools
 GROUPBY Elementary_Middle_HighSchool;

-- Total numbers of schools listed

Select COUNT(DISTINCT ID) as Total_Number_Of_Schools FROM Chicago_Public_Schools

-- Total numbers of Elementary,Middle and High School listed

Select COUNT(DISTINCT ID) as Total_Number_Of_Schools, Elementary_Middle_High_School as Category 
FROM Chicago_Public_Schools 
GROUPBY Elementary_Middle_High_School

-- List the schools of "Albany Park" area along with their codes

SELECT School_Name,School_Code
 FROM Chicago_Public_School 
 WHERE Community_Area_Name="Albany Park"

List the School Name with highest Parent Involvement score

SELECT School_Name,Community_Area,Parent_Involvement_Score FROM Chicago_Public_School WHERE Parent_Involvement_Score= (SELECT MAX(Parent_Involvement_Score))

-- List Top 5 Best Environment Schools

SELECT School_Name,(Environment_Score) 
FROM Chicago_Public_School 
Group by School_Name
Order by Environment_Score desc
LIMIT 5

--list the school names, community names and average attendance for communities with a hardship less than 40.

SELECT cps.Name_Of_School,cps.Community_Name, cps.Average_Attendance
 from Chicago_Public_Schools as cps
 RIGHTJOIN Census_Data as cd 
 on cps.Community_Area_Number=cd.Community_Area_Number
 WHERE cd.Hardship_Index < 40

-- Creating View with School name and rating

CREATE VIEW SchoolAndIcon AS
SELECT Name_OF_School,Leaders_Icon
 FROM Chicago_Public_School

-- Creating Procedure to update Leaders_Score
--The icon fields are calculated based on the value in the corresponding score field. We need to make sure that when a score field is updated, the icon field is updated too. To do this, we will write a stored procedure that receives the school id and a leaders score as input parameters,

@ CREATE OR REPLACE PROCEDURE UPDATE_LEADERS_SCORE (IN in_School_ID INTEGER, IN in_Leader_Score INTEGER) BEGIN

   UPDATE CHICAGO_PUBLIC_SCHOOLS
   SET "Leaders_Score" = in_Leader_Score
   WHERE "School_ID" = in_School_ID;

END @

/*Displaying Icon against a given range of Leaders_Score field
To update the Leaders_Icon field using the following information
 1-(80-99): Very Strong
 2-(60-79): Strong
 3-(40-59): Average
 4-(20-39): Weak 
 5-(0-19) : Very Weak */

CREATE OR REPLACE PROCEDURE UPDATE_LEADERS_SCORE (IN in_School_ID INTEGER, IN in_Leader_Score INTEGER)

BEGIN

  UPDATE CHICAGO_PUBLIC_SCHOOLS
      SET "Leaders_Score" = in_Leader_Score
          WHERE "School_ID" = in_School_ID;

    IF in_Leader_Score > 0 AND in_Leader_Score < 20 THEN
        UPDATE CHICAGO_PUBLIC_SCHOOLS
        SET "Leaders_Icon" = 'Very Weak';
    ELSEIF in_Leader_Score < 40 THEN
        UPDATE CHICAGO_PUBLIC_SCHOOLS
            SET "Leaders_Icon" = 'Weak';    
    ELSEIF in_Leader_Score < 60 THEN
        UPDATE CHICAGO_PUBLIC_SCHOOLS
            SET "Leaders_Icon" = 'Average';
    ELSEIF in_Leader_Score < 80 THEN
        UPDATE CHICAGO_PUBLIC_SCHOOLS
            SET "Leaders_Icon" = 'Strong';
    ELSEIF in_Leader_Score < 100 THEN
        UPDATE CHICAGO_PUBLIC_SCHOOLS
            SET "Leaders_Icon" = 'Very Strong';
    END IF;

END@
-- To Call the procedure
CALL UPDATE_LEADERS_SCORE(134,56)