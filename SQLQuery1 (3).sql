
USE Quanlytrongtrot;
GO

-- Huyện
CREATE TABLE Huyen (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    TenHuyen NVARCHAR(255)
);

-- Xã
CREATE TABLE Xa (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    TenXa NVARCHAR(255),
    ID_Huyen INT,
    FOREIGN KEY (ID_Huyen) REFERENCES Huyen(ID)
);

-- Giống cây trồng
CREATE TABLE GiongCayTrong (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    TenGiong NVARCHAR(255),
    ThongTin NVARCHAR(1000)
);

-- bảng Giống cây - Khu vực lưu hành
CREATE TABLE GiongCay_LuuHanh (
    ID_GiongCay INT,
    ID_Xa INT,
    PRIMARY KEY (ID_GiongCay, ID_Xa),
    FOREIGN KEY (ID_GiongCay) REFERENCES GiongCayTrong(ID),
    FOREIGN KEY (ID_Xa) REFERENCES Xa(ID)
);

-- bảng Sản xuất trồng trọt
CREATE TABLE SXTT (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    CSAnToanVietGap BIT,
    VungTrong GEOGRAPHY,
    SinhVatGayHai NVARCHAR(255),
    ID_Xa INT,
    FOREIGN KEY (ID_Xa) REFERENCES Xa(ID)
);

--  Cơ sở sản xuất
CREATE TABLE CoSoSanXuat (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    TenCS NVARCHAR(255),
    ViTri GEOGRAPHY,
    ID_Xa INT,
    FOREIGN KEY (ID_Xa) REFERENCES Xa(ID)
);

-- Cơ sở buôn bán
CREATE TABLE CoSoBuonBan (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    TenCS NVARCHAR(255),
    ViTri GEOGRAPHY,
    ID_Xa INT,
    FOREIGN KEY (ID_Xa) REFERENCES Xa(ID)
);


-- bảng Thuốc bảo vệ thực vật
CREATE TABLE ThuocBVTV (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    TenThuoc NVARCHAR(255),
    ThongTin NVARCHAR(1000),
    ID_CSSX INT, -- Cơ sở sản xuất
    ID_CSBB INT, -- Cơ sở buôn bán
    FOREIGN KEY (ID_CSSX) REFERENCES CoSoSanXuat(ID),
    FOREIGN KEY (ID_CSBB) REFERENCES CoSoBuonBan(ID)
);

-- Tạo bảng Phân bón
CREATE TABLE PhanBon (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    TenPhanBon NVARCHAR(255),
    ThongTin NVARCHAR(1000),
    ID_CSSX INT, -- Cơ sở sản xuất
    ID_CSBB INT, -- Cơ sở buôn bán
    FOREIGN KEY (ID_CSSX) REFERENCES CoSoSanXuat(ID),
    FOREIGN KEY (ID_CSBB) REFERENCES CoSoBuonBan(ID)
);

-- dữ liệu Huyện
INSERT INTO Huyen (TenHuyen) VALUES 
(N'Gia Lâm'), (N'Đông Anh'), (N'Sóc Sơn');

-- dữ liệu Xã
INSERT INTO Xa (TenXa, ID_Huyen) VALUES 
(N'Dương Xá', 1), (N'Vĩnh Ngọc', 2), (N'Minh Phú', 3);

-- dữ liệu Giống Cây Trồng
INSERT INTO GiongCayTrong (TenGiong, ThongTin) VALUES 
(N'Rau cải ngọt', N'Giống rau cải dễ trồng, phù hợp với khí hậu miền Bắc'),
(N'Bưởi Diễn', N'Giống bưởi thơm ngon, đặc sản Hà Nội');

-- dữ liệu Giống cây - Khu vực lưu hành
INSERT INTO GiongCay_LuuHanh (ID_GiongCay, ID_Xa) VALUES 
(1, 1), (1, 2), (2, 3);

-- dữ liệu mẫu bảng SXTT
INSERT INTO SXTT (CSAnToanVietGap, VungTrong, SinhVatGayHai, ID_Xa) VALUES 
(1, geography::Point(21.0046, 105.9311, 4326), N'Sâu xanh ăn lá', 1),
(0, geography::Point(21.1523, 105.8471, 4326), N'Bệnh phấn trắng', 2);

-- dữ liệu Cơ sở sản xuất
INSERT INTO CoSoSanXuat (TenCS, ViTri, ID_Xa) VALUES 
(N'Công ty TNHH Nông Nghiệp Hà Nội', geography::Point(21.0285, 105.8542, 4326), 1),
(N'Cơ sở sản xuất phân bón Đông Anh', geography::Point(21.1343, 105.8476, 4326), 2);

-- dữ liệu Cơ sở buôn bán
INSERT INTO CoSoBuonBan (TenCS, ViTri, ID_Xa) VALUES 
(N'Công ty TNHH Witgang Việt Nam', geography::Point(21.0422, 105.8346, 4326), 1),
(N'Công ty Cổ phần Nữ hoàng châu Á - Asian Queen', geography::Point(21.1343, 105.8476, 4326), 2);

-- dữ liệu bảng Thuốc BVTV
INSERT INTO ThuocBVTV (TenThuoc, ThongTin, ID_CSSX, ID_CSBB) VALUES 
(N'Thuốc BVTV Hà Thành', N'Thuốc trừ sâu sinh học thân thiện môi trường', 1, 2);

-- dữ liệu mẫu bảng Phân Bón
INSERT INTO PhanBon (TenPhanBon, ThongTin, ID_CSSX, ID_CSBB) VALUES 
(N'Phân bón hữu cơ Gia Lâm', N'Phân bón hữu cơ cải tạo đất, tăng năng suất', 2, 1);

SELECT 
    GiongCayTrong.TenGiong AS 'Giống cây trồng',
    Huyen.TenHuyen AS 'Huyện',
    Xa.TenXa AS 'Xã',
    GiongCayTrong.ThongTin AS 'Thông tin giống cây',
    SXTT.CSAnToanVietGap AS 'Chứng nhận VietGap',
    SXTT.SinhVatGayHai AS 'Sinh vật gây hại',
    CoSoSX.TenCS AS 'Cơ sở sản xuất',
    CoSoBB.TenCS AS 'Cơ sở buôn bán',
    PhanBon.TenPhanBon AS 'Phân bón',
    ThuocBVTV.TenThuoc AS 'Thuốc bảo vệ thực vật'
FROM 
    GiongCayTrong
-- lket giống cây trồng với khu vực lưu hành
INNER JOIN 
    GiongCay_LuuHanh ON GiongCayTrong.ID = GiongCay_LuuHanh.ID_GiongCay
INNER JOIN 
    Xa ON GiongCay_LuuHanh.ID_Xa = Xa.ID
INNER JOIN 
    Huyen ON Xa.ID_Huyen = Huyen.ID
-- giống cây với vùng sản xuất
LEFT JOIN 
    SXTT ON Xa.ID = SXTT.ID_Xa
-- liên kết cơ sở sản xuất & buôn bán cho thuốc BVTV
LEFT JOIN 
    CoSoSanXuat AS CoSoSX ON ThuocBVTV.ID_CSSX = CoSoSX.ID
LEFT JOIN 
    CoSoBuonBan AS CoSoBB ON ThuocBVTV.ID_CSBB = CoSoBB.ID
-- liên kết cơ sở sản xuất & buôn bán cho phân bón
LEFT JOIN 
    CoSoSanXuat AS CoSoSX_PB ON PhanBon.ID_CSSX = CoSoSX_PB.ID
LEFT JOIN 
    CoSoBuonBan AS CoSoBB_PB ON PhanBon.ID_CSBB = CoSoBB_PB.ID;

--SELECT *
--FROM PhanBon
--SELECT *
--FROM SXTT