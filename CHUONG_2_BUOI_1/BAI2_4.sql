use master
drop database QL_THUVIEN
go
use master   
create database QL_THUVIEN
on primary
( 
    name = 'QLTV_Primary',
    filename = 'D:\BaiTap\TH HQTCSDL\CHUONG_2_BUOI_1\QLTV_Primary.mdf',
    size = 15MB,
    maxsize = 30MB,
    filegrowth = 10% 
),
filegroup nhom1
(
    name = 'QLTV_Second1_1',
    filename = 'D:\BaiTap\TH HQTCSDL\CHUONG_2_BUOI_1\QLTV_Second1_1.ndf',
    size = 8MB,
    maxsize = 20MB,
    filegrowth = 10%  
),
(
    name = 'QLTV_Second1_2',
    filename = 'D:\BaiTap\TH HQTCSDL\CHUONG_2_BUOI_1\QLTV_Second1_2.ndf',
    size = 8MB,
    maxsize = 20MB,
    filegrowth = 10%  
),
filegroup nhom2
(
    name = 'QLTV_Second2_1',
    filename = 'D:\BaiTap\TH HQTCSDL\CHUONG_2_BUOI_1\QLTV_Second2_1.ndf',
    size = 15MB,
    maxsize = 30MB,
    filegrowth = 5%  
)
log on
(
    name = 'QLTV_Log',
    filename = 'D:\BaiTap\TH HQTCSDL\CHUONG_2_BUOI_1\QLTV_Log.ldf',
    size = 10MB,
    maxsize = 20MB,
    filegrowth = 15% 
)
go

use QL_THUVIEN
go

--xoa bang
drop table CHITIETPM
drop table PHIEUMUON
drop table SACH
drop table DOCGIA
go

--tao bang
create table DOCGIA
(
    MADG char(5),
    TENDG nvarchar(50) not null,
    SDT char(10),
    DIACHI nvarchar(100),
    primary key (MADG)
)
go

create table SACH
(
    MASACH char(5),
    TENSACH nvarchar(100) not null,
    TACGIA nvarchar(50),
    GIATIEN money,
    SOLUONG int,
    primary key (MASACH)
)
go

create table PHIEUMUON
(
    MAPM char(5),
    NGAYMUON date,
    MADG char(5),
    primary key (MAPM)
)
go

create table CHITIETPM
(
    MAPM char(5),
    MASACH char(5),
    SOLUONGMUON int,
    NGAYTRA date,
    primary key (MAPM, MASACH)
)
go

--xoa constraint
alter table DOCGIA drop constraint UQ_SDT
go
alter table SACH drop constraint CHK_GIATIEN
go
alter table SACH drop constraint DF_SOLUONG
go
alter table SACH drop constraint CHK_SOLUONG
go
alter table PHIEUMUON drop constraint DF_NGAYMUON
go
alter table CHITIETPM drop constraint CHK_SOLUONGMUON
go

--xoa khoa ngoai
alter table PHIEUMUON drop constraint FK_PHIEUMUON_DOCGIA
go
alter table CHITIETPM drop constraint FK_CTPM_PHIEUMUON
go
alter table CHITIETPM drop constraint FK_CTPM_SACH
go

--tao constraint
alter table DOCGIA
add constraint UQ_SDT unique (SDT)
go

alter table SACH
add constraint CHK_GIATIEN check (GIATIEN > 0)
go

alter table SACH
add constraint DF_SOLUONG default 0 for SOLUONG
go

alter table SACH
add constraint CHK_SOLUONG check (SOLUONG >= 0)
go

alter table PHIEUMUON
add constraint DF_NGAYMUON default getdate() for NGAYMUON
go

alter table CHITIETPM
add constraint CHK_SOLUONGMUON check (SOLUONGMUON > 0)
go

alter table PHIEUMUON
add constraint FK_PHIEUMUON_DOCGIA foreign key (MADG) references DOCGIA(MADG)
go

alter table CHITIETPM
add constraint FK_CTPM_PHIEUMUON foreign key (MAPM) references PHIEUMUON(MAPM)
go

alter table CHITIETPM
add constraint FK_CTPM_SACH foreign key (MASACH) references SACH(MASACH)
go

--them du lieu
insert into DOCGIA values
('DG001', N'Nguyễn Văn A', '0987654321', N'Ký túc xá khu A'),
('DG002', N'Trần Thị B', '0912345678', N'Nhà trọ quận 9')
go

insert into SACH values
('S001', N'Hệ quản trị CSDL', N'Nguyễn C', 50000, 20),
('S002', N'Lập trình Web', N'Lê D', 75000, 15),
('S003', N'Toán rời rạc', N'Phạm E', 60000, 10)
go

insert into PHIEUMUON (MAPM, MADG) values 
('PM001', 'DG001'),
('PM002', 'DG002')
go

insert into CHITIETPM values
('PM001', 'S001', 1, null), 
('PM001', 'S002', 2, null),
('PM002', 'S003', 1, null)
go