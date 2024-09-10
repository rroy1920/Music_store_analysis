create database music_database;
use  music_database;
select * from artist;

select count(artist_id) from  artist;

select * from album2;

select *from employee order by levels limit 1;


select count(*) as c, billing_country from invoice 
group by billing_country
order by c desc;


select sum(total) as c , billing_city from invoice group by billing_city
order by c desc limit 1;

select customer.customer_id,
sum(invoice.total) as total from customer
 join invoice on customer.customer_id= invoice.customer_id
group by customer.customer_id
order by total desc;

select distinct email,first_name, last_name from customer
join invoice  on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id= invoice_line.invoice_id
where track_id in(
select track_id from track
join genre on track.genre_id= genre.genre_id
where genre.name like'Rock')
order by email;


select name, milliseconds from track
where milliseconds >=(
select avg(milliseconds) as avg_track_length from track)
order by milliseconds;


select artist. artist_id, artist.anme, count(artist.artist_id) as number_of_songs
from track
join album2 on album2.album_id = track.album_id;



with popular_genre as
(
select count(invoice_line.quantity) as purchases,customer.country,genre.name,
genre.genre_id,row_number() over (partition by customer.country 
order by count(invoice_line.quantity) desc) as row_no
from invoice_line
join invoice on invoice.invoice_id= invoice_line.invoice_id
join customer on customer.customer_id=invoice.customer_id
join track on track.track_id=invoice_line.track_id
join genre on genre.genre_id= track.genre_id
group by 2,3,4
order by 2 asc,1 desc
)
select * from popular_genre where row_no <=1;


with customer_with_country as ( 
select customer.customer_id , first_name, last_name , billing_country,
sum(total) as total_spending,
row_number() over( partition by billing_country order by sum(total) desc) as row_no
from invoice 
join customer on customer.customer_id = invoice.customer_id
group by 1,2,3,4
 order by 4 asc,5 desc
 )
 select * from customer_with_country where row_no <= 1;

