use master
go
drop database DB1
go
use master
go
create database DB1
on primary
(
    name = 'DB1_PRIMARY',
    filename = 'D:\BaiTap\TH HQTCSDL\CHUONG_2_BUOI_1\db1_primary.mdf',
    size = 30MB,
    maxsize = 100MB,
    filegrowth = 5MB
),
(
    name = 'DB1_SECOND',
    filename = 'D:\BaiTap\TH HQTCSDL\CHUONG_2_BUOI_1\db1_second.ndf',
    size = 10MB,
    maxsize = 20MB,
    filegrowth = 15%
)
log on
(
    name = 'DB1_Log',
    filename = 'D:\BaiTap\TH HQTCSDL\CHUONG_2_BUOI_1\db1_log.ldf',
    size = 20MB,
    maxsize = 50MB,
    filegrowth = 15%
)
go

use DB1
go

exec sp_spaceused
go

alter database DB1
add file
(
    name = 'DB1_SECOND2',
    filename = 'D:\BaiTap\TH HQTCSDL\CHUONG_2_BUOI_1\db1_second2.ndf',
    size = 10MB,
    maxsize = 20MB,
    filegrowth = 10%
)
go

alter database DB1
modify file
(
    name = 'DB1_SECOND2',
    size = 15MB
)
go

dbcc shrinkfile ('DB1_PRIMARY', 20)
go