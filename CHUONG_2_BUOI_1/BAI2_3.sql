use master
drop database QL_HOADON
go
use master
create database QL_HOADON
on primary
( 
	name = 'QLHD_Primary',
	filename = 'D:\BaiTap\TH HQTCSDL\CHUONG_2_BUOI_1\QLHD_Primary.mdf',
	size = 15MB,
	maxsize = 30MB,
	filegrowth = 10% 
),
filegroup nhom1
(
	name = 'QLHD_Second1_1',
	filename = 'D:\BaiTap\TH HQTCSDL\CHUONG_2_BUOI_1\QLHD_Second1_1.ndf',
	size = 8MB,
	maxsize = 20MB,
	filegrowth = 10%  
),
(
	name = 'QLHD_Second1_2',
	filename = 'D:\BaiTap\TH HQTCSDL\CHUONG_2_BUOI_1\QLHD_Second1_2.ndf',
	size = 8MB,
	maxsize = 20MB,
	filegrowth = 10%  
),
filegroup nhom2
(
	name = 'QLHD_Second1_3',
	filename = 'D:\BaiTap\TH HQTCSDL\CHUONG_2_BUOI_1\QLHD_Second1_3.ndf',
	size = 15MB,
	maxsize = 30MB,
	filegrowth = 5%  
)
log on
(
	name = 'QLHD_Log',
	filename = 'D:\BaiTap\TH HQTCSDL\CHUONG_2_BUOI_1\QLHD_Log.ldf',
	size = 10MB,
	maxsize = 20MB,
	filegrowth = 15% 
)

use QL_HOADON
--xoa bang
drop table KHACH
drop table HOADON
drop table HANG
drop table CHITIETHD
drop table PHIEUNHAP
drop table CHITIETPN
go
--tao bang
create table KHACH
(
	MAKH char(3),
	TENKH nvarchar(30),
	DIACHI nvarchar(40),
	DIENTHOAI char(10),
	primary key (MAKH)
)
go
select * from KHACH
go
create table HOADON
(
	MAHD char(5),
	NGAYLAP date,
	MAKH char(3),
	primary key(MAHD)
)
go
select * from HOADON
go
create table HANG
(
	MAHG char(4),
	TENHG nvarchar(40),
	DVT nvarchar(10),
	NHASX nvarchar(30),
	primary key (MAHG)
)
go
select * from HANG
go
create table CHITIETHD
(
	MAHD char(5),
	MAHG char(4),
	SOLUONG int,
	GIABAN money,
	primary key (MAHD, MAHG)
)
go
select * from CHITIETHD
go
create table PHIEUNHAP
(
	MAPN char(5),
	NGAYLAP date,
	MANCC char(3),
	primary key (MAPN)
)
go
select * from PHIEUNHAP
go
create table CHITIETPN
(
	MAPN char(5),
	MAHG char(4),
	SOLUONG int,
	GIANHAP money,
	primary key (MAPN, MAHG)
)
go 
select * from CHITIETPN
go
--xoa khoa ngoai
alter table HOADON
drop constraint FK_HOADON_KHACH
go
alter table CHITIETHD
drop constraint FK_CTHD_HOADON
go
alter table CHITIETHD
drop constraint FK_CTHD_HANG
go
alter table CHITIETPN
drop constraint FK_CTPN_PHIEUNHAP
go
alter table CHITIETPN
drop constraint FK_CTPN_HANG
go
--khoa ngoai
alter table HOADON
add constraint FK_HOADON_KHACH foreign key (MAKH) references KHACH(MAKH)
go
alter table CHITIETHD
add constraint FK_CTHD_HOADON foreign key (MAHD) references HOADON(MAHD)
go
alter table CHITIETHD
add constraint FK_CTHD_HANG foreign key (MAHG) references HANG(MAHG)
go
alter table CHITIETPN
add constraint FK_CTPN_PHIEUNHAP foreign key (MAPN) references PHIEUNHAP(MAPN)
go
alter table CHITIETPN
add constraint FK_CTPN_HANG foreign key (MAHG) references HANG(MAHG)
go
Thêm dữ liệu bằng excel
insert into KHACH
select * from KHACH_TAM

select * from KHACH

drop table KHACH_TAM

insert into HOADON
select * from HOADON_TAM

select * from HOADON

drop table HOADON_TAM

insert into HANG
select * from HANG_TAM

select * from HANG

drop table HANG_TAM

insert into CHITIETHD
select * from CHITIETHD_TAM

select * from CHITIETHD

drop table CHITIETHD_TAM

insert into PHIEUNHAP
select * from PHIEUNHAP_TAM

select * from PHIEUNHAP

drop table PHIEUNHAP_TAM

insert into CHITIETPN
select * from CHITIETPN_TAM

select * from CHITIETPN

drop table CHITIETPN_TAM

--bài 4
-- Câu a
select * from KHACH
select * from HOADON
select * from CHITIETHD

select * from KHACH, HOADON, CHITIETHD

create view vw_DoanhSoKhachHang
as
select
    K.MAKH, 
    K.TENKH, 
    SUM(C.SOLUONG * C.GIABAN) AS DoanhSo
from KHACH K, HOADON H, CHITIETHD C
where K.MAKH = H.MAKH and H.MAHD = C.MAHD
group by K.MAKH, K.TENKH;
go

select * from vw_DoanhSoKhachHang
go

-- Câu b
select * from HOADON
select * from KHACH
select * from CHITIETHD

select * from HOADON, KHACH, CHITIETHD

create view vw_TongTriGiaHoaDon
as
select
    H.MAHD, 
    K.TENKH, 
    SUM(C.SOLUONG * C.GIABAN) AS TongTriGia
from HOADON H, KHACH K, CHITIETHD C
where H.MAKH = K.MAKH and H.MAHD = C.MAHD
group by H.MAHD, K.TENKH;
go

select * from vw_TongTriGiaHoaDon
go

-- Câu c
select * from HANG
select * from CHITIETHD

select * from HANG, CHITIETHD

create view vw_TongSoLuongBan
as
select
    H.MAHG, 
    H.TENHG, 
    H.DVT, 
    SUM(C.SOLUONG) AS TongSoLuongBan
from HANG H, CHITIETHD C
where H.MAHG = C.MAHG
group by H.MAHG, H.TENHG, H.DVT;
go

select * from vw_TongSoLuongBan
go

-- Câu d
select * from HANG
select * from CHITIETPN

select * from HANG, CHITIETPN

create view vw_TongSoLuongNhap
as
select
    H.MAHG, 
    H.TENHG, 
    H.DVT, 
    SUM(C.SOLUONG) AS TongSoLuongNhap
from HANG H, CHITIETPN C
where H.MAHG = C.MAHG
group by H.MAHG, H.TENHG, H.DVT;
go

select * from vw_TongSoLuongNhap
go

-- Câu e
select * from HOADON
select * from CHITIETHD

select * from HOADON, CHITIETHD

create view vw_TongTriGiaTheoThang
as
select
    MONTH(H.NGAYLAP) AS Thang, 
    SUM(C.SOLUONG * C.GIABAN) AS TongTriGia
from HOADON H, CHITIETHD C
where H.MAHD = C.MAHD
group by MONTH(H.NGAYLAP);
go

select * from vw_TongTriGiaTheoThang
go

-- Câu f
select * from HOADON
select * from CHITIETHD
select * from CHITIETPN

select * from HOADON, CHITIETHD, CHITIETPN

create view vw_TongLoiNhuanTheoThang
as
select
    MONTH(HD.NGAYLAP) AS Thang, 
    SUM(CTHD.SOLUONG * (CTHD.GIABAN - CTPN.GIANHAP)) AS TongLoiNhuan
from HOADON HD, CHITIETHD CTHD, CHITIETPN CTPN
where HD.MAHD = CTHD.MAHD and CTHD.MAHG = CTPN.MAHG
group by MONTH(HD.NGAYLAP);
go

select * from vw_TongLoiNhuanTheoThang
go

-- Câu g
select * from HOADON
select * from CHITIETHD
select * from CHITIETPN

select * from HOADON, CHITIETHD, CHITIETPN

create view vw_ThongKeTheoThang
as
select
    MONTH(HD.NGAYLAP) AS Thang, 
    SUM(CTHD.SOLUONG * CTHD.GIABAN) AS TongTriGia,
    SUM(CTHD.SOLUONG * (CTHD.GIABAN - CTPN.GIANHAP)) AS TongLoiNhuan
from HOADON HD, CHITIETHD CTHD, CHITIETPN CTPN
where HD.MAHD = CTHD.MAHD and CTHD.MAHG = CTPN.MAHG
group by MONTH(HD.NGAYLAP);
go

select * from vw_ThongKeTheoThang
go
-- Câu h
select * from HANG
select * from CHITIETPN
select * from CHITIETHD

select * from HANG, CHITIETPN, CHITIETHD

create view vw_TonKho
as
select
    H.MAHG, 
    H.TENHG, 
    H.DVT, 
    SUM(P.SOLUONG) AS TongSoLuongNhap, 
    SUM(C.SOLUONG) AS TongSoLuongBan, 
    SUM(P.SOLUONG) - SUM(C.SOLUONG) AS TongSoLuongConLai
from HANG H, CHITIETPN P, CHITIETHD C
where H.MAHG = P.MAHG and H.MAHG = C.MAHG
group by H.MAHG, H.TENHG, H.DVT;
go

select * from vw_TonKho
go
