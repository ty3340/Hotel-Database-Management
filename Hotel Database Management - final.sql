
--down
if exists(select * from sys.objects where name='v_revenue_chart')
	drop view v_revenue_chart 

if exists(select * from sys.objects where name='v_timeseries_chart')
	drop view v_timeseries_chart 

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_staff_staff_role_title')
    alter table staffs drop constraint fk_staff_staff_role_title

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_staff_staff_department_name')
    alter table staffs drop constraint fk_staff_staff_department_name

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_staff_staff_supervisor_id')
    alter table staffs drop constraint fk_staff_staff_supervisor_id

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_room_room_roomtype_name')
    alter table rooms drop constraint fk_room_room_roomtype_name

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_room_room_staff_id')
    alter table rooms drop constraint fk_room_room_staff_id

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_room_room_status')
    alter table rooms drop constraint fk_room_room_status

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_guest_guest_rating_id')
    alter table guests drop constraint fk_guest_guest_rating_id

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_invoice_invoice_guest_id')
    alter table invoices drop constraint fk_invoice_invoice_guest_id

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_invoice_invoice_payment_method_type')
    alter table invoices drop constraint fk_invoice_invoice_payment_method_type

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_invoice_invoice_status')
    alter table invoices drop constraint fk_invoice_invoice_status

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_invoice_item_invoice_id')
    alter table invoice_items drop constraint fk_invoice_item_invoice_id

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_invoice_item_item_id')
    alter table invoice_items drop constraint fk_invoice_item_item_id

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_guest_payment_method_guest_id')
    alter table guest_payment_methods drop constraint fk_guest_payment_method_guest_id

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_guest_payment_method_payment_method_type')
    alter table guest_payment_methods drop constraint fk_guest_payment_method_payment_method_type

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_booking_booking_invoice_id')
    alter table bookings drop constraint fk_booking_booking_invoice_id

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_booking_booking_guest_id')
    alter table bookings drop constraint fk_booking_booking_guest_id

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_booking_booking_room_id')
    alter table bookings drop constraint fk_booking_booking_room_id

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_booking_booking_guest_rating_id')
    alter table bookings drop constraint fk_booking_booking_guest_rating_id


drop table if exists staffs
drop table if exists rooms
drop table if exists guests
drop table if exists invoices
drop table if exists invoice_items
drop table if exists bookings

drop table if exists departments
drop table if exists roles
drop table if exists roomtypes
drop table if exists guest_ratings
drop table if exists payment_methods
drop table if exists invoice_status_lookup
drop table if exists items
drop table if exists room_status_lookup
drop table if exists guest_payment_methods
GO


--up

--employee section*********************************
--department
create table departments(
    department_name varchar (100) not null,

    constraint pk_department_department_name primary key (department_name)
) 

create table roles(
    role_title varchar (100) not null,
    role_description varchar(200) null,

    constraint pk_role_role_title primary key (role_title)
)

create table staffs(
    staff_id varchar(10) not null,
    staff_role_title varchar(100) not null,
    staff_department_name varchar(100) not null,
    staff_firstname varchar (50) not null,
    staff_lastname varchar (50) not null,
    staff_DOB date not null,
    staff_phone_number varchar (50) not null,
    staff_email varchar (50) not null,
    staff_gender varchar (10) not null,
    staff_hire_date date not null,
    staff_supervisor_id varchar(10) null,

    constraint pk_staff_staff_id primary key (staff_id),

    constraint u_staff_staff_email unique(staff_email),

    constraint fk_staff_staff_role_title 
		foreign key (staff_role_title) references roles(role_title),

    constraint fk_staff_staff_department_name
        foreign key (staff_department_name) references departments(department_name),

    constraint fk_staff_staff_supervisor_id
        foreign key (staff_supervisor_id) references staffs(staff_id)
)

--room section****************************************
--roomtypes
create table roomtypes (
    roomtype_name varchar(50) not null,
    roomtype_price numeric(6,2) not null,
    roomtype_max_occupancy int not null,
    roomtype_description varchar(100) not null,

    constraint pk_roomtype_roomtype_name primary key (roomtype_name)
)

--room_status_lookup
create table room_status_lookup (
    room_status varchar(50) not null,
    constraint pk_room_status_lookup_room_status primary key (room_status)

)

--rooms
create table rooms(
    room_id int identity not null,
    room_number varchar (10) not null,
    room_status varchar (50) not null,
    room_roomtype_name varchar(50) not null,
    room_staff_id varchar(10) not null,
    room_cleaned_date datetime default (getdate()) null,
    room_checkin_date datetime default (getdate()) null,
    room_checkout_date datetime default (getdate()) null,

    constraint pk_room_room_id primary key (room_id),

    constraint fk_room_room_roomtype_name
        foreign key (room_roomtype_name) references roomtypes (roomtype_name),

    constraint fk_room_room_staff_id 
        foreign key (room_staff_id) references staffs(staff_id),
    
    constraint fk_room_room_status 
        foreign key (room_status) references room_status_lookup(room_status)

)

--guest section*******************************************
--guest rating
create table guest_ratings (
    guest_rating_id varchar (10) not null,
    guest_rating_value int null,
    guest_rating_comment varchar (100) null,
    guest_rating_date date null,

    constraint pk_guest_rating_guest_rating_id primary key (guest_rating_id)
)

--guests
create table guests (
    guest_id varchar(10) not null,
    guest_guest_rating_id varchar(10) null,
    guest_firstname varchar (50) not null,
    guest_lastname varchar (50) not null,
    guest_DOB date not null,
    guest_email varchar (50) not null,
    guest_phone_number varchar (20) not null,
    guest_address varchar (50) not null,
    guest_city varchar (10) not null,
    guest_country varchar (10) not null,

    constraint pk_guest_guest_id primary key (guest_id),
    constraint u_guest_guest_email unique (guest_email),
    constraint fk_guest_guest_rating_id 
        foreign key (guest_guest_rating_id) references guest_ratings (guest_rating_id)

)

--payment section ********************************************
--payment_methods
create table payment_methods (
    payment_method_type varchar(50) not null,

    constraint pk_payment_method_payment_method_type primary key (payment_method_type)
)

--guest_payment_methods
create table guest_payment_methods (

    guest_id varchar (10) not null,
    payment_method_type varchar (50) not null,
 
    constraint pk_guest_payment_method_guest_id primary key (guest_id,payment_method_type),

    constraint fk_guest_payment_method_guest_id 
        foreign key (guest_id) references guests (guest_id),

    constraint fk_guest_payment_method_payment_method_type
        foreign key (payment_method_type) references payment_methods (payment_method_type)
)

--invoice section********************************************************
--invoice_status_lookup

create table invoice_status_lookup(
    invoice_status varchar (50) not null,

    constraint pk_invoice_status_lookup_invoice_status primary key (invoice_status)
)

--invoices
create table invoices (
    invoice_id varchar(10) not null,
    invoice_guest_id varchar(10) not null,
    invoice_payment_method_type varchar (50) not null,
    invoice_status varchar(50) not null,
    invoice_due_date date not null,

    constraint pk_invoice_invoice_id primary key (invoice_id),

    constraint fk_invoice_invoice_guest_id 
        foreign key (invoice_guest_id) references guests (guest_id),

    constraint fk_invoice_invoice_payment_method_type 
        foreign key (invoice_payment_method_type) references payment_methods (payment_method_type),

    constraint fk_invoice_invoice_status 
        foreign key (invoice_status) references invoice_status_lookup(invoice_status)
)



--items section ****************************************************
--items
create table items(
    item_id int not null,
    item_name varchar (50) not null,
    item_price money not null,

    constraint pk_item_item_id primary key (item_id),
    constraint u_item_item_name unique (item_name)
)
--invoice_items
create table invoice_items (
    invoice_id varchar(10) not null,
    item_id int not null,
    invoice_item_quantity int not null,

    constraint pk_invoice_item__invoice_id_item_id primary key (invoice_id,item_id),

    constraint fk_invoice_item_invoice_id 
        foreign key (invoice_id) references invoices (invoice_id),
    constraint fk_invoice_item_item_id 
        foreign key (item_id) references items (item_id)
)
--bookings
create table bookings(
    booking_number varchar(10) not null,
    booking_invoice_id varchar(10) null,
    booking_guest_id varchar(10) not null,
    booking_room_id int not null,
    booking_guest_rating_id varchar(10) null,
    booking_start_date date not null,
    booking_end_date date not null,

    constraint pk_booking_booking_id primary key (booking_number),
    constraint fk_booking_booking_invoice_id 
        foreign key (booking_invoice_id) references invoices(invoice_id),

    constraint fk_booking_booking_guest_id 
        foreign key (booking_guest_id) references guests(guest_id),

    constraint fk_booking_booking_room_id
        foreign key (booking_room_id) references rooms(room_id),
    
    constraint fk_booking_booking_guest_rating_id
        foreign key (booking_guest_rating_id) references guest_ratings(guest_rating_id)
)
go 

--Revenue by room type created in View
create view v_revenue_chart AS
    SELECT r.room_roomtype_name, sum(rt.roomtype_price*datediff(day,b.booking_start_date,b.booking_end_date)) as revenue_by_roomtype 
        from bookings as b
        join invoices as i on b.booking_invoice_id = i.invoice_id
        join rooms as r on r.room_id=b.booking_room_id
        join roomtypes as rt on rt.roomtype_name = r.room_roomtype_name
        group by room_roomtype_name
GO


--Timeseries Reveue created in View
create view v_timeseries_chart AS

    with timeseries_chart as 
    (
    SELECT TOP (100) i.invoice_due_date as pay_date, rt.roomtype_price*datediff(day,b.booking_start_date,b.booking_end_date) as room_charge, 
                im.item_price*ii.invoice_item_quantity as item_charge
        from bookings as b
        right join invoices as i on b.booking_invoice_id = i.invoice_id 
        left join rooms as r on r.room_id=b.booking_room_id
        left join invoice_items as ii on ii.invoice_id = i.invoice_id 
        left join items as im on im.item_id = ii.item_id
        left join roomtypes as rt on rt.roomtype_name = r.room_roomtype_name
        order by i.invoice_due_date
    )
    select pay_date,cast(coalesce(room_charge,0) + coalesce(item_charge,0) as decimal(6,2)) as revenue_by_date
    from timeseries_chart    
GO


--up data

--departments
INSERT [dbo].[departments] ([department_name]) VALUES ('Housekeeping')
INSERT [dbo].[departments] ([department_name]) VALUES ('Front Office')
INSERT [dbo].[departments] ([department_name]) VALUES ('Accounting')
INSERT [dbo].[departments] ([department_name]) VALUES ('Food')
GO

--roles
INSERT [dbo].[roles] ([role_title],[role_description]) VALUES ('Housekeeping Supervisor','Keep a look on housekeeping staffs and make sure every room is cleaned before and after checkout')
INSERT [dbo].[roles] ([role_title],[role_description]) VALUES ('Front Desk Manager','Handles all front desk job like check-in, check-out, and guest services')
INSERT [dbo].[roles] ([role_title],[role_description]) VALUES ('Accountant','Process invoices, ensure timely payments of staffs and maintain financial records')
INSERT [dbo].[roles] ([role_title],[role_description]) VALUES ('Restaurant Manager', 'Responsible for day to day operations, monitor food quality, guest service')
INSERT [dbo].[roles] ([role_title],[role_description]) VALUES ('Housekeeper', 'Cleaning and sanitizing each used room')
GO

--staff
INSERT [dbo].[staffs] ([staff_id],[staff_role_title], [staff_department_name], [staff_firstname], [staff_lastname], [staff_DOB], [staff_phone_number], [staff_email], [staff_gender], [staff_hire_date],[staff_supervisor_id]) VALUES ('E111','Accountant', 'Accounting', 'Chris', 'Evans',CAST('1981-06-13' AS date), 9845211803, 'chrise@gmail.com', 'Male', CAST('2022-04-05' AS date),null)
INSERT [dbo].[staffs] ([staff_id],[staff_role_title], [staff_department_name], [staff_firstname], [staff_lastname], [staff_DOB], [staff_phone_number], [staff_email], [staff_gender], [staff_hire_date],[staff_supervisor_id]) VALUES ('E112','Housekeeping Supervisor', 'Housekeeping', 'Scarlett', 'Johansson', CAST('1984-11-22' AS date), 9845200888, 'scarlettj@gmail.com', 'Female', CAST('2023-05-20' AS date),null)
INSERT [dbo].[staffs] ([staff_id],[staff_role_title], [staff_department_name], [staff_firstname], [staff_lastname], [staff_DOB], [staff_phone_number], [staff_email], [staff_gender], [staff_hire_date],[staff_supervisor_id]) VALUES ('E113','Housekeeper','Housekeeping','Tom','Holland',CAST('2001-01-15' as date),9845200801,'tomh@gmail.com','Male', CAST('2021-02-18' as date),'E112')
INSERT [dbo].[staffs] ([staff_id],[staff_role_title], [staff_department_name], [staff_firstname], [staff_lastname], [staff_DOB], [staff_phone_number], [staff_email], [staff_gender], [staff_hire_date],[staff_supervisor_id]) VALUES ('E114','Housekeeper', 'Housekeeping', 'Emma', 'Watson', CAST('1990-04-15' AS date), 9845200802, 'emmaw@gmail.com', 'Female', CAST('2021-03-10' AS date),'E112')

--roomtypes
INSERT INTO [dbo].[roomtypes] ([roomtype_name], [roomtype_price], [roomtype_max_occupancy], [roomtype_description]) VALUES ('Standard', 100.00, 2, 'Cozy room with basic amenities suitable for couples.');
INSERT INTO [dbo].[roomtypes] ([roomtype_name], [roomtype_price], [roomtype_max_occupancy], [roomtype_description]) VALUES ('Deluxe', 150.00, 4, 'Spacious room with additional amenities suitable for families.');
INSERT INTO [dbo].[roomtypes] ([roomtype_name], [roomtype_price], [roomtype_max_occupancy], [roomtype_description]) VALUES ('Suite', 250.00, 2, 'Luxurious suite with separate living area and premium amenities.');
INSERT INTO [dbo].[roomtypes] ([roomtype_name], [roomtype_price], [roomtype_max_occupancy], [roomtype_description]) VALUES ('Penthouse', 500.00, 6, 'Exclusive penthouse with panoramic views and top-notch facilities.');


--room status
INSERT INTO [dbo].[room_status_lookup] ([room_status])VALUES('Occupied')
INSERT INTO [dbo].[room_status_lookup] ([room_status])VALUES('Vacant')


--rooms
INSERT INTO [dbo].[rooms] ([room_number], [room_roomtype_name], [room_staff_id], [room_status],[room_cleaned_date],[room_checkin_date],[room_checkout_date]) VALUES ('ST101', 'Standard','E113', 'Occupied',CAST('2024-04-05' AS date),CAST('2024-04-01' AS date), CAST('2024-04-05' AS date))
INSERT INTO [dbo].[rooms] ([room_number], [room_roomtype_name], [room_staff_id], [room_status],[room_cleaned_date],[room_checkin_date],[room_checkout_date]) VALUES ('ST102', 'Standard','E113', 'Occupied',CAST('2024-04-13' AS date),CAST('2024-04-03' AS date), CAST('2024-04-13' AS date))
INSERT INTO [dbo].[rooms] ([room_number], [room_roomtype_name], [room_staff_id], [room_status],[room_cleaned_date],[room_checkin_date],[room_checkout_date]) VALUES ('ST103', 'Standard','E113', 'Occupied',CAST('2024-04-14' AS date),CAST('2024-04-05' AS date), CAST('2024-04-14' AS date))
INSERT INTO [dbo].[rooms] ([room_number], [room_roomtype_name], [room_staff_id], [room_status],[room_cleaned_date],[room_checkin_date],[room_checkout_date]) VALUES ('D101', 'Deluxe', 'E114', 'Vacant',null,null,null)
INSERT INTO [dbo].[rooms] ([room_number], [room_roomtype_name], [room_staff_id], [room_status],[room_cleaned_date],[room_checkin_date],[room_checkout_date]) VALUES ('S101', 'Suite','E114','Vacant',null,null,null)

--guest ratings
INSERT INTO [dbo].[guest_ratings] ([guest_rating_id], [guest_rating_value], [guest_rating_comment], [guest_rating_date]) VALUES ('R20001', 4, 'Wonderful Experience', CAST('2024-04-06' AS date))
INSERT INTO [dbo].[guest_ratings] ([guest_rating_id], [guest_rating_value], [guest_rating_comment], [guest_rating_date]) VALUES ('R20002', 5, 'Great Stay!', CAST('2024-04-12' AS date))
INSERT INTO [dbo].[guest_ratings] ([guest_rating_id], [guest_rating_value], [guest_rating_comment], [guest_rating_date]) VALUES ('R20003',null, null, null)
INSERT INTO [dbo].[guest_ratings] ([guest_rating_id], [guest_rating_value], [guest_rating_comment], [guest_rating_date]) VALUES ('R20004',null,  null, null)
INSERT INTO [dbo].[guest_ratings] ([guest_rating_id], [guest_rating_value], [guest_rating_comment], [guest_rating_date]) VALUES ('R20005',null,  null, null)

--guests
INSERT INTO [dbo].[guests] ([guest_id], [guest_guest_rating_id], [guest_firstname], [guest_lastname], [guest_DOB], [guest_email], [guest_phone_number], [guest_address], [guest_city], [guest_country]) VALUES ('G20001', 'R20001', 'Matt', 'Turner', CAST('1992-01-15' AS date), 'mattt@gmail.com', '2356775122', 'Madison Street', 'Beijing', 'China')
INSERT INTO [dbo].[guests] ([guest_id], [guest_guest_rating_id], [guest_firstname], [guest_lastname], [guest_DOB], [guest_email], [guest_phone_number], [guest_address], [guest_city], [guest_country]) VALUES ('G20002', 'R20002', 'Sarah', 'Jones', CAST('1985-06-20' AS date), 'sarahj@gmail.com', '9876543210', 'Oak Avenue', 'New York', 'USA')
INSERT INTO [dbo].[guests] ([guest_id], [guest_guest_rating_id], [guest_firstname], [guest_lastname], [guest_DOB], [guest_email], [guest_phone_number], [guest_address], [guest_city], [guest_country]) VALUES ('G20003', 'R20003', 'John', 'Smith', CAST('1978-09-10' AS date), 'johns@gmail.com', '1234567890', 'Maple Street', 'London', 'UK')
INSERT INTO [dbo].[guests] ([guest_id], [guest_guest_rating_id], [guest_firstname], [guest_lastname], [guest_DOB], [guest_email], [guest_phone_number], [guest_address], [guest_city], [guest_country]) VALUES ('G20004', 'R20004', 'Emily', 'Brown', CAST('1990-03-05' AS date), 'emilyb@gmail.com', '2468101214', 'Pine Road', 'Sydney', 'Australia')
INSERT INTO [dbo].[guests] ([guest_id], [guest_guest_rating_id], [guest_firstname], [guest_lastname], [guest_DOB], [guest_email], [guest_phone_number], [guest_address], [guest_city], [guest_country]) VALUES ('G20005', 'R20005', 'Ted', 'Turner', CAST('1990-01-05' AS date), 'tedturn@gmail.com', '8168001214', 'Comstock Ave', 'Syracuse', 'USA')

--payment methods
INSERT INTO [dbo].[payment_methods] ([payment_method_type]) VALUES ('Credit Card')
INSERT INTO [dbo].[payment_methods] ([payment_method_type]) VALUES ('Debit Card')
INSERT INTO [dbo].[payment_methods] ([payment_method_type]) VALUES ('Cash')
INSERT INTO [dbo].[payment_methods] ([payment_method_type]) VALUES ('Online Transfer')

--invoice status
INSERT INTO [dbo].[invoice_status_lookup] ([invoice_status]) VALUES ('Pending')
INSERT INTO [dbo].[invoice_status_lookup] ([invoice_status]) VALUES ('Paid')
INSERT INTO [dbo].[invoice_status_lookup] ([invoice_status]) VALUES ('Not paid yet')

--guest_payment_methods
INSERT INTO [dbo].[guest_payment_methods] ([guest_id],[payment_method_type]) VALUES ('G20001','Credit Card')
INSERT INTO [dbo].[guest_payment_methods] ([guest_id],[payment_method_type]) VALUES ('G20001','Cash')
INSERT INTO [dbo].[guest_payment_methods] ([guest_id],[payment_method_type]) VALUES ('G20002','Online Transfer')
INSERT INTO [dbo].[guest_payment_methods] ([guest_id],[payment_method_type]) VALUES ('G20002','Cash')
INSERT INTO [dbo].[guest_payment_methods] ([guest_id],[payment_method_type]) VALUES ('G20003','Credit Card')
INSERT INTO [dbo].[guest_payment_methods] ([guest_id],[payment_method_type]) VALUES ('G20003','Cash')
INSERT INTO [dbo].[guest_payment_methods] ([guest_id],[payment_method_type]) VALUES ('G20004','Online Transfer')
INSERT INTO [dbo].[guest_payment_methods] ([guest_id],[payment_method_type]) VALUES ('G20005','Credit Card')

--invoices
INSERT INTO [dbo].[invoices] ([invoice_id],[invoice_guest_id], [invoice_payment_method_type], [invoice_status], [invoice_due_date]) VALUES ('I10001', 'G20001', 'Credit Card', 'Paid',CAST('2024-04-01' AS date))
INSERT INTO [dbo].[invoices] ([invoice_id],[invoice_guest_id], [invoice_payment_method_type], [invoice_status], [invoice_due_date]) VALUES ('I10002', 'G20001', 'Cash', 'Paid',CAST('2024-04-03' AS date))
INSERT INTO [dbo].[invoices] ([invoice_id],[invoice_guest_id], [invoice_payment_method_type], [invoice_status], [invoice_due_date]) VALUES ('I10003', 'G20002', 'Online Transfer','Paid',CAST('2024-04-03' AS date))
INSERT INTO [dbo].[invoices] ([invoice_id],[invoice_guest_id], [invoice_payment_method_type], [invoice_status], [invoice_due_date]) VALUES ('I10004', 'G20002', 'Cash','Paid',CAST('2024-04-08' AS date))
INSERT INTO [dbo].[invoices] ([invoice_id],[invoice_guest_id], [invoice_payment_method_type], [invoice_status], [invoice_due_date]) VALUES ('I10005', 'G20003', 'Credit Card','Paid',CAST('2024-04-05' AS date))
INSERT INTO [dbo].[invoices] ([invoice_id],[invoice_guest_id], [invoice_payment_method_type], [invoice_status], [invoice_due_date]) VALUES ('I10006', 'G20003', 'Cash','Paid',CAST('2024-04-10' AS date))
INSERT INTO [dbo].[invoices] ([invoice_id],[invoice_guest_id], [invoice_payment_method_type], [invoice_status], [invoice_due_date]) VALUES ('I10007', 'G20004','Online Transfer','Paid',CAST('2024-04-20' AS date))
INSERT INTO [dbo].[invoices] ([invoice_id],[invoice_guest_id], [invoice_payment_method_type], [invoice_status], [invoice_due_date]) VALUES ('I10008', 'G20005','Credit Card','Not paid yet',CAST('2024-04-21' AS date))
GO

--items
INSERT INTO [dbo].[items] ([item_id],[item_name], [item_price]) VALUES (1,'Bottled Water', 2.50)
INSERT INTO [dbo].[items] ([item_id],[item_name], [item_price]) VALUES (2,'Snack Pack', 5.99)
INSERT INTO [dbo].[items] ([item_id],[item_name], [item_price]) VALUES (3,'Toothbrush Kit', 3.75)
INSERT INTO [dbo].[items] ([item_id],[item_name], [item_price]) VALUES (4,'Mini Bar Alcohol', 8.99)
GO

--invoice items
INSERT INTO [dbo].[invoice_items] ([invoice_id],[item_id],[invoice_item_quantity]) VALUES ('I10002',1,3)
INSERT INTO [dbo].[invoice_items] ([invoice_id],[item_id],[invoice_item_quantity]) VALUES ('I10004',4,1)
INSERT INTO [dbo].[invoice_items] ([invoice_id],[item_id],[invoice_item_quantity]) VALUES ('I10006',4,2)
GO

--bookings
INSERT INTO [dbo].[bookings] ([booking_number],[booking_invoice_id], [booking_guest_id], [booking_room_id], [booking_guest_rating_id], [booking_start_date], [booking_end_date]) VALUES ('B10001','I10001','G20001',1,'R20001', CAST('2024-04-01' AS date), CAST('2024-04-05' AS date))
INSERT INTO [dbo].[bookings] ([booking_number],[booking_invoice_id], [booking_guest_id], [booking_room_id], [booking_guest_rating_id], [booking_start_date], [booking_end_date]) VALUES ('B10002','I10003','G20002',2,null, CAST('2024-04-03' AS date), CAST('2024-04-13' AS date))
INSERT INTO [dbo].[bookings] ([booking_number],[booking_invoice_id], [booking_guest_id], [booking_room_id], [booking_guest_rating_id], [booking_start_date], [booking_end_date]) VALUES ('B10003','I10005','G20003',3,null, CAST('2024-04-05' AS date), CAST('2024-04-14' AS date))
INSERT INTO [dbo].[bookings] ([booking_number],[booking_invoice_id], [booking_guest_id], [booking_room_id], [booking_guest_rating_id], [booking_start_date], [booking_end_date]) VALUES ('B10004','I10007','G20004',4,null, CAST('2024-04-20' AS date), CAST('2024-04-29' AS date))
INSERT INTO [dbo].[bookings] ([booking_number],[booking_invoice_id], [booking_guest_id], [booking_room_id], [booking_guest_rating_id], [booking_start_date], [booking_end_date]) VALUES ('B10005','I10008','G20005',5, null, CAST('2024-04-21' AS date), CAST('2024-04-28' AS date))


select room_number, room_cleaned_date, room_checkin_date,room_checkout_date from rooms

select* from staffs

select* from invoices




























