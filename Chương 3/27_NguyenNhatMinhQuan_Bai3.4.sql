CREATE DATABASE QLTV;
GO
USE QLTV;
GO

CREATE TABLE SACH (
    MASH VARCHAR(10) PRIMARY KEY,
    TENSH NVARCHAR(50) NOT NULL,
    TACGIA NVARCHAR(50),
    LOAI NVARCHAR(50),
    TINHTRANG NVARCHAR(50) DEFAULT N'Chưa mượn'
);

CREATE TABLE DOCGIA (
    MADG VARCHAR(10) PRIMARY KEY,
    TENDG NVARCHAR(50) NOT NULL,
    NGAYSINH DATE,
    PHAI NVARCHAR(10), 
    DIACHI NVARCHAR(50)
);

CREATE TABLE MUONSACH (
    MADG VARCHAR(10),
    MASH VARCHAR(10),
    NGAYMUON DATE NOT NULL,
    NGAYTRA DATE NULL, 
    PRIMARY KEY (MADG, MASH, NGAYMUON),
    FOREIGN KEY (MADG) REFERENCES DOCGIA(MADG),
    FOREIGN KEY (MASH) REFERENCES SACH(MASH)
);
GO

INSERT INTO SACH (MASH, TENSH, TACGIA, LOAI, TINHTRANG) VALUES 
('S001', N'Lập trình C# cơ bản', N'Phạm Hữu Đăng', N'Khoa học tự nhiên', N'Đã mượn'),
('S002', N'Vũ trụ trong vỏ hạt dẻ', N'Stephen Hawking', N'Khoa học tự nhiên', N'Đã mượn'),
('S003', N'Tâm lý học đám đông', N'Gustave Le Bon', N'Xã hội', N'Chưa mượn'),
('S004', N'Dế mèn phiêu lưu ký', N'Tô Hoài', N'Truyện', N'Chưa mượn'),
('S005', N'Lịch sử văn minh nhân loại', N'Will Durant', N'Xã hội', N'Đã mượn'),
('S006', N'Sherlock Holmes', N'Arthur Conan Doyle', N'Truyện', N'Chưa mượn'),
('S007', N'Quản trị học cơ bản', N'Trần Thanh Nam', N'Kinh tế', N'Đã mượn'),
('S008', N'Đắc Nhân Tâm', N'Dale Carnegie', N'Xã hội', N'Chưa mượn'),
('S009', N'Harry Potter và Hòn đá Phù thủy', N'J.K. Rowling', N'Truyện', N'Đã mượn'),
('S010', N'Kinh tế học vĩ mô', N'Gregory Mankiw', N'Kinh tế', N'Đã mượn');
GO

INSERT INTO DOCGIA VALUES 
('DG001', N'Lê Minh Anh', '1995-05-12', N'Nam', N'Quận 1, TP.HCM'),
('DG002', N'Nguyễn Thị Bình', '2000-11-20', N'Nữ', N'Quận 7, TP.HCM'),
('DG003', N'Trần Hoàng Long', '1988-02-15', N'Nam', N'Bình Thạnh, TP.HCM'),
('DG004', N'Phạm Thu Thảo', '2005-08-30', N'Nữ', N'Cầu Giấy, Hà Nội'),
('DG005', N'Đỗ Hữu Phước', '1992-04-10', N'Nam', N'Quận 3, TP.HCM'),
('DG006', N'Vũ Phương Linh', '2008-01-05', N'Nữ', N'Hà Đông, Hà Nội'),
('DG007', N'Nguyễn Nam Thành', '1999-12-12', N'Nam', N'Thủ Đức, TP.HCM'),
('DG008', N'Hoàng Ngọc Diệp', '2003-06-25', N'Nữ', N'Quận 10, TP.HCM');
GO

INSERT INTO MUONSACH VALUES 
('DG001', 'S001', '2023-12-01', '2023-12-15'),
('DG001', 'S002', '2022-03-12', NULL), 
('DG002', 'S003', '2023-11-20', '2023-11-30'),
('DG003', 'S005', '2024-02-05', '2024-02-20'),
('DG004', 'S009', '2024-03-01', NULL), 
('DG005', 'S004', '2023-10-15', '2023-10-25'),
('DG006', 'S006', '2024-01-05', '2024-01-20'),
('DG007', 'S010', '2022-03-12', NULL), 
('DG008', 'S008', '2023-12-20', '2024-01-05'),
('DG002', 'S001', '2024-02-20', NULL), 
('DG003', 'S007', '2024-03-10', NULL),
('DG001', 'S005', '2022-03-12', NULL), 
('DG005', 'S003', '2024-01-20', '2024-01-30'),
('DG004', 'S002', '2024-02-28', NULL),
('DG008', 'S004', '2024-03-05', '2024-03-12');
GO

--trigger
--câu a
--Bước 1: 
select * from DOCGIA
go
--Bước 2:
select *
from DOCGIA
where DATEDIFF(yy, NGAYSINH, GETDATE()) >= 15
go
--Bước 3:
create trigger kt_tuoi_doc_gia on DOCGIA
for insert, update
as
begin
    if exists (
                select *
                from inserted
                where DATEDIFF(yy, NGAYSINH, getdate()) >= 15)
                commit tran
    else
    begin
        print N'Tuổi của độc giả phải >= 15'
        rollback
    end
end
--Bước 4:
insert into DOCGIA
values ('DG009', 'Nguyen Van Test', '2022-05-10', N'Nam', 'Tp.HCM', 2)
--Bước 5:
drop trigger kt_tuoi_doc_gia
--câu b
--Bước 1:
select * from DOCGIA
--Bước 2:
insert into DOCGIA
values ('DG010', 'Nguyen Van Test', '2008-05-10', N'Ko', 'Tp.HCM', 2)
--Bước 3:
select *
from DOCGIA dg
where dg.PHAI not in (N'Nam', N'Nữ')
go
--Bước 4:
create trigger kt_phai_doc_gia on DOCGIA
for insert, update
as
begin
    if exists (
                select *
                from inserted
                where PHAI not in (N'Nam', N'Nữ'))
    begin
        print N'Phái của độc giả phải là nam hoặc nữ'
        rollback tran
    end
end
--Bước 5:
insert into DOCGIA
values ('DG011', 'Nguyen Van Test', '2008-05-10', N'Ko', 'Tp.HCM', 2)
--Bước 6:
drop trigger kt_phai_doc_gia
--câu c: Loại sách phải thuộc một trong các loại quy định

--Bước 1:
select * from SACH
go

--Bước 2:
select *
from SACH s
where s.LOAI in (N'Khoa học tự nhiên', N'Xã hội', N'Kinh tế', N'Truyện')
go

--Bước 3:
select *
from SACH s
where s.LOAI not in (N'Khoa học tự nhiên', N'Xã hội', N'Kinh tế', N'Truyện')
go

--Bước 4:
create trigger kt_loai_sach on SACH
for insert, update
as
begin
    if exists (
                select 1
                from inserted i
                where i.LOAI not in (N'Khoa học tự nhiên', N'Xã hội', N'Kinh tế', N'Truyện')
              )
    begin
        print N'Loại sách phải thuộc một trong các loại: Khoa học tự nhiên, Xã hội, Kinh tế, Truyện'
        rollback tran
    end
end
go

--Bước 5: Thêm sách có loại sai để trigger chặn
insert into SACH
values ('S011', N'Sách test sai loại', N'Nguyen Van A', N'Thiếu nhi', N'Chưa mượn')
go

--Bước 6: Kiểm tra sách S011 có bị chặn không
select *
from SACH s
where s.MASH = 'S011'
go

--Bước 7: Thêm sách có loại đúng để trigger cho thêm
insert into SACH
values ('S012', N'Sách test đúng loại', N'Nguyen Van B', N'Truyện', N'Chưa mượn')
go

--Bước 8: Kiểm tra sách S012 đã được thêm chưa
select *
from SACH s
where s.MASH = 'S012'
go

--Bước 9:
drop trigger kt_loai_sach
go


--câu d: Mỗi độc giả chỉ được mượn tối đa 3 cuốn sách chưa trả và khi mượn thì cập nhật tình trạng sách

--Bước 1:
select * from MUONSACH
select * from SACH
go

--Bước 2: Đếm số sách chưa trả của DG001
select ms.MADG, count(ms.MASH) as SoSachChuaTra
from MUONSACH ms
where ms.MADG = 'DG001' and ms.NGAYTRA is null
group by ms.MADG
go

--Bước 3: Thêm sách mới để test
insert into SACH
values ('S013', N'Sách test mượn 1', N'Tac gia test', N'Truyện', N'Chưa mượn'),
       ('S014', N'Sách test mượn 2', N'Tac gia test', N'Truyện', N'Chưa mượn')
go

--Bước 4:
create trigger kt_doc_gia_muon on MUONSACH
for insert
as
begin
    if exists (
                select 1
                from inserted i, MUONSACH ms
                where i.MADG = ms.MADG
                  and ms.NGAYTRA is null
                group by i.MADG
                having count(ms.MASH) > 3
              )
    begin
        print N'Độc giả này đã mượn 3 cuốn chưa trả. Không được mượn thêm cuốn thứ 4'
        rollback tran
    end
    else
    begin
        update s
        set s.TINHTRANG = N'Đã mượn'
        from SACH s, inserted i
        where s.MASH = i.MASH
    end
end
go

--Bước 5: Cho DG001 mượn thêm 1 cuốn để đủ 3 cuốn chưa trả
insert into MUONSACH
values ('DG001', 'S013', '2024-04-01', null)
go

--Bước 6: Kiểm tra sách S013 đã chuyển sang Đã mượn chưa
select s.MASH, s.TENSH, s.TINHTRANG
from SACH s
where s.MASH = 'S013'
go

--Bước 7: Thử cho DG001 mượn thêm cuốn thứ 4, trigger sẽ chặn
insert into MUONSACH
values ('DG001', 'S014', '2024-04-02', null)
go

--Bước 8: Kiểm tra lại sách S014 có bị chặn không
select ms.MADG, ms.MASH, ms.NGAYMUON, ms.NGAYTRA
from MUONSACH ms
where ms.MADG = 'DG001' and ms.MASH = 'S014'
go

--Bước 9:
drop trigger kt_doc_gia_muon
go


--câu e: Khi độc giả trả sách thì cập nhật tình trạng sách thành Chưa mượn

--Bước 1:
select * from MUONSACH
select * from SACH
go

--Bước 2:
select ms.MADG, ms.MASH, ms.NGAYMUON, ms.NGAYTRA
from MUONSACH ms
where ms.MADG = 'DG004' and ms.MASH = 'S009'
go

--Bước 3:
select s.MASH, s.TENSH, s.TINHTRANG
from SACH s
where s.MASH = 'S009'
go

--Bước 4:
create trigger kt_doc_gia_tra_sach on MUONSACH
for update
as
begin
    if update(NGAYTRA)
    begin
        update s
        set s.TINHTRANG = N'Chưa mượn'
        from SACH s, inserted i
        where s.MASH = i.MASH
          and i.NGAYTRA is not null
    end
end
go

--Bước 5: Cập nhật ngày trả sách để trigger tự đổi tình trạng sách
update MUONSACH
set NGAYTRA = '2024-04-05'
where MADG = 'DG004' and MASH = 'S009' and NGAYMUON = '2024-03-01'
go

--Bước 6: Kiểm tra sách S009 đã chuyển sang Chưa mượn chưa
select s.MASH, s.TENSH, s.TINHTRANG
from SACH s
where s.MASH = 'S009'
go

--Bước 7:
drop trigger kt_doc_gia_tra_sach
go



--thủ tục

--câu a: Trả về tên và địa chỉ của độc giả khi biết mã độc giả

--Bước 1:
select * from DOCGIA
go

--Bước 2:
select dg.TENDG, dg.DIACHI
from DOCGIA dg
where dg.MADG = 'DG001'
go

--Bước 3:
create proc sp_tra_ve_ten_dia_chi
    @madg varchar(10),
    @hoten nvarchar(50) output,
    @diachi nvarchar(50) output
as
begin
    select @hoten = dg.TENDG,
           @diachi = dg.DIACHI
    from DOCGIA dg
    where dg.MADG = @madg
end
go

--Bước 4:
declare @hoten nvarchar(50), @diachi nvarchar(50)
exec sp_tra_ve_ten_dia_chi 'DG001', @hoten output, @diachi output
select @hoten as HoTen, @diachi as DiaChi
go

--Bước 5:
drop proc sp_tra_ve_ten_dia_chi
go


--câu b: Trả về tên sách và tác giả khi biết mã sách

--Bước 1:
select * from SACH
go

--Bước 2:
select s.TENSH, s.TACGIA
from SACH s
where s.MASH = 'S001'
go

--Bước 3:
create proc sp_tra_ve_ten_sach_tg
    @masach varchar(10),
    @tensach nvarchar(50) output,
    @tacgia nvarchar(50) output
as
begin
    select @tensach = s.TENSH,
           @tacgia = s.TACGIA
    from SACH s
    where s.MASH = @masach
end
go

--Bước 4:
declare @tensach nvarchar(50), @tacgia nvarchar(50)
exec sp_tra_ve_ten_sach_tg 'S001', @tensach output, @tacgia output
select @tensach as TenSach, @tacgia as TacGia
go

--Bước 5:
drop proc sp_tra_ve_ten_sach_tg
go


--câu c: Trả về số lượng sách độc giả đang mượn chưa trả

--Bước 1:
select * from MUONSACH
go

--Bước 2:
select *
from MUONSACH ms
where ms.MADG = 'DG001' and ms.NGAYTRA is null
go

--Bước 3:
select count(ms.MASH) as SoLuong
from MUONSACH ms
where ms.MADG = 'DG001' and ms.NGAYTRA is null
go

--Bước 4:
create proc sp_tra_ve_so_luong_sach_dg_muon
    @madg varchar(10),
    @soluong int output
as
begin
    select @soluong = count(ms.MASH)
    from MUONSACH ms
    where ms.MADG = @madg and ms.NGAYTRA is null
end
go

--Bước 5:
declare @soluong int
exec sp_tra_ve_so_luong_sach_dg_muon 'DG001', @soluong output
select @soluong as SoLuongSachDangMuon
go

--Bước 6:
drop proc sp_tra_ve_so_luong_sach_dg_muon
go


--câu d: Trả về tên độc giả đang mượn sách và tình trạng sách khi biết mã sách

--Bước 1:
select * from MUONSACH
select * from DOCGIA
select * from SACH
go

--Bước 2:
select dg.TENDG, s.TINHTRANG
from MUONSACH ms, DOCGIA dg, SACH s
where ms.MADG = dg.MADG
  and ms.MASH = s.MASH
  and ms.MASH = 'S002'
  and ms.NGAYTRA is null
go

--Bước 3:
create proc sp_tra_ve_ten_dg_dang_muon
    @masach varchar(10),
    @tendg nvarchar(50) output,
    @tinhtrang nvarchar(50) output
as
begin
    set @tendg = N'Không có ai mượn'
    set @tinhtrang = N'Chưa mượn'

    select @tendg = dg.TENDG,
           @tinhtrang = N'Đã mượn'
    from MUONSACH ms, DOCGIA dg
    where ms.MADG = dg.MADG
      and ms.MASH = @masach
      and ms.NGAYTRA is null
end
go

--Bước 4:
declare @tendg nvarchar(50), @tinhtrang nvarchar(50)
exec sp_tra_ve_ten_dg_dang_muon 'S002', @tendg output, @tinhtrang output
select @tendg as TenDocGia, @tinhtrang as TinhTrang
go

--Bước 5:
drop proc sp_tra_ve_ten_dg_dang_muon
go


--câu e: Trả về số sách mà độc giả mượn trong một ngày

--Bước 1:
select * from MUONSACH
go

--Bước 2:
select *
from MUONSACH ms
where ms.MADG = 'DG001' and ms.NGAYMUON = '2022-03-12'
go

--Bước 3:
select count(ms.MASH) as SoLuong
from MUONSACH ms
where ms.MADG = 'DG001' and ms.NGAYMUON = '2022-03-12'
go

--Bước 4:
create proc sp_tra_ve_so_sach
    @madg varchar(10),
    @ngay date,
    @soluong int output
as
begin   
    select @soluong = count(ms.MASH)
    from MUONSACH ms
    where ms.MADG = @madg and ms.NGAYMUON = @ngay 
end
go

--Bước 5:
declare @soluong int
exec sp_tra_ve_so_sach 'DG001', '2022-03-12', @soluong output
select @soluong as SoSachMuonTrongNgay
go

--Bước 6:
drop proc sp_tra_ve_so_sach
go


--câu f: Trả về ngày mượn gần nhất của một quyển sách

--Bước 1:
select * from MUONSACH
go

--Bước 2:
select *
from MUONSACH ms
where ms.MASH = 'S002'
go

--Bước 3:
select max(ms.NGAYMUON) as NgayMuonGanNhat
from MUONSACH ms
where ms.MASH = 'S002'
go

--Bước 4:
create proc sp_tra_ve_ngay_muon
    @mash varchar(10),
    @ngay date output
as
begin
    select @ngay = max(ms.NGAYMUON)
    from MUONSACH ms
    where ms.MASH = @mash
end
go

--Bước 5:
declare @ngay date
exec sp_tra_ve_ngay_muon 'S002', @ngay output
select @ngay as NgayMuonGanNhat
go

--Bước 6:
drop proc sp_tra_ve_ngay_muon
go



--function 

--câu a: Trả về tên độc giả và địa chỉ khi biết mã độc giả

--Bước 1:
select * from DOCGIA
go

--Bước 2:
select dg.TENDG, dg.DIACHI
from DOCGIA dg
where dg.MADG = 'DG001'
go

--Bước 3:
select N'Độc giả ' + dg.TENDG + N' có địa chỉ ' + dg.DIACHI as KetQua
from DOCGIA dg
where dg.MADG = 'DG001'
go

--Bước 4:
create function tra_ve_tendg_diachi(@madg varchar(10))
returns nvarchar(150)
as
begin
    declare @ketqua nvarchar(150)

    select @ketqua = N'Độc giả ' + dg.TENDG + N' có địa chỉ ' + dg.DIACHI
    from DOCGIA dg
    where dg.MADG = @madg

    return @ketqua
end
go

--Bước 5:
select dbo.tra_ve_tendg_diachi('DG001') as KetQua
go

--Bước 6:
drop function tra_ve_tendg_diachi
go


--câu b: Trả về danh sách sách độc giả đang mượn chưa trả

--Bước 1:
select * from MUONSACH
select * from SACH
go

--Bước 2:
select *
from MUONSACH ms, SACH s
where ms.MASH = s.MASH
go

--Bước 3:
select ms.MASH, s.TENSH
from MUONSACH ms, SACH s
where ms.MASH = s.MASH
  and ms.MADG = 'DG001'
  and ms.NGAYTRA is null
go

--Bước 4:
create function tra_ve_dssach(@madg varchar(10))
returns @ds table 
(
    MASH varchar(10),
    TENSH nvarchar(50)
)
as
begin
    insert into @ds
    select ms.MASH, s.TENSH
    from MUONSACH ms, SACH s
    where ms.MASH = s.MASH
      and ms.MADG = @madg
      and ms.NGAYTRA is null

    return
end
go

--Bước 5:
select *
from dbo.tra_ve_dssach('DG001')
go

--Bước 6:
drop function tra_ve_dssach
go


--câu c: Trả về danh sách độc giả đã từng mượn một quyển sách

--Bước 1:
select * from MUONSACH
select * from DOCGIA
go

--Bước 2:
select *
from MUONSACH ms, DOCGIA dg
where ms.MADG = dg.MADG
go

--Bước 3:
select dg.MADG, dg.TENDG
from MUONSACH ms, DOCGIA dg
where ms.MADG = dg.MADG
  and ms.MASH = 'S001'
go

--Bước 4:
create function tra_ve_dsdg(@mash varchar(10))
returns @ds table 
(
    MADG varchar(10),
    TENDG nvarchar(50)
)
as
begin
    insert into @ds
    select dg.MADG, dg.TENDG
    from MUONSACH ms, DOCGIA dg
    where ms.MADG = dg.MADG
      and ms.MASH = @mash

    return
end
go

--Bước 5:
select *
from dbo.tra_ve_dsdg('S001')
go

--Bước 6:
drop function tra_ve_dsdg
go


--câu d: Trả về tổng số sách độc giả mượn trong một tháng

--Bước 1:
select * from MUONSACH
go

--Bước 2:
select *
from MUONSACH ms
where ms.MADG = 'DG001'
go

--Bước 3:
select count(ms.MASH) as TongSach
from MUONSACH ms
where ms.MADG = 'DG001'
  and month(ms.NGAYMUON) = month('2022-03-01')
  and year(ms.NGAYMUON) = year('2022-03-01')
go

--Bước 4:
create function tra_ve_tong_sach(@madg varchar(10), @thang date)
returns int
as
begin
    declare @tongsach int

    select @tongsach = count(ms.MASH)
    from MUONSACH ms
    where ms.MADG = @madg
      and month(ms.NGAYMUON) = month(@thang)
      and year(ms.NGAYMUON) = year(@thang)

    return @tongsach
end
go

--Bước 5:
select dbo.tra_ve_tong_sach('DG001', '2022-03-01') as TongSach
go

--Bước 6:
drop function tra_ve_tong_sach
go