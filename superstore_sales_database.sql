create database superstore_sales

use superstore_sales

create table product (
    ProductID            int,
    ProductName	         varchar(200),
    ProductCategory	     varchar(20),
    ProductSubCategory	 varchar(50),
    ProductContainer	 varchar(20),
    ProductBaseMargin	 decimal(4,2),
    PRIMARY KEY	(ProductID)
);

create table customer (
  CustomerID int,
  CustomerName varchar(50),
  Province varchar (50),
  Region varchar (50),
  CustomerSegment Varchar(20),
  Primary Key (CustomerID)
);

create table returns (
		OrderID Int,
        status varchar (45),
       FOREIGN KEY OrderID REFERENCES orders(OrderID)
);

create table orders (
	OrderID Int auto_increment,
    ProductID int,
    CustomerID int,
    OrderDate Date,
    OrderPriority VARCHAR(20),
    OrderQuantity int,
    Sales decimal (15,5),
    Discount decimal (3,2),
    ShipMode VARCHAR (20),
    Profit decimal (15,2),
    UnitPrice decimal (15,2),
    ShippingCost decimal (15,2),
    Primary Key (OrderID) ,
    FOREIGN KEY (ProductID) REFERENCES product(ProductID),
    FOREIGN KEY (CustomerID) REFERENCES customer(CustomerID);


