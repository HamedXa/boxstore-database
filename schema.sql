/** Name: Hamed Sharafeldin
  
  ** Date:2023-04-05
  
  **                         
**/


-- DROP/CREATE/USE database -----------------------------------------------------

DROP DATABASE IF EXISTS hs_0394114_boxstore;
CREATE DATABASE IF NOT EXISTS hs_0394114_boxstore
CHARSET = 'utf8mb4'
COLLATE = 'utf8mb4_unicode_ci';

USE hs_0394114_boxstore;

-- Alert/Drop constraints for table "people" ------------------------------------------
ALTER TABLE IF EXISTS people DROP CONSTRAINT IF EXISTS people_gat_addr_type_id_Fk;
ALTER TABLE IF EXISTS people DROP CONSTRAINT IF EXISTS people_gtc_tc_id_Fk;
-- DROP/CREATE/VERIFY table -----------------------------------------------------

DROP TABLE IF EXISTS people;
CREATE TABLE people(
  p_id INT(11) AUTO_INCREMENT
  , full_name VARCHAR(100) NULL
  , PRIMARY KEY (p_id)
);
-- verification -----------------------------------------------------
DESCRIBE people;

SELECT p_id, full_name 
FROM people 
WHERE 1=1;

-- reset and INSERT 2 rows in people TABLE --------------------------

TRUNCATE TABLE people;

INSERT INTO people(full_name) VALUES ('Brad Vincelette');
INSERT INTO people(full_name) VALUES ('Hamed Sharafeldin');

-- verification-----------------------------------------------------
SELECT p_id, full_name
FROM people
WHERE 1=1;
--
-- import data file------------------------------------------------
LOAD DATA INFILE "./hs_0394114_boxstore-10000.csv"
INTO TABLE people(full_name);

-- verification----------------------------------------------------
SELECT p_id, full_name
FROM people
WHERE 1=1;


--
-- -- Alert Table Add new COLUMNS--------------------------------
ALTER TABLE people 
    ADD COLUMN first_name VARCHAR(40) NULL
    , ADD COLUMN last_name VARCHAR(60) NULL;

--
-- verification---------------------------------------------------
DESCRIBE people;
--

-- transfer data to new columns -------------------------------
UPDATE people 
SET first_name = MID(full_name, 1, INSTR(full_name,' ')-1)
   , last_name = MID(full_name, INSTR (full_name, ' ')+1
                     , LENGTH(full_name)-INSTR(full_name, ' ')
)
WHERE 1=1;

SELECT p_id, full_name, first_name, last_name
FROM people 
WHERE 1=1;
-- 


 
-- verification ----------------------------------------------------
DESCRIBE people;
SELECT p_id, first_name, last_name
FROM people 
WHERE 1=1;


-- ---------------- phase 2 -----------------------------------------
-- ---------------- Part A ------------------------------------------

-- ALTER/DESCRIBE table DROP/MODIFY/ADD COLUMNS ---------------------

ALTER TABLE people
    DROP COLUMN full_name
    
    , MODIFY COLUMN first_name VARCHAR(30)
    , MODIFY COLUMN last_name VARCHAR(30)
-- --------- login information--------------------------------------    
    , ADD COLUMN email_addr VARCHAR(50) 
    , ADD COLUMN password CHAR(32)
-- --------- Contact information--------------------------------------    
    , ADD COLUMN phone_pri VARCHAR(15)
    , ADD COLUMN phone_sec VARCHAR(15)
    , ADD COLUMN phone_wrk VARCHAR(15)
-- --------- Adress information--------------------------------------        
    , ADD COLUMN suite_no VARCHAR(10)         -- apartment NO
    , ADD COLUMN addr VARCHAR(60)             -- Adress 
    , ADD COLUMN addr_code CHAR (7)           -- postal code
    , ADD COLUMN addr_info VARCHAR(19) 		  
    , ADD COLUMN addr_type_id SMALLINT		 -- BUILDING TYPE house[1], apartment[2], basement[3], warehouse[4]
    , ADD COLUMN tc_id INT                   -- FK FOR the town city TABLE
    , ADD COLUMN delivery_info TEXT          -- special instructor for delivery
    
    , ADD COLUMN employee BIT NOT NULL DEFAULT 0 -- bit IMPLIES THAT we ARE weither employee (1), AND 0 means customer
    , ADD COLUMN user_id INT NULL DEFAULT 0      -- p_id OF the record
    
    , ADD COLUMN date_mod DATETIME NOT NULL DEFAULT NOW()
    , ADD COLUMN date_act DATETIME NOT NULL DEFAULT NOW()
    , ADD COLUMN active BIT NOT NULL DEFAULT 1
;
DESCRIBE people;

--  ----------------- Part B ------------------------------------------
-- ---------------- UPDATE TABLE   ------------------------------------
-- ---------------- UPDATE MANAGER INFO--------------------------------
UPDATE people 
SET email_addr= 'brad.vincelette@boxstore.com'
     , password = MD5('hahahaha')
     , phone_pri = '12045768192'
     , phone_sec = '14310357322'
     , phone_wrk ='1204556891'
     , suite_no = NULL -- brad lives in a house
     , addr = '557 Lincoln St'
     , addr_code = 'R2K 7P3'
     , addr_info = 'PO BOX 12234'
     , addr_type_id = 1 -- house
     , tc_id = 1
     , delivery_info = NULL 
     , employee = 1
     , user_id = 1 
     , date_mod = NOW()
WHERE p_id = 1;
  
-- UPDATE TABLE AND MY INFO-------------------------------------------
UPDATE people 
SET email_addr= 'hamed.sharafeldin@boxstore.com'
     , password = MD5('Say LoL')
     , phone_pri = '12045768192'
     , phone_sec = '14310357322'
     , phone_wrk ='1204556891'
     , suite_no = '2057' 
     , addr = '400 Webb Pl'
     , addr_code = 'R2K 7P3'
     , addr_info = 'PO BOX 12234'
     , addr_type_id = 2 -- apartment
     , tc_id = 1
     , delivery_info = 'Call me when you arrive'
     , employee = 1
     , user_id = 1 -- your employer (p_id of manager)
     , date_mod = NOW()
WHERE p_id = 2;
     
-- ---------------------PART C--------------------------------------------
-- -------------- verification--------------------------------------------
SELECT p.p_id, p.first_name, p.last_name
	   , p.email_addr, p.password, p.phone_pri, p.phone_sec, p.phone_wrk
       , p.suite_no, p.addr, p.addr_code, p.addr_info, p.delivery_info
       , p.addr_type_id, p.tc_id
       , p.employee, p.user_id, p.date_mod, p.date_act, p.active
FROM people p
LIMIT 2;


-- ---------------PART D -------------------------------------
-- ---DROP/CREATE/TRUNCATE/INSERT/SELECT - TABLE--------------
-- geo_address_type (ga)--------------------------------------
ALTER TABLE IF EXISTS manufacturer DROP CONSTRAINT IF EXISTS manufacturer_addr_type_id_FK;

DROP TABLE IF EXISTS geo_address_type;
CREATE TABLE IF NOT EXISTS geo_address_type (
    addr_type_id TINYINT AUTO_INCREMENT 
    , addr_type VARCHAR(15) UNIQUE -- house[1], apartment[2], basement[3], warehouse[4]
    , active BIT NOT NULL DEFAULT 1
    , PRIMARY KEY (addr_type_id)
);
-- ---Reast and INSERT----------------------------------------
TRUNCATE TABLE geo_address_type;
INSERT INTO geo_address_type (addr_type)
VALUES                       ('House')  -- 1
                             ,('Apartment') -- 2
                             ,('Basement') -- 3
                             ,('Warehouse');  -- 4
                             
                             
SELECT gat.addr_type_id, gat.addr_type, gat.active
FROM geo_address_type gat;

-- Foreign JOIN ---------------------------------------------
SELECT p.p_id, p.first_name, p.last_name, p.addr_type_id
	 , gat.addr_type_id, gat.addr_type
FROM people p
	 JOIN geo_address_type gat ON p.addr_type_id=gat.addr_type_id
;

  


-- geo_country (gc)--------------------------------------------
DROP TABLE IF EXISTS geo_country;
CREATE TABLE IF NOT EXISTS geo_country (
 c_id  TINYINT (11) AUTO_INCREMENT   
 , c_name VARCHAR(35)
 , c_code CHAR(2)
 , active BIT NOT NULL DEFAULT 1
 , PRIMARY KEY (c_id)
 , UNIQUE KEY (c_name)
);

TRUNCATE TABLE geo_country;
INSERT INTO geo_country (c_name, c_code)
VALUES                  ('Canada', 'CA');

-- SELECT---------------------------------------------------
SELECT gc.c_id, gc.c_name, gc.c_code, gc.active
FROM geo_country gc;



-- geo_region (gr)------------------------------------------
DROP TABLE IF EXISTS geo_region;
CREATE TABLE IF NOT EXISTS geo_region (
    r_id SMALLINT AUTO_INCREMENT
    , r_name VARCHAR(35)
    , r_code CHAR(2)
    , c_id TINYINT NOT NULL DEFAULT 1
    , active BIT NOT NULL DEFAULT 1
    , PRIMARY KEY (r_id)
    , UNIQUE KEY (r_name, c_id)
);

TRUNCATE TABLE geo_region;
INSERT INTO geo_region (r_name, r_code, c_id)
VALUES                 ('Manitoba', 'MB', 1);

SELECT gr.r_id, gr.r_name, gr.r_code, gr.c_id, gr.active
FROM geo_region gr;


-- Foreign JOIN--------------------------------------------------
SELECT gr.r_id, gr.r_name, gr.r_code, gr.c_id
	 , gc.c_id, gc.c_name, gc.c_code
FROM geo_region gr
	 JOIN geo_country gc ON gr.c_id=gc.c_id
;


-- geo_towncity table (gtc)-------------------------------------
ALTER TABLE IF EXISTS manufacturer DROP CONSTRAINT IF EXISTS manufacturer_tc_id_FK;

DROP TABLE IF EXISTS geo_towncity;
CREATE TABLE IF NOT EXISTS geo_towncity (
 tc_id INT AUTO_INCREMENT
 , tc_name VARCHAR(35)
 , r_id SMALLINT NOT NULL
 , active BIT NOT NULL DEFAULT 1
 , PRIMARY KEY (tc_id)
 , UNIQUE KEY (tc_name, r_id)
);

TRUNCATE TABLE geo_towncity;
INSERT INTO geo_towncity(tc_name, r_id)
VALUES                   ('Winnipeg', 1);

-- SELECT-------------------------------------------------- 
SELECT gtc.tc_id, gtc.tc_name, gtc.r_id, gtc.active
FROM geo_towncity gtc;


-- Foreign JOIN------------------------------------------------------
SELECT gtc.tc_id, gtc.tc_name, gtc.r_id
	 , gr.r_id, gr.r_name, gr.r_code, gr.c_id
	 , gc.c_id, gc.c_name, gc.c_code
FROM geo_towncity gtc
	 JOIN geo_region gr ON gtc.r_id=gr.r_id
	 JOIN geo_country gc ON gr.c_id=gc.c_id
;



-- Envelope JOIN----------------------------------------
-- Part D Envelope --------------------------------------------------
ALTER TABLE IF EXISTS people DROP CONSTRAINT IF EXISTS people_gtc_tc_id_FK;
ALTER TABLE IF EXISTS people DROP CONSTRAINT IF EXISTS people_gat_addr_type_id_FK;

ALTER TABLE IF EXISTS people
	ADD CONSTRAINT people_gat_addr_type_id_FK FOREIGN KEY (addr_type_id) REFERENCES geo_address_type(addr_type_id);
ALTER TABLE IF EXISTS people
	ADD CONSTRAINT people_gtc_tc_id_FK FOREIGN KEY (tc_id) REFERENCES geo_towncity(tc_id);


SELECT p.p_id, p.first_name, p.last_name
     , p.suite_no, p.addr, p.addr_code, p.addr_info, p.delivery_info
     , p.addr_type_id, p.tc_id
     , gat.addr_type_id, gat.addr_type
     , gtc.tc_id, gtc.tc_name, gtc.r_id
     , gr.r_id, gr.r_name, gr.r_code, gr.c_id
     , gc.c_id, gc.c_name, gc.c_code
FROM people p
	 JOIN geo_address_type gat ON p.addr_type_id = gat.addr_type_id
	 JOIN geo_towncity gtc ON p.tc_id = gtc.tc_id
	 JOIN geo_region gr ON gtc.r_id = gr.r_id
	 JOIN geo_country gc ON gr.c_id = gc.c_id
LIMIT 2;






-- -----------------Part E------------------------------------
-- Drop/Create Table-------------------------------------------------
DROP TABLE IF EXISTS people_employee;
CREATE TABLE IF NOT EXISTS people_employee (
    pe_id               INT AUTO_INCREMENT   -- employee number SURROGATE KEY
    , p_id              INT                  -- FOREIGN KEY
    , p_id_mgr          INT                  -- NULL FOR p_id=1 and 1 for p_id=2
    , pe_uri            VARCHAR(60)          -- 'brad-vincelette' 'hamed-sharafeldin'
    , pe_sin            INT(9)               -- Social incurance number
    , date_beg          DATE                 -- hire date
    , date_end          DATE                 -- fire date = NULL for now
    , pe_wage           DECIMAL(7,2)         -- Employee Wage (PART-E)
    , bank_info         VARCHAR(10)          -- bank routing information (direct deposit info (PART-E)
    , user_id           INT                  NOT NULL DEFAULT 1
    , date_mod          DATETIME             NOT NULL DEFAULT NOW()
    , active            BIT                  NOT NULL DEFAULT 1
    , PRIMARY KEY(pe_id)
);

-- reset and INSERT in people`_employee-------------------------
TRUNCATE TABLE people_employee;
INSERT INTO people_employee (p_id, p_id_mgr, pe_uri, pe_sin
                            , date_beg, date_end, pe_wage, bank_info)                        
VALUES                      (1,NULL,'brad-vincelette', 283764729  
                            , '1999-10-22', NULL, 100000/12, 3901738949);
                            
INSERT INTO people_employee (p_id, p_id_mgr, pe_uri, pe_wage, pe_sin
                            , date_beg, date_end, bank_info)                        
VALUES                      (2,1,'Hamed-Sharafeldin', 55000/12, 982746374
                            , '2016-06-11', NULL, 8720374919);
SELECT pe.pe_id, pe.p_id, pe.p_id_mgr
     , pe_uri, pe_wage, pe_sin
     , date_beg, date_end, bank_info
     , user_id, date_mod, active
FROM people_employee pe;


-- --------------PART F------------------------------------------
SELECT pe.pe_id, pe.p_id, pe.p_id_mgr
	 , p.p_id, p.first_name, p.last_name
	 , m.p_id, m.first_name, m.last_name
FROM people_employee pe
	 RIGHT JOIN people p ON pe.p_id=p.p_id
	 LEFT JOIN people m ON pe.p_id_mgr=m.p_id
LIMIT 10;


/*-- to the cheatsheet
 
SELECT p.p_id, p.first_name, p.last_name
       , e.p_id, e.p_id_mgr, e.pe_uri, e.pe_wage, e.pe_sin
       , e.date_beg, e.date_end, e.bank_info
FROM people p
LEFT JOIN people_employee e 
ON p.p_id = e.p_id
UNION
SELECT p.p_id, p.first_name, p.last_name
       , e.p_id, e.p_id_mgr, e.pe_uri, e.pe_wage, e.pe_sin
       , e.date_beg, e.date_end, e.bank_info
FROM people p
RIGHT JOIN people_employee e 
ON p.p_id = e.p_id
LIMIT 10;

*/





-- --------------PART G------------------------------------------


SELECT p.p_id, p.first_name, p.last_name
     , pe.pe_id, pe.p_id, pe.p_id_mgr
     , m.p_id, m.first_name, m.last_name
     , p.suite_no, p.addr, p.addr_code, p.addr_info, p.delivery_info
     , p.addr_type_id, p.tc_id
     , gat.addr_type_id, gat.addr_type
     , gtc.tc_id, gtc.tc_name, gtc.r_id
     , gr.r_id, gr.r_name, gr.r_code, gr.c_id
     , gc.c_id, gc.c_name, gc.c_code
FROM people p
	 JOIN people_employee pe   ON pe.p_id = p.p_id
	 LEFT JOIN people m        ON pe.p_id_mgr=m.p_id
	 JOIN geo_address_type gat ON p.addr_type_id = gat.addr_type_id
	 JOIN geo_towncity gtc     ON p.tc_id = gtc.tc_id
	 JOIN geo_region gr        ON gr.r_id = gtc.r_id
	 JOIN geo_country gc       ON gc.c_id = gr.c_id
LIMIT 2;


-- --------------------------------------------------------------------------------------------------------------------


	  
DROP TABLE IF EXISTS category;
CREATE TABLE IF NOT EXISTS category (
	  cat_id 		MEDIUMINT 	AUTO_INCREMENT
	, cat_id_parent MEDIUMINT 				-- FK
	, cat_name 		VARCHAR(60)
	, cat_abbr 		VARCHAR(10)
	, cat_uri 		VARCHAR(60)
	, taxonomy 		VARCHAR(15)
	, user_id 		INT 		NOT NULL DEFAULT 2 	-- FK
	, date_mod 		DATETIME 	NOT NULL DEFAULT CURRENT_TIMESTAMP
	, active 		BIT 		NOT NULL DEFAULT 1
	, CONSTRAINT category_PK PRIMARY KEY(cat_id)
	, CONSTRAINT category_UK UNIQUE (taxonomy ASC, cat_name ASC)
);

TRUNCATE TABLE category;
INSERT INTO category (cat_id_parent, cat_name, cat_abbr, cat_uri, taxonomy)
VALUES               	(NULL, 'Electronics', NULL, 'electronics', 'departments')
					  , (NULL, 'Sales', NULL, 'sales', 'departments');

SELECT cat.cat_id, cat.cat_id_parent, cat.cat_name
	 , cat.cat_abbr, cat.cat_uri, cat.taxonomy
     , cat.user_id, cat.date_mod, cat.active
FROM category cat
WHERE taxonomy='departments';


SELECT cat.cat_id, cat.cat_id_parent, cat.cat_name
	 , cat.cat_abbr, cat.cat_uri, cat.taxonomy
     , cat.user_id, cat.date_mod, cat.active
FROM category cat
WHERE taxonomy='departments';

-- -------------------------------category__people ------------------------------------------
ALTER TABLE IF EXISTS category__people DROP CONSTRAINT IF EXISTS cp_cat_FK;
ALTER TABLE IF EXISTS category__people DROP CONSTRAINT IF EXISTS cp_pe_FK;

DROP TABLE IF EXISTS category__people;
CREATE TABLE IF NOT EXISTS category__people (
	 cp_id 		INT AUTO_INCREMENT
	, cat_id 	MEDIUMINT 		-- FK
	, pe_id 	INT 			-- FK
	, user_id 	INT NOT NULL DEFAULT 2
	, date_mod 	DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
	, active 	BIT NOT NULL DEFAULT 1
	, CONSTRAINT cp_PK PRIMARY KEY(cp_id)
	, CONSTRAINT cp_UK UNIQUE (cat_id, pe_id)
);

TRUNCATE TABLE category__people;
INSERT INTO category__people (cat_id, pe_id)
VALUES                       (1, 2),(2, 1);

SELECT cp.cp_id, cp.cat_id, cp.pe_id
	 , cp.user_id, cp.date_mod, cp.active
FROM category__people cp;

	 
-- ------------ JOIN category to people -----------------------------------
SELECT cat.cat_id, cat.cat_name, cat.taxonomy, cat.cat_uri
	 , cp.cat_id, cp.pe_id             
	 , pe.pe_id, pe.pe_uri, pe.p_id    
	 , p.p_id, p.first_name, p.last_name
FROM category cat
	 JOIN category__people cp 	ON cat.cat_id=cp.cat_id
	 JOIN people_employee pe 	ON cp.pe_id=pe.pe_id
	 JOIN people p  			ON pe.p_id=p.p_id
WHERE cat.taxonomy='departments';


SELECT cat.cat_id, cp.cat_id, cp.pe_id, p.p_id
	 , CONCAT('https://boxstore.com/',cat.taxonomy,'/',cat.cat_uri,'/',pe.pe_uri,'/') AS dept_permalink
	 , CONCAT('https://boxstore.com/staff/',pe.pe_uri,'/') AS emp_permalink
FROM category cat
	 JOIN category__people cp 	ON cat.cat_id=cp.cat_id
	 JOIN people_employee pe 	ON cp.pe_id=pe.pe_id
	 JOIN people p  			ON pe.p_id=p.p_id
WHERE cat.taxonomy='departments';


ALTER TABLE category__people
	  ADD CONSTRAINT cp_cat_FK 	FOREIGN KEY (cat_id) 	REFERENCES category(cat_id);
ALTER TABLE category__people
	  ADD CONSTRAINT cp_pe_FK 	FOREIGN KEY (pe_id) 	REFERENCES people_employee(pe_id);
	 
-- -----------------------------manufacturer (man) ----------------------------------------------------
ALTER TABLE IF EXISTS manufacturer 	  DROP CONSTRAINT IF EXISTS man_people_FK;
ALTER TABLE IF EXISTS manufacturer	  DROP CONSTRAINT IF EXISTS man_gtc_tc_id_FK;
ALTER TABLE IF EXISTS manufacturer	  DROP CONSTRAINT IF EXISTS man_gat_FK;
									
DROP TABLE IF EXISTS manufacturer;
CREATE TABLE IF NOT EXISTS manufacturer(
	 man_id				INT AUTO_INCREMENT  -- PK > FK (item.man_id)
	 , man_name 		VARCHAR(35)
	 , p_id_man			INT
	 , phone_pri		VARCHAR(15)
	 , phone_sales		VARCHAR(15)
	 , phone_sup		VARCHAR(15)
	 , phone_fax		VARCHAR(15)
	 , suite_no			VARCHAR(10)		
	 , addr				VARCHAR(60)		-- address
	 , addr_code		CHAR(7)			-- postal code 
	 , addr_info		VARCHAR(191)	
	 , delivery_info 	VARCHAR(191)	-- additional info
	 , addr_type_id		INT(20)		 	
	 , tc_id			INT				-- FK to tc TABLE
	 , user_id			INT NOT NULL DEFAULT 2 -- FK
	 , date_mod			DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
	 , active			BIT NOT NULL DEFAULT 1
	 , CONSTRAINT man_PK PRIMARY KEY(man_id)
	 , CONSTRAINT man_UK UNIQUE (man_name)
);


TRUNCATE TABLE manufacturer;
INSERT INTO manufacturer 	  (man_name, p_id_man
							, phone_pri, phone_sales, phone_sup, phone_fax
							, addr, addr_code, addr_info, addr_type_id, tc_id)
VALUES 					  ('EDBTZ.', 3
							, '222-222-222', '333-333-333', '444-444-444', '555-555-555'
							, 'shahi st', 'Bla Bla', NULL, 1, 2)
	 					, ('RRC Co.', 4
							, '222-222-223', '333-333-334', '444-444-445', '555-555-556'
							, 'webb place', '400', NULL, 3, 4)
						, ('Sony Inc.', 5
							, '222-222-224', '333-333-335', '444-444-446', '555-555-557'
							, '160 Princes Street', 'YEY EYE', NULL, 2, 1)
						;
-- ---------------------------------------join-------------------------------------------------------						
SELECT 	  man.man_id, man.man_name, man.p_id_man
		, man.phone_pri, man.phone_sales, man.phone_sup, man.phone_fax
		, man.suite_no, man.addr, man.addr_code
		, man.addr_info, man.delivery_info
		, man.addr_type_id, man.tc_id
		, man.user_id, man.date_mod, man.active
FROM manufacturer man;


SELECT 	  man.man_id, man.man_name
		, man.p_id_man
		, man.addr_type_id
		, man.tc_id
		, p.p_id, p.first_name, p.last_name
		, gat.addr_type_id, gat.addr_type
		, gtc.tc_id, gtc.tc_name
		, gr.r_id, gr.r_name
		, gc.c_id, gc.c_name
FROM manufacturer man
		JOIN people 			p		ON man.p_id_man = p.p_id
		JOIN geo_address_type 	gat		ON man.addr_type_id = gat.addr_type_id
		JOIN geo_towncity 		gtc		ON man.tc_id = gtc.tc_id
		JOIN geo_region 		gr		ON gtc.r_id = gr.r_id
		JOIN geo_country 		gc		ON gr.c_id = gc.c_id;

-- ----------------------------- ALTER Table / ADD  CONSTRAINT/FOREIGN KEY/ EFERENCES----------------------------------------------
ALTER TABLE manufacturer
	ADD CONSTRAINT man_people_FK 		FOREIGN KEY (p_id_man) 		REFERENCES people(p_id);
ALTER TABLE manufacturer
	ADD CONSTRAINT man_gtc_tc_id_FK 	FOREIGN KEY (tc_id) 		REFERENCES geo_towncity(tc_id);
	
	

--  -------------------------item  TABLE--------------------------------------------------------------------------------------------
-- --------------------------Alert/Drop/Create table----------------------------------------
ALTER TABLE IF EXISTS item DROP CONSTRAINT IF EXISTS item_man_FK;

DROP TABLE IF EXISTS item;
CREATE TABLE IF NOT EXISTS item (
	 item_id			INT 		AUTO_INCREMENT  -- PK > FK
	 , item_name 		VARCHAR(50) NOT NULL
	 , item_uri			VARCHAR(50) UNIQUE
	 , item_type		VARCHAR(25)
	 , item_modelno		VARCHAR(30)
	 , item_barcode		VARCHAR(18)
	 , item_uom			VARCHAR(10)
	 , item_size		DECIMAL(5,2)		
	 , item_price		DECIMAL(7,2)
	 , man_id			INT NOT NULL 			-- FK
	 , user_id			INT NOT NULL DEFAULT 2 	-- FK
	 , date_mod			DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
	 , active			BIT NOT NULL DEFAULT 1
	 , CONSTRAINT item_PK PRIMARY KEY(item_id)
	 , CONSTRAINT item_UK UNIQUE (item_name)
	 );
	
-- ---------------------- TRUNCATE/INSERT INTO VALUES ------------------------------------------------
TRUNCATE TABLE item;
INSERT INTO item (item_name, item_uri, item_type, item_modelno	
			   	, item_barcode, item_uom, item_size, item_price, man_id)
VALUES			 ('Black Whole Mat',REPLACE(LOWER('Black Whole Mat'),' ','-'),'street','BWM90210'
               	, '11223344556670','m2',1.00, 999.99, 1);
INSERT INTO item (item_name, item_uri, item_type, item_modelno	
			   	, item_barcode, item_uom, item_size, item_price, man_id)
VALUES			 ('Electric Wires', REPLACE(LOWER('Elecric Wires'),' ','-'), 'street', 'Acme90210'
                , NULL, 'foots', 82, 6.99, 1 )
                , ('TV', REPLACE(LOWER('Electronic Devices Smart TV'),' ','-'), 'Home', 'Sony Bravia 2657'
                , '11223344556675', 'inches', 55, 299.99, 1);
               	
SELECT i.item_id, i.item_name, i.item_uri, i. item_type, i.item_modelno	
	 , i.item_barcode, i.item_uom, i.item_size, i.item_price, i.man_id
	 , i.user_id, i.date_mod, i.active
FROM item i;

SELECT i.item_id, i.item_name, i.item_price	
	FROM item i;


SELECT man.man_id, man.man_name
	 , item_id, i.item_name, i.item_uri
FROM manufacturer man
	 JOIN item i ON man.man_id=i.man_id
;

ALTER TABLE item
	ADD CONSTRAINT item_man_FK FOREIGN KEY (man_id) REFERENCES manufacturer(man_id);


-- -------------------item detail TABLE (id) ------------------------------------------------------
ALTER TABLE IF EXISTS item_detail 	DROP CONSTRAINT IF EXISTS id_item_FK;

DROP TABLE IF EXISTS item_detail;
CREATE TABLE IF NOT EXISTS item_detail (
	 id_id				INT 		AUTO_INCREMENT
	 , item_id	 		INT 		NOT NULL
	 , id_label			VARCHAR(50) NOT NULL
	 , id_value			VARCHAR(50)	NOT NULL
	 , user_id			INT			NOT NULL DEFAULT 2 -- FK
	 , date_mod			DATETIME 	NOT NULL DEFAULT CURRENT_TIMESTAMP
	 , active			BIT 		NOT NULL DEFAULT 1
	 , CONSTRAINT id_PK 		PRIMARY KEY(id_id)
	 , CONSTRAINT idl_UK 		UNIQUE (item_id, id_label)
	 );
	
-- ---------------------- TRUNCATE/INSERT INTO VALUES ------------------------------------------------
	
TRUNCATE TABLE item_detail;
INSERT INTO item_detail (item_id, id_label, id_value)
VALUES				    (1,'Width','1m')
						, (1,'Depth','infinty')
						, (1,'Color','Black')
						, (1,'Shape','Circle')
						, (2,'Lenght','82 foots')
						, (2,'Type','Multifilar')
						, (2,'Color','Black & Red')
						, (2,'Capacity','14A')
						, (3,'width','55 inches')
						, (3,'Color','Black')
						, (3,'Shape','Rounded corners')
						, (3,'Resolution','16K');
						
SELECT id.id_id, id.item_id, id.id_label, id.id_value
	 FROM item_detail id;

SELECT man.man_id, man.man_name
	 , i.item_id, i.item_name, i.item_uri
	 , id.id_id, id.item_id, id.id_label, id.id_value
	 
FROM manufacturer man
	 JOIN item i 			ON man.man_id=i.man_id
	 JOIN item_detail id 	ON i.item_id=id.item_id
	;
ALTER TABLE item_detail
ADD CONSTRAINT id_item_FK 	FOREIGN KEY (item_id) REFERENCES item(item_id);

-- --------------------------item_metadesc(im) TABLE ------------------------------------------
-- --------------------------Alert/Drop/Create table-------------------------------------------

ALTER TABLE IF EXISTS item_metadesc DROP CONSTRAINT IF EXISTS im_item_FK;

DROP TABLE IF EXISTS item_metadesc;
CREATE TABLE IF NOT EXISTS item_metadesc (
	  im_id 			BIGINT 		AUTO_INCREMENT
	, item_id 			INT							-- FK1
	, im_description 	TEXT
	, user_id 			INT 		NOT NULL DEFAULT 2		-- FK
	, date_mod 			DATETIME 	NOT NULL DEFAULT CURRENT_TIMESTAMP
	, active 			BIT 		NOT NULL DEFAULT 1			-- FK1
	, PRIMARY KEY (im_id)
	);

TRUNCATE TABLE item_metadesc;
INSERT INTO item_metadesc (item_id, im_description)
VALUES 		(1, 'A black dot, used like a mat, to send someone into the abyss.')
		, (2, 'Wires to activate the hole remotly aunexpectly while Cayotee shows up.')
		, (3, 'TV to watch how Cayote falls into the abyss');

SELECT 	im.im_id, im.item_id, im.im_description
		, im.user_id, im.date_mod, im.active
FROM 	item_metadesc im;

ALTER TABLE item_metadesc
ADD CONSTRAINT im_item_FK FOREIGN KEY (item_id) REFERENCES item(item_id);

-- --------------------------item_price(ip) TABLE ------------------------------------------
-- --------------------------Alert/Drop/Create table----------------------------------------

ALTER TABLE IF EXISTS item_price 	DROP CONSTRAINT IF EXISTS ip_item_FK;

DROP TABLE IF EXISTS item_price;
CREATE TABLE IF NOT EXISTS item_price (
	  ip_id 	BIGINT 		AUTO_INCREMENT
	, item_id 	INT 									-- FK
	, ip_beg 	DATETIME 	NULL
	, ip_end 	DATETIME 	NULL
	, ip_price 	DECIMAL(7,2)
	, user_id 	INT 		NOT NULL DEFAULT 	2 		-- FK
	, date_mod 	DATETIME 	NOT NULL DEFAULT NOW()
	, active 	BIT 		NOT NULL DEFAULT 1
	, PRIMARY KEY (ip_id)
	, CONSTRAINT ip_item_FK FOREIGN KEY (item_id) REFERENCES item(item_id)
);

TRUNCATE TABLE item_price;
INSERT INTO item_price 	(item_id, ip_price, ip_beg, ip_end)
VALUES					(1, 999.99, '2023-03-01 00:00:00', '2023-04-07 23:59:59')	-- REGULAR price end 
					  , (1, 899.99, '2023-03-24 00:00:00', '2023-03-31 23:59:59' )	-- sale price end 
					  , (1, 799.99, '2023-04-08 00:00:00', NULL)					-- REGUALR 
					  , (2, 6.99, '2023-03-02 00:00:00', '2023-04-07 23:59:59')	    -- REGUALR prce end
					  , (2, 5.99, '2023-03-25 00:00:00', '2023-03-31 23:59:59' )	-- sale price end 
					  , (2, 4.99, '2023-04-01 00:00:00', NULL)					    -- REGUALR 
					  , (3, 299.99, '2023-03-02 00:00:00', '2023-04-07 23:59:59' )	-- sale price end 
					  , (3, 289.99, '2023-03-24 00:00:00', '2023-03-31 23:59:59' )	-- sale price end 
					  , (3, 279.99, '2023-04-01 00:00:00', NULL);					-- REGULAR					
					  
SELECT 	  ip.ip_id, ip.item_id, ip.ip_beg, ip.ip_end, ip.ip_price
		, ip.user_id, ip.date_mod, ip.active
FROM item_price ip;


-- ----------------------------------------tax TABLE --------------------------------
-- --------------------------Drop/Create table----------------------------------------

DROP TABLE IF EXISTS tax;
CREATE TABLE IF NOT EXISTS tax(
	  tax_id 	SMALLINT 	AUTO_INCREMENT
	, tax_type 	CHAR(3)
	, tax_beg 	DATE
	, tax_end 	DATE
	, tax_perc 	DECIMAL(4,2)
	, user_id 	INT 		NOT NULL DEFAULT 2 			-- FK
	, date_mod 	DATETIME 	NOT NULL DEFAULT CURRENT_TIMESTAMP
	, active 	BIT 		NOT NULL DEFAULT 1
	, PRIMARY KEY (tax_id)
);

TRUNCATE TABLE tax;
-- bulk insert
INSERT INTO tax   (tax_type, tax_beg, tax_end, tax_perc)
VALUES			  ('GST', '2017-02-12', NULL, 5.00)
				, ('PST', '2017-02-16', NULL, 7.00);

SELECT 	  t.tax_id, t.tax_type, t.tax_beg, t.tax_end, t.tax_perc
		, t.user_id, t.date_mod, t.active
FROM tax t;


-- ---------------------------orders(o) ----------------------------------------------------
-- --------------------------Alert/Drop/Create table----------------------------------------

ALTER TABLE IF EXISTS orders 				DROP CONSTRAINT IF EXISTS oi_orders_FK;
ALTER TABLE IF EXISTS order__transactions 	DROP CONSTRAINT IF EXISTS ot_order_FK;

ALTER TABLE IF EXISTS people DROP CONSTRAINT IF EXISTS orders_p_cust_FK;
ALTER TABLE IF EXISTS people DROP CONSTRAINT IF EXISTS orders_p_emp_FK;

DROP TABLE IF EXISTS orders;
CREATE TABLE IF NOT EXISTS orders (
	 order_id			INT 		AUTO_INCREMENT  -- PK > FK (item_detail.item_id)
	 , order_num 		VARCHAR(15) NOT NULL 	UNIQUE
	 , order_date		DATETIME
	 , order_credit		DECIMAL(7,2)			-- 10% OR $10.00
	 , order_cr_uom		CHAR(1)					-- % OR $	
	 , order_override	DECIMAL(7,2)            -- 99999.99
	 , order_atm_tnd 	DECIMAL(7,2)			-- 99999.99
	 , order_type		VARCHAR(10)				-- instore, online, po
	 , order_notes		VARCHAR(191)		
	 , p_id_cust		INT
	 , p_id_emp			INT 		NOT NULL 			-- FK
	 , user_id			INT 		NOT NULL DEFAULT 2 	-- FK
	 , date_mod			DATETIME 	NOT NULL DEFAULT CURRENT_TIMESTAMP
	 , active			BIT 		NOT NULL DEFAULT 1
	 , CONSTRAINT orders_PK PRIMARY KEY(order_id)
	 , CONSTRAINT orders_UK UNIQUE (order_date, p_id_cust)
	);

TRUNCATE TABLE orders;
INSERT INTO orders(order_num, order_date, order_credit, order_cr_uom	
			   	  , order_override, order_type, p_id_cust, p_id_emp
			   	  , order_notes)
VALUES			  ('000000000000001', '2023-03-12 11:00:32', NULL, '$'
               	  		, NULL,'online', 4, 2
                  		, 'Final Sale')
                , ('000000000000002', '2023-03-24 11:00:32', NULL, '%'
               	  		, NULL,'online', 5, 3
                  		, 'Final Sale')
                , ('000000000000003', '2023-03-25 11:00:32', NULL, '%'
               	  		, NULL,'online', 6, 4
                  		, 'Final Sale');             	
SELECT o.order_id, o.order_num, o.order_date, o.order_credit, o.order_cr_uom	
	 , o.order_override, o.order_type, o.p_id_cust, o.p_id_emp, o.order_notes
	 , o.user_id, o.date_mod, o.active
FROM orders o;		

-- --------------------------orders__item(oi) TABLE ----------------------------------------
-- --------------------------Alert/Drop/Create table----------------------------------------

ALTER TABLE IF EXISTS orders__item 	DROP CONSTRAINT IF EXISTS oi_i_FK;
ALTER TABLE IF EXISTS orders__item 	DROP CONSTRAINT IF EXISTS oi_o_FK;

DROP TABLE IF EXISTS orders__item;
CREATE TABLE IF NOT EXISTS orders__item (
	  oi_id 			BIGINT 		AUTO_INCREMENT
	, order_id 			INT						-- FK
	, item_id 			INT 					-- FK
	, oi_serial_number	INT						-- UK1
	, oi_qty 			SMALLINT
	, oi_status 		VARCHAR(25)				-- available. delivery
	, oi_override 		DECIMAL(9,2)			-- dollar amount
	, user_id 			INT 		NOT NULL DEFAULT 2	-- FK
	, date_mod 			DATETIME 	NOT NULL DEFAULT CURRENT_TIMESTAMP
	, active 			BIT 		NOT NULL DEFAULT 1
	, PRIMARY KEY (oi_id)
	, CONSTRAINT oi_UK UNIQUE (order_id, item_id, oi_serial_number)
	);

TRUNCATE TABLE orders__item;
INSERT INTO orders__item (order_id, item_id, oi_qty, oi_status, oi_override)

VALUES	(1, 1, 1, 'Available', NULL)
		   , (1, 2, 82, 'Available', NULL)
		   , (1, 3, 3, 'Available', NULL)
		,(2, 1, 1, 'Available', NULL)
		   , (2, 2, 100, 'Available', NULL)
		   , (2, 3, 5, 'Available', NULL)
		,(3, 1, 1, 'Available', NULL)
		   , (3, 2, 120, 'Available', NULL)
		   , (3, 3, 1, 'Available', NULL);

SELECT 	  oi.oi_id, oi.order_id, oi.item_id
		, oi.oi_qty, oi.oi_status, oi.oi_override
		, oi.user_id, oi.date_mod, oi.active
FROM orders__item oi;	

-- -------------------------------Rebuild onto using orders.order_date----------------
SELECT 	  fake.order_date
		, i.item_id, i.item_price
		, MAX(ip.ip_price) AS ip_price_reg
		, CASE 	WHEN MIN(ip.ip_price)= MAX(ip.ip_price) 
				THEN 0 
				ELSE MIN(ip.ip_price) 
				END AS ip_price_sale
FROM item i
	JOIN item_price ip ON i.item_id = ip.item_id
	, (SELECT '2023-03-31 11:00:00' AS order_date) fake
WHERE fake.order_date BETWEEN ip.ip_beg AND IFNULL(ip_end, fake.order_date)
GROUP BY i.item_id -
;


ALTER TABLE orders__item
	ADD CONSTRAINT oi_i_FK FOREIGN KEY (item_id) REFERENCES item(item_id);
ALTER TABLE orders__item
	ADD CONSTRAINT oi_o_FK FOREIGN KEY (order_id) REFERENCES orders(order_id);

-- --------------------------transactions(t) TABLE -----------------------------------------
-- --------------------------Alert/Drop/Create table----------------------------------------

DROP TABLE IF EXISTS transactions;
CREATE TABLE IF NOT EXISTS transactions (
	   t_id			BIGINT 		AUTO_INCREMENT 
	 , t_num	 	CHAR(15)
	 , t_mid		CHAR(3)
	 , t_acct		BIGINT 
	 , t_type		VARCHAR(15)							-- TYPE OF card
	 , t_date 		DATETIME 	DEFAULT CURRENT_TIMESTAMP 	
	 , t_amount		DECIMAL(8,2)
	 , t_cr_dr 		CHAR(2)								
	 , t_status		VARCHAR(10)							-- payment status: Aproved, Declained, Failed
	 , user_id		INT 		NOT NULL DEFAULT 2 	-- FK
	 , date_mod		DATETIME 	NOT NULL DEFAULT CURRENT_TIMESTAMP
	 , active		BIT 		NOT NULL DEFAULT 1
	 , PRIMARY KEY  (t_id)
	 , CONSTRAINT transactions_UK UNIQUE KEY (t_num)
);

TRUNCATE TABLE transactions;
INSERT INTO transactions  (t_num, t_mid, t_acct, t_type
						 , t_date, t_amount, t_cr_dr, t_status)
VALUES 					  ('123456789012345', '001', '1234432112344321', 'Visa'
						 , '2022-03-12 11:00:32', 999.99, 'CR', 'Aprobed')
						 , ('123456789012346', '002', '1234432112344322', 'Mastercard'
						 , '2022-03-13 11:00:32', 899.99, 'CR', 'Aprobed')
						, ('123456789012347', '003', '1234432112344323', 'Mastercard'
						 , '2022-03-14 11:00:32', 899.99, 'DR', 'Aprobed');

SELECT 	  t.t_id, t.t_num, t.t_mid, t.t_acct, t.t_type
		, t.t_date, t.t_amount, t.t_cr_dr, t.t_status
		, t.user_id, t.date_mod, t.active
FROM	transactions t;

-- -----------------------order_transactions(ot) TABLE -------------------------------------
-- --------------------------Alert/Drop/Create table----------------------------------------

ALTER TABLE IF EXISTS order__transactions 	DROP CONSTRAINT IF EXISTS ot_orders_FK;
ALTER TABLE IF EXISTS order__transactions 	DROP CONSTRAINT IF EXISTS ot_transactions_FK;
ALTER TABLE IF EXISTS order__transactions 	DROP CONSTRAINT IF EXISTS ot_p_cust_FK;

DROP TABLE IF EXISTS order__transactions;
CREATE TABLE IF NOT EXISTS order__transactions (
	  ot_id 	BIGINT 	AUTO_INCREMENT
	, order_id 	INT 	NOT NULL 			
	, t_id		BIGINT 	NOT NULL 			
	, p_id_cust	INT 	NOT NULL 			
	, user_id	INT 	NOT NULL DEFAULT 2 	
	, date_mod	DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
	, active	BIT 	NOT NULL DEFAULT 1
	, PRIMARY KEY (ot_id)
	, CONSTRAINT ot_UK 	UNIQUE (order_id, t_id, p_id_cust)
);

TRUNCATE TABLE order__transactions;
INSERT INTO order__transactions (order_id, t_id, p_id_cust)
VALUES 			  ( 1, 1, 3)
				, (2, 2, 4)
				, (3, 3, 5);

SELECT 	  ot.ot_id, ot.order_id, ot.t_id
		, ot.p_id_cust, ot.user_id, ot.date_mod
FROM order__transactions ot;

ALTER TABLE order__transactions
	  ADD CONSTRAINT ot_orders_FK 		FOREIGN KEY (order_id) 	REFERENCES orders(order_id); 
ALTER TABLE order__transactions
	  ADD CONSTRAINT ot_transactions_FK FOREIGN KEY (t_id) 		REFERENCES transactions(t_id); 
ALTER TABLE order__transactions
	  ADD CONSTRAINT ot_p_cust_FK 		FOREIGN KEY (p_id_cust) REFERENCES people(p_id);


-- -------------- Receipt Build Query --------------------------------------------------------------------------------

SET @fakeOrderDate = '2023-04-25 11:00:00';
	 
	 SELECT 	  ip.item_id, i.item_name, i.item_price
		, ip.item_id, ip.ip_beg, ip.ip_end, ip.ip_price
FROM item i
	JOIN item_price ip ON i.item_id = ip.item_id;

-- ----------------------------Items ----------------------------------------------------------
SELECT 	  i.item_id, i.item_name, i.item_price
		, ip.ip_beg, ip.ip_end, ip.ip_price
		, fake.order_date
		, fake.order_date BETWEEN ip.ip_beg AND IFNULL(ip.ip_end, fake.order_date)
FROM item i
	JOIN item_price ip ON i.item_id = ip.item_id
	, (SELECT @fakeOrderDate AS order_date) fake;

-- ------------- Fake order date  ---------------------------------------------------------------
SELECT 	 fake.order_date, i.item_id, i.item_name, i.item_price
		, ip.ip_price
FROM item i
	JOIN item_price ip ON i.item_id = ip.item_id
	, (SELECT @fakeOrderDate AS order_date) fake
WHERE fake.order_date BETWEEN ip.ip_beg AND IFNULL(ip_end, fake.order_date);



SELECT fake.order_date, i.item_id, i.item_name, i.item_price,		                                           -- results
	MAX(ip.ip_price) AS ip_price_reg,								                                           -- Max price
	CASE WHEN MIN(ip.ip_price) = MAX(ip.ip_price) THEN NULL ELSE MIN(ip.ip_price) END AS ip_price_sale         -- IS it ON sale ?
FROM item i															                                           -- From the item and item_price tables
	JOIN item_price ip ON i.item_id = ip.item_id
	, (SELECT @fakeOrderDate AS order_date) fake				                                              -- Fake ORDER date
WHERE fake.order_date BETWEEN ip.ip_beg AND IFNULL(ip_end, fake.order_date)                                   
GROUP BY fake.order_date, i.item_id, i.item_name, i.item_price;		                                          -- order date, item ID, item name, and item price



-- --------------------------Drop/Craete View -------------------------------------------------------------

DROP VIEW IF EXISTS gst;
CREATE VIEW IF NOT EXISTS gst AS (
	SELECT 	tax_type, ROUND(tax_perc/100, 2) AS tax_rate 
			, CONCAT(tax_type, ' (', TRUNCATE(tax_perc, 0), '%)') AS Label
	FROM tax
	WHERE tax_type = 'GST'
	);

CREATE VIEW IF NOT EXISTS pst AS (
	
	SELECT tax_type, ROUND(tax_perc/100, 2) AS tax_rate,                -- tax type and rate
	
		CONCAT(tax_type, ' (', TRUNCATE(tax_perc, 0), '%)') AS Label
	FROM tax
	WHERE tax_type = 'PST'
);

SELECT gst.tax_rate, gst.label, pst.tax_rate, pst.label 
FROM gst, pst;

-- --------------------------Drop/Craete taxes View -------------------------------------------------------------

DROP VIEW IF EXISTS taxes;
CREATE VIEW IF NOT EXISTS taxes AS (
	SELECT 	gst.tax_rate AS gst_tax_rate, gst.label AS gst_label,
			pst.tax_rate AS pst_tax_rate, pst.label AS pst_label
	FROM gst, pst
);

SELECT * FROM taxes;


-- -----------------------------------------orders table -----------------------------------------
SELECT o.order_id, o.order_date, o.order_num, o.order_type, o.p_id_cust, o.p_id_emp, o.order_notes
		, o.order_credit, o.order_cr_uom, o.order_override
FROM orders o;

SELECT 	  oi.order_id, oi.item_id
		, oi.oi_qty, oi.oi_override
FROM orders__item oi;

UPDATE orders SET order_date = '2023-03-28 11:00:32' WHERE order_id = 1;

-- ------------------------join query ---------------------------------------------
SELECT 	  oi.order_id, oi.item_id, oi.oi_qty, oi.oi_override, oi.oi_status
		, o.order_id, o.order_date
		, o.order_credit, o.order_cr_uom, o.order_override
FROM orders__item oi
	JOIN orders o ON oi.order_id = o.order_id
;


SELECT o.order_date, ip.ip_beg, ip.ip_end, i.item_id, i.item_name, i.item_price,
			
	MAX(ip.ip_price) AS ip_price_reg,
			
	CASE WHEN MIN(ip.ip_price) = MAX(ip.ip_price) THEN NULL ELSE MIN(ip.ip_price) END AS ip_price_sal,
	oi.oi_qty, oi.oi_override, oi.oi_status,
	o.order_id, o.order_credit, o.order_cr_uom, o.order_override,
	o.order_num, o.order_type, o.p_id_cust, o.p_id_emp, o.order_notes
-- ------------- Join the item, item_price, orders__item, and orders tables--------------------------
FROM item i
	JOIN item_price 	ip ON i.item_id = ip.item_id
	JOIN orders__item 	oi ON i.item_id = oi.item_id
	JOIN orders 		o  ON oi.order_id = o.order_id

WHERE o.order_date BETWEEN ip.ip_beg AND IFNULL(ip.ip_end, o.order_date)

GROUP BY o.order_id, o.order_date, i.item_id, i.item_name, i.item_price,
	oi.oi_qty, oi.oi_override, oi.oi_status, o.order_credit, o.order_cr_uom, o.order_override,
	o.order_num, o.order_type, o.p_id_cust, o.p_id_emp, o.order_notes
;

UPDATE orders SET order_date = '2023-03-28 11:00:32' WHERE order_id = 1;




-- ---------------------------------RECEIPT VIEW  -------------------------------
SELECT order_id, order_date, item_id, item_name, item_price, oi_override
	, ip_price_sal, ip_price_reg
	, IFNULL( order_override, IFNULL(ip_price_sal, ip_price_reg)) AS ip_price
	, oi_qty
	, IFNULL(order_override, IFNULL(ip_price_sal, ip_price_reg)) * oi_qty AS ip_price_tot
	, oi_status
	, order_credit, order_cr_uom, order_override
	, order_num, order_type, p_id_cust, p_id_emp, order_notes
FROM (
	SELECT o.order_date, ip.ip_beg, ip.ip_end, i.item_id, i.item_name, i.item_price,
		MAX(ip.ip_price) AS ip_price_reg,
				
		CASE WHEN MIN(ip.ip_price) = MAX(ip.ip_price) THEN NULL ELSE MIN(ip.ip_price) END AS ip_price_sal,
		oi.oi_qty, oi.oi_override, oi.oi_status,
		o.order_id, o.order_credit, o.order_cr_uom, o.order_override,
		o.order_num, o.order_type, o.p_id_cust, o.p_id_emp, o.order_notes
				
	FROM item i
		JOIN item_price ip ON i.item_id = ip.item_id
		JOIN orders__item oi ON i.item_id = oi.item_id
		JOIN orders o ON oi.order_id = o.order_id
				
	WHERE o.order_date BETWEEN ip.ip_beg AND IFNULL(ip.ip_end, o.order_date)
				
	GROUP BY o.order_id, o.order_date, i.item_id, i.item_name, i.item_price,
		oi.oi_qty, oi.oi_override, oi.oi_status, o.order_credit, o.order_cr_uom, o.order_override,
		o.order_num, o.order_type, o.p_id_cust, o.p_id_emp, o.order_notes
) x;

DROP VIEW IF EXISTS orders__items__receipt_items;
CREATE VIEW IF NOT EXISTS orders__items__receipt_items AS (
	SELECT order_id, order_date, item_id, item_name, item_price, oi_override
		, ip_price_sal, ip_price_reg
		, IFNULL( order_override, IFNULL(ip_price_sal, ip_price_reg)) AS ip_price
		, oi_qty
		, IFNULL(order_override, IFNULL(ip_price_sal, ip_price_reg)) * oi_qty AS ip_price_tot
		, oi_status
		, order_credit, order_cr_uom, order_override
		, order_num, order_type, p_id_cust, p_id_emp, order_notes
	FROM (
		SELECT o.order_date, ip.ip_beg, ip.ip_end, i.item_id, i.item_name, i.item_price,
			
			MAX(ip.ip_price) AS ip_price_reg,
					
			CASE WHEN MIN(ip.ip_price) = MAX(ip.ip_price) THEN NULL ELSE MIN(ip.ip_price) END AS ip_price_sal,
			oi.oi_qty, oi.oi_override, oi.oi_status,
			o.order_id, o.order_credit, o.order_cr_uom, o.order_override,
			o.order_num, o.order_type, o.p_id_cust, o.p_id_emp, o.order_notes
					
		FROM item i
			JOIN item_price ip ON i.item_id = ip.item_id
			JOIN orders__item oi ON i.item_id = oi.item_id
			JOIN orders o ON oi.order_id = o.order_id
					
		WHERE o.order_date BETWEEN ip.ip_beg AND IFNULL(ip.ip_end, o.order_date)
		-- -----------------------------Group the results-----------------------------------------			
		GROUP BY o.order_id, o.order_date, i.item_id, i.item_name, i.item_price,
			oi.oi_qty, oi.oi_override, oi.oi_status, o.order_credit, o.order_cr_uom, o.order_override,
			o.order_num, o.order_type, o.p_id_cust, o.p_id_emp, o.order_notes
	) x
);


SELECT *
FROM orders__items__receipt_items;


-- ---------------------------Final Sale----------------------------------------------
SELECT		order_id, order_date -- , ip_beg, ip_end, item_id, i.item_name, item_price
			, SUM(ip_price_tot) AS subtotal
			, order_credit, order_cr_uom, order_override
			, order_num, order_type, p_id_cust, p_id_emp, order_notes
FROM orders__items__receipt_items;

-- ---------------------------Add Taxes -------------------------------------------
DROP VIEW IF EXISTS orders__items__receipt;
CREATE VIEW IF NOT EXISTS orders__items__receipt AS (
SELECT order_id, order_date 
	, order_num, order_type, order_notes -- ,p_id_cust, p_id_emp,
	, CONCAT(p_c.first_name, ' ', p_c.last_name) AS customer
	, CONCAT(p_e.first_name, ' ', p_e.last_name) AS employee
	, order_credit, order_cr_uom, order_override
		, subtotal
		, gst_label, ROUND(subtotal*gst_tax_rate, 2) AS gst_subtotal
		, pst_label, ROUND(subtotal*pst_tax_rate, 2) AS pst_subtotal
		, ROUND(subtotal*(1+gst_tax_rate+pst_tax_rate), 2) AS grandtotal
FROM (
		SELECT		order_id, order_date
					, SUM(ip_price_tot) AS subtotal
					, order_credit, order_cr_uom, order_override
					, order_num, order_type, p_id_cust, p_id_emp, order_notes
		FROM orders__items__receipt_items
	) ois
	JOIN people p_c ON ois.p_id_cust = p_c.p_id
	JOIN people p_e ON ois.p_id_emp = p_e.p_id
	, taxes
);

SELECT *
FROM orders__items__receipt;


SELECT order_id, grandtotal
FROM orders__items__receipt;


-- --------------------------------------------Final project----------------------------------------------------------


SELECT * FROM geo_country;
SELECT * FROM geo_region;
SELECT * FROM geo_towncity;
-- geo_country INSERTS ----------------------------------------------

#TRUNCATE TABLE geo_country;
#INSERT INTO geo_country (c_name, c_code) VALUES ('Canada', 'CA');  -- 1
INSERT INTO geo_country (c_id, c_name, c_code) VALUES (10,'Japan', 'JP');                      -- 10
INSERT INTO geo_country (c_id, c_name, c_code) VALUES (11,'South Korea', 'KR');                -- 11
INSERT INTO geo_country (c_id, c_name, c_code) VALUES (12,'United States of America', 'US');   -- 12

-- geo_region INSERTS -----------------------------------------------
-- TRUNCATE TABLE geo_region;
-- INSERT INTO geo_region (r_name, r_code, c_id) VALUES ('Manitoba', 'MB', 1);            -- 1,1
INSERT INTO geo_region (r_id, r_name, r_code, c_id) VALUES (10, 'Tokyo', NULL, 10);           -- 10,10
INSERT INTO geo_region (r_id, r_name, r_code, c_id) VALUES (11, 'Osaka', NULL, 10);           -- 11,10
INSERT INTO geo_region (r_id, r_name, r_code, c_id) VALUES (12, 'Gyeonggi', NULL, 11);        -- 12,11
INSERT INTO geo_region (r_id, r_name, r_code, c_id) VALUES (13, 'California', 'CA', 12);      -- 13,12
INSERT INTO geo_region (r_id, r_name, r_code, c_id) VALUES (14, 'Texas', 'TX', 12);           -- 14,12
INSERT INTO geo_region (r_id, r_name, r_code, c_id) VALUES (15, 'Washington', 'WA', 12);      -- 15,12


-- geo_towncity INSERTS ---------------------------------------------
-- TRUNCATE TABLE geo_towncity;
-- INSERT INTO geo_towncity (tc_name, r_id) VALUES ('Winnipeg', 1);               -- 1,1,1
INSERT INTO geo_towncity (tc_id, tc_name, r_id) VALUES (10, 'Chiyoda', 10);              -- 10,10,10
INSERT INTO geo_towncity (tc_id, tc_name, r_id) VALUES (11, 'Minato', 10);               -- 11,10,10
INSERT INTO geo_towncity (tc_id, tc_name, r_id) VALUES (12, 'Kadoma', 11);               -- 12,11,10
INSERT INTO geo_towncity (tc_id, tc_name, r_id) VALUES (13, 'Suwon', 12);                -- 13,12,11
INSERT INTO geo_towncity (tc_id, tc_name, r_id) VALUES (14, 'Seoul', 12);                -- 14,12,11
INSERT INTO geo_towncity (tc_id, tc_name, r_id) VALUES (15, 'Lost Altos', 13);           -- 15,13,12
INSERT INTO geo_towncity (tc_id, tc_name, r_id) VALUES (16, 'Santa Clara', 13);          -- 16,13,12
INSERT INTO geo_towncity (tc_id, tc_name, r_id) VALUES (17, 'Round Rock', 14);           -- 17,14,12
INSERT INTO geo_towncity (tc_id, tc_name, r_id) VALUES (18, 'Redmond', 15);              -- 18,15,12   
   
SELECT gtc.tc_id, gtc.tc_name, gtc.r_id
     , gr.r_id, gr.r_name, gr.r_code, gr.c_id
   , gc.c_id, gc.c_name, gc.c_code
FROM geo_towncity gtc
   JOIN geo_region gr ON gtc.r_id=gr.r_id
   JOIN geo_country gc ON gr.c_id=gc.c_id;
   
   
-- manufacturer INSERTS ---------------------------------------------
-- TRUNCATE TABLE manufacturer;
-- INSERT INTO manufacturer (man_name, p_id_man
--            , phone_pri, phone_sales, phone_sup, phone_fax
--            , addr, addr_code, addr_info, addr_type_id, tc_id)
-- VALUES                   ('Acme Co.', 3
--            , '222-222-2222', '333-333-3333', '444-444-4444', '555-555-5555'
--            , '3 Road Runner Way', 'R1R 2W3', NULL, 3, 1);
INSERT INTO manufacturer (man_id, man_name, addr, addr_info, addr_type_id, tc_id)
VALUES (10 ,'Apple Inc.'         ,'260-17 First St','PO Box: 26017',3,15)
      ,(11 ,'Samsung Electronics','221-6 Second St','PO Box: 24355',3,13)
      ,(12 ,'Dell Technologies'  ,'90-62 Third St' ,'PO Box: 26517',3,17)
      ,(13 ,'Hitachi'            ,'88-42 Fourth St','PO Box: 26054',3,10)
      ,(14 ,'Sony'               ,'80-92 Fifth St' ,'PO Box: 46017',3,11)
      ,(15 ,'Panasonic'          ,'74-73 Sixth St' ,'PO Box: 49587',3,12)
      ,(16 ,'Intel'              ,'71-9 Seventh St','PO Box: 29234',3,16)
      ,(17 ,'LG Electronics'     ,'54-39 Eighth St','PO Box: 98234',3,14)
      ,(18 ,'Microsoft'          ,'100-10 Ninth St','PO Box: 98245',3,18)
;


SELECT man.man_id, man.man_name
   , man.p_id_man
   , man.addr_type_id
   , man.tc_id
   , gat.addr_type_id, gat.addr_type
   , gtc.tc_id, gtc.tc_name
   , gr.r_id, gr.r_name
   , gc.c_id, gc.c_name
FROM manufacturer man
     JOIN geo_address_type gat  ON man.addr_type_id=gat.addr_type_id
     JOIN geo_towncity gtc ON man.tc_id=gtc.tc_id
     JOIN geo_region gr     ON gtc.r_id=gr.r_id
     JOIN geo_country gc    ON gr.c_id=gc.c_id
;
   
   
-- category INSERTS -------------------------------------------------
ALTER TABLE IF EXISTS category__people DROP CONSTRAINT IF EXISTS cp_cat_FK ;
ALTER TABLE IF EXISTS category__people DROP CONSTRAINT IF EXISTS cp_pe_FK;


TRUNCATE TABLE category;
-- people INSERTS --
INSERT INTO category (cat_name, cat_id_parent, cat_uri, cat_abbr, taxonomy)
VALUES               ('Staff', NULL, 'staff', NULL, 'departments');         -- 1

INSERT INTO category (cat_name, cat_id_parent, cat_uri, cat_abbr, taxonomy)
VALUES               ('Sales', 1, 'sales', NULL, 'departments');            -- 2

INSERT INTO category (cat_name, cat_id_parent, cat_uri, cat_abbr, taxonomy)
VALUES               ('Warehouse', 1, 'warehouse', NULL, 'departments');    -- 3


#TRUNCATE TABLE category__people;
INSERT INTO category__people (cat_id, pe_id)
VALUES                       (2, 2),(3, 1);

SELECT cp.cp_id, cp.cat_id, cp.pe_id
   , cp.user_id, cp.date_mod, cp.active
FROM category__people cp;

-- join verify
SELECT cat.cat_id, cat.cat_name, cat.taxonomy, cat.cat_uri
   , cp.cat_id, cp.pe_id             -- , cp.cp_id
   , pe.pe_id, pe.pe_uri, pe.p_id    -- , pe.p_id_mgr
   , p.p_id, p.first_name, p.last_name
FROM category cat
   JOIN category__people cp ON cat.cat_id=cp.cat_id
   JOIN people_employee pe ON cp.pe_id=pe.pe_id
   JOIN people p  ON pe.p_id=p.p_id
WHERE cat.taxonomy='departments';

-- site urls
SELECT cat.cat_id, cp.cat_id, cp.pe_id, p.p_id
   , CONCAT('https://boxstore.com/',cat.taxonomy,'/',cat.cat_uri,'/',pe.pe_uri,'/') AS dept_permalink
   , CONCAT('https://boxstore.com/staff/',pe.pe_uri,'/') AS emp_permalink
FROM category cat
   JOIN category__people cp ON cat.cat_id=cp.cat_id
   JOIN people_employee pe ON cp.pe_id=pe.pe_id
   JOIN people p  ON pe.p_id=p.p_id
WHERE cat.taxonomy='departments';


-- item INSERTS --
INSERT INTO category (cat_name, cat_id_parent, cat_uri, cat_abbr, taxonomy)
VALUES  ('Televisions', NULL,'televisions', 'TV', 'general')          -- 4
      , ('Portable Electronics', NULL,'portable-electronics', 'PE', 'general')  -- 5
      , ('Kitchen Appliances', NULL,'kitchen-appliances', 'KA', 'general')    -- 6
      , ('Large Appliances', NULL,'large-appliances', 'LA', 'general');     -- 7

    
INSERT INTO category (cat_name, cat_id_parent, cat_uri, cat_abbr, taxonomy)
VALUES   ('70" & Up',4,'70-up',NULL,'general')                  -- 8
       , ('60" - 69"',4,'60-69',NULL,'general')                 -- 9
       , ('55" & Down',4,'55-down',NULL,'general')                -- 10
       , ('Smartphones',5,'smartphones',NULL,'general')             -- 11
       , ('Tablets',5,'tablets',NULL,'general')                 -- 12
       , ('Blender',6,'blender',NULL,'general')                 -- 13
       , ('Coffee & Tea',6,'coffee-tea',NULL,'general')             -- 14
       , ('Washer',7,'washer',NULL,'general')                 -- 15
       , ('Dryer',7,'dryer',NULL,'general');                  -- 16   


-- ------------------------------------------------------------------
SELECT cat.cat_id, cp.cat_id, cp.pe_id, p.p_id
   , CONCAT('https://boxstore.com/',cat.taxonomy,'/',cat.cat_uri,'/',pe.pe_uri,'/') AS dept_permalink
   , CONCAT('https://boxstore.com/staff/',pe.pe_uri,'/') AS emp_permalink
FROM category cat
   JOIN category__people cp ON cat.cat_id=cp.cat_id
   JOIN people_employee pe ON cp.pe_id=pe.pe_id
   JOIN people p  ON pe.p_id=p.p_id
WHERE cat.taxonomy='general';

DROP TABLE IF EXISTS `z__orders_items_csv`;

CREATE TABLE `z__orders_items_csv` (
  `man_id` INT(11) DEFAULT NULL,
  `order_num` INT(11) DEFAULT NULL,
  `order_date` DATE DEFAULT NULL,
  `item_type` VARCHAR(8) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_modelno` VARCHAR(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_barcode` INT(11) DEFAULT NULL,
  `cat_name` VARCHAR(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cat_id` INT(11) DEFAULT NULL,
  `item_name_new` VARCHAR(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_qty` INT(11) DEFAULT NULL,
  `item_price` DECIMAL(7,2) DEFAULT NULL,
  `extra` VARCHAR(8) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT  INTO `z__orders_items_csv`(`man_id`,`order_num`,`order_date`,`item_type`,`item_modelno`,`item_barcode`,`cat_name`,`cat_id`,`item_name_new`,`order_qty`,`item_price`,`extra`) VALUES 
(6,1160,'2021-05-18','product','6PRI0299999203',99999203,'55\" & Down',10,'50\" HDTV',3,2100.00,'6PRI02'),
(10,1026,'2021-01-13','product','2BRE1100066001',66001,'55\" & Down',10,'50\" HDTV',2,2100.00,'2BRE11'),
(10,1057,'2021-01-18','product','2BRE1000056014',56014,'55\" & Down',10,'50\" HDTV',2,2605.00,'2BRE10'),
(4,1091,'2021-02-17','product','3FPT0100051287',51287,'60\" - 69\"',9,'65\" HDTV',4,6065.33,'3FPT01'),
(4,1091,'2021-02-17','product','3FPT0100051281',51281,'60\" - 69\"',9,'65\" HDTV',1,6665.33,'3FPT01'),
(4,1091,'2021-02-17','product','3FPT0100051286',51286,'60\" - 69\"',9,'65\" HDTV',1,6665.33,'3FPT01'),
(5,1060,'2021-01-18','product','6LID0100051166',51166,'60\" - 69\"',9,'65\" HDTV',2,5502.67,'6LID01'),
(9,1174,'2021-05-19','product','2SUR1100056001',56001,'60\" - 69\"',9,'65\" HDTV',3,5000.00,'2SUR11'),
(6,1160,'2021-05-18','product','6PRI0299999197',99999197,'70\" & Up',8,'75\" HDTV',2,20013.33,'6PRI02'),
(6,1160,'2021-05-18','product','6PRI0299999198',99999198,'70\" & Up',8,'75\" HDTV',2,20013.33,'6PRI02'),
(4,1044,'2021-01-18','product','3SKY0111164009',11164009,'Blender',13,'20 ounce Blender',3,69.53,'3SKY01'),
(4,1044,'2021-01-18','product','3SKY0142542001',42542001,'Blender',13,'20 ounce Blender',3,89.41,'3SKY01'),
(5,1021,'2021-01-13','product','4MAR0120815001',20815001,'Blender',13,'20 ounce Blender',3,54.35,'4MAR01'),
(6,1254,'2022-01-28','product','4SOD0100001009',1009,'Blender',13,'20 ounce Blender',5,89.00,'4SOD01'),
(8,1040,'2021-01-18','product','2SUR1108413009',8413009,'Blender',13,'20 ounce Blender',3,50.75,'2SUR11'),
(1,1003,'2021-01-13','product','1GQD0200001006',1006,'Coffee & Tea',14,'Barista Express',2,100.00,'1GQD02'),
(1,1180,'2021-05-20','product','1GQD0200001006',1006,'Coffee & Tea',14,'Barista Express',1,100.00,'1GQD02'),
(1,1239,'2021-01-13','product','1GQD0200001006',1006,'Coffee & Tea',14,'Barista Express',1,100.00,'1GQD02'),
(1,1030,'2021-01-13','product','1GQD0200001012',1012,'Coffee & Tea',14,'Barista Express',1,133.17,'1GQD02'),
(2,1173,'2021-05-18','product','7BOC0244563001',44563001,'Coffee & Tea',14,'Barista Express',4,199.80,'7BOC02'),
(3,1151,'2021-04-28','product','3BRI0300001012',1012,'Coffee & Tea',14,'Barista Express',3,133.17,'3BRI03'),
(5,1195,'2021-05-24','product','4HEL0141994001',41994001,'Coffee & Tea',14,'Barista Express',3,124.38,'4HEL01'),
(5,1054,'2021-01-18','product','4HEL0140182001',40182001,'Coffee & Tea',14,'Barista Express',3,172.63,'4HEL01'),
(7,1031,'2021-01-14','product','7SPP0105618009',5618009,'Coffee & Tea',14,'Barista Express',4,199.80,'7SPP01'),
(8,1040,'2021-01-18','product','2SUR1103820009',3820009,'Coffee & Tea',14,'Barista Express',1,104.50,'2SUR11'),
(8,1040,'2021-01-18','product','2SUR1115323121',15323121,'Coffee & Tea',14,'Barista Express',1,144.18,'2SUR11'),
(8,1040,'2021-01-18','product','2SUR1115384001',15384001,'Coffee & Tea',14,'Barista Express',3,152.74,'2SUR11'),
(8,1040,'2021-01-18','product','2SUR1115199001',15199001,'Coffee & Tea',14,'Barista Express',3,174.05,'2SUR11'),
(8,1040,'2021-01-18','product','2SUR1104929009',4929009,'Coffee & Tea',14,'Barista Express',2,184.80,'2SUR11'),
(8,1040,'2021-01-18','product','2SUR1108718009',8718009,'Coffee & Tea',14,'Barista Express',3,189.61,'2SUR11'),
(8,1040,'2021-01-18','product','2SUR1108255009',8255009,'Coffee & Tea',14,'Barista Express',3,196.60,'2SUR11'),
(5,1049,'2021-01-18','product','7HAN0200008359',8359,'Dryer',16,'Dryer',1,710.00,'7HAN02'),
(5,1117,'2021-03-04','product','7HYU0200008359',8359,'Dryer',16,'Dryer',1,710.00,'7HYU02'),
(5,1119,'2021-03-04','product','7SMS0100008359',8359,'Dryer',16,'Dryer',1,710.00,'7SMS01'),
(5,1228,'2021-01-15','product','7SPP0100008359',8359,'Dryer',16,'Dryer',1,710.00,'7SPP01'),
(7,1229,'2021-02-23','product','7SPP0100041409',41409,'Dryer',16,'Dryer',4,716.67,'7SPP01'),
(10,1225,'2020-01-28','product','2BRE1500012590',12590,'Dryer',16,'Dryer',2,666.67,'2BRE15'),
(10,1225,'2020-01-28','product','2BRE1400012576',12576,'Dryer',16,'Dryer',2,783.33,'2BRE14'),
(1,1120,'2021-03-04','product','1GQD0240880001',40880001,'Smartphones',11,'Actually a Flipper',5,238.06,'1GQD02'),
(2,1173,'2021-05-18','product','7BOC0200002293',2293,'Smartphones',11,'Actually a Flipper',3,207.79,'7BOC02'),
(2,1168,'2021-05-18','product','4DAI0200002260',2260,'Smartphones',11,'Actually a Flipper',3,264.74,'4DAI02'),
(3,1137,'2021-04-06','product','3BRI0400002124',2124,'Smartphones',11,'Not-as Smartphone',3,358.74,'3BRI04'),
(3,1046,'2021-01-18','product','7DAE0400012490',12490,'Smartphones',11,'Really Smartphone',4,1250.00,'7DAE04'),
(4,1048,'2021-01-18','product','3TEC0350864001',50864001,'Smartphones',11,'Really Smartphone',1,1090.91,'3TEC03'),
(5,1054,'2021-01-18','product','4HEL0140184001',40184001,'Smartphones',11,'Actually a Flipper',5,226.07,'4HEL01'),
(5,1049,'2021-01-18','product','7HAN0200013563',13563,'Smartphones',11,'Really Smartphone',2,1170.00,'7HAN02'),
(6,1254,'2022-01-28','product','4SOD0100001011',1011,'Smartphones',11,'Actually a Flipper',2,299.70,'4SOD01'),
(6,1160,'2021-05-18','product','6PRI0299999177',99999177,'Smartphones',11,'Not-as Smartphone',3,332.97,'6PRI02'),
(6,1160,'2021-05-18','product','6PRI0299999178',99999178,'Smartphones',11,'Really Smartphone',2,1333.33,'6PRI02'),
(7,1031,'2021-01-14','product','7SPP0120983041',20983041,'Smartphones',11,'Not-as Smartphone',4,332.97,'7SPP01'),
(7,1031,'2021-01-14','product','7SPP0120983081',20983081,'Smartphones',11,'Not-as Smartphone',1,332.97,'7SPP01'),
(8,1040,'2021-01-18','product','2SUR1106484009',6484009,'Smartphones',11,'Not-as Smartphone',3,321.23,'2SUR11'),
(8,1201,'2021-05-24','product','2SUR1199999114',99999114,'Smartphones',11,'Not-as Smartphone',1,363.64,'2SUR11'),
(8,1043,'2021-01-18','product','2SUR1101100321',1100321,'Smartphones',11,'Really Smartphone',3,1272.00,'2SUR11'),
(8,1178,'2021-05-20','product','2SUR1101100321',1100321,'Smartphones',11,'Really Smartphone',4,1272.00,'2SUR11'),
(9,1114,'2021-03-08','product','2SUR1100002124',2124,'Smartphones',11,'Not-as Smartphone',3,358.74,'2SUR11'),
(9,1042,'2021-01-18','product','2SUR1151463001',51463001,'Smartphones',11,'Really Smartphone',1,1040.00,'2SUR11'),
(9,1111,'2021-02-26','product','2SUR1100041398',41398,'Smartphones',11,'Really Smartphone',5,1200.00,'2SUR11'),
(10,1089,'2021-02-24','product','2BRE1200002124',2124,'Smartphones',11,'Not-as Smartphone',3,358.74,'2BRE12'),
(10,1242,'2021-06-09','product','2BRE1600013212',13212,'Smartphones',11,'Really Smartphone',3,1000.00,'2BRE16'),
(10,1033,'2021-01-14','product','2BRE0100008427',8427,'Smartphones',11,'Really Smartphone',1,1010.00,'2BRE01'),
(10,1036,'2021-01-18','product','2BRE0200008427',8427,'Smartphones',11,'Really Smartphone',1,1010.00,'2BRE02'),
(10,1225,'2020-01-28','product','2BRE1300008427',8427,'Smartphones',11,'Really Smartphone',1,1010.00,'2BRE13'),
(10,1058,'2021-01-18','product','2BRE0600013628',13628,'Smartphones',11,'Really Smartphone',3,1350.00,'2BRE06'),
(10,1157,'2021-05-17','product','2BRE0700013628',13628,'Smartphones',11,'Really Smartphone',5,1350.00,'2BRE07'),
(10,1177,'2021-05-20','product','2BRE0900013628',13628,'Smartphones',11,'Really Smartphone',3,1350.00,'2BRE09'),
(1,1046,'2021-01-18','product','1GQD0200008335',8335,'Tablets',12,'Super Tablet',4,1435.00,'1GQD02'),
(1,1090,'2021-02-24','product','3ADA0100008360',8360,'Tablets',12,'Super Tablet',4,2000.00,'3ADA01'),
(2,1170,'2021-05-18','product','4DAI0200002136',2136,'Tablets',12,'Mini Tablet',3,374.63,'4DAI02'),
(2,1211,'2021-05-26','product','4DAI0200002136',2136,'Tablets',12,'Mini Tablet',3,374.63,'4DAI02'),
(2,1171,'2021-05-18','product','4DAI0200002123',2123,'Tablets',12,'Mini Tablet',3,424.58,'4DAI02'),
(3,1169,'2021-05-18','product','3BRI0400002136',2136,'Tablets',12,'Mini Tablet',3,374.63,'3BRI04'),
(3,1111,'2021-02-26','product','7DAE0400008335',8335,'Tablets',12,'Super Tablet',1,1435.00,'7DAE04'),
(4,1105,'2021-02-26','product','3OCE0108211010',8211010,'Tablets',12,'Mini Tablet',3,499.50,'3OCE01'),
(4,1182,'2021-05-20','product','7UNI0400008355',8355,'Tablets',12,'Super Tablet',5,1435.00,'7UNI04'),
(5,1054,'2021-01-18','product','4HEL0105850009',5850009,'Tablets',12,'Mini Tablet',2,448.25,'4HEL01'),
(5,1031,'2021-01-14','product','7HYU0200041406',41406,'Tablets',12,'Super Tablet',4,1500.00,'7HYU02'),
(6,1052,'2021-01-18','product','7SAK0100008355',8355,'Tablets',12,'Super Tablet',3,1435.00,'7SAK01'),
(6,1117,'2021-03-04','product','7SMS0100041406',41406,'Tablets',12,'Super Tablet',4,1500.00,'7SMS01'),
(7,1119,'2021-03-04','product','7SPP0100041406',41406,'Tablets',12,'Super Tablet',4,1500.00,'7SPP01'),
(7,1228,'2021-01-15','product','7SPP0100041406',41406,'Tablets',12,'Super Tablet',4,1500.00,'7SPP01'),
(8,1150,'2021-04-27','product','2SUR1100008294',8294,'Tablets',12,'Super Tablet',3,1414.11,'2SUR11'),
(9,1102,'2021-02-26','product','2SUR1100002136',2136,'Tablets',12,'Mini Tablet',3,374.63,'2SUR11'),
(9,1107,'2021-03-05','product','2SUR1100002136',2136,'Tablets',12,'Mini Tablet',3,374.63,'2SUR11'),
(9,1102,'2021-02-26','product','2SUR1100002137',2137,'Tablets',12,'Mini Tablet',3,394.61,'2SUR11'),
(9,1107,'2021-03-05','product','2SUR1100002137',2137,'Tablets',12,'Mini Tablet',3,394.61,'2SUR11'),
(9,1102,'2021-02-26','product','2SUR1100002143',2143,'Tablets',12,'Mini Tablet',3,419.58,'2SUR11'),
(9,1107,'2021-03-05','product','2SUR1100002143',2143,'Tablets',12,'Mini Tablet',3,419.58,'2SUR11'),
(9,1064,'2021-01-19','product','2SUR1100008335',8335,'Tablets',12,'Super Tablet',5,1435.00,'2SUR11'),
(9,1056,'2021-01-18','product','2SUR1100011577',11577,'Tablets',12,'Super Tablet',1,1842.00,'2SUR11'),
(10,1056,'2021-01-18','product','2SUR1100041491',41491,'Tablets',12,'Super Tablet',1,1991.00,'2SUR11'),
(1,1090,'2021-02-24','product','3ADA0100004335',4335,'Washer',15,'Washer',5,500.00,'3ADA01'),
(3,1034,'2021-01-14','product','3BRI3505804084',5804084,'Washer',15,'Washer',3,504.69,'3BRI35'),
(3,1051,'2021-01-18','product','3DAE0106096009',6096009,'Washer',15,'Washer',3,553.95,'3DAE01');

UPDATE z__orders_items_csv
SET man_id=man_id+8
WHERE man_id<>1;




-- item ----------------------------------
ALTER TABLE item DROP CONSTRAINT item_UK;


INSERT INTO item  (item_type, item_name, item_modelno, item_barcode
                  , item_uri, item_size, item_uom, item_price
                  , man_id)
SELECT 'Available', CONCAT(man.man_name,' - ',item_name_new), item_modelno, item_barcode
       , NULL, 1, 'Unit', MAX(item_price)
       , z.man_id
FROM z__orders_items_csv z 
     JOIN manufacturer man ON z.man_id=man.man_id
GROUP BY CONCAT(man.man_name,' - ',item_name_new), item_modelno, item_barcode, z.man_id;



INSERT INTO item_price (ip_beg, ip_end, item_id, ip_price)
SELECT                  '2022-01-05 00:00:00', NULL, i.item_id, i.item_price
FROM item i
     LEFT JOIN item_price ip    ON i.item_id = ip.item_id
WHERE ip.ip_id IS NULL;



-- item__category ----------------------------------

DROP TABLE IF EXISTS item__category;
CREATE TABLE IF NOT EXISTS item__category (
    ic_id BIGINT AUTO_INCREMENT
  , item_id BIGINT -- FK
  , cat_id MEDIUMINT -- FK
  , user_id INT NOT NULL DEFAULT 2 -- FK
  , date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
  , active BIT NOT NULL DEFAULT 1
  , PRIMARY KEY(ic_id)
);

TRUNCATE TABLE item__category;
INSERT INTO item__category (item_id, cat_id)
VALUES                    (1, 14);

INSERT INTO item__category (item_id, cat_id)
SELECT i.item_id, z.cat_id
FROM z__orders_items_csv z 
    JOIN manufacturer m ON z.man_id=m.man_id
  JOIN item i ON i.item_modelno=z.item_modelno
GROUP BY i.item_id, z.cat_id;

SELECT ic.ic_id, ic.item_id, ic.cat_id, ic.user_id, ic.date_mod, ic.active
FROM item__category ic;



-- orders ----------------------------------


ALTER TABLE orders DROP CONSTRAINT orders_UK;
ALTER TABLE IF EXISTS orders                DROP CONSTRAINT IF EXISTS order_p_cust_FK;
ALTER TABLE IF EXISTS orders                DROP CONSTRAINT IF EXISTS p_id_cust;

INSERT INTO orders  (order_id, order_num, order_date, order_notes
                    , order_credit, order_cr_uom, p_id_cust, p_id_emp)
                    
SELECT (l.order_num_interv*numlist.p_id)+z.order_num AS order_id
     , (l.order_num_interv*numlist.p_id)+z.order_num AS order_num
     , DATE_ADD(z.order_date, INTERVAL ((-numlist.p_id)/2)+1 DAY) AS order_date_new
     , NULL
     , 0, '$'
     , CONVERT(FLOOR(1 + RAND() * (l.p_id_lmt - 1 + 1)),DECIMAL(10,0)) AS p_id_rnd
     , 2 AS p_id_emp
FROM z__orders_items_csv z
  JOIN manufacturer man ON z.man_id=man.man_id
  JOIN item i ON i.item_modelno=z.item_modelno
  JOIN (
    SELECT 10002 AS p_id_lmt
       , 10000 AS order_num_interv
       , -100 AS od_val 
  ) l
  , (SELECT p_id-1 AS p_id FROM people ORDER BY p_id) numlist
GROUP BY (l.order_num_interv*numlist.p_id)+z.order_num
  , DATE_ADD(z.order_date, INTERVAL ((-numlist.p_id)/2)+1 DAY), l.p_id_lmt, l.order_num_interv, l.od_val;


-- orders__item ----------------------------------

INSERT INTO orders__item  (order_id, item_id, oi_status
                         , oi_qty, oi_override)
SELECT o.order_id, i.item_id, 'Sold', z.order_qty, NULL
FROM z__orders_items_csv z 
    JOIN manufacturer man ON z.man_id=man.man_id
  JOIN item i ON i.item_modelno=z.item_modelno
  JOIN orders o ON RIGHT(o.order_id,4)=z.order_num
GROUP BY o.order_id, i.item_id, z.order_qty;
                     
SELECT oi.oi_id, oi.order_id, oi.item_id, oi.oi_status, oi.oi_qty, oi.oi_override
     , oi.user_id, oi.date_mod, oi.active
FROM orders__item oi;

DROP TABLE z__orders_items_csv;
