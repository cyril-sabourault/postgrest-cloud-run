create sequence "user_seq";
create sequence "tag_seq";
create sequence "category_seq";
create sequence "pet_seq";
create sequence "order_seq";


-- "User" definition
-- Drop table
-- DROP TABLE "User";
CREATE TABLE "User" (
    id int4 NOT NULL DEFAULT nextval('user_seq'::regclass),
    username varchar NOT NULL,
    "password" varchar NOT NULL,
    firstname varchar NOT NULL,
    lastname varchar NOT NULL,
    email varchar NOT NULL,
    phone varchar NOT NULL,
    status int4 NULL DEFAULT 1,
    CONSTRAINT "User_pkey" PRIMARY KEY (id),
    CONSTRAINT "User_u_status_check" CHECK (
        (
            (status = 0)
            OR (status = 1)
        )
    )
);
-- "Tag" definition
-- Drop table
-- DROP TABLE "Tag";
CREATE TABLE "Tag" (
    id int4 NOT NULL DEFAULT nextval('tag_seq'::regclass),
    "name" varchar(10) NOT NULL,
    CONSTRAINT "Tag_pkey" PRIMARY KEY (id)
);
-- "Category" definition
-- Drop table
-- DROP TABLE "Category";
CREATE TABLE "Category" (
    id int4 NOT NULL DEFAULT nextval('category_seq'::regclass),
    "name" varchar NOT NULL,
    CONSTRAINT "Category_pkey" PRIMARY KEY (id)
);
-- "Pet" definition
-- Drop table
-- DROP TABLE "Pet";
CREATE TABLE "Pet" (
    id int4 NOT NULL DEFAULT nextval('pet_seq'::regclass),
    categoryid int4 NOT NULL,
    "name" varchar NOT NULL,
    photourls varchar NULL,
    tagid int4 NULL,
    status varchar NULL,
    CONSTRAINT "Pet_pkey" PRIMARY KEY (id)
);
-- "Pet" foreign keys
ALTER TABLE "Pet"
ADD CONSTRAINT "Pet_p_categoryid_fkey" FOREIGN KEY (categoryid) REFERENCES "Category"(id);
ALTER TABLE "Pet"
ADD CONSTRAINT "Pet_p_tagid_fkey" FOREIGN KEY (tagid) REFERENCES "Tag"(id);
-- "Order" definition
-- Drop table
-- DROP TABLE "Order";
CREATE TABLE "Order" (
    id int4 NOT NULL DEFAULT nextval('order_seq'::regclass),
    petid int4 NOT NULL,
    quantity int4 NOT NULL,
    shipdate date NULL,
    status varchar NULL,
    complete varchar NULL DEFAULT 'false'::character varying,
    CONSTRAINT order_o_complete_check CHECK (
        (
            ((complete)::text = 'false'::text)
            OR ((complete)::text = 'true'::text)
        )
    ),
    CONSTRAINT order_pkey PRIMARY KEY (id)
);
-- "Order" foreign keys
ALTER TABLE "Order"
ADD CONSTRAINT order_o_petid_fkey FOREIGN KEY (petid) REFERENCES "Pet"(id);
---
INSERT INTO "User" (
        username,
        "password",
        firstname,
        lastname,
        email,
        phone,
        status
    )
VALUES (
        'User1',
        '123456',
        'firstname',
        'lastname',
        'mail@mail.com',
        '12345678909',
        1
    );
INSERT INTO "Tag" ("name")
VALUES ('cute'),
    ('handsome'),
    ('mighty');
INSERT INTO "Category" ("name")
VALUES ('kitten'),
    ('puppy'),
    ('tortoise');
INSERT INTO "Pet" (categoryid, "name", photourls, tagid, status)
VALUES (1, 'rouky', NULL, 1, 'unsold'),
    (3, 'thicky', NULL, 2, 'reserved');
INSERT INTO "Order" (petid, quantity, shipdate, status, complete)
VALUES (2, 1, '2022-01-01', 'undone', 'false');