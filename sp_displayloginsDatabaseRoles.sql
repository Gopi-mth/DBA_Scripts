
  
if (object_id('sp_DBA_displayLoginsDatabaseRoles') is not null)
begin
drop procedure sp_DBA_displayLoginsDatabaseRoles
print '<<<dropped procedure sp_DBA_displayLoginsDatabaseRoles>>>'
end
go


create procedure sp_DBA_displayLoginsDatabaseRoles (@userName varchar(max))  
as 


if (select count(*) from sys.database_principals where name=@username) <> 0  
begin  
select db_name() as [---Database Name---],stuff(  
(  
select ','+name from sys.database_principals where principal_id in  
(  
select role_principal_id from sys.database_role_members where member_principal_id=user_id(@username)  
)  
for xml path('')  
),1,1,''  
) as [---Roles granted---] 
end
go

exec sp_ms_marksystemobject 'sp_DBA_displayLoginsDatabaseRoles'
print'sp_DBA_displayLoginsDatabaseRoles marked as system object'



if object_id('sp_DBA_displayLoginsDatabaseRoles') is not null
begin
print '<<<created procedure sp_DBA_displayLoginsDatabaseRoles>>>'
end

else
begin
print'<<<failed creating  procedure sp_DBA_displayLoginsDatabaseRoles>>>'
end



--exec sp_DBA_displayLoginsDatabaseRoles 'gopi'
--exec sp_ms_marksystemobject 'sp_DBA_displayLoginsDatabaseRoles'
