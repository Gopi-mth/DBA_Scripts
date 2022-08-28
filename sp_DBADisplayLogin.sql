Create   procedure sp_DBADisplayLogin(@userName sysname)  
as  
  
--------------------------------------------------------This procedure displays the login details and its permissions on both server and DB level-----------------------------------------------  
  
select name [---Login Name---],type_desc [---Login Type---],create_date as [---Created date---],LOGINPROPERTY (@userName, 'PasswordLastSetTime') [---LastPasswordChangeDate---],case when is_disabled=1 then 'disabled' else  'enabled' end [---Login status---
]from sys.server_principals where name=@userName  
select string_agg(name,',') [---Server Roles Granted---]from sys.server_principals where principal_id in (select role_principal_id from sys.server_role_members where member_principal_id=suser_id(@userName))  
declare @cmd varchar(max)='use ?;   
if (select count(*) from sys.database_principals where name='+quotename(@userName,'''')+')<>0 '+  
'select db_name() [---Exists in ---],string_agg(name,'+quotename(',','''')+') [---Database Roles Granted---]from sys.Database_principals where principal_id in (select role_principal_id from sys.Database_role_members where member_principal_id=user_id('+quo
tename(@userName,'''')+'))'  
+'else  '+' select'+quotename('Not exist in  ','''')+quotename('?''','''')    
exec sp_MSforeachdb @cmd   
  
--sp_DBADisplayLogin 'testlog'