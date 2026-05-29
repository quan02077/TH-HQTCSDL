--Bài 3.3
create database QLSV_3_3;
go

use QLSV_3_3;
go

create table LOP (
    MALOP varchar(10) primary key,
    TENLOP nvarchar(50),
    SISO int
);
go

create table SINHVIEN (
    MASV varchar(10) primary key,
    HOTEN nvarchar(30),
    NGSINH date,
    GIOITINH nvarchar(10),
    QUEQUAN nvarchar(100),
    MALOP varchar(10),
    DIEMTB float,
    XEPLOAI nvarchar(20),
    foreign key (MALOP) references LOP(MALOP)
);
go

create table MONHOC (
    MAMH varchar(10) primary key,
    TENMH nvarchar(100),
    SOTC int,
    BATBUOC bit
);
go

create table KETQUA (
    MASV varchar(10),
    MAMH varchar(10),
    HOCKY int,
    DIEMTHI float,
    primary key (MASV, MAMH, HOCKY),
    foreign key (MASV) references SINHVIEN(MASV),
    foreign key (MAMH) references MONHOC(MAMH)
);
go

insert into LOP values
('L01', N'CNTT1', 0),
('L02', N'CNTT2', 0),
('L03', N'KTPM1', 0);
go

insert into SINHVIEN (MASV, HOTEN, NGSINH, GIOITINH, QUEQUAN, MALOP) values
('SV01', N'Nguyen Van A', '2004-01-01', N'Nam', N'HCM', 'L01'),
('SV02', N'Tran Thi B', '2004-02-02', N'Nu', N'Ha Noi', 'L01'),
('SV03', N'Le Van C', '2004-03-03', N'Nam', N'Da Nang', 'L02'),
('SV04', N'Pham Thi D', '2004-04-04', N'Nu', N'Hue', 'L02'),
('SV05', N'Hoang Van E', '2004-05-05', N'Nam', N'Can Tho', 'L03'),
('SV06', N'Vo Thi F', '2004-06-06', N'Nu', N'HCM', 'L03'),
('SV07', N'Do Van G', '2004-07-07', N'Nam', N'Hai Phong', 'L01'),
('SV08', N'Bui Thi H', '2004-08-08', N'Nu', N'Quang Nam', 'L02'),
('SV09', N'Nguyen Van I', '2004-09-09', N'Nam', N'HCM', 'L03'),
('SV10', N'Tran Thi K', '2004-10-10', N'Nu', N'Ha Noi', 'L01');
go

insert into MONHOC values
('MH01', N'Co so du lieu', 3, 1),
('MH02', N'Cau truc du lieu', 3, 1),
('MH03', N'Lap trinh C', 4, 1),
('MH04', N'Mang may tinh', 3, 0),
('MH05', N'Tri tue nhan tao', 3, 0);
go

insert into KETQUA values
('SV01', 'MH01', 1, 8.5), 
('SV01', 'MH02', 1, 8.0), 
('SV02', 'MH01', 1, 6.5), 
('SV03', 'MH01', 1, 8.5),  
('SV04', 'MH02', 1, 5.5), 
('SV05', 'MH03', 1, null), 
('SV06', 'MH05', 1, 8.5), 
('SV07', 'MH01', 1, 5.0), 
('SV08', 'MH03', 1, 4.0), 
('SV09', 'MH01', 1, 7.5),
('SV10', 'MH01', 1, 9.5),
('SV01', 'MH03', 2, null), 
('SV02', 'MH02', 2, 7.0), 
('SV03', 'MH04', 2, 9.0), 
('SV04', 'MH04', 2, 6.0),
('SV05', 'MH01', 2, 4.0), 
('SV06', 'MH02', 2, 9.0), 
('SV07', 'MH05', 2, 5.5), 
('SV08', 'MH01', 2, 3.5), 
('SV09', 'MH02', 2, null);
go

--để cập nhật sĩ số lớp
update LOP
set SISO = (    select count(MASV)
                from SINHVIEN
                where SINHVIEN.MALOP = LOP.MALOP
            )
go

--cập nhật dtb và xếp loại 
update SINHVIEN
set DIEMTB = (
                select round(sum(mh.SOTC * kq.DIEMTHI) / sum(mh.SOTC), 2)
                from KETQUA kq, MONHOC mh
                where kq.MAMH = mh.MAMH and kq.MASV = SINHVIEN.MASV
             )
where SINHVIEN.MASV = 'SV11'
go
select * from SINHVIEN 
-- Đã điền điều kiện xếp loại
update SINHVIEN
set XEPLOAI = case
                when DIEMTB >= 8.0 then N'Giỏi'
                when DIEMTB >= 6.5 then N'Khá'
                when DIEMTB >= 5.0 then N'Trung bình'
                when DIEMTB is null then null
                else N'Yếu'
              end
go

--thủ tục

--câu a
--Bước 1:
select * from LOP
go
--Bước 2:
insert into LOP (MALOP, TENLOP, SISO)
values('L04', N'CNPM', 0)
go
--Bước 3:
select MALOP, TENLOP, SISO
from LOP
go
--Bước 4:
create proc sp_them_lop @malop varchar(10), @tenlop nvarchar(50)
as
begin
    insert into LOP (MALOP, TENLOP, SISO)
    values (@malop, @tenlop, 0)
end
go
--Bước 5:
exec sp_them_lop 'L05', N'MMT'
go
--Bước 6:
select * from LOP
go
--Bước 7:
drop proc sp_them_lop
go

--câu b
--Bước 1:
select * from SINHVIEN
go
--Bước 2:
insert into SINHVIEN (MASV, HOTEN, NGSINH, GIOITINH, QUEQUAN, MALOP)
values ('SV11', 'Tran Thi Anh', '2004-11-10', N'Nu', N'Tây Ninh', 'L01')
go
--Bước 3:
select MASV, HOTEN, NGSINH, GIOITINH, QUEQUAN, MALOP, DIEMTB, XEPLOAI
from SINHVIEN
go
--Bước 4:
create proc sp_them_sv @masv varchar(10), @hoten nvarchar(30), @ngsinh date, @gioitinh nvarchar(10), @quequan nvarchar(100), @malop varchar(10)
as
begin
    insert into SINHVIEN (MASV, HOTEN, NGSINH, GIOITINH, QUEQUAN, MALOP)
    values (@masv, @hoten, @ngsinh, @gioitinh, @quequan, @malop)
end
go
--Bước 5:
exec sp_them_sv 'SV12', 'Tran Van Binh', '2004-11-10', N'Nam', N'Tây Ninh', 'L04'
go
--Bước 6:
select * from SINHVIEN
go
--Bước 7:
drop proc sp_them_sv
go

--câu c
--Bước 1:
select * from SINHVIEN
go
--Bước 2:
select * from SINHVIEN
where MALOP = 'L04'
--Bước 3:
select count(*)
from SINHVIEN
where MALOP = 'L04'
go
--Bước 4:
update LOP
set SISO =  (   
                select count(*)
                from SINHVIEN
                where MALOP = 'L04'
            )
where MALOP = 'L04'
go
--Bước 5:
select MALOP, SISO
from LOP
go
--Bước 6:
create proc sp_capnhat_siso @malop varchar(10)
as
begin 
    update LOP
    set SISO = (select count(*)
                from SINHVIEN
                where MALOP = @malop)
    where MALOP = @malop
end
go
--Bước 7:
exec sp_capnhat_siso 'L04'
go
--Bước 8:
select * from LOP
go
--Bước 9:
drop proc sp_capnhat_siso
go
--C2:
create proc sp_capnhat_siso2
as
begin 
    update LOP
    set SISO = (select count(*)
                from SINHVIEN
                where SINHVIEN.MALOP = LOP.MALOP)
end
go

exec sp_capnhat_siso2

select * from LOP
--câu d
--Bước 1:
select * from KETQUA
go
--Bước 2:
select * from KETQUA
where MASV = 'SV07' and MAMH = 'MH01' and HOCKY = 1
--Bước 3:
update KETQUA
set DIEMTHI = DIEMTHI + 1
where MASV = 'SV07' and MAMH = 'MH01' and HOCKY = 1
go
--Bước 4:
select MASV, MAMH, HOCKY, DIEMTHI
from KETQUA
go
--Bước 5:
create proc sp_cong_diem @masv varchar(10), @mamh varchar(10), @hocky int
as
begin
    update KETQUA
    set DIEMTHI = DIEMTHI + 1
    where MASV = @masv and MAMH = @mamh and HOCKY = @hocky
end
go
--Bước 6:
exec sp_cong_diem 'SV03', 'MH03', 1
go
--Bước 7:
select * from KETQUA
go
--Bước 7:
drop proc sp_cong_diem
go

--câu e
--Bước 1:
select * from SINHVIEN
select * from LOP
go
--Bước 2:
select * from SINHVIEN sv, LOP lp
go
--Bước 3:
select * from SINHVIEN sv, LOP lp
where sv.MALOP = lp.MALOP
go
--Bước 4:
select HOTEN, NGSINH, GIOITINH, TENLOP
from SINHVIEN sv, LOP lp
where sv.MALOP = lp.MALOP
go
--Bước 5:
select HOTEN, NGSINH, GIOITINH, TENLOP
from SINHVIEN sv, LOP lp
where sv.MALOP = lp.MALOP and MASV = 'SV04'
go
--Bước 6:
create proc sp_tra_ve_sv @masv varchar(10), @hoten nvarchar(30) output, @ngsinh date output, @gioitinh nvarchar(10) output, @tenlop nvarchar(50) output
as
begin
    select 
        @hoten = sv.HOTEN, 
        @ngsinh = sv.NGSINH, 
        @gioitinh = sv.GIOITINH, 
        @tenlop = l.TENLOP
    from SINHVIEN sv, LOP l
    where sv.MASV = @masv 
      and sv.MALOP = l.MALOP
end
go
--Bước 7:
declare @hoten_output nvarchar(30), @ngsinh_output date, @gioitinh_output nvarchar(10), @tenlop_output nvarchar(50)
exec sp_tra_ve_sv 'SV04', @hoten_output output, @ngsinh_output output, @gioitinh_output output, @tenlop_output output
print @hoten_output + ' ' + cast(@ngsinh_output as varchar(20))+ ' ' + @gioitinh_output+ ' ' + @tenlop_output 
go
--Bước 8:
drop proc sp_tra_ve_sv
go

--câu f 
--Bước 1:
select * from SINHVIEN
go
--Bước 2:
select *
from SINHVIEN
where MASV = 'SV04'
go
--Bước 3:
select DIEMTB, XEPLOAI
from SINHVIEN
where MASV = 'SV04'
go
--Bước 4:
alter proc sp_tra_ve_dtb_xeploai @masv varchar(10), @dtb float output, @xeploai nvarchar(20) output
as
begin
    select 
        @dtb = DIEMTB,
        @xeploai = XEPLOAI
    from SINHVIEN
    where MASV = @masv
	print cast(@dtb as varchar(20)) + ' ' + @xeploai 
end
go
--Bước 5:
declare @masv varchar(10), @dtb_output float, @xeploai_output nvarchar(20)
set @masv = 'SV04'
exec sp_tra_ve_dtb_xeploai @masv, @dtb_output output, @xeploai_output output
go
--Bước 6:
drop sp_tra_ve_dtb_xeploai
go

--câu g
--Bước 1:
select * from SINHVIEN
go
--Bước 2:
select * 
from SINHVIEN
where MALOP = 'L02'
go
--Bước 3:
create proc sp_tra_ve_dssv @malop varchar(10)
as
begin   
    select *
    from SINHVIEN
    where MALOP = @malop
end
go
--Bước 4:
exec sp_tra_ve_dssv 'L02'
go
--Bước 5:
drop proc sp_tra_ve_dssv
go

--câu h
--Bước 1:
select * from KETQUA
go
--Bước 2:
select * 
from KETQUA
where MAMH = 'MH03' and HOCKY = 1
go
--Bước 3:
select count(MASV) as TongSoSV 
from KETQUA
where MAMH = 'MH03' and HOCKY = 1
go
--Bước 4:
create proc sp_tra_ve_tong_so_sv @mamh varchar(10), @hocky int
as
begin
    select count(MASV) as TongSoSV
    from KETQUA
    where MAMH = @mamh and HOCKY = @hocky
end
go
--Bước 5:
exec sp_tra_ve_tong_so_sv 'MH03', 1
go
--Bước 6:
drop proc sp_tra_ve_tong_so_sv
go

--câu i 
--Bước 1: 
select * from KETQUA
go
--Bước 2:
select *
from KETQUA
where MASV = 'SV03' and MAMH = 'MH04' and HOCKY = 2
go
--Bước 3:
select *
from KETQUA
where MASV = 'SV03' and MAMH = 'MH02' and HOCKY = 1
go
--Bước 4:
select *
from KETQUA
where MASV = 'SV05' and MAMH = 'MH03' and HOCKY = 1
go
--Bước 3
if not exists ( 
                select *
                from KETQUA
                where MASV = 'SV03' and MAMH = 'MH02' and HOCKY = 1
              )
    print N'Chưa đăng ký'
go
--Bước 4:
if exists ( 
                select *
                from KETQUA
                where MASV = 'SV05' and MAMH = 'MH03' and HOCKY = 1 and DIEMTHI is null
          )               
    print N'Chưa có điểm'
go
--Bước 5:
if exists ( 
                select *
                from KETQUA
                where MASV = 'SV03' and MAMH = 'MH04' and HOCKY = 2 and DIEMTHI >= 5
          )               
    print N'Đạt'
else
    print N'Chưa đạt'
go
--Bước 6:
create proc sp_cau_i @masv varchar(10), @mamh varchar(10), @hocky int
as
begin
    if not exists (
                    select *
                    from KETQUA
                    where MASV = @masv and MAMH = @mamh and HOCKY = @hocky
                  )
        print N'Chưa đăng ký'
    else
    begin
        if exists (
                    select *
                    from KETQUA
                    where MASV = @masv and MAMH = @mamh and HOCKY = @hocky and DIEMTHI is null
                  )
            print N'Chưa có điểm'
        else
        begin
            if exists (
                        select *
                        from KETQUA
                        where MASV = @masv and MAMH = @mamh and HOCKY = @hocky and DIEMTHI >=5
                      )
                print N'Đạt'
            else
                print N'Không đạt'
        end
    end
end
go
--Bước 7:
exec sp_cau_i 'SV03', 'MH02', 1
go
--Bước 8:
drop proc sp_cau_i
go

--câu j
--Bước 1:
select * from MONHOC
select * from KETQUA
go
--Bước 2:
select *
from MONHOC, KETQUA
go
--Bước 3:
select *
from MONHOC mh, KETQUA kq
where mh.MAMH = kq.MAMH and MASV = 'SV02' and HOCKY = 1
go
--Bước 4:
select sum(SOTC * DIEMTHI) / sum(SOTC)
from MONHOC mh, KETQUA kq
where mh.MAMH = kq.MAMH and MASV = 'SV02' and HOCKY = 1
go
--Bước 5:
create proc sp_cauJ @masv varchar(10), @hocky int, @ketQua nvarchar(20) output
as
begin
    declare @dtb float
    select @dtb = sum(SOTC * DIEMTHI) / sum(SOTC)
    from MONHOC mh, KETQUA kq
    where mh.MAMH = kq.MAMH and MASV = @masv and HOCKY = @hocky

    if @dtb >= 8
        set @ketQua =  N'Khen thưởng'
    else
        set @ketQua = N'Không khen thưởng'
	print cast(@dtb as varchar(10)) + ' ' + @ketQua
end
go
--Bước 6:
create proc sp_ThucThi @masv varchar(10), @hocky int, @ketQua nvarchar(20)
as 
begin
	set @masv = 'SV02'
	set @hocky = 1
	exec sp_cauJ @masv, @hocky, @ketQua output
end
go


--Bước 7
drop proc sp_cau_j
go

--Function
--câu f
--Bước 1
select * from SINHVIEN
go
--Bước 2:
select *
from SINHVIEN
go
--Bước 3:
select SINHVIEN.MASV, SINHVIEN.HOTEN, SINHVIEN.NGSINH
from SINHVIEN
where MALOP = 'L02'
go
--Bước 4:
alter function ds_sinhVien(@malop varchar(10))
returns @ds table (
						MASV char(4),
						HOTEN nvarchar(30),
						NGSINH date
				  )
as 
begin
	insert into @ds 
	select SINHVIEN.MASV, SINHVIEN.HOTEN, SINHVIEN.NGSINH
	from SINHVIEN
	where MALOP = @malop
return
end
go
--Bước 6:
select * from ds_sinhVien('L02')
go


--câu h
--Bước 1:
select * from SINHVIEN
select * from KETQUA
--Bước 2:
select *
from SINHVIEN, KETQUA
--Bước 3:
select *
from SINHVIEN, KETQUA
where SINHVIEN.MASV = KETQUA.MASV
--Bước 4:
select *
from SINHVIEN
where not exists (
						select 1
						from KETQUA
						where SINHVIEN.MASV = KETQUA.MASV and MAMH = 'MH04'
					 )
--Bước 5:
select SINHVIEN.MASV, HOTEN, NGSINH
from SINHVIEN
where not exists (
						select 1
						from KETQUA
						where SINHVIEN.MASV = KETQUA.MASV and MAMH = 'MH04'
					 )
--Bước 6:
alter function ds_sinhVienKoHoc(@maMon char(4))
returns @ds table (
					maSV char(4),
					hoTen nvarchar(30),
					ngsinh date
                  )
as
begin
	insert into @ds
	select SINHVIEN.MASV, HOTEN, NGSINH
	from SINHVIEN
	where not exists (
						select 1
						from KETQUA
						where SINHVIEN.MASV = KETQUA.MASV and MAMH = @maMon
					 )												
return
end
--Bước 7:
select * from ds_sinhVienKoHoc('MH04')

--Câu e;
--Bước 1:
select * from KETQUA
select * from MONHOC
go
--Bước 2:
select * 
from KETQUA, MONHOC
go
--Bước 3:
select * 
from KETQUA, MONHOC
where KETQUA.MAMH = MONHOC.MAMH
go
--Bước 4:
select * 
from KETQUA, MONHOC
where KETQUA.MAMH = MONHOC.MAMH and KETQUA.MASV = 'SV04' and KETQUA.HOCKY = 1 and KETQUA.DIEMTHI >= 5
go
--Bước 5:
select sum(SOTC)
from KETQUA, MONHOC
where KETQUA.MAMH = MONHOC.MAMH and KETQUA.MASV = 'SV04' and KETQUA.HOCKY = 1 and KETQUA.DIEMTHI >= 5
go
--Bước 6:
create function tra_ve_tongtc(@masv varchar(10), @hocky int)
returns int
as
begin
    declare @tongtc int
    select @tongtc = sum(mh.SOTC)
    from KETQUA kq, MONHOC mh
    where kq.MAMH = mh.MAMH and kq.MASV = @masv and kq.HOCKY = @hocky and kq.DIEMTHI >= 5
    return @tongtc
end
go
--Bước 7:
select dbo.tra_ve_tongtc('SV04', 1) as TinChiDat
go
--Bước 8:
drop function tra_ve_tongtc

--câu a
--Bước 1:
select * from MONHOC
go
--Bước 2:
select *
from MONHOC
where MAMH = 'MH01'
go
--Bước 3:
select SOTC
from MONHOC
where MAMH = 'MH01'
go
--Bước 4:
create function tra_ve_sotc(@mamh varchar(10))
returns int
as
begin
    declare @sotc int

    select @sotc = SOTC
    from MONHOC
    where MAMH = @mamh

    return @sotc
end
go
--Bước 5:
select dbo.tra_ve_sotc('MH01') as SoTinChi
go
--Bước 6:
drop function tra_ve_sotc
go


--câu b
--Bước 1:
select * from KETQUA
go
--Bước 2:
select *
from KETQUA
where MASV = 'SV01'
go
--Bước 3:
select DIEMTHI
from KETQUA
where MASV = 'SV01'
go
--Bước 4:
select avg(DIEMTHI)
from KETQUA
where MASV = 'SV01'
go
--Bước 5:
create function tra_ve_dtb(@masv varchar(10))
returns float
as
begin
    declare @dtb float

    select @dtb = avg(DIEMTHI)
    from KETQUA
    where MASV = @masv

    return @dtb
end
go
--Bước 6:
select dbo.tra_ve_dtb('SV01') as DiemTrungBinh
go
--Bước 7:
drop function tra_ve_dtb
go


--câu c
--Bước 1:
select * from KETQUA
go
--Bước 2:
select *
from KETQUA
where MAMH = 'MH01'
go
--Bước 3:
select *
from KETQUA
where MAMH = 'MH01' and HOCKY = 1
go
--Bước 4:
select count(MASV)
from KETQUA
where MAMH = 'MH01' and HOCKY = 1
go
--Bước 5:
create function tra_ve_tong_sv(@mamh varchar(10), @hocky int)
returns int
as
begin
    declare @tongsv int

    select @tongsv = count(MASV)
    from KETQUA
    where MAMH = @mamh and HOCKY = @hocky

    return @tongsv
end
go
--Bước 6:
select dbo.tra_ve_tong_sv('MH01', 1) as TongSoSV
go
--Bước 7:
drop function tra_ve_tong_sv
go


--câu d
--Bước 1:
select * from KETQUA
go
--Bước 2:
select *
from KETQUA
where MASV = 'SV01'
go
--Bước 3:
select *
from KETQUA
where MASV = 'SV01' and MAMH = 'MH01'
go
--Bước 4:
select DIEMTHI
from KETQUA
where MASV = 'SV01' and MAMH = 'MH01'
go
--Bước 5:
create function tra_ve_diemthi(@masv varchar(10), @mamh varchar(10))
returns float
as
begin
    declare @diemthi float

    select @diemthi = DIEMTHI
    from KETQUA
    where MASV = @masv and MAMH = @mamh

    return @diemthi
end
go
--Bước 6:
select dbo.tra_ve_diemthi('SV01', 'MH01') as DiemThi
go
--Bước 7:
drop function tra_ve_diemthi
go

--câu g
--Bước 1:
select * from SINHVIEN
select * from KETQUA
select * from LOP
go
--Bước 2:
select *
from SINHVIEN, KETQUA, LOP
go
--Bước 3:
select *
from SINHVIEN, KETQUA, LOP
where SINHVIEN.MASV = KETQUA.MASV
  and SINHVIEN.MALOP = LOP.MALOP
go
--Bước 4:
select *
from SINHVIEN, KETQUA, LOP
where SINHVIEN.MASV = KETQUA.MASV
  and SINHVIEN.MALOP = LOP.MALOP
  and KETQUA.MAMH = 'MH01'
  and KETQUA.HOCKY = 2
  and KETQUA.DIEMTHI < 5
go
--Bước 5:
select SINHVIEN.MASV, HOTEN, NGSINH, TENLOP
from SINHVIEN, KETQUA, LOP
where SINHVIEN.MASV = KETQUA.MASV
  and SINHVIEN.MALOP = LOP.MALOP
  and KETQUA.MAMH = 'MH01'
  and KETQUA.HOCKY = 2
  and KETQUA.DIEMTHI < 5
go
--Bước 6:
create function ds_sinhVienDiemDuoi5(@mamh varchar(10), @hocky int)
returns @ds table 
(
    MASV varchar(10),
    HOTEN nvarchar(30),
    NGSINH date,
    TENLOP nvarchar(50)
)
as
begin
    insert into @ds
    select SINHVIEN.MASV, HOTEN, NGSINH, TENLOP
    from SINHVIEN, KETQUA, LOP
    where SINHVIEN.MASV = KETQUA.MASV
      and SINHVIEN.MALOP = LOP.MALOP
      and KETQUA.MAMH = @mamh
      and KETQUA.HOCKY = @hocky
      and KETQUA.DIEMTHI < 5

    return
end
go
--Bước 7:
select * from ds_sinhVienDiemDuoi5('MH01', 2)
go
--Bước 8:
drop function ds_sinhVienDiemDuoi5
go

--câu i
--Bước 1:
select * from KETQUA
select * from MONHOC
go
--Bước 2:
select *
from KETQUA, MONHOC
go
--Bước 3:
select *
from KETQUA, MONHOC
where KETQUA.MAMH = MONHOC.MAMH
go
--Bước 4:
select *
from KETQUA, MONHOC
where KETQUA.MAMH = MONHOC.MAMH
  and MASV = 'SV01'
go
--Bước 5:
select KETQUA.MAMH, TENMH, max(DIEMTHI) as DIEMCAONHAT
from KETQUA, MONHOC
where KETQUA.MAMH = MONHOC.MAMH
  and MASV = 'SV01'
group by KETQUA.MAMH, TENMH
go
--Bước 6:
create function ds_monHocDiemCaoNhat(@masv varchar(10))
returns @ds table 
(
    MAMH varchar(10),
    TENMH nvarchar(100),
    DIEMCAONHAT float
)
as
begin
    insert into @ds
    select KETQUA.MAMH, TENMH, max(DIEMTHI) as DIEMCAONHAT
    from KETQUA, MONHOC
    where KETQUA.MAMH = MONHOC.MAMH
      and MASV = @masv
    group by KETQUA.MAMH, TENMH

    return
end
go
--Bước 7:
select * from ds_monHocDiemCaoNhat('SV01')
go
--Bước 8:
drop function ds_monHocDiemCaoNhat
go

--trigger

--câu a: Khi thêm, sửa, xóa sinh viên thì tự động cập nhật sĩ số lớp
--Bước 1:
select * from LOP
select * from SINHVIEN
go

--Bước 2:
select count(MASV)
from SINHVIEN
where MALOP = 'L01'
go
--Bước 3:
insert into SINHVIEN (MASV, HOTEN, NGSINH, GIOITINH, QUEQUAN, MALOP)
values ('SV13', N'Nguyen Van Test', '2004-11-11', N'Nam', N'HCM', 'L01')
go
--Bước 4:
update LOP
set SISO = (
            select count(MASV)
            from SINHVIEN
            where SINHVIEN.MALOP = LOP.MALOP
           )
where MALOP = 'L01'
go
--Bước 5:
create trigger tri_siso on SINHVIEN
for insert, update, delete
as
begin
    update LOP
    set SISO = (
                select count(MASV)
                from SINHVIEN
                where SINHVIEN.MALOP = LOP.MALOP
               )
    where MALOP in (select MALOP from inserted)
       or MALOP in (select MALOP from deleted)
end
go

--Bước 6:
insert into SINHVIEN (MASV, HOTEN, NGSINH, GIOITINH, QUEQUAN, MALOP)
values ('SV14', N'Nguyen Thi Test', '2004-11-11', N'Nữ', N'HCM', 'L01')
go
--Bước 7:
select * from LOP
go
--Bước 8:
delete from SINHVIEN
where MASV = 'SV14'
go
--Bước 9:
select * from LOP
go
--Bước 10:
drop trigger tri_siso
go


--câu b: Mỗi sinh viên chỉ được đăng ký tối đa 5 môn trong mỗi học kỳ
--Bước 1:
select * from KETQUA
go
--Bước 2:
select *
from KETQUA
where MASV = 'SV01' and HOCKY = 1
go
--Bước 3: Đếm số môn của SV01 trong học kỳ 1
select MASV, HOCKY, count(MAMH) as SoMon
from KETQUA
where MASV = 'SV01' and HOCKY = 1
group by MASV, HOCKY
go
--Bước 4: Kiểm tra nếu số môn lớn hơn 5
                select MASV, HOCKY, count(MAMH) as SoMon
                from KETQUA
                where MASV = 'SV01' and HOCKY = 1
                group by MASV, HOCKY
                having count(MAMH) > 5
                go
--Bước 5:
create trigger tri_dangkymon on KETQUA
for insert, update
as 
begin   
    if exists (
                select 1
                from inserted i, KETQUA kq
                where i.MASV = kq.MASV 
                  and i.HOCKY = kq.HOCKY
                group by kq.MASV, kq.HOCKY
                having count(kq.MAMH) > 5
              )
    begin
        print N'Mỗi sinh viên chỉ được đăng ký tối đa 5 môn trong mỗi học kỳ'
        rollback tran
    end
end
go

--Bước 6: Thêm môn học mới để test
insert into MONHOC values ('MH06', N'Lap trinh web', 3, 0)
go

--Bước 7: Cho SV01 đăng ký thêm môn học
insert into KETQUA values ('SV01', 'MH04', 1, 7.0)
go

--Bước 8: Kiểm tra lại số môn của SV01 trong học kỳ 1
select *
from KETQUA
where MASV = 'SV01' and HOCKY = 1
go

--Bước 9: Thử đăng ký thêm môn nữa, nếu vượt quá 5 môn thì trigger sẽ chặn
insert into KETQUA values ('SV01', 'MH05', 1, 8.0)
go

--Bước 10: Kiểm tra lại xem môn vừa thêm có bị chặn không
select *
from KETQUA
where MASV = 'SV01' and HOCKY = 1
go
--Bước 11: Ví dụ thêm quá 5 môn
insert into KETQUA 
values ('SV01', 'MH03', 1, 7.5),
       ('SV01', 'MH06', 1, 8.0)
go
--Bước 11:
drop trigger tri_dangkymon
go



--câu c: Mỗi sinh viên chỉ được đăng ký tối đa 10 tín chỉ môn bắt buộc trong mỗi học kỳ

--Bước 1:
select * from KETQUA
select * from MONHOC
go

--Bước 2:
select *
from KETQUA, MONHOC
go

--Bước 3:
select *
from KETQUA, MONHOC
where KETQUA.MAMH = MONHOC.MAMH
go

--Bước 4: Tính tổng tín chỉ bắt buộc của SV03 trong học kỳ 1
select KETQUA.MASV, KETQUA.HOCKY, sum(MONHOC.SOTC) as TongTinChiBatBuoc
from KETQUA, MONHOC
where KETQUA.MAMH = MONHOC.MAMH
  and MONHOC.BATBUOC = 1
  and KETQUA.MASV = 'SV03'
  and KETQUA.HOCKY = 1
group by KETQUA.MASV, KETQUA.HOCKY
go

--Bước 5: Kiểm tra nếu tổng tín chỉ bắt buộc lớn hơn 10
select KETQUA.MASV, KETQUA.HOCKY, sum(MONHOC.SOTC) as TongTinChiBatBuoc
from KETQUA, MONHOC
where KETQUA.MAMH = MONHOC.MAMH
  and MONHOC.BATBUOC = 1
  and KETQUA.MASV = 'SV03'
  and KETQUA.HOCKY = 1
group by KETQUA.MASV, KETQUA.HOCKY
having sum(MONHOC.SOTC) > 10
go

--Bước 6:
create trigger tri_dangkytc on KETQUA
for insert, update
as
begin
    if exists (
                select 1
                from inserted i, KETQUA kq, MONHOC mh
                where i.MASV = kq.MASV 
                  and i.HOCKY = kq.HOCKY 
                  and kq.MAMH = mh.MAMH 
                  and mh.BATBUOC = 1
                group by kq.MASV, kq.HOCKY
                having sum(mh.SOTC) > 10
              )
    begin
        print N'Mỗi sinh viên chỉ được đăng ký tối đa 10 tín chỉ của môn học bắt buộc trong mỗi học kỳ'
        rollback tran
    end
end
go

--Bước 7: Thêm môn học bắt buộc mới để test
insert into MONHOC 
values ('MH07', N'He quan tri co so du lieu', 3, 1),
       ('MH08', N'The chat', 3, 1)
go

--Bước 8: Cho SV03 đăng ký thêm môn bắt buộc
insert into KETQUA values ('SV03', 'MH03', 1, 8.0)
go

--Bước 10: Thử thêm môn bắt buộc làm vượt quá 10 tín chỉ, trigger sẽ chặn
insert into KETQUA 
values ('SV03', 'MH07', 1, 9.0),
       ('SV03', 'MH08', 1, 9.0)
go

--Bước 11:
drop trigger tri_dangkytc
go

--câu d: Khi thêm hoặc sửa điểm thi thì tự động cập nhật điểm trung bình và xếp loại

--Bước 1:
select * from KETQUA
select * from MONHOC
go
--Bước 2:
select *
from KETQUA , MONHOC 
go
--Bước 3:
select *
from KETQUA , MONHOC 
where KETQUA.MAMH = MONHOC.MAMH
go
--Bước 4:
select *
from KETQUA , MONHOC 
where KETQUA.MAMH = MONHOC.MAMH and KETQUA.MASV = 'SV02'
go
--Bước 3: Tính điểm trung bình của SV02 theo công thức có tín chỉ
select sum(MONHOC.SOTC * KETQUA.DIEMTHI) / sum(MONHOC.SOTC) as DiemTrungBinh
from KETQUA , MONHOC
where KETQUA.MAMH = MONHOC.MAMH
  and KETQUA.MASV = 'SV02'
go

--Bước 4: Cập nhật điểm trung bình bằng tay theo công thức có tín chỉ
update SINHVIEN
set DIEMTB = (
                select sum(MONHOC.SOTC * KETQUA.DIEMTHI) / sum(MONHOC.SOTC)
                from KETQUA, MONHOC
                where KETQUA.MAMH = MONHOC.MAMH
                  and KETQUA.MASV = SINHVIEN.MASV
             )
where MASV = 'SV02'
go

--Bước 5: Cập nhật xếp loại bằng tay
update SINHVIEN
set XEPLOAI = case
                when DIEMTB >= 8 then N'Giỏi'
                when DIEMTB >= 6.5 then N'Khá'
                when DIEMTB >= 5 then N'Trung bình'
                when DIEMTB is null then null
                else N'Yếu'
              end
where MASV = 'SV02'
go

--Bước 6: Kiểm tra DIEMTB và XEPLOAI đã cập nhật chưa
select MASV, HOTEN, DIEMTB, XEPLOAI
from SINHVIEN
where MASV = 'SV02'
go

--Bước 7:
create trigger tri_capnhat_dtb_xeploai on KETQUA
for insert, update
as
begin 
    update SINHVIEN
    set DIEMTB = (
                    select sum(MONHOC.SOTC * KETQUA.DIEMTHI) / sum(MONHOC.SOTC)
                    from KETQUA, MONHOC
                    where KETQUA.MAMH = MONHOC.MAMH
                      and KETQUA.MASV = SINHVIEN.MASV
                 )
    where MASV in (select MASV from inserted)

    update SINHVIEN
    set XEPLOAI = case
                    when DIEMTB >= 8 then N'Giỏi'
                    when DIEMTB >= 6.5 then N'Khá'
                    when DIEMTB >= 5 then N'Trung bình'
                    when DIEMTB is null then null
                    else N'Yếu'
                  end
    where MASV in (select MASV from inserted)
end
go

--Bước 8: Sửa điểm thi của SV02 để trigger tự cập nhật điểm trung bình và xếp loại
update KETQUA
set DIEMTHI = 9
where MASV = 'SV02' and MAMH = 'MH01' and HOCKY = 1
go

--Bước 9: Kiểm tra điểm thi đã sửa chưa
select *
from KETQUA
where MASV = 'SV02'
go

--Bước 10: Kiểm tra DIEMTB và XEPLOAI đã tự cập nhật chưa
select MASV, HOTEN, DIEMTB, XEPLOAI
from SINHVIEN
where MASV = 'SV02'
go
--Bước 11:
drop trigger tri_capnhat_dtb_xeploai
go