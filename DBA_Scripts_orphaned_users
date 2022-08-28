---------------------------------------------stored procedure to display the orphaned user in current database------------------------------------------------------

create   procedure sp_DBAgetOrphanedUsers      
as    
    
    
--------------------------------------procedure to get orphaned users/logins ------------------------------------------        
      
          
-- checks for database users having incorrect server logins        
select db_name() as [----Database name----],dp.name as [----Database users with incorrect sid----],        
'EXEC sp_change_users_login'+'   '+quotename('Auto_fix','''')+','+quotename(dp.name,'''')          
as [----Run below command(s) to sync orphaned users------] from sys.server_principals sp        
left outer join sys.database_principals dp on dp.name=sp.name        
where sp.name in (select name from sys.database_principals)         
and  sp.name not like 'public'         
and sp.sid<>dp.sid        
        
        
--checks for database users with no server logins        
select db_name() as [----Database name----],dp.name as [----Database users with no server logins],        
'EXEC sp_change_users_login'+'   '+quotename('Auto_fix','''')+','+quotename(dp.name,'''')+',null,<password>' as[----run below commands with password-----]        
from sys.database_principals dp         
left outer join sys.server_principals sp on sp.name=dp.name        
where dp.type in ('s','g','u') and dp.name not in (select name from sys.server_principals)         
and dp.name not like ('%guest%')        
and dp.name not in ('sys','dbo','information_schema')     
    
--DBA_getOrphanedUsers 
