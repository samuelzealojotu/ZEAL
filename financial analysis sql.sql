CREATE TABLE fact_sales_monthly (
    date DATE,
    product_code VARCHAR(20),
    sold_quantity INT,
    customer_code INT
);

INSERT INTO fact_sales_monthly (date, product_code, sold_quantity, customer_code) VALUES
('2021-01-15', 'P001', 100, 90002002),
('2021-05-20', 'P002', 150, 90002002),
('2021-08-22', 'P003', 200, 90002002),
('2021-11-10', 'P004', 250, 90002002),
('2022-02-14', 'P001', 120, 90002002),
('2022-06-18', 'P002', 130, 90002002);

SELECT * FROM fact_sales_monthly;

CREATE TABLE dim_product (
    product_code VARCHAR(20),
    product VARCHAR(100),
    variant VARCHAR(50)
);

INSERT INTO dim_product (product_code, product, variant) VALUES
('P001', 'Product A', 'Variant 1'),
('P002', 'Product B', 'Variant 2'),
('P003', 'Product C', 'Variant 3'),
('P004', 'Product D', 'Variant 4');

SELECT * FROM dim_product;

CREATE TABLE fact_gross_price (
    fiscal_year INT,
    product_code VARCHAR(20),
    gross_price DECIMAL(10, 2)
);

INSERT INTO fact_gross_price (fiscal_year, product_code, gross_price) VALUES
(2021, 'P001', 20.50),
(2021, 'P002', 30.75),
(2021, 'P003', 40.00),
(2021, 'P004', 50.25),
(2022, 'P001', 22.00),
(2022, 'P002', 32.50);

SELECT * FROM fact_gross_price;

CREATE FUNCTION get_fiscal_year(input_date DATE)
RETURNS INT
DETERMINISTIC
RETURN YEAR(input_date);


CREATE TABLE fact_sales_monthly (
    date DATE,
    fiscal_year INT,
    product_code VARCHAR(20),
    customer_code INT,
    sold_quantity INT
);

INSERT INTO fact_sales_monthly (date, fiscal_year, product_code, customer_code, sold_quantity) VALUES
('2021-01-15', 2021, 'P001', 90002002, 100),
('2021-05-20', 2021, 'P002', 90002002, 150),
('2020-08-22', 2020, 'P003', 90002002, 200),
('2020-11-10', 2020, 'P004', 90002002, 250);


SELECT 
    	    s.date, 
            s.product_code, 
            p.product, 
            p.variant, 
            s.sold_quantity, 
            g.gross_price,
            ROUND(s.sold_quantity*g.gross_price,2) as gross_price_total
	FROM fact_sales_monthly s
	JOIN dim_product p
            ON s.product_code=p.product_code
	JOIN fact_gross_price g
            ON g.fiscal_year=get_fiscal_year(s.date)
    	AND g.product_code=s.product_code
	WHERE 
    	    customer_code=90002002 AND 
            get_fiscal_year(s.date)=2021     
	LIMIT 1000000;
    
     # Croma Monthly Sales Report For All Years
 
 SELECT 
            s.date, 
    	    SUM(ROUND(s.sold_quantity*g.gross_price,2)) as monthly_sales
	FROM fact_sales_monthly s
	JOIN fact_gross_price g
        ON g.fiscal_year=get_fiscal_year(s.date) AND g.product_code=s.product_code
	WHERE 
             customer_code=90002002
	GROUP BY s.dateget_monthly_gross_sales_for_customer
    ORDER BY s.date;
    
SELECT 
    get_fiscal_year(s.date) AS Fiscal_Year, 
    SUM(ROUND(s.sold_quantity * g.gross_price, 2)) AS Total_Gross_Sales
FROM 
    fact_sales_monthly s
JOIN 
    fact_gross_price g
    ON g.fiscal_year = get_fiscal_year(s.date)
    AND g.product_code = s.product_code
WHERE 
    customer_code = 90002002
GROUP BY 
    get_fiscal_year(s.date)
ORDER BY 
    Fiscal_Year;
    
    # Market Badge based on Performance

SELECT 
	SUM(sold_quantity) as Total_qty_sold
	FROM fact_sales_monthly s
    JOIN dim_customer c 
    ON s.customer_code = c.customer_code
    WHERE get_fiscal_year(s.date) = 2021 AND c.market = "India"
    GROUP BY c.market;
    
-- Create the `fact_sales_monthly2` table
-- Create the `fact_forecast_monthly` table
CREATE TABLE fact_forecast_monthly (
    date DATE,
    fiscal_year INT,
    product_code VARCHAR(20),
    customer_code INT,
    forecast_quantity INT
);

-- Insert sample data into `fact_forecast_monthly`
INSERT INTO fact_forecast_monthly (date, fiscal_year, product_code, customer_code, forecast_quantity) VALUES
('2021-01-15', 2021, 'P001', 90002002, 120),
('2021-05-20', 2021, 'P002', 90002002, 160),
('2020-08-22', 2020, 'P003', 90002002, 210),
('2020-11-10', 2020, 'P004', 90002002, 260);











