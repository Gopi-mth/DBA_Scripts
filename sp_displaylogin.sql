if (object_id('sp_displaylogin') is not null)
begin 
drop procedure sp_displaylogin
print '<<< dropped procedure sp_displaylogin>>>'
end
go

create procedure sp_displaylogin(@username sysname)
as

begin  
select name [---Login Name---],type_desc [---Login Type---],create_date as [---Created date---],LOGINPROPERTY (@userName, 'PasswordLastSetTime') [---LastPasswordChangeDate---],case when is_disabled=1 then 'disabled' else  'enabled' end [---Login status---
]from sys.server_principals where name=@userName  
select string_agg(name,',') [---Server Roles Granted---]from sys.server_principals where principal_id in (select role_principal_id from sys.server_role_members where member_principal_id=suser_id(@userName))  
declare @cmd nvarchar(max)='use ?; Exec sp_DBA_displayLoginsDatabaseRoles'+' '+quotename(@userName,'''') 
--declare @loopsql nvarchar(max)= 'exec sp_executesql'+''+@cmd
exec sp_msforeachdb @command1=@cmd
end
go

if (object_id('sp_displaylogin') is not null)
begin 
print '<<< Created procedure sp_displaylogin>>>'
end

else
begin 
print'<<<failed creating procedure sp_displaylogin>>>'
end
go

--sp_displaylogin 'ravi'