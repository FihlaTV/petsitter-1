Create TABLE pet(
pet_id serial,
name varchar(20),
feeding_instructions varchar(140),
activity_instructions varchar(140),
Emer_Contact varchar(40),
Emer_number varchar(14),
code varchar(8),
is_sitted boolean,
time_start date,
time_end date,
Primary key(pet_id)
) ENGINE = INNODB;