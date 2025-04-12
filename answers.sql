CREATE DATABASE Bookstore;
USE Bookstore;

CREATE TABLE book (
    bookID INT AUTO_INCREMENT NOT NULL,
    title VARCHAR(100) NOT NULL,
    isbn VARCHAR(20) NOT NULL,
    languageID INT NOT NULL, 
    publisherID INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    publicationYear INT NOT NULL,
    PRIMARY KEY (bookID),
    FOREIGN KEY (languageID) REFERENCES bookLanguage(languageID),
    FOREIGN KEY (publisherID) REFERENCES publisher(publisherID)
);

CREATE TABLE author(
    authorID INT AUTO_INCREMENT NOT NULL,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    bio VARCHAR(100),
    PRIMARY KEY (authorID)
);

CREATE TABLE bookAuthor(
    bookID INT NOT NULL,
    authorID INT NOT NULL,
    PRIMARY KEY (bookID, authorID),
    FOREIGN KEY (bookID) REFERENCES book(bookID),
    FOREIGN KEY (authorID) REFERENCES author(authorID),
);


CREATE TABLE bookLanguage(
    langaugeID INT AUTO_INCREMENT NOT NULL,
    languageName VARCHAR(50) NOT NULL,
    PRIMARY KEY (languageID)
);

CREATE TABLE publisher(
    pubisherID INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(100) NOT NULL,
    PRIMARY KEY (publisherID)

);

CREATE TABLE customer (
    customerID INT AUTO_INCREMENT NOT NULL,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    PRIMARY KEY (customerID)
);

CREATE TABLE customerAddress(
        customerAddressID INT AUTO_INCREMENT NOT NULL,
        customerID INT NOT NULL,
        addressID INT NOT NULL,
        statusID INT NOT NULL,
        PRIMARY KEY (customerAddressID),
        FOREIGN KEY (customerID) REFERENCES customer(customerID),
        FOREIGN KEY (addressID) REFERENCES address(addressID),
        FOREIGN KEY (statusID) REFERENCES addressStatus(statusID)
    );

CREATE TABLE address(
    addressID INT AUTO_INCREMENT NOT NULL,
    strett VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    postalCode VARCHAR(20) NOT NULL,
    countryID VARCHAR(50) NOT NULL,
    PRIMARY KEY (addressID),   
    FOREIGN KEY (countryID) REFERENCES country(countryID)
);

CREATE TABLE addressStatus(
    statusID INT AUTO_INCREMENT NOT NULL,
    statusName VARCHAR(50) NOT NULL DEFAULT 'current',
    
    PRIMARY KEY (statusID)
);

CREATE TABLE country(
    countryID INT AUTO_INCREMENT NOT NULL,
    countryName VARCHAR(50) NOT NULL,
    PRIMARY KEY (countryID)
);

CREATE TABLE custOrder(
    orderID INT AUTO_INCREMENT NOT NULL,
    customerID INT NOT NULL,
    orderDate DATE NOT NULL,
    shippingMethodID INT NOT NULL,
    orderStatusID INT NOT NULL,
    PRIMARY KEY (orderID),
    FOREIGN KEY (customerID) REFERENCES customer(customerID),
    FOREIGN KEY (orderStatusID) REFERENCES addressStatus(statusID)
);

CREATE TABLE orderLine(
    orderLineID INT AUTO_INCREMENT NOT NULL,
    orderID INT NOT NULL,
    bookID INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(10,2) CHECK (price > 0) NOT NULL,
    PRIMARY KEY(orderLineID),
    FOREIGN KEY(orderID) REFERENCES custOrder(orderID),
    FOREIGN KEY(bookID) REFERENCES book(bookID)
);

CREATE TABLE shippingMethod(
    shippingMethodID INT AUTO_INCREMENT NOT NULL,
    methodName VARCHAR(50) NOT NULL,
    estimatedDays INT NOT NULL,
    PRIMARY KEY(shippingMethodID)
);

CREATE TABLE orderStatus(
    statusID INT AUTO_INCREMENT NOT NULL,
    statusName VARCHAR(50) NOT NULL,
    PRIMARY KEY(statusID)

);

CREATE TABLE orderHistory(
    historyID INT AUTO_INCREMENT NOT NULL,
    orderID INT NOT NULL,
    statusID INT NOT NULL,
    timestamp DATETIME NOT NULL,
    PRIMARY KEY(historyID),
);



