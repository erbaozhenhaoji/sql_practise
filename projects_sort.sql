/*
Enter your query here.
Please append a semicolon ";" at the end of the query and enter your query in a single line to avoid error.
*/
DECLARE @end_date date
declare @start_date date
declare @prev_date date
declare @project_start_date date
DECLARE cursor_date CURSOR FOR

SELECT start_date, end_date FROM projects order by end_date
OPEN cursor_date
FETCH NEXT FROM cursor_date INTO @start_date, @end_date
set @prev_date = @end_date
set @project_start_date = @start_date

create table temp_projects (start_date date, end_date date, duration int)
WHILE @@FETCH_STATUS = 0
BEGIN
    --print @end_date
    FETCH NEXT FROM cursor_date INTO @start_date, @end_date
    
    if (datediff(day, @prev_date, @end_date)=1)
    begin
        set @prev_date = @end_date
    end
    else
    begin
        --print cast(@project_start_date as char(100)) + "  " + cast(@prev_date as char(100))
        insert into temp_projects values(@project_start_date, @prev_date, datediff(day, @project_start_date, @prev_date))
        set @project_start_date = @start_date
        set @prev_date = @end_date
    end 
    
END

select start_date, end_date from temp_projects order by duration, start_date
--print cast(@project_start_date as char(100)) + "  " + cast(@prev_date as char(100))
