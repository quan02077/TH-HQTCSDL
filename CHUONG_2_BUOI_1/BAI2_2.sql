use master
drop database QL_SINHVIEN
go
use master
create database QL_SINHVIEN
on primary
( 
	name = 'QLSV_Primary',
	filename = 'D:\BaiTap\TH HQTCSDL\CHUONG_2_BUOI_1\QLSV_Primary.mdf',
	size = 15MB,
	maxsize = 30MB,
	filegrowth = 10% 
),
filegroup nhom1
(
	name = 'QLSV_Second1_1',
	filename = 'D:\BaiTap\TH HQTCSDL\CHUONG_2_BUOI_1\QLSV_Second1_1.ndf',
	size = 8MB,
	maxsize = 20MB,
	filegrowth = 10%  
),
(
	name = 'QLSV_Second1_2',
	filename = 'D:\BaiTap\TH HQTCSDL\CHUONG_2_BUOI_1\QLSV_Second1_2.ndf',
	size = 8MB,
	maxsize = 20MB,
	filegrowth = 10%  
),
filegroup nhom2
(
	name = 'QLSV_Second1_3',
	filename = 'D:\BaiTap\TH HQTCSDL\CHUONG_2_BUOI_1\QLSV_Second1_3.ndf',
	size = 15MB,
	maxsize = 30MB,
	filegrowth = 5%  
)
log on
(
	name = 'QLSV_Log',
	filename = 'D:\BaiTap\TH HQTCSDL\CHUONG_2_BUOI_1\QLSV_Log.ldf',
	size = 10MB,
	maxsize = 20MB,
	filegrowth = 15% 
)
use QL_SINHVIEN
--xoa bang
drop table KHOA
drop table LOP
drop table SINHVIEN
drop table MONHOC
drop table KETQUA
go
--tao bang
create table KHOA
(
	MAKHOA char(2) not null,
	TENKHOA nvarchar(30),
	primary key (MAKHOA)
)
go
select * from KHOA
go
create table LOP
(
	MALOP char(4) not null,
	TENLOP nvarchar(30),
	SISODK int null,
	MAKHOA char(2),
	primary key (MALOP)
)
go
select * from LOP
go
create table SINHVIEN
(
	MASV char(4) not null,
	HOTEN nvarchar(30),
	NGSINH date,
	DCHI nvarchar(40),
	GIOITINH nvarchar(3),
	MALOP char(4),
	primary key (MASV)
)
go
select * from SINHVIEN
go
create table MONHOC
(
	MAMH char(4) not null,
	TENMH nvarchar(30),
	SOTC int,
	primary key (MAMH)
)
go
select * from MONHOC
go
create table KETQUA
(
	MASV char(4) not null,
	MAMH char(4) not null,
	DIEM float,
	primary key (MASV,MAMH)
)
go
select * from KETQUA
go
--xoa khoa ngoai
alter table LOP
drop constraint FK_LOP_KHOA
go
alter table SINHVIEN
drop constraint FK_SINHVIEN_LOP
go
alter table SINHVIEN
drop constraint FK_SV_SV
go
alter table KETQUA
drop constraint FK_KETQUA_SINHVIEN
go
alter table KETQUA
drop constraint FK_KETQUA_MONHOC
go

alter table SINHVIEN
add LOPTRUONG char(4)
go
--khoa ngoai
alter table LOP
add constraint FK_LOP_KHOA foreign key (MAKHOA) references KHOA(MAKHOA)
go
alter table SINHVIEN
add constraint FK_SINHVIEN_LOP foreign key (MALOP) references LOP(MALOP)
go
alter table SINHVIEN
add constraint FK_SV_SV foreign key (LOPTRUONG) references SINHVIEN(MASV)
go
alter table KETQUA
add constraint FK_KETQUA_SINHVIEN foreign key (MASV) references SINHVIEN(MASV)
go
alter table KETQUA
add constraint FK_KETQUA_MONHOC foreign key (MAMH) references MONHOC(MAMH)
go
--them du lieu
insert into KHOA
values('01', N'Công nghệ thông tin'),
	('02', N'Điện - Điện tử'),
	('03', N'Công nghệ thực phẩm')
go
insert into LOP(MALOP, TENLOP, SISODK, MAKHOA)
values('L001', '15CNTT1',null,'01'),
	('L002', '15CNTT2',null,'01'),
	('L003', '14ATTT',null,'01'),
	('L004', '14DTVT',null,'02'),
	('L005', '16ATTP1',null,'03'),
	('L006', '16ATTP2',null,'03')
go
insert into SINHVIEN
values('SV01', N'Nguyễn Thị Lan', '2005/07/15', 'TPHCM','Nam', null,null),
	('SV02', N'Trần Thanh Tùng', '2005/05/19', N'Vũng tàu','Nam', null,null),
	('SV03', N'Trương Thị Huệ', '2002/08/31', N'Đà Nẵng',N'Nữ', null,null),
	('SV04', N'Lê Văn Khánh', '2002/01/18', N'Vũng tàu','Nam', null,null),
	('SV05', N'Ngô Đình Việt', '2004/09/27', N'Đà Nẵng','Nam', null,null),
	('SV06', N'Trần Thị Liễu', '2003/02/18', 'TPHCM',N'Nữ', null,null),
	('SV07', N'Trần Thanh Nam', '2004/06/22', N'Đồng Nai','Nam', null,null),
	('SV08', N'Phạm Hoài Phong', '2003/12/08', N'Tiền Giang','Nam', null,null),
	('SV09', N'Trần Thị Tố Anh', '2004/11/28', 'TPHCM',N'Nữ', null,null),
	('SV10', N'Đỗ Thị Hạnh', '2005/04/26', N'Đồng Nai',N'Nữ', null,null)
go
insert into MONHOC
values('M001', N'Toán cao cấp A1', 3),
	('M002', N'Lịch sử đảng', 2),
	('M003', N'Chính trị', 2),
	('M004', N'Cơ sở dữ liệu', 4),
	('M005', N'Hệ quản trị CSDL', 4),
	('M006', N'Lập trình C', 3),
	('M007', N'Xử lý ản', 2),
	('M008', N'Tin học cơ bản', 3),
	('M009', N'Mạng máy tính', 2),
	('M010', N'Toán rời rạc', 2),
	('M011', N'Lập trình web', 3),
	('M012', N'Công nghệ Java', 3)
go
insert into KETQUA
values('SV01','M001',8),
	('SV01','M002',4),
	('SV01','M003',6),
	('SV02','M001',4),
	('SV02','M004',5),
	('SV03','M002',7),
	('SV03','M006',9),
	('SV04','M004',10),
	('SV05','M005',6),
	('SV06','M006',9),
	('SV07','M008',7),
	('SV08','M001',3),
	('SV08','M002',8),
	('SV09','M003',6),
	('SV10','M002',5)
go
update SINHVIEN
set MALOP = 'L001'
where MASV in ('SV01', 'SV02', 'SV03')
update SINHVIEN
set MALOP = 'L002'
where MASV = 'SV04'
update SINHVIEN
set MALOP = 'L003'
where MASV in ('SV05', 'SV06')
update SINHVIEN
set MALOP = 'L004'
where MASV in ('SV07', 'SV08')
update SINHVIEN
set MALOP = 'L005'
where MASV = 'SV09'
update SINHVIEN
set MALOP = 'L006'
where MASV = 'SV10'

--Bài 5
--câu a
select * from SINHVIEN
select * from LOP
select * from KHOA

select * 
from SINHVIEN, LOP, KHOA

select *
from SINHVIEN sv, LOP lp, KHOA kh
where sv.MALOP = lp.MALOP and lp.MAKHOA = kh.MAKHOA

select *
from SINHVIEN sv, LOP lp, KHOA kh
where sv.MALOP = lp.MALOP and lp.MAKHOA = kh.MAKHOA and kh.TENKHOA = N'Công nghệ thông tin'

select sv.MASV, sv.HOTEN
from SINHVIEN sv, LOP lp, KHOA kh
where sv.MALOP = lp.MALOP and lp.MAKHOA = kh.MAKHOA and kh.TENKHOA = N'Công nghệ thông tin'
--câu b
select * from KETQUA
select * from MONHOC

select *
from KETQUA, MONHOC

select * 
from KETQUA kq, MONHOC mh
where kq.MAMH = mh.MAMH

select * 
from KETQUA kq, MONHOC mh
where kq.MAMH = mh.MAMH and kq.MASV = 'SV01'

select mh.MAMH, mh.TENMH, kq.DIEM
from KETQUA kq, MONHOC mh
where kq.MAMH = mh.MAMH and kq.MASV = 'SV01'
--câu c
select * from KETQUA
select * from SINHVIEN
select * from LOP

select *
from KETQUA, SINHVIEN, LOP

select *
from KETQUA kq, SINHVIEN sv, LOP lp
where kq.MASV = sv.MASV and sv.MALOP = lp.MALOP

select *
from KETQUA kq, SINHVIEN sv, LOP lp
where kq.MASV = sv.MASV and sv.MALOP = lp.MALOP and kq.MAMH = 'M001'

select *
from KETQUA kq, SINHVIEN sv, LOP lp
where kq.MASV = sv.MASV and sv.MALOP = lp.MALOP and kq.MAMH = 'M001' and kq.DIEM < 5

select sv.MASV, sv.HOTEN, sv.NGSINH, lp.TENLOP
from KETQUA kq, SINHVIEN sv, LOP lp
where kq.MASV = sv.MASV and sv.MALOP = lp.MALOP and kq.MAMH = 'M001' and kq.DIEM < 5
--câu d
select * from KETQUA
select * from SINHVIEN
select * from MONHOC

select * 
from KETQUA, SINHVIEN, MONHOC

select *
from KETQUA kq, SINHVIEN sv, MONHOC mh
where kq.MASV = sv.MASV and kq.MAMH = mh.MAMH

select sv.MASV, sv.HOTEN, round(sum(mh.SOTC * kq.DIEM) / sum(mh.SOTC), 2) AS DIEMTRUNGBINH
from KETQUA kq, SINHVIEN sv, MONHOC mh
where kq.MASV = sv.MASV and kq.MAMH = mh.MAMH

select sv.MASV, sv.HOTEN, round(sum(mh.SOTC * kq.DIEM) / sum(mh.SOTC), 2)AS DIEMTRUNGBINH
from KETQUA kq, SINHVIEN sv, MONHOC mh
where kq.MASV = sv.MASV and kq.MAMH = mh.MAMH
group by sv.MASV, sv.HOTEN
--câu e
select * from KETQUA
select * from SINHVIEN
select * from MONHOC

select *
from KETQUA, SINHVIEN, MONHOC

select *
from KETQUA kq, SINHVIEN sv, MONHOC mh
where kq.MASV = sv.MASV and kq.MAMH = mh.MAMH

select *
from KETQUA kq, SINHVIEN sv, MONHOC mh
where kq.MASV = sv.MASV and kq.MAMH = mh.MAMH and kq.DIEM >=5

select sv.MASV, sv.HOTEN, sum(mh.SOTC) AS TONGTC
from KETQUA kq, SINHVIEN sv, MONHOC mh
where kq.MASV = sv.MASV and kq.MAMH = mh.MAMH and kq.DIEM >=5

select sv.MASV, sv.HOTEN, sum(mh.SOTC) AS TONGTC
from KETQUA kq, SINHVIEN sv, MONHOC mh
where kq.MASV = sv.MASV and kq.MAMH = mh.MAMH and kq.DIEM >=5
group by sv.MASV, sv.HOTEN
--câu f
select * from MONHOC
select * from KETQUA

select *
from MONHOC, KETQUA

select * 
from MONHOC mh, KETQUA kq
where mh.MAMH = kq.MAMH

select *
from MONHOC mh
where not exists (
	select * 
	from KETQUA kq
	where kq.MAMH = mh.MAMH
)

select mh.MAMH, mh.TENMH
from MONHOC mh
where not exists (
	select * 
	from KETQUA kq
	where kq.MAMH = mh.MAMH
)
--câu g
select * from LOP
select * from SINHVIEN

select * 
from LOP, SINHVIEN

select *
from LOP lp, SINHVIEN sv
where lp.MALOP = sv.MALOP

select lp.MALOP, lp.TENLOP, count(sv.MASV) as SISOMAX
from LOP lp, SINHVIEN sv
where lp.MALOP = sv.MALOP

select lp.MALOP, lp.TENLOP, count(sv.MASV) as SISOMAX
from LOP lp, SINHVIEN sv
where lp.MALOP = sv.MALOP
group by lp.MALOP, lp.TENLOP

select lp.MALOP, lp.TENLOP, count(sv.MASV) as SISOMAX
from LOP lp, SINHVIEN sv
where lp.MALOP = sv.MALOP
group by lp.MALOP, lp.TENLOP
having count(sv.MASV) >= ALL (
	select count(sv1.MASV)
	from LOP lp1, SINHVIEN sv1
	where lp1.MALOP = sv1.MALOP
	group by lp1.MALOP
)

--bài 5
--câu a
select * from KHOA
select * from LOP
select * from SINHVIEN

select * 
from KHOA, LOP, SINHVIEN

create view cau5_a
as
	select kh.MAKHOA, kh.TENKHOA, count(sv.MASV) as SISOSV_KHOA
	from KHOA kh, LOP lp, SINHVIEN sv
	where kh.MAKHOA = lp.MAKHOA and lp.MALOP = sv.MALOP
	group by kh.MAKHOA, kh.TENKHOA

select * from cau5_a
--câu b
select * from KETQUA
select * from MONHOC

select * 
from KETQUA, MONHOC

create view cau5_b
as
	select mh.MAMH, mh.TENMH,count(MASV) as SISOSV_MONHOC
	from KETQUA kq, MONHOC mh
	where kq.MAMH = mh.MAMH 
	group by mh.MAMH, mh.TENMH

select * from cau5_b
--câu c
select * from MONHOC
select * from KETQUA

select *
from MONHOC, KETQUA

create view cau5_c
as
	select mh.MAMH, mh.TENMH, mh.SOTC, count(case when kq.DIEM >= 5 then 1 end) as SOSV_DAU, count(case when kq.DIEM < 5 then 1 end) as SOSV_ROT
	from MONHOC mh, KETQUA kq
	where mh.MAMH = kq.MAMH
	group by mh.MAMH, mh.TENMH, mh.SOTC

select * from cau5_c
--câu d
select * from LOP
select * from SINHVIEN

select *
from LOP, SINHVIEN

create view cau5_d
as
select 
    L.MALOP, 
    L.TENLOP, 
    SUM(CASE WHEN SV.GIOITINH = N'Nam' THEN 1 ELSE 0 END) AS SoSV_Nam,
    SUM(CASE WHEN SV.GIOITINH = N'Nữ' THEN 1 ELSE 0 END) AS SoSV_Nu,
    COUNT(SV.MASV) AS TongSV
from LOP L, SINHVIEN SV
where L.MALOP = SV.MALOP
group by L.MALOP, L.TENLOP;
go

select * from cau5_d
--câu e
select * from SINHVIEN
select * from KETQUA
select * from  MONHOC

select * 
from SINHVIEN, KETQUA, MONHOC

create view V_ThongKeSinhVien
as
select
    SV.MASV, 
    SV.HOTEN, 
    SUM(MH.SOTC) AS TongTinChi,
    SUM(CASE WHEN KQ.DIEM >= 5 THEN MH.SOTC ELSE 0 END) AS TongTichLuy,
    ROUND(SUM(KQ.DIEM * MH.SOTC) / CAST(SUM(MH.SOTC) AS FLOAT), 2) AS DiemTB
from SINHVIEN SV, KETQUA KQ, MONHOC MH 
where SV.MASV = KQ.MASV and KQ.MAMH = MH.MAMH
group by SV.MASV, SV.HOTEN;
go

select * from cau5_e