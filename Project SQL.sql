Create database Project_SQL;
USE Project_SQL;
CREATE TABLE publisher ( 
    PublisherName VARCHAR(255) PRIMARY KEY, 
    PublisherAddress TEXT, 
    PublisherPhone VARCHAR(15) 
); 
select * from publisher;
 -- Table: tbl_book 
CREATE TABLE book ( 
    Book_ID INT PRIMARY KEY, 
    book_Title VARCHAR(255), 
    book_PublisherName VARCHAR(255), 
    FOREIGN KEY (book_PublisherName) REFERENCES 
publisher(PublisherName) 
); 
select * from book;
 -- Table: tbl_book_authors 
CREATE TABLE authors ( 
    authors_AuthorID INT PRIMARY KEY AUTO_INCREMENT, 
    authors_BookID INT, 
    authors_AuthorName VARCHAR(255),
        FOREIGN KEY (authors_BookID) REFERENCES book(Book_ID) 
); 
select * from authors;
 -- Table: tbl_library_branch 
CREATE TABLE library_branch ( 
    library_BranchID INT PRIMARY KEY auto_increment, 
    library_BranchName VARCHAR(255), 
    library_BranchAddress TEXT 
); 
select * from library_branch;
 -- Table: tbl_book_copies 
CREATE TABLE book_copies ( 
    bookcopies_CopiesID INT PRIMARY KEY auto_increment, 
    bookcopies_BookID INT, 
    bookcopies_BranchID INT, 
    bookcopies_No_Of_Copies INT, 
    FOREIGN KEY (bookcopies_BookID) REFERENCES book(Book_ID), 
    FOREIGN KEY (bookcopies_BranchID) REFERENCES 
library_branch(library_BranchID) 
); 
select * from book_copies;
 -- Table: tbl_borrower 
CREATE TABLE borrower ( 
    borrower_CardNo INT PRIMARY KEY, 
    borrower_Name VARCHAR(255), 
    borrower_Address TEXT, 
    borrower_Phone VARCHAR(15) 
); 
select * from borrower;
 -- Table: tbl_book_loans 
 Drop TABLE book_loans;
Create TABLE book_loans ( 
    bookloans_LoansID INT PRIMARY KEY AUTO_INCREMENT, 
    bookloans_BookID INT, 
    bookloans_BranchID INT, 
    bookloans_CardNo INT, 
    bookloans_DateOut DATE, 
    bookloans_DueDate DATE, 
    FOREIGN KEY (bookloans_BookID) REFERENCES book(Book_ID), 
    FOREIGN KEY (bookloans_BranchID) REFERENCES 
library_branch(library_BranchID), 
    FOREIGN KEY (bookloans_CardNo) REFERENCES borrower(borrower_CardNo) 
); 
select * from book_loans;

select * from borrower;

-- CODE
-- 1
select bookcopies_no_Of_Copies  as No_Of_Copies from book_copies
join book
ON book.Book_ID=bookcopies_BookID
join library_branch
ON library_branch.library_BranchID=book_copies.bookcopies_BranchID
where book_title= "The Lost Tribe" AND library_BranchName="Sharpstown";

select * from book_copies;
-- 2
select sum(bookcopies_no_Of_Copies)  as No_Of_Copies from book_copies
join book
ON book.Book_ID=bookcopies_BookID
join library_branch
ON library_branch.library_BranchID=book_copies.bookcopies_BranchID
where book_title= "The Lost Tribe";

select * from borrower,book_loans,library_branch,book;
-- 3
select borrower_Name from borrower
left join book_loans
ON borrower.borrower_CardNo=book_loans.bookloans_CardNo where  book_loans.bookloans_CardNo  IS NULL;

-- 3(different method using sub query)
SELECT borrower_CardNo, borrower_Name
FROM borrower
WHERE borrower_CardNo NOT IN (SELECT bookloans_CardNo FROM book_loans);

-- 4
select * from borrower,book_loans,library_branch;
select book_Title,borrower_Name,borrower_Address from book b
join book_loans bl
ON b.Book_ID=bl.bookloans_BookID
join borrower br
ON br.borrower_CardNo=bl.bookloans_CardNo
join library_branch lb
ON lb.library_BranchID=bl.bookloans_BranchID
WHERE library_BranchName="Sharpstown" AND bookloans_DueDate='2018-02-03';


select * from book_loans;

-- 5
select library_BranchName,count(bookloans_BranchID) as No_of_books_loaned from library_branch lb
join book_loans bl
ON lb.library_BranchID=bl.bookloans_BranchID
group by library_BranchName;

-- 6

select borrower_Name,borrower_Address,count(bookloans_LoansID) from book_loans bl
join borrower b
ON bl.bookloans_CardNo=b.borrower_CardNo
group by borrower_Name,borrower_Address
having count(bookloans_CardNo)>5;

select * from borrower;
select * from library_branch;
select * from authors;
select * from book;
select * from book,authors,book_copies;
select * from book_copies;
-- 7
SELECT book_Title,bookcopies_No_Of_Copies as No_of_Copies from book
join authors a
ON book.Book_ID=a.authors_BookID
join book_copies bc
ON bc.bookcopies_BookID=book.Book_ID
join library_branch lb
ON lb.library_BranchID=bc.bookcopies_BranchID
where authors_AuthorName="Stephen King" AND library_BranchName="Central";

-- 8
select * from book_loans;
select * from borrower;
select distinct borrower_Name from book_loans bl
join borrower b
ON  bl.bookloans_CardNo=b.borrower_CardNo
where year(bookloans_DateOut)=2018;