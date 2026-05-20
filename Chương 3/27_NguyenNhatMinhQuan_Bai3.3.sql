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
                select round(sum(mh.sotc * kq.diemthi) / sum(mh.sotc), 2)
                from KETQUA kq, MONHOC mh
                where kq.mamh = mh.mamh and kq.masv = SINHVIEN.masv
             )
go

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
select count(*)
from SINHVIEN
where MALOP = 'L04'
go
--Bước 3:
update LOP
set SISO =  (   
                select count(*)
                from SINHVIEN
                where MALOP = 'L04'
            )
where MALOP = 'L04'
go
--Bước 4:
select MALOP, SISO
from LOP
go
--Bước 5:
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
--Bước 6:
exec sp_capnhat_siso 'L04'
go
--Bước 7:
select * from LOP
go
--Bước 8:
drop proc sp_capnhat_siso
go

--câu d
--Bước 1:
select * from KETQUA
go
--Bước 2:
update KETQUA
set DIEMTHI = DIEMTHI + 1
where MASV = 'SV07' and MAMH = 'MH01' and HOCKY = 1
go
--Bước 3:
select MASV, MAMH, HOCKY, DIEMTHI
from KETQUA
go
--Bước 4:
create proc sp_cong_diem @masv varchar(10), @mamh varchar(10), @hocky int
as
begin
    update KETQUA
    set DIEMTHI = DIEMTHI + 1
    where MASV = @masv and MAMH = @mamh and HOCKY = @hocky
end
go
--Bước 5:
exec sp_cong_diem 'SV03', 'MH03', 1
go
--Bước 6:
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
create proc sp_tra_ve_dtb_xeploai @masv varchar(10), @dtb float output, @xeploai nvarchar(20) output
as
begin
    select 
        @dtb = DIEMTB,
        @xeploai = XEPLOAI
    from SINHVIEN
    where MASV = @masv
end
go
--Bước 5:
declare @dtb_output float, @xeploai_output nvarchar(20)
exec sp_tra_ve_dtb_xeploai 'SV04', @dtb_output output, @xeploai_output output
print cast(@dtb_output as varchar(20)) + ' ' + @xeploai_output 
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
where MASV = 'SV03' and MAMH = 'MH03' and HOCKY = 1
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
                where MASV = 'SV03' and MAMH = 'MH03' and HOCKY = 1 and DIEMTHI >= 5
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
exec sp_cau_i 'SV03', 'MH03', 1
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
create proc sp_cau_j @masv varchar(10), @hocky int
as
begin
    declare @dtb float
    select @dtb = sum(SOTC * DIEMTHI) / sum(SOTC)
    from MONHOC mh, KETQUA kq
    where mh.MAMH = kq.MAMH and MASV = @masv and HOCKY = @hocky

    if @dtb >= 8
        print N'Khen thưởng'
    else
        print N'Không khen thưởng'
end
go
--Bước 6:
exec sp_cau_j 'SV02', 1
go
--Bước 7
drop proc sp_cau_j
go