--1
SELECT VendorName
FROM Vendors
WHERE VendorID IN
       (SELECT VendorID
       FROM Invoices)
ORDER BY VendorName;

--2
SELECT InvoiceNumber, InvoiceTotal
FROM Invoices
WHERE PaymentTotal >
      (SELECT AVG(PaymentTotal)
	  FROM Invoices)
ORDER BY PaymentTotal DESC;

--3
SELECT InvoiceNumber, InvoiceTotal
FROM Invoices
WHERE PaymentTotal > ALL
      (SELECT TOP 50 PERCENT PaymentTotal
	  FROM Invoices
	  ORDER BY PaymentTotal)
ORDER BY InvoiceTotal;


--4
SELECT AccountNo, AccountDescription
FROM GLAccounts AS a
WHERE NOT EXISTS
      (SELECT *
	  FROM InvoiceLineItems AS b
	  WHERE b.AccountNo = a.AccountNo)
ORDER BY AccountNo;

--5
SELECT DISTINCT VendorName, InvoiceLineItems.InvoiceID, InvoiceSequence, InvoiceLineItemAmount
FROM InvoiceLineItems JOIN Invoices
     ON InvoiceLineItems.InvoiceID = Invoices.InvoiceID
	 JOIN Vendors
	 ON Invoices.VendorID = Vendors.VendorID
WHERE InvoiceLineItems.InvoiceID IN
	   (SELECT InvoiceID 
		FROM InvoiceLineItems
		WHERE InvoiceSequence > 1);


--6
SELECT SUM(MaxInvoice) AS Unpaid
FROM (SELECT MAX(InvoiceTotal) AS MaxInvoice
      FROM Invoices
	  WHERE InvoiceTotal - PaymentTotal - CreditTotal > 0
      GROUP BY VendorID) AS MaxTable;
	   
--7
SELECT DISTINCT VendorName, VendorCity, VendorState
FROM Vendors
WHERE VendorCity + VendorState NOT IN
     (SELECT VendorCity + VendorState
	 FROM Vendors
	 GROUP BY VendorCity + VendorState
	 HAVING COUNT(*) > 1)
ORDER BY VendorState;

--8
SELECT VendorName, InvoiceNumber, InvoiceDate, InvoiceTotal
FROM Vendors JOIN Invoices
     ON Vendors.VendorID = Invoices.VendorID
WHERE Invoices.InvoiceDate = 
      (SELECT MIN(InvoiceDate)
	  FROM Invoices
	  WHERE Vendors.VendorID = Invoices.VendorID)
GROUP BY VendorName, InvoiceNumber, InvoiceDate, InvoiceTotal;

--9
WITH MaxTable AS
(
  SELECT MAX(InvoiceTotal) AS MaxInvoice
  FROM Invoices
  WHERE InvoiceTotal - PaymentTotal - CreditTotal > 0
  GROUP BY VendorID
)
SELECT SUM(MaxInvoice) AS Unpaid
FROM MaxTable;





