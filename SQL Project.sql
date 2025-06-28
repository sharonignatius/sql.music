use music_data;
select*from invoice;
#senior most employee based on job title
select * 
from employee
order by levels desc
limit 1;

#which country has the most invoices
select billing_country,count(total) as total
from invoice
group by billing_country
order by total desc
;

#top three values of total invoice
select total
from invoice
order by total desc
limit 3;

#city that has the best customers
select i.billing_city,sum(i.total) as total
from customer c
join invoice i
on c.customer_id=i.customer_id
group by i.billing_city
order by total desc;

#best customer who spent the most money
select c.customer_id, c.first_name, c.last_name, sum(i.total) as total_amount
from customer c
join invoice i
on c.customer_id=i.customer_id
group by 1,2,3
order by 4 desc
limit 1;

#details of all rock music listeners
select distinct c.email, c.first_name,c.last_name
from customer c
join invoice i on c.customer_id=i.customer_id
join invoice_line il on i.invoice_id=il.invoice_id
join track t on t.track_id=il.track_id
join genre g on g.genre_id=t.genre_id
where g.name='rock'
order by c.email;

#artists who've written the most rock music
select a.artist_id,a.name,count(a.artist_id) as total_count
from artist a
join album al on a.artist_id=al.artist_id
join track t on t.album_id=al.album_id
join genre g on g.genre_id=t.genre_id
where g.name='rock'
group by a.artist_id,a.name
order by total_count desc;

#track names that have song length higher than average song length
select name,milliseconds
from track 
where milliseconds>(select avg(milliseconds)
                    from track)
order by 2 desc;


#most popular genre
with popular_genre as (select g.genre_id,c.country,g.name,sum(quantity),
row_number() over (partition by c.country order by sum(quantity) desc) as max_quantity
from customer c
join invoice i on i.customer_id=c.customer_id
join invoice_line il on il.invoice_id=i.invoice_id
join track t on t.track_id=il.track_id
join genre g on g.genre_id=t.genre_id
group by 1,2,3
order by 2 desc
)
select * from popular_genre where max_quantity=1;

#customer who spent most money on music for each country
with cte as (select c.customer_id,c.first_name,c.last_name, i.billing_country,sum(i.total) as total_spent,
row_number() over (partition by billing_country order by sum(i.total)desc) as row_num
from customer c
join invoice i on i.customer_id=c.customer_id
group by 1,2,3,4
order by 5 desc)
select * from cte where row_num=1;








