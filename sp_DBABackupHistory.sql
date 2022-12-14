if (OBJECT_ID('sp_DBABackupHistory') is not null)
begin 
drop procedure sp_DBABackupHistory
print '<<<dropped procedure sp_DBABackupHistory>>>'
end
go
 
create procedure sp_DBABackupHistory(@dbname varchar(max))  
as    
----------------------------------------Gives last 10 backup details of the  provided database---------------  
select top 10 bs.database_name,  
case when bs.type ='D' then 'Data Backup'   
when bs.type='L' then 'Log backup'   
when bs.type='I' then 'differential backup'  
when bs.type='F' then 'file / file group backup'  
when bs.type='G' then 'differential file'  
end [backupType],  
round((bs.compressed_backup_size /1024),0) [backupSizeKB],  
bmf.physical_device_name,  
case when bmf.device_type=2 then 'disk' when bmf.device_type=5 then 'tape'  when bmf.device_type=7 then 'virtual device' end [Backup Device type],bs.backup_start_date,bs.backup_finish_date,cast(datediff(ss,bs.backup_start_date,bs.backup_finish_date) as varchar)+' seconds' duration,bs.user_name  
from msdb..backupset bs  
inner join msdb..backupmediafamily bmf on bs.media_set_id=bmf.media_set_id  
inner join msdb..backupfile bf on bf.backup_set_id=bs.backup_set_id  
where database_name=@dbname  
group by bs.database_name,bmf.physical_device_name,bmf.device_type ,bs.backup_start_date,bs.backup_finish_date,bs.user_name,bs.type,bs.compressed_backup_size/1024  
order by backup_start_date desc
go  

if (OBJECT_ID('sp_DBABackupHistory') is not null)
begin 
print '<<<created procedure sp_DBABackupHistory>>>'
end 
go

if (OBJECT_ID('sp_DBABackupHistory') is null)
begin
print '<<<Failed creating procedure sp_DBABackupHistory>>>'
end
go
  
--sp_DBABackuphistory 'northwind'


