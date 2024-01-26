SELECT JSON_OBJECT(
"Name",CONCAT(c.firstName," ", c.lastName),
"Email",c.email,
"Address",CONCAT(c.address1," - ",c.zip),

"Orders",( json_arrayagg(JSON_OBJECT("datePlaced",o.datePlaced,
 "dateShipped",o.dateShipped,
 "products",
(
 SELECT (json_arrayagg(JSON_OBJECT("productName",p.`name`, "quantity",ol.quantity,
 "unitPrice",ol.unitPrice, "lineTotal",ol.lineTotal)))


FROM `order` o1
JOIN orderline ol ON
o1.ID=ol.orderID
JOIN product p ON
ol.productID=p.ID 
WHERE o1.ID=o.ID)))))

INTO OUTFILE 'milestone.json'
FROM `order` o
JOIN customer c
ON c.ID=o.customerID
GROUP BY c.ID;
