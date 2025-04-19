Create table Corporate
(
Sr_Num int not null,
Employee_code varchar(100) Not null,
Relation varchar(100) not null,
Employee_Name varchar(100) Not null,
Gender enum('Male','Female'),
Date_of_birth date,
Email_Id Varchar(150),
Salary decimal(15,2)
);