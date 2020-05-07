library(RMySQL)
library(ggplot2)
library(GGally)
connection<-dbConnect(MySQL(), user='root', password='password', dbname='classicModels', host='localhost', port=3306)
dbListTables(connection)

# 1. Visualize in blue the number of items for each product scale.
prodScale <- dbSendQuery(connection, 
                             "select productscale, count(productcode) as Count 
                             from products 
                             group by productscale")
res_prodScale <- fetch(prodScale, n=-1)
res_prodScale

ggplot(data=res_prodScale, mapping=aes(x=productscale, y=Count)) +
  geom_bar(stat="identity",fill=c("blue"))


# 2. Prepare a line plot with appropriate labels for total payments for each month in 2004.
payment2004Months <- dbSendQuery(connection, 
                                     "select left(paymentdate, 7) as Months, sum(amount) as Total_Payment
                                     from payments
                                     where year(paymentdate)=2004
                                     group by Months
                                     order by Months")
res_payment2004Months <- fetch(payment2004Months, n=-1)
res_payment2004Months

ggplot(data=res_payment2004Months, mapping=aes(x=Months, y=Total_Payment)) + 
  geom_line(stat="identity") +
  geom_point()


# 3. Create a histogram with appropriate labels for the value of orders received from the Nordic countries (Denmark,Finland, Norway,Sweden).
orderValue_Nordic <- dbSendQuery(connection, 
                                 "select Country, sum(priceeach*quantityordered) as Order_Value 
                                 from customers c, orders o, orderdetails d
                                 where c.customernumber=o.customernumber
                                 and o.ordernumber=o.ordernumber
                                 and c.country in ('Denmark', 'Finland', 'Norway', 'Sweden')
                                 group by country")
res_orderValue_Nordic <- fetch(orderValue_Nordic, n=-1)
res_orderValue_Nordic

ggplot(data=res_orderValue_Nordic, mapping=aes(x=Country, y=Order_Value)) +
  geom_histogram(stat="identity")


# 4. Create a heatmap for product lines and Norwegian cities.
prodLine_Norwegian <- dbSendQuery(connection, 
                                  "select city, productline, count(productline) as freq
                                  from customers c, orders o, orderdetails d, products p
                                  where c.customernumber=o.customernumber
                                  and o.ordernumber=d.ordernumber
                                  and d.productcode=p.productcode
                                  and country='Norway'
                                  group by city, productline
                                  order by city")
res_prodLine_Norwegian <- fetch(prodLine_Norwegian, n=-1)
res_prodLine_Norwegian

ggplot(data=res_prodLine_Norwegian, mapping=aes(x=productline, y=city)) +
  geom_tile(aes(fill=freq))


# 5. Create a parallel coordinates plot for product scale, quantity in stock, and MSRP in the Products table.
prodInfo <- dbSendQuery(connection, 
                        "select productname, productscale, quantityinstock, msrp
                        from products")
res_prodInfo <- fetch(prodInfo, n=-1)
res_prodInfo

ggparcoord(data=res_prodInfo, columns=c(2,3,4), groupColumn=4)


