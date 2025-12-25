-- Phần 1 thao tác với dữ liệu

-- Tạo bảng Customer
create table Customer (
    customer_id varchar(5) primary key ,
    customer_full_name varchar (100) not null ,
    customer_email varchar(100) unique ,
    customer_phone varchar(15) ,
    customer_address varchar(255)
);

-- Tạo bảng Room
create table Room(
    room_id varchar(5) primary key ,
    room_type varchar(50) not null ,
    room_price decimal(10, 2) not null ,
    room_status varchar(20) default 'Available' ,
    room_area int
);

-- Tạo bảng Booking
create table Booking(
    booking_id serial primary key ,
    customer_id varchar(5) ,
    room_id varchar(5) ,
    check_in_date date not null ,
    check_out_date date not null ,
    total_amount decimal(10, 2) ,
    constraint fk_booking_customer foreign key (customer_id) references Customer(customer_id) ,
    constraint fk_booking_room foreign key (room_id) references Room(room_id)
);

-- Tạo bảng Payment
create table Payment(
    payment_id serial primary key ,
    booking_id int ,
    payment_method varchar(50) not null ,
    payment_date date not null ,
    payment_amount decimal(10, 2) ,
    constraint fk_payment_booking foreign key (booking_id) references Booking(booking_id)
);

-- 2. Chèn dữ liệu
-- Chèn dữ liệu bảng Customer
insert into Customer(customer_id, customer_full_name, customer_email, customer_phone, customer_address) values
('C001', 'Nguyen Anh Tu', 'tu.nguyen@example.com', '0912345678', 'Hanoi, Vietnam'),
('C002', 'Tran Thi Mai', 'mai.tran@example.com', '0923456789', 'Ho Chi Minh, Vietnam'),
('C003', 'Le Minh Hoang', 'hoang.le@example.com', '0934567890', 'Danang, Vietnam'),
('C004', 'Pham Hoang Nam', 'nam.pham@example.com', '0945678901', 'Hue, Vietnam'),
('C005', 'Vu Minh Thu', 'thu.vu@example.com', '0956789012', 'Hai Phong, Vietnam');

-- Chèn dữ liệu bảng Room
insert into Room(room_id, room_type, room_price, room_status, room_area) VALUES
('R001', 'Single', 100.0, 'Available', 25),
('R002', 'Double', 150.0, 'Booked', 40),
('R003', 'Suite', 250.0, 'Available', 60),
('R004', 'Single', 120.0, 'Booked', 30),
('R005', 'Double', 160.0, 'Available', 35);

-- Chèn dữ liệu bảng Booing
insert into Booking(customer_id, room_id, check_in_date, check_out_date, total_amount) VALUES
('C001', 'R001', '2025-03-01', '2025-03-05', 400.0),
('C002', 'R002', '2025-03-02', '2025-03-06', 600.0),
('C003', 'R003', '2025-03-03', '2025-03-07', 1000.0),
('C004', 'R004', '2025-03-04', '2025-03-08', 480.0),
('C005', 'R005', '2025-03-05', '2025-03-09', 800.0);

-- Chèn dữ liệu bảng Payment
insert into Payment (booking_id, payment_method, payment_date, payment_amount) VALUES
(1, 'Cash', '2025-03-05', 400.0),
(2, 'Credit Card', '2025-03-06', 600.0),
(3, 'Bank Transfer', '2025-03-07', 1000.0),
(4, 'Cash', '2025-03-08', 480.0),
(5, 'Credit Card', '2025-03-09', 800.0);


-- 3 Cập nhật dữ liệu
-- Giảm 10% (nhân 0.9) cho các booking check-in trước ngày 2025-03-03
update Booking
set total_amount = total_amount * 0.9
where check_in_date < '2025-03-03';

-- 4. Xóa dữ liệu
-- Xóa thanh toán Cash và số tiền < 500
delete from Payment
where payment_method = 'Cash' and payment_amount < 500;

--========================================================
-- Phần 2: Truy vấn dữ liệu (Select)

-- 5. Lấy thông tin khách hàng, sắp xếp theo tên giảm dần
select customer_id, customer_full_name, customer_email, customer_phone
from Customer
order by customer_full_name desc;

-- 6. Lấy thông tin phòng, sắp xếp theo diện tích tăng dần
select room_id, room_type, room_price, room_area
from Room
order by room_area;

-- 7. Lấy thông tin khách hàng và phòng đã đặt
select c.customer_full_name, r.room_id, b.check_in_date, b.check_out_date
from Booking b
join Customer c on b.customer_id = c.customer_id
join Room r on b.room_id = r.room_id;

-- 8. Danh sách khách hàng và tổng tiền thanh toán, sắp xếp tiền tăng dần
select c.customer_id, c.customer_full_name, p.payment_method, p.payment_amount
from Payment p
join Booking b on p.booking_id = b.booking_id
join Customer c on b.customer_id = c.customer_id
order by p.payment_amount;

-- 9. Lấy khách hàng từ vị trí 2 đến 4, sắp xếp tên Z-A
-- Offset 1 (bỏ qua 1 người đầu) và Limit 3 (lấy 3 người tiếp theo: 2, 3, 4)
select *
from Customer
order by customer_full_name desc
offset 1 limit 3;

-- 10. Khách hàng đã đặt ít nhất 2 phòng
select c.customer_id, c.customer_full_name, count(b.booking_id) as so_luong_phong
from Booking b
join Customer c on b.customer_id = c.customer_id
group by c.customer_id, c.customer_full_name
having count(b.booking_id) >= 2;

-- 11. Các phòng có ít nhất 3 khách đặt
select r.room_id, r.room_type, r.room_price, count(b.booking_id) as so_lan_dat
from Booking b
join Room r on b.room_id = r.room_id
group by r.room_id, r.room_type, r.room_price
having count(b.booking_id) >= 3;

-- 12. Khách hàng có tổng tiền thanh toán > 1000
select c.customer_id, c.customer_full_name, b.room_id, sum(p.payment_amount) as tong_tien
from Payment p
join Booking b on p.booking_id = b.booking_id
join Customer c on b.customer_id = c.customer_id
group by c.customer_id, c.customer_full_name, b.room_id
having sum(p.payment_amount) > 1000;

-- 13. Tìm khách tên có chữ "Minh" hoặc địa chỉ "Hanoi", sắp xếp tên tăng dần
select customer_id, customer_full_name, customer_email, customer_phone
from Customer
where customer_full_name like '%Minh%' or customer_address like '%Hanoi%'
order by customer_full_name;

-- 14. Phân trang phòng: Trang 2 (bỏ 5 phòng đầu, lấy 5 phòng tiếp), xếp giá giảm dần
select room_id, room_type, room_price
from Room
order by room_price desc
offset 5 limit 5;

--====================================================================================
-- Phần 3: Tạo view

--  15. View thông tin phòng và khách đặt trước ngày 2025-03-04
create or replace view v_room_booking_before_mar4 as
select r.room_id, r.room_type, c.customer_id, c.customer_full_name
from Booking b
join Room r on b.room_id = r.room_id
join Customer c on b.customer_id = c.customer_id
where b.check_in_date < '2025-03-04';

-- 16. View khách và phòng có diện tích > 30 m2
create or replace view v_customer_room_large_area as
select c.customer_id, c.customer_full_name, r.room_id, r.room_area, b.check_in_date
from Booking b
join Room r on b.room_id = r.room_id
join Customer c on b.customer_id = c.customer_id
where r.room_area > 30;

--=================================================================================
-- Phần 4: Tạo trigger

-- 17. Trigger kiểm tra ngày đặt không sau ngày trả
-- Bước 1: Tạo function
create or replace function func_check_insert_booking()
returns trigger as
$$
begin
    if new.check_in_date > new.check_out_date then
        RAISE EXCEPTION 'Ngày đặt phòng không thể sau ngày trả phòng được!';
    end if;
    return new;
end;
$$
language plpgsql;

-- Bước 2: Tạo trigger gắn với bảng Booking
create trigger check_insert_booking
before insert on Booking
for each row
execute function func_check_insert_booking();

-- 18. Trigger cập nhật trạng thái phòng thành "Booked" khi đặt phòng
-- Bước 1: Tạo function
create or replace function func_update_room_status()
    returns trigger as
$$
begin
    update Room
    set room_status = 'Booked'
    where room_id = new.room_id;
    return new;
end;
$$
language plpgsql;

-- Bước 2: Tạo Trigger gắn với bảng Booking
create trigger update_room_status_on_booking
after insert on Booking
for each row
execute function func_update_room_status();

--====================================================
-- Phần 5: Stored procedure

-- 19. Procedure thêm khách hàng mới
create or replace procedure add_customer(
    p_id varchar(5),
    p_name varchar(100),
    p_email varchar(100),
    p_phone varchar(15),
    p_addr varchar(255)
)
    language plpgsql
as
$$
begin
    insert into Customer(customer_id, customer_full_name, customer_email, customer_phone, customer_address) values
    (p_id, p_name, p_email, p_phone, p_addr);
end;
$$;

-- 20. Procedure thêm thanh toán mới (5 điểm) [cite: 65, 66]
create or replace procedure add_payment(
    p_booking_id int ,
    p_payment_method varchar(50),
    p_payment_amount decimal(10, 2),
    p_payment_date date
)
language plpgsql
as
$$
begin
    insert into Payment(booking_id, payment_method, payment_amount, payment_date) values
    (p_booking_id, p_payment_method, p_payment_amount, p_payment_date);
end;
$$;