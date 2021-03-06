--
-- PostgreSQL database dump
--

-- Dumped from database version 13.0
-- Dumped by pg_dump version 13.0

-- Started on 2021-01-30 14:45:59 +03

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3363 (class 1262 OID 20652)
-- Name: ImpalaRecords; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "ImpalaRecords" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.UTF-8';


ALTER DATABASE "ImpalaRecords" OWNER TO postgres;

\connect "ImpalaRecords"

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 217 (class 1255 OID 21762)
-- Name: deletestudio(character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.deletestudio(studionom character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
DELETE FROM Studio
WHERE Nom = studionom ;
END $$;


ALTER PROCEDURE public.deletestudio(studionom character varying) OWNER TO postgres;

--
-- TOC entry 231 (class 1255 OID 21818)
-- Name: fluxchangelog(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fluxchangelog() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF NEW.Flux <> OLD.Flux THEN
		 INSERT INTO Fluxchangeaudits(ChansonID,Flux,datechange)
		 VALUES(OLD.ChansonID,OLD.Flux,now());
	END IF;

	RETURN NEW;
END;$$;


ALTER FUNCTION public.fluxchangelog() OWNER TO postgres;

--
-- TOC entry 219 (class 1255 OID 21784)
-- Name: fluxlog(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fluxlog() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF NEW.Flux <> OLD.Flux THEN
		 INSERT INTO Fluxaudits(ChansonID,Flux,datehit)
		 VALUES(OLD.ChangeID,OLD.Flux,now());
	END IF;

	RETURN NEW;
END;
$$;


ALTER FUNCTION public.fluxlog() OWNER TO postgres;

--
-- TOC entry 218 (class 1255 OID 21773)
-- Name: hitlog(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.hitlog() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF NEW.Flux <> OLD.Flux THEN
		 INSERT INTO Hitaudits(ChansonID,Flux,datehit)
		 VALUES(OLD.HitID,OLD.Flux,now());
	END IF;

	RETURN NEW;
END;
$$;


ALTER FUNCTION public.hitlog() OWNER TO postgres;

--
-- TOC entry 215 (class 1255 OID 21760)
-- Name: insertfestival(character varying, timestamp without time zone, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.insertfestival(festnom character varying, festdebut timestamp without time zone, lieuid integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
INSERT INTO Festival(
			FestivalID,
			nom,
			"DateFestDebut",
			lieuid)
VALUES ((SELECT MAX(FestivalID)+1 FROM public.Festival),festnom,FestDebut,lieuid);
COMMIT;
END ; $$;


ALTER PROCEDURE public.insertfestival(festnom character varying, festdebut timestamp without time zone, lieuid integer) OWNER TO postgres;

--
-- TOC entry 216 (class 1255 OID 21761)
-- Name: updateflux(character varying, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.updateflux(chansontitre character varying, nouveauflux integer)
    LANGUAGE plpgsql
    AS $$
	BEGIN
	UPDATE Chanson
	SET flux = nouveauflux
WHERE Titre = ChansonTitre ;
END ; $$;


ALTER PROCEDURE public.updateflux(chansontitre character varying, nouveauflux integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 201 (class 1259 OID 21538)
-- Name: album; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.album (
    albumid integer NOT NULL,
    titre character varying(100) NOT NULL,
    datedecopyright date NOT NULL,
    nbchanson integer NOT NULL
);


ALTER TABLE public.album OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 21548)
-- Name: artist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.artist (
    artistid integer NOT NULL,
    prenom character varying(50) NOT NULL,
    nom character varying(50) NOT NULL,
    paysdorigine character varying(100) NOT NULL,
    anniversaire date NOT NULL,
    bandid integer
);


ALTER TABLE public.artist OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 21543)
-- Name: band; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.band (
    bandid integer NOT NULL,
    nom character varying(50) NOT NULL,
    paysdorigine character varying(100) NOT NULL,
    fonddate date NOT NULL
);


ALTER TABLE public.band OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 21583)
-- Name: chanson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chanson (
    chansonid integer NOT NULL,
    titre character varying(100) NOT NULL,
    datedecopyright date NOT NULL,
    flux integer NOT NULL,
    genreid integer NOT NULL,
    albumid integer,
    artistid integer NOT NULL,
    studioid integer NOT NULL
);


ALTER TABLE public.chanson OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 21680)
-- Name: concert; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.concert (
    concertid integer NOT NULL,
    dateconcertdebut timestamp without time zone NOT NULL,
    lieuid integer NOT NULL,
    festivalid integer
);


ALTER TABLE public.concert OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 21665)
-- Name: concertchansonlist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.concertchansonlist (
    concertlistid integer NOT NULL,
    chansonid integer NOT NULL,
    concertid integer NOT NULL
);


ALTER TABLE public.concertchansonlist OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 21618)
-- Name: festival; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.festival (
    festivalid integer NOT NULL,
    nom character varying(50) NOT NULL,
    "DateFestDebut" timestamp without time zone NOT NULL,
    lieuid integer NOT NULL
);


ALTER TABLE public.festival OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 21832)
-- Name: fluxchangeaudits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fluxchangeaudits (
    changeid integer NOT NULL,
    chansonid integer NOT NULL,
    flux integer NOT NULL,
    datechange timestamp without time zone NOT NULL
);


ALTER TABLE public.fluxchangeaudits OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 21830)
-- Name: fluxchangeaudits_changeid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.fluxchangeaudits ALTER COLUMN changeid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.fluxchangeaudits_changeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 200 (class 1259 OID 21533)
-- Name: genre; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.genre (
    genreid integer NOT NULL,
    nom character varying(100) NOT NULL
);


ALTER TABLE public.genre OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 21563)
-- Name: studio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.studio (
    studioid integer NOT NULL,
    nom character varying(50) NOT NULL,
    adresse character varying(100) NOT NULL,
    prop character varying(100) NOT NULL,
    proptel character varying(20) NOT NULL
);


ALTER TABLE public.studio OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 21715)
-- Name: fullinfoaboutsongs; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.fullinfoaboutsongs AS
 SELECT chanson.titre,
    band.nom AS band,
    artist.prenom AS artistprenom,
    artist.nom AS artistnom,
    genre.nom AS genre,
    chanson.flux AS nombredeflux,
    studio.adresse AS studioadresse
   FROM ((((public.chanson
     JOIN public.artist ON ((artist.artistid = chanson.artistid)))
     JOIN public.genre ON ((chanson.genreid = genre.genreid)))
     JOIN public.studio ON ((studio.studioid = chanson.studioid)))
     LEFT JOIN public.band ON ((band.bandid = artist.bandid)));


ALTER TABLE public.fullinfoaboutsongs OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 21558)
-- Name: instrument; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instrument (
    instrumentid integer NOT NULL,
    nom character varying(100) NOT NULL,
    marque character varying(100) NOT NULL
);


ALTER TABLE public.instrument OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 21643)
-- Name: instrumentlist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instrumentlist (
    instrumentlistid integer NOT NULL,
    instrumentid integer NOT NULL,
    chansonid integer NOT NULL
);


ALTER TABLE public.instrumentlist OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 21568)
-- Name: lieu; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lieu (
    lieuid integer NOT NULL,
    nom character varying(100) NOT NULL,
    typedezone character varying(100) NOT NULL,
    city character varying(100) NOT NULL,
    country character varying(100) NOT NULL
);


ALTER TABLE public.lieu OWNER TO postgres;

--
-- TOC entry 3345 (class 0 OID 21538)
-- Dependencies: 201
-- Data for Name: album; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.album VALUES (1, 'The Slow Rush', '2020-02-14', 12);
INSERT INTO public.album VALUES (2, 'Currents', '2015-07-17', 13);
INSERT INTO public.album VALUES (3, 'My Dear Melancholy', '2018-03-30', 7);
INSERT INTO public.album VALUES (4, 'Little Dark Age', '2018-02-02', 10);
INSERT INTO public.album VALUES (5, 'AM', '2013-09-09', 12);
INSERT INTO public.album VALUES (6, 'Tasmania', '2019-03-01', 10);


--
-- TOC entry 3347 (class 0 OID 21548)
-- Dependencies: 203
-- Data for Name: artist; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.artist VALUES (1, 'Kevin', 'Parker', 'Australie', '1986-01-20', 1);
INSERT INTO public.artist VALUES (2, 'Abel', 'Tesfaye', 'Canada', '1990-02-16', NULL);
INSERT INTO public.artist VALUES (3, 'Alex', 'Turner', 'États-Unis', '1986-01-06', 3);
INSERT INTO public.artist VALUES (4, 'Jay', 'Watson', 'Australie', '1990-05-27', 4);
INSERT INTO public.artist VALUES (5, 'Benjamin', 'Goldwasser', 'États-Unis', '1988-06-14', 2);


--
-- TOC entry 3346 (class 0 OID 21543)
-- Dependencies: 202
-- Data for Name: band; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.band VALUES (1, 'Tame Impala', 'Australie', '2007-10-05');
INSERT INTO public.band VALUES (2, 'MGMT', 'États-Unis', '2002-07-17');
INSERT INTO public.band VALUES (3, 'Arctic Monkeys', 'États-Unis', '2002-01-09');
INSERT INTO public.band VALUES (4, 'Pond', 'Australie', '2008-03-26');


--
-- TOC entry 3351 (class 0 OID 21583)
-- Dependencies: 207
-- Data for Name: chanson; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.chanson VALUES (1, 'One More Year', '2020-02-14', 19994938, 1, 1, 1, 9);
INSERT INTO public.chanson VALUES (3, 'New Person Same Old Mistakes', '2015-07-17', 19994938, 1, 2, 1, 1);
INSERT INTO public.chanson VALUES (4, 'Patience', '2019-04-10', 60418978, 2, NULL, 1, 3);
INSERT INTO public.chanson VALUES (5, 'Eventually', '2015-07-17', 47784548, 1, 2, 1, 1);
INSERT INTO public.chanson VALUES (6, 'Let It Happen', '2015-07-17', 220983804, 1, 2, 1, 1);
INSERT INTO public.chanson VALUES (7, 'The Moment', '2015-07-17', 114547049, 1, 2, 1, 1);
INSERT INTO public.chanson VALUES (8, 'I Was Never There', '2018-10-22', 435876391, 5, 3, 2, 4);
INSERT INTO public.chanson VALUES (9, 'Starboy', '2017-03-11', 811643206, 5, NULL, 2, 5);
INSERT INTO public.chanson VALUES (10, 'I Feel It Coming', '2016-05-21', 975178578, 6, NULL, 2, 2);
INSERT INTO public.chanson VALUES (11, 'Repeat After Me', '2020-05-21', 67245692, 4, NULL, 2, 6);
INSERT INTO public.chanson VALUES (12, 'Do I Wanna Know?', '2013-09-09', 765570842, 3, 5, 3, 2);
INSERT INTO public.chanson VALUES (13, 'I Wanna Be Yours', '2013-09-09', 727317869, 3, 5, 3, 2);
INSERT INTO public.chanson VALUES (14, 'No.1 Party Anthem', '2013-09-09', 616793702, 3, 5, 3, 2);
INSERT INTO public.chanson VALUES (15, 'R U Mine?', '2013-09-09', 389736872, 3, 5, 3, 2);
INSERT INTO public.chanson VALUES (16, 'Star Treatment', '2018-05-10', 975178578, 3, NULL, 3, 2);
INSERT INTO public.chanson VALUES (17, 'The Boys Are Killing Me', '2019-03-01', 56715839, 2, 6, 4, 8);
INSERT INTO public.chanson VALUES (18, 'Daisy', '2019-03-01', 33234806, 2, 6, 4, 8);
INSERT INTO public.chanson VALUES (19, 'Paint Me Silver', '2015-08-10', 82841199, 4, NULL, 2, 2);
INSERT INTO public.chanson VALUES (20, 'Sweep Me Of My Feet', '2016-05-21', 34426857, 6, NULL, 2, 7);
INSERT INTO public.chanson VALUES (21, 'Little Dark Age', '2018-02-09', 452969984, 4, 4, 5, 7);
INSERT INTO public.chanson VALUES (23, 'When You Die', '2018-02-09', 769567136, 4, 4, 5, 7);
INSERT INTO public.chanson VALUES (24, 'Electric Feel', '2007-11-12', 179348604, 5, NULL, 5, 5);
INSERT INTO public.chanson VALUES (25, 'Time To Pretend', '2008-07-24', 624639431, 5, NULL, 5, 3);
INSERT INTO public.chanson VALUES (22, 'TSLAMP', '2018-02-09', 430367632, 4, 4, 5, 7);
INSERT INTO public.chanson VALUES (2, 'On Track', '2020-02-14', 991124634, 1, 1, 1, 9);


--
-- TOC entry 3355 (class 0 OID 21680)
-- Dependencies: 211
-- Data for Name: concert; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.concert VALUES (1, '2019-06-09 18:30:00', 1, NULL);
INSERT INTO public.concert VALUES (2, '2020-03-20 21:00:00', 1, NULL);
INSERT INTO public.concert VALUES (3, '2019-04-12 22:00:00', 1, NULL);
INSERT INTO public.concert VALUES (4, '2019-04-28 23:00:00', 2, NULL);
INSERT INTO public.concert VALUES (5, '2020-02-11 19:30:00', 2, NULL);
INSERT INTO public.concert VALUES (6, '2019-07-03 23:30:00', 2, NULL);
INSERT INTO public.concert VALUES (7, '2019-06-07 18:30:00', 2, NULL);
INSERT INTO public.concert VALUES (8, '2019-06-25 19:00:00', 3, NULL);
INSERT INTO public.concert VALUES (9, '2019-07-03 22:00:00', 4, NULL);
INSERT INTO public.concert VALUES (10, '2019-08-17 16:30:00', 4, NULL);
INSERT INTO public.concert VALUES (11, '2019-04-12 22:00:00', 5, 1);
INSERT INTO public.concert VALUES (12, '2019-04-12 23:00:00', 5, 1);
INSERT INTO public.concert VALUES (13, '2019-05-12 12:00:00', 6, 2);
INSERT INTO public.concert VALUES (14, '2019-05-12 12:00:00', 6, 2);
INSERT INTO public.concert VALUES (15, '2019-10-14 21:30:00', 7, 3);
INSERT INTO public.concert VALUES (16, '2019-10-14 22:30:00', 7, 3);
INSERT INTO public.concert VALUES (17, '2019-11-27 19:00:00', 8, 4);
INSERT INTO public.concert VALUES (18, '2019-11-27 20:30:00', 8, 4);
INSERT INTO public.concert VALUES (19, '2020-02-21 23:00:00', 9, NULL);
INSERT INTO public.concert VALUES (20, '2019-09-27 20:30:00', 9, NULL);


--
-- TOC entry 3354 (class 0 OID 21665)
-- Dependencies: 210
-- Data for Name: concertchansonlist; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.concertchansonlist VALUES (1, 1, 1);
INSERT INTO public.concertchansonlist VALUES (2, 2, 1);
INSERT INTO public.concertchansonlist VALUES (3, 4, 1);
INSERT INTO public.concertchansonlist VALUES (4, 8, 2);
INSERT INTO public.concertchansonlist VALUES (5, 9, 2);
INSERT INTO public.concertchansonlist VALUES (6, 13, 3);
INSERT INTO public.concertchansonlist VALUES (7, 14, 3);
INSERT INTO public.concertchansonlist VALUES (8, 16, 3);
INSERT INTO public.concertchansonlist VALUES (9, 20, 4);
INSERT INTO public.concertchansonlist VALUES (10, 21, 4);
INSERT INTO public.concertchansonlist VALUES (11, 17, 5);
INSERT INTO public.concertchansonlist VALUES (12, 18, 5);
INSERT INTO public.concertchansonlist VALUES (13, 1, 6);
INSERT INTO public.concertchansonlist VALUES (14, 3, 6);
INSERT INTO public.concertchansonlist VALUES (15, 5, 6);
INSERT INTO public.concertchansonlist VALUES (16, 8, 7);
INSERT INTO public.concertchansonlist VALUES (17, 9, 7);
INSERT INTO public.concertchansonlist VALUES (18, 10, 7);
INSERT INTO public.concertchansonlist VALUES (19, 11, 7);
INSERT INTO public.concertchansonlist VALUES (20, 24, 8);
INSERT INTO public.concertchansonlist VALUES (21, 25, 8);
INSERT INTO public.concertchansonlist VALUES (22, 12, 9);
INSERT INTO public.concertchansonlist VALUES (23, 13, 9);
INSERT INTO public.concertchansonlist VALUES (24, 14, 9);
INSERT INTO public.concertchansonlist VALUES (25, 22, 10);
INSERT INTO public.concertchansonlist VALUES (26, 23, 10);
INSERT INTO public.concertchansonlist VALUES (27, 24, 10);
INSERT INTO public.concertchansonlist VALUES (28, 25, 10);
INSERT INTO public.concertchansonlist VALUES (29, 1, 11);
INSERT INTO public.concertchansonlist VALUES (30, 2, 11);
INSERT INTO public.concertchansonlist VALUES (31, 3, 11);
INSERT INTO public.concertchansonlist VALUES (32, 4, 11);
INSERT INTO public.concertchansonlist VALUES (33, 5, 11);
INSERT INTO public.concertchansonlist VALUES (34, 6, 11);
INSERT INTO public.concertchansonlist VALUES (35, 7, 11);
INSERT INTO public.concertchansonlist VALUES (36, 8, 11);
INSERT INTO public.concertchansonlist VALUES (37, 9, 12);
INSERT INTO public.concertchansonlist VALUES (38, 10, 12);
INSERT INTO public.concertchansonlist VALUES (39, 11, 12);
INSERT INTO public.concertchansonlist VALUES (40, 12, 12);
INSERT INTO public.concertchansonlist VALUES (41, 13, 12);
INSERT INTO public.concertchansonlist VALUES (42, 14, 12);
INSERT INTO public.concertchansonlist VALUES (43, 15, 12);
INSERT INTO public.concertchansonlist VALUES (44, 16, 12);
INSERT INTO public.concertchansonlist VALUES (45, 17, 12);
INSERT INTO public.concertchansonlist VALUES (46, 19, 12);
INSERT INTO public.concertchansonlist VALUES (47, 1, 13);
INSERT INTO public.concertchansonlist VALUES (48, 20, 13);
INSERT INTO public.concertchansonlist VALUES (49, 21, 13);
INSERT INTO public.concertchansonlist VALUES (50, 22, 13);
INSERT INTO public.concertchansonlist VALUES (51, 23, 13);
INSERT INTO public.concertchansonlist VALUES (52, 24, 13);
INSERT INTO public.concertchansonlist VALUES (53, 25, 13);
INSERT INTO public.concertchansonlist VALUES (54, 2, 13);
INSERT INTO public.concertchansonlist VALUES (55, 3, 13);
INSERT INTO public.concertchansonlist VALUES (56, 4, 14);
INSERT INTO public.concertchansonlist VALUES (57, 5, 14);
INSERT INTO public.concertchansonlist VALUES (58, 6, 14);
INSERT INTO public.concertchansonlist VALUES (59, 7, 14);
INSERT INTO public.concertchansonlist VALUES (60, 8, 14);
INSERT INTO public.concertchansonlist VALUES (61, 9, 14);
INSERT INTO public.concertchansonlist VALUES (62, 10, 14);
INSERT INTO public.concertchansonlist VALUES (63, 11, 14);
INSERT INTO public.concertchansonlist VALUES (64, 12, 14);
INSERT INTO public.concertchansonlist VALUES (65, 1, 15);
INSERT INTO public.concertchansonlist VALUES (66, 14, 15);
INSERT INTO public.concertchansonlist VALUES (67, 15, 15);
INSERT INTO public.concertchansonlist VALUES (68, 16, 15);
INSERT INTO public.concertchansonlist VALUES (69, 17, 15);
INSERT INTO public.concertchansonlist VALUES (70, 18, 15);
INSERT INTO public.concertchansonlist VALUES (71, 19, 15);
INSERT INTO public.concertchansonlist VALUES (72, 20, 15);
INSERT INTO public.concertchansonlist VALUES (73, 21, 15);
INSERT INTO public.concertchansonlist VALUES (74, 22, 16);
INSERT INTO public.concertchansonlist VALUES (75, 23, 16);
INSERT INTO public.concertchansonlist VALUES (76, 24, 16);
INSERT INTO public.concertchansonlist VALUES (77, 25, 16);
INSERT INTO public.concertchansonlist VALUES (78, 2, 16);
INSERT INTO public.concertchansonlist VALUES (79, 3, 16);
INSERT INTO public.concertchansonlist VALUES (80, 4, 16);
INSERT INTO public.concertchansonlist VALUES (81, 5, 16);
INSERT INTO public.concertchansonlist VALUES (82, 6, 16);
INSERT INTO public.concertchansonlist VALUES (83, 1, 17);
INSERT INTO public.concertchansonlist VALUES (84, 7, 17);
INSERT INTO public.concertchansonlist VALUES (85, 8, 17);
INSERT INTO public.concertchansonlist VALUES (86, 9, 17);
INSERT INTO public.concertchansonlist VALUES (87, 10, 17);
INSERT INTO public.concertchansonlist VALUES (88, 11, 17);
INSERT INTO public.concertchansonlist VALUES (89, 12, 17);
INSERT INTO public.concertchansonlist VALUES (90, 13, 17);
INSERT INTO public.concertchansonlist VALUES (91, 14, 17);
INSERT INTO public.concertchansonlist VALUES (92, 15, 18);
INSERT INTO public.concertchansonlist VALUES (93, 16, 18);
INSERT INTO public.concertchansonlist VALUES (94, 17, 18);
INSERT INTO public.concertchansonlist VALUES (95, 18, 18);
INSERT INTO public.concertchansonlist VALUES (96, 19, 18);
INSERT INTO public.concertchansonlist VALUES (97, 20, 18);
INSERT INTO public.concertchansonlist VALUES (98, 21, 18);
INSERT INTO public.concertchansonlist VALUES (99, 22, 18);
INSERT INTO public.concertchansonlist VALUES (100, 23, 18);
INSERT INTO public.concertchansonlist VALUES (101, 17, 19);
INSERT INTO public.concertchansonlist VALUES (102, 18, 19);
INSERT INTO public.concertchansonlist VALUES (103, 19, 19);
INSERT INTO public.concertchansonlist VALUES (104, 1, 20);
INSERT INTO public.concertchansonlist VALUES (105, 2, 20);
INSERT INTO public.concertchansonlist VALUES (106, 3, 20);
INSERT INTO public.concertchansonlist VALUES (107, 5, 20);
INSERT INTO public.concertchansonlist VALUES (108, 7, 20);


--
-- TOC entry 3352 (class 0 OID 21618)
-- Dependencies: 208
-- Data for Name: festival; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.festival VALUES (1, 'Lolapalooza', '2019-04-12 20:00:00', 5);
INSERT INTO public.festival VALUES (2, 'Coachella', '2019-05-12 12:00:00', 6);
INSERT INTO public.festival VALUES (3, 'Glastonbury', '2019-10-14 21:00:00', 7);
INSERT INTO public.festival VALUES (4, 'Sziget', '2019-11-27 18:00:00', 8);
INSERT INTO public.festival VALUES (5, 'Music Festival', '2019-11-05 21:30:00', 4);


--
-- TOC entry 3357 (class 0 OID 21832)
-- Dependencies: 214
-- Data for Name: fluxchangeaudits; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.fluxchangeaudits OVERRIDING SYSTEM VALUE VALUES (1, 2, 990124634, '2021-01-14 22:32:06.844433');


--
-- TOC entry 3344 (class 0 OID 21533)
-- Dependencies: 200
-- Data for Name: genre; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.genre VALUES (1, 'Rock Psychédélique');
INSERT INTO public.genre VALUES (2, 'Dream Pop');
INSERT INTO public.genre VALUES (3, 'Indé');
INSERT INTO public.genre VALUES (4, 'Pop Psychédélique');
INSERT INTO public.genre VALUES (5, 'Raï n B');
INSERT INTO public.genre VALUES (6, 'Électro-pop');


--
-- TOC entry 3348 (class 0 OID 21558)
-- Dependencies: 204
-- Data for Name: instrument; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.instrument VALUES (1, 'Synthétiseur', 'Roland');
INSERT INTO public.instrument VALUES (2, 'Guitare électro', 'Yamaha');
INSERT INTO public.instrument VALUES (3, 'Tambour', 'Gibson');
INSERT INTO public.instrument VALUES (4, 'Violon', 'Sennheiser');
INSERT INTO public.instrument VALUES (5, 'Clavier', 'Roland');
INSERT INTO public.instrument VALUES (6, 'Piano', 'Roland');
INSERT INTO public.instrument VALUES (7, 'Guitare basse', 'Roland');
INSERT INTO public.instrument VALUES (8, 'Guitare acoustique', 'Yamaha');
INSERT INTO public.instrument VALUES (9, 'Guitare principale', 'Gibson');
INSERT INTO public.instrument VALUES (10, 'Caisse claire', 'Steinway');
INSERT INTO public.instrument VALUES (11, 'Conga', 'Yamaha');
INSERT INTO public.instrument VALUES (12, 'Violoncelle', 'Sennheiser');
INSERT INTO public.instrument VALUES (13, 'Orgue', 'Steinway');
INSERT INTO public.instrument VALUES (14, 'Piano électronique', 'Yamaha');


--
-- TOC entry 3353 (class 0 OID 21643)
-- Dependencies: 209
-- Data for Name: instrumentlist; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.instrumentlist VALUES (1, 7, 1);
INSERT INTO public.instrumentlist VALUES (2, 7, 2);
INSERT INTO public.instrumentlist VALUES (3, 7, 3);
INSERT INTO public.instrumentlist VALUES (4, 7, 4);
INSERT INTO public.instrumentlist VALUES (5, 7, 5);
INSERT INTO public.instrumentlist VALUES (6, 7, 6);
INSERT INTO public.instrumentlist VALUES (7, 7, 7);
INSERT INTO public.instrumentlist VALUES (8, 7, 8);
INSERT INTO public.instrumentlist VALUES (9, 7, 9);
INSERT INTO public.instrumentlist VALUES (10, 7, 10);
INSERT INTO public.instrumentlist VALUES (11, 7, 11);
INSERT INTO public.instrumentlist VALUES (12, 7, 12);
INSERT INTO public.instrumentlist VALUES (13, 7, 13);
INSERT INTO public.instrumentlist VALUES (14, 7, 14);
INSERT INTO public.instrumentlist VALUES (15, 7, 15);
INSERT INTO public.instrumentlist VALUES (16, 7, 16);
INSERT INTO public.instrumentlist VALUES (17, 7, 17);
INSERT INTO public.instrumentlist VALUES (18, 7, 18);
INSERT INTO public.instrumentlist VALUES (19, 7, 19);
INSERT INTO public.instrumentlist VALUES (20, 7, 20);
INSERT INTO public.instrumentlist VALUES (21, 7, 21);
INSERT INTO public.instrumentlist VALUES (22, 7, 22);
INSERT INTO public.instrumentlist VALUES (23, 7, 23);
INSERT INTO public.instrumentlist VALUES (24, 7, 24);
INSERT INTO public.instrumentlist VALUES (25, 7, 25);
INSERT INTO public.instrumentlist VALUES (26, 1, 1);
INSERT INTO public.instrumentlist VALUES (27, 1, 2);
INSERT INTO public.instrumentlist VALUES (28, 1, 3);
INSERT INTO public.instrumentlist VALUES (29, 1, 4);
INSERT INTO public.instrumentlist VALUES (30, 2, 25);
INSERT INTO public.instrumentlist VALUES (31, 3, 25);
INSERT INTO public.instrumentlist VALUES (32, 4, 24);
INSERT INTO public.instrumentlist VALUES (33, 5, 23);
INSERT INTO public.instrumentlist VALUES (34, 6, 23);
INSERT INTO public.instrumentlist VALUES (35, 4, 22);
INSERT INTO public.instrumentlist VALUES (36, 2, 22);
INSERT INTO public.instrumentlist VALUES (37, 2, 2);
INSERT INTO public.instrumentlist VALUES (38, 3, 2);
INSERT INTO public.instrumentlist VALUES (39, 3, 21);
INSERT INTO public.instrumentlist VALUES (40, 4, 20);
INSERT INTO public.instrumentlist VALUES (41, 5, 19);
INSERT INTO public.instrumentlist VALUES (42, 2, 18);
INSERT INTO public.instrumentlist VALUES (43, 1, 17);
INSERT INTO public.instrumentlist VALUES (44, 2, 16);
INSERT INTO public.instrumentlist VALUES (45, 3, 15);
INSERT INTO public.instrumentlist VALUES (46, 2, 14);
INSERT INTO public.instrumentlist VALUES (47, 14, 13);
INSERT INTO public.instrumentlist VALUES (48, 13, 12);
INSERT INTO public.instrumentlist VALUES (49, 8, 11);
INSERT INTO public.instrumentlist VALUES (50, 9, 11);
INSERT INTO public.instrumentlist VALUES (51, 5, 10);
INSERT INTO public.instrumentlist VALUES (52, 5, 9);
INSERT INTO public.instrumentlist VALUES (53, 9, 8);
INSERT INTO public.instrumentlist VALUES (54, 11, 7);
INSERT INTO public.instrumentlist VALUES (55, 10, 6);
INSERT INTO public.instrumentlist VALUES (56, 4, 6);
INSERT INTO public.instrumentlist VALUES (57, 14, 6);
INSERT INTO public.instrumentlist VALUES (58, 3, 17);
INSERT INTO public.instrumentlist VALUES (59, 11, 17);
INSERT INTO public.instrumentlist VALUES (60, 14, 5);
INSERT INTO public.instrumentlist VALUES (61, 13, 5);
INSERT INTO public.instrumentlist VALUES (62, 12, 4);
INSERT INTO public.instrumentlist VALUES (63, 11, 4);
INSERT INTO public.instrumentlist VALUES (64, 14, 3);
INSERT INTO public.instrumentlist VALUES (65, 4, 3);
INSERT INTO public.instrumentlist VALUES (66, 8, 12);
INSERT INTO public.instrumentlist VALUES (67, 3, 4);
INSERT INTO public.instrumentlist VALUES (68, 13, 11);
INSERT INTO public.instrumentlist VALUES (69, 1, 10);
INSERT INTO public.instrumentlist VALUES (70, 9, 9);
INSERT INTO public.instrumentlist VALUES (71, 12, 8);
INSERT INTO public.instrumentlist VALUES (72, 12, 7);
INSERT INTO public.instrumentlist VALUES (73, 13, 6);
INSERT INTO public.instrumentlist VALUES (74, 3, 2);
INSERT INTO public.instrumentlist VALUES (75, 9, 4);
INSERT INTO public.instrumentlist VALUES (76, 2, 3);
INSERT INTO public.instrumentlist VALUES (77, 6, 3);
INSERT INTO public.instrumentlist VALUES (78, 3, 4);
INSERT INTO public.instrumentlist VALUES (79, 9, 5);
INSERT INTO public.instrumentlist VALUES (80, 3, 6);
INSERT INTO public.instrumentlist VALUES (81, 12, 7);
INSERT INTO public.instrumentlist VALUES (82, 11, 8);
INSERT INTO public.instrumentlist VALUES (83, 10, 9);
INSERT INTO public.instrumentlist VALUES (84, 6, 10);
INSERT INTO public.instrumentlist VALUES (85, 10, 11);
INSERT INTO public.instrumentlist VALUES (86, 11, 12);
INSERT INTO public.instrumentlist VALUES (87, 12, 13);
INSERT INTO public.instrumentlist VALUES (88, 5, 14);
INSERT INTO public.instrumentlist VALUES (89, 4, 15);
INSERT INTO public.instrumentlist VALUES (90, 3, 16);
INSERT INTO public.instrumentlist VALUES (91, 10, 17);
INSERT INTO public.instrumentlist VALUES (92, 1, 18);
INSERT INTO public.instrumentlist VALUES (93, 4, 19);
INSERT INTO public.instrumentlist VALUES (94, 12, 20);
INSERT INTO public.instrumentlist VALUES (95, 12, 19);
INSERT INTO public.instrumentlist VALUES (96, 11, 18);
INSERT INTO public.instrumentlist VALUES (97, 10, 17);
INSERT INTO public.instrumentlist VALUES (98, 9, 16);
INSERT INTO public.instrumentlist VALUES (99, 3, 15);
INSERT INTO public.instrumentlist VALUES (100, 6, 14);


--
-- TOC entry 3350 (class 0 OID 21568)
-- Dependencies: 206
-- Data for Name: lieu; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.lieu VALUES (1, 'Staples Center', 'Stade', 'Los Angeles', 'États-Unis');
INSERT INTO public.lieu VALUES (2, 'Bataclan', 'Music-hall', 'Paris', 'France');
INSERT INTO public.lieu VALUES (3, 'Enmore Theatre', 'Music-hall', 'Sydney', 'Australie');
INSERT INTO public.lieu VALUES (5, 'Grant Park', 'En plein air', 'Chicago', 'États-Unis');
INSERT INTO public.lieu VALUES (6, 'Indio', 'En plein air', 'Palm Springs', 'États-Unis');
INSERT INTO public.lieu VALUES (7, 'Óbuda', 'En plein air', 'Budapest', 'Hongrie');
INSERT INTO public.lieu VALUES (8, 'Avalon', 'En plein air', 'Glastonbury', 'Royaume-Uni');
INSERT INTO public.lieu VALUES (9, 'Vodafone Park', 'Stade', 'Istanbul', 'Turquie');
INSERT INTO public.lieu VALUES (4, 'Madison Square Garden', 'En plein air', 'New York', 'États-Unis');


--
-- TOC entry 3349 (class 0 OID 21563)
-- Dependencies: 205
-- Data for Name: studio; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.studio VALUES (1, 'Paramount Recording Studio', '6245 Santa Monica Blvd, Los Angeles, CA 90038', 'Adam Beilenson', '+1 323-465-4000');
INSERT INTO public.studio VALUES (2, 'Hollywood Records Studio', '500 S Buena Vista St, Burbank, CA 91521', 'Michael Eisner', '+1 818-560-5670');
INSERT INTO public.studio VALUES (3, 'Capital Records Studio', '16 Oakwood St. San Diego, CA 92126', 'Alfredo Edwards', '+1 402-841-5468');
INSERT INTO public.studio VALUES (4, 'XO Studio', '584A County St. Oakland, CA 94601', 'Rosamaria Farris', '+1 867-826-8264');
INSERT INTO public.studio VALUES (5, 'Universal Music Studio', '76 Fairway Road Los Angeles, CA 90042', 'Philip Johnson', '+1 430-233-4282');
INSERT INTO public.studio VALUES (6, 'Interscope Records Studio', '9114 Cobblestone Street San Jose, CA 95123', 'Sara Alexander', '+1 686-969-5299');
INSERT INTO public.studio VALUES (7, 'Silverside Recording Studio', '208 White Rd. San Diego, CA 92115', 'Sara Alexander', '+1-266-778-0196');
INSERT INTO public.studio VALUES (8, 'Arts & Crafts Records Studio', '395 Queen St W, Toronto, ON M5V 2A5', 'Anthony Jackson', '+1-613-555-0115');
INSERT INTO public.studio VALUES (9, 'Modular Interscope Fiction Studio', '11-19 Hargrave St, East Sydney NSW 2010', 'Joshua Clark', '+61 1900 654 321');


--
-- TOC entry 3364 (class 0 OID 0)
-- Dependencies: 213
-- Name: fluxchangeaudits_changeid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fluxchangeaudits_changeid_seq', 1, true);


--
-- TOC entry 3178 (class 2606 OID 21542)
-- Name: album album_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.album
    ADD CONSTRAINT album_pkey PRIMARY KEY (albumid);


--
-- TOC entry 3182 (class 2606 OID 21552)
-- Name: artist artist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artist
    ADD CONSTRAINT artist_pkey PRIMARY KEY (artistid);


--
-- TOC entry 3180 (class 2606 OID 21547)
-- Name: band band_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.band
    ADD CONSTRAINT band_pkey PRIMARY KEY (bandid);


--
-- TOC entry 3191 (class 2606 OID 21587)
-- Name: chanson chanson_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chanson
    ADD CONSTRAINT chanson_pkey PRIMARY KEY (chansonid);


--
-- TOC entry 3199 (class 2606 OID 21684)
-- Name: concert concert_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.concert
    ADD CONSTRAINT concert_pkey PRIMARY KEY (concertid);


--
-- TOC entry 3197 (class 2606 OID 21669)
-- Name: concertchansonlist concertchansonlist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.concertchansonlist
    ADD CONSTRAINT concertchansonlist_pkey PRIMARY KEY (concertlistid);


--
-- TOC entry 3193 (class 2606 OID 21622)
-- Name: festival festival_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.festival
    ADD CONSTRAINT festival_pkey PRIMARY KEY (festivalid);


--
-- TOC entry 3176 (class 2606 OID 21537)
-- Name: genre genre_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genre
    ADD CONSTRAINT genre_pkey PRIMARY KEY (genreid);


--
-- TOC entry 3184 (class 2606 OID 21562)
-- Name: instrument instrument_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument
    ADD CONSTRAINT instrument_pkey PRIMARY KEY (instrumentid);


--
-- TOC entry 3195 (class 2606 OID 21647)
-- Name: instrumentlist instrumentlist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrumentlist
    ADD CONSTRAINT instrumentlist_pkey PRIMARY KEY (instrumentlistid);


--
-- TOC entry 3189 (class 2606 OID 21572)
-- Name: lieu lieu_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lieu
    ADD CONSTRAINT lieu_pkey PRIMARY KEY (lieuid);


--
-- TOC entry 3187 (class 2606 OID 21567)
-- Name: studio studio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.studio
    ADD CONSTRAINT studio_pkey PRIMARY KEY (studioid);


--
-- TOC entry 3185 (class 1259 OID 21844)
-- Name: instrumentindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX instrumentindex ON public.instrument USING btree (nom);


--
-- TOC entry 3212 (class 2620 OID 21843)
-- Name: chanson fluxchangetrigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER fluxchangetrigger BEFORE UPDATE OF flux ON public.chanson FOR EACH ROW EXECUTE FUNCTION public.fluxchangelog();


--
-- TOC entry 3202 (class 2606 OID 21593)
-- Name: chanson fk_album; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chanson
    ADD CONSTRAINT fk_album FOREIGN KEY (albumid) REFERENCES public.album(albumid);


--
-- TOC entry 3203 (class 2606 OID 21598)
-- Name: chanson fk_artist; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chanson
    ADD CONSTRAINT fk_artist FOREIGN KEY (artistid) REFERENCES public.artist(artistid);


--
-- TOC entry 3200 (class 2606 OID 21553)
-- Name: artist fk_band; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artist
    ADD CONSTRAINT fk_band FOREIGN KEY (bandid) REFERENCES public.band(bandid);


--
-- TOC entry 3211 (class 2606 OID 21835)
-- Name: fluxchangeaudits fk_changechanson; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fluxchangeaudits
    ADD CONSTRAINT fk_changechanson FOREIGN KEY (chansonid) REFERENCES public.chanson(chansonid);


--
-- TOC entry 3208 (class 2606 OID 21670)
-- Name: concertchansonlist fk_concertchanson; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.concertchansonlist
    ADD CONSTRAINT fk_concertchanson FOREIGN KEY (chansonid) REFERENCES public.chanson(chansonid);


--
-- TOC entry 3210 (class 2606 OID 21690)
-- Name: concert fk_festconcert; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.concert
    ADD CONSTRAINT fk_festconcert FOREIGN KEY (festivalid) REFERENCES public.festival(festivalid);


--
-- TOC entry 3201 (class 2606 OID 21588)
-- Name: chanson fk_genre; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chanson
    ADD CONSTRAINT fk_genre FOREIGN KEY (genreid) REFERENCES public.genre(genreid);


--
-- TOC entry 3207 (class 2606 OID 21653)
-- Name: instrumentlist fk_instrumentchanson; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrumentlist
    ADD CONSTRAINT fk_instrumentchanson FOREIGN KEY (chansonid) REFERENCES public.chanson(chansonid);


--
-- TOC entry 3206 (class 2606 OID 21648)
-- Name: instrumentlist fk_instrumentinstrument; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrumentlist
    ADD CONSTRAINT fk_instrumentinstrument FOREIGN KEY (instrumentid) REFERENCES public.instrument(instrumentid);


--
-- TOC entry 3209 (class 2606 OID 21685)
-- Name: concert fk_lieuconcert; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.concert
    ADD CONSTRAINT fk_lieuconcert FOREIGN KEY (lieuid) REFERENCES public.lieu(lieuid);


--
-- TOC entry 3205 (class 2606 OID 21623)
-- Name: festival fk_lieufest; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.festival
    ADD CONSTRAINT fk_lieufest FOREIGN KEY (lieuid) REFERENCES public.lieu(lieuid);


--
-- TOC entry 3204 (class 2606 OID 21608)
-- Name: chanson fk_studio; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chanson
    ADD CONSTRAINT fk_studio FOREIGN KEY (studioid) REFERENCES public.studio(studioid);


-- Completed on 2021-01-30 14:46:00 +03

--
-- PostgreSQL database dump complete
--

