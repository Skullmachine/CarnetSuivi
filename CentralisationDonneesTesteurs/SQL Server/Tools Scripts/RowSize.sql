use DMCapabiliteRetest
go
create table ##tmpRowSize (TableName varchar(100),RowSizeDefinition int)
exec sp_msforeachtable 'INSERT INTO ##tmpRowSize Select ''?'' As TableName, SUM(C.Length) as Length from dbo.SysColumns C where C.id = object_id(''?'') '
select * from ##tmpRowSize order by RowSizeDefinition  desc
drop table ##tmpRowSize