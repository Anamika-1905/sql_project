select 
		department,
        count(*) as Total_Employees
	from
    employees
    group by
    department
    order by
		total_employees;