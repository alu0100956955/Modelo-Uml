-- MySQL Script generated by MySQL Workbench
-- Sat Jan  5 02:16:18 2019
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering


-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS mydb;

----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------
-- Table `mydb`.`zona`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.zona (
  nombre VARCHAR(45) NOT NULL,
  limites VARCHAR(45) NULL,
  extension VARCHAR(45) NULL,
  PRIMARY KEY (nombre));


-- -----------------------------------------------------
-- Table `mydb`.`construccion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.construccion (
  numero INT NOT NULL,
  calle VARCHAR(45) NOT NULL,
  cp INT NULL,
  m2_solar INT NULL,
  fecha_construccion DATE NULL,
  tipo VARCHAR(45) NOT NULL,
  PRIMARY KEY (numero, calle));


-- -----------------------------------------------------
-- Table `mydb`.`vivienda_unifamilar`
-- CUIDADO es unifamiLAR no unifamiLIAR
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.vivienda_unifamiliar (
  m2_construidos INT NULL,
  numero INT NULL,
  calle VARCHAR(45) NULL,
   PRIMARY KEY (calle, numero),
  CONSTRAINT numero_calle
    FOREIGN KEY (numero,calle)
    REFERENCES mydb.construccion (numero,calle)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
	
CREATE INDEX numero_idx ON mydb.vivienda_unifamiliar (numero ASC);
CREATE INDEX calle_idx ON mydb.vivienda_unifamiliar (calle ASC);

-- -----------------------------------------------------
-- Table `mydb`.`bloque`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.bloque (
  nombre VARCHAR(45) NULL,
  m2_totales INT NULL,
  num_plantas INT NULL,
  numero INT NOT NULL,
  calle VARCHAR(45) NOT NULL,
  PRIMARY KEY (calle, numero),
  CONSTRAINT numero_calle
    FOREIGN KEY (numero,calle)
    REFERENCES mydb.construccion (numero,calle)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE INDEX numero_idb ON mydb.bloque (numero ASC);

-- -----------------------------------------------------
-- Table `mydb`.`piso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.piso (
  m2_comun INT NOT NULL,
  m2_vivienda INT NOT NULL,
  portal VARCHAR(45) NOT NULL,
  planta INT NOT NULL,
  numero INT NOT NULL,
  calle VARCHAR(45) NOT NULL,
  PRIMARY KEY (m2_comun, m2_vivienda, portal, planta),
  CONSTRAINT numero_calle
    FOREIGN KEY (numero,calle)
    REFERENCES mydb.bloque (numero,calle)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

  CREATE INDEX numero_idp ON mydb.piso (numero ASC);
  CREATE INDEX calle_idp ON mydb.piso (calle ASC);

-- -----------------------------------------------------
-- Table `mydb`.`persona`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.persona (
  fecha_nac DATE NOT NULL,
  nombre VARCHAR(45) NULL,
  apellido VARCHAR(45) NULL,
  DNI INT NOT NULL,
  PRIMARY KEY (DNI));


-- -----------------------------------------------------
-- Table `mydb`.`residente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.residente (
  DNI INT NOT NULL,
  PRIMARY KEY (DNI),
  CONSTRAINT DNI
    FOREIGN KEY (DNI)
    REFERENCES mydb.persona (DNI)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mydb`.`reside_p`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.reside_p (
  m2_comun INT NOT NULL,
  m2_vivienda INT NULL,
  portal VARCHAR(45) NULL,
  planta INT NULL,
  DNI INT NULL,
  PRIMARY KEY (m2_comun),
  CONSTRAINT DNI
    FOREIGN KEY (DNI)
    REFERENCES mydb.residente (DNI)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT m2_comun_m2_vivienda_portal_planta
    FOREIGN KEY (m2_comun,m2_vivienda,portal,planta)
    REFERENCES mydb.piso (m2_comun,m2_vivienda,portal,planta)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

  CREATE INDEX DNI_idx ON mydb.reside_p (DNI ASC);
  CREATE INDEX m2_vivienda_idx ON mydb.reside_p (m2_vivienda ASC);
  CREATE INDEX portal_idx ON mydb.reside_p (portal ASC);
  CREATE INDEX planta_idx ON mydb.reside_p (planta ASC);

-- -----------------------------------------------------
-- Table `mydb`.`propietario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.propietario (
  DNI INT NOT NULL,
  PRIMARY KEY (DNI),
  CONSTRAINT DNI
    FOREIGN KEY (DNI)
    REFERENCES mydb.persona (DNI)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mydb`.`posee_p`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.posee_p (
  m2_comun INT NOT NULL,
  m2_vivienda INT NULL,
  portal VARCHAR(45) NULL,
  planta INT NULL,
  DNI INT NULL,
  PRIMARY KEY (m2_comun),
  CONSTRAINT DNI
    FOREIGN KEY (DNI)
    REFERENCES mydb.propietario (DNI)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT m2_comun_m2_vivienda_portal_planta
    FOREIGN KEY (m2_comun,m2_vivienda,portal,planta)
    REFERENCES mydb.piso (m2_comun,m2_vivienda,portal,planta)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


  CREATE INDEX DNI_idp ON mydb.posee_p (DNI ASC);
  CREATE INDEX m2_vivienda_idp ON mydb.posee_p (m2_vivienda ASC);
  CREATE INDEX portal_idp ON mydb.posee_p (portal ASC);
  CREATE INDEX planta_idp ON mydb.posee_p (planta ASC);

-- -----------------------------------------------------
-- Table `mydb`.`posee_u`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.posee_u (
  DNI INT NOT NULL,
  numero INT NULL,
  calle VARCHAR(45) NULL,
  PRIMARY KEY (DNI),
  CONSTRAINT DNI
    FOREIGN KEY (DNI)
    REFERENCES mydb.propietario (DNI)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT numero_calle_posee
    FOREIGN KEY (numero,calle)
    REFERENCES mydb.vivienda_unifamiliar (numero,calle)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

  CREATE INDEX numero_idu ON mydb.posee_u (numero ASC);
  CREATE INDEX calle_idxu ON mydb.posee_u (calle ASC);

-- -----------------------------------------------------
-- Table `mydb`.`reside_u`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.reside_u (
  DNI INT NOT NULL,
  numero INT NULL,
  calle VARCHAR(45) NULL,
  PRIMARY KEY (DNI),
  CONSTRAINT DNI
    FOREIGN KEY (DNI)
    REFERENCES mydb.residente (DNI)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT numero_calle_reside
    FOREIGN KEY (numero,calle)
    REFERENCES mydb.vivienda_unifamiliar (numero,calle)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

  CREATE INDEX numero_idru ON mydb.reside_u (numero ASC);
  CREATE INDEX calle_idru ON mydb.reside_u (calle ASC);

-- -----------------------------------------------------
-- Table `mydb`.`construccion_pertenece`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.construccion_pertenece (
  nombre VARCHAR(45) NOT NULL,
  numero INT NULL,
  calle VARCHAR(45) NULL,
  PRIMARY KEY (nombre),
  CONSTRAINT nombre
    FOREIGN KEY (nombre)
    REFERENCES mydb.zona (nombre)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT numero_calle
    FOREIGN KEY (numero,calle)
    REFERENCES mydb.construccion (numero,calle)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

  CREATE INDEX numero_idcp ON mydb.construccion_pertenece (numero ASC);
  CREATE INDEX calle_idcp ON mydb.construccion_pertenece (calle ASC);

-- -----------------------------------------------------
-- Data for table `mydb`.`zona`
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO mydb.zona (nombre, limites, extension) VALUES ('central', NULL, NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`construccion`
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO mydb.construccion (numero, calle, cp, m2_solar, fecha_construccion, tipo) VALUES (23, 'primera', NULL, NULL, NULL, 'bloque');
INSERT INTO mydb.construccion (numero, calle, cp, m2_solar, fecha_construccion, tipo) VALUES (24, 'segunda', NULL, NULL, NULL, 'vivienda');
INSERT INTO mydb.construccion (numero, calle, cp, m2_solar, fecha_construccion, tipo)  VALUES (25, 'tercera', NULL, NULL, NULL, 'vivienda');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`vivienda_unifamilar`
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO mydb.vivienda_unifamiliar (m2_construidos, numero, calle) VALUES (NULL, 24, 'segunda');
INSERT INTO mydb.vivienda_unifamiliar (m2_construidos, numero, calle) VALUES (NULL, 25, 'tercera');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`bloque`
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO mydb.bloque (nombre, m2_totales, num_plantas, numero, calle) VALUES (NULL, NULL, 2, 23, 'primera');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`piso`
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO mydb.piso (m2_comun, m2_vivienda, portal, planta, numero, calle) VALUES (70, 150, 'a', 2, 23, 'primera');
INSERT INTO mydb.piso (m2_comun, m2_vivienda, portal, planta, numero, calle) VALUES (70, 160, 'b', 2, 23, 'primera');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`persona`
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO mydb.persona (fecha_nac, nombre, apellido, DNI) VALUES ('2012-12-11', 'pepe', NULL, 4321);
INSERT INTO mydb.persona (fecha_nac, nombre, apellido, DNI)  VALUES ('2013-11-21', 'marcos', NULL, 1234);
INSERT INTO mydb.persona (fecha_nac, nombre, apellido, DNI)  VALUES ('2014-10-12', 'ramon', NULL, 234);
INSERT INTO mydb.persona (fecha_nac, nombre, apellido, DNI)  VALUES ('2015-10-15', 'alba', NULL, 432);

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`residente`
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO mydb.residente (DNI) VALUES (1234);
INSERT INTO mydb.residente (DNI) VALUES (432);

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`reside_p`
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO mydb.reside_p (m2_comun, m2_vivienda, portal, planta, DNI) VALUES (70, 160, 'b', 2, 1234);

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`propietario`
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO mydb.propietario (DNI) VALUES (4321);
INSERT INTO mydb.propietario (DNI)  VALUES (234);
 
COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`posee_p`
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO mydb.posee_p (m2_comun, m2_vivienda, portal, planta, DNI)  VALUES (70, 150, 'a', 2, 4321);

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`posee_u`
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO mydb.posee_u (DNI, numero, calle) VALUES (234, 24, 'segunda');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`reside_u`
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO mydb.reside_u (DNI, numero, calle) VALUES (432, 25, 'tercera');

COMMIT;
