PGDMP         :                 y            ImpalaRecords    13.0    13.0 A                0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            !           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            "           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            #           1262    20652    ImpalaRecords    DATABASE     d   CREATE DATABASE "ImpalaRecords" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.UTF-8';
    DROP DATABASE "ImpalaRecords";
                postgres    false            �            1255    21762    deletestudio(character varying) 	   PROCEDURE     �   CREATE PROCEDURE public.deletestudio(studionom character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
DELETE FROM Studio
WHERE Nom = studionom ;
END $$;
 A   DROP PROCEDURE public.deletestudio(studionom character varying);
       public          postgres    false            �            1255    21818    fluxchangelog()    FUNCTION     �   CREATE FUNCTION public.fluxchangelog() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF NEW.Flux <> OLD.Flux THEN
		 INSERT INTO Fluxchangeaudits(ChansonID,Flux,datechange)
		 VALUES(OLD.ChansonID,OLD.Flux,now());
	END IF;

	RETURN NEW;
END;$$;
 &   DROP FUNCTION public.fluxchangelog();
       public          postgres    false            �            1255    21784 	   fluxlog()    FUNCTION     �   CREATE FUNCTION public.fluxlog() RETURNS trigger
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
     DROP FUNCTION public.fluxlog();
       public          postgres    false            �            1255    21773    hitlog()    FUNCTION     �   CREATE FUNCTION public.hitlog() RETURNS trigger
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
    DROP FUNCTION public.hitlog();
       public          postgres    false            �            1255    21760 G   insertfestival(character varying, timestamp without time zone, integer) 	   PROCEDURE     O  CREATE PROCEDURE public.insertfestival(festnom character varying, festdebut timestamp without time zone, lieuid integer)
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
 x   DROP PROCEDURE public.insertfestival(festnom character varying, festdebut timestamp without time zone, lieuid integer);
       public          postgres    false            �            1255    21761 &   updateflux(character varying, integer) 	   PROCEDURE     �   CREATE PROCEDURE public.updateflux(chansontitre character varying, nouveauflux integer)
    LANGUAGE plpgsql
    AS $$
	BEGIN
	UPDATE Chanson
	SET flux = nouveauflux
WHERE Titre = ChansonTitre ;
END ; $$;
 W   DROP PROCEDURE public.updateflux(chansontitre character varying, nouveauflux integer);
       public          postgres    false            �            1259    21538    album    TABLE     �   CREATE TABLE public.album (
    albumid integer NOT NULL,
    titre character varying(100) NOT NULL,
    datedecopyright date NOT NULL,
    nbchanson integer NOT NULL
);
    DROP TABLE public.album;
       public         heap    postgres    false            �            1259    21548    artist    TABLE     �   CREATE TABLE public.artist (
    artistid integer NOT NULL,
    prenom character varying(50) NOT NULL,
    nom character varying(50) NOT NULL,
    paysdorigine character varying(100) NOT NULL,
    anniversaire date NOT NULL,
    bandid integer
);
    DROP TABLE public.artist;
       public         heap    postgres    false            �            1259    21543    band    TABLE     �   CREATE TABLE public.band (
    bandid integer NOT NULL,
    nom character varying(50) NOT NULL,
    paysdorigine character varying(100) NOT NULL,
    fonddate date NOT NULL
);
    DROP TABLE public.band;
       public         heap    postgres    false            �            1259    21583    chanson    TABLE       CREATE TABLE public.chanson (
    chansonid integer NOT NULL,
    titre character varying(100) NOT NULL,
    datedecopyright date NOT NULL,
    flux integer NOT NULL,
    genreid integer NOT NULL,
    albumid integer,
    artistid integer NOT NULL,
    studioid integer NOT NULL
);
    DROP TABLE public.chanson;
       public         heap    postgres    false            �            1259    21680    concert    TABLE     �   CREATE TABLE public.concert (
    concertid integer NOT NULL,
    dateconcertdebut timestamp without time zone NOT NULL,
    lieuid integer NOT NULL,
    festivalid integer
);
    DROP TABLE public.concert;
       public         heap    postgres    false            �            1259    21665    concertchansonlist    TABLE     �   CREATE TABLE public.concertchansonlist (
    concertlistid integer NOT NULL,
    chansonid integer NOT NULL,
    concertid integer NOT NULL
);
 &   DROP TABLE public.concertchansonlist;
       public         heap    postgres    false            �            1259    21618    festival    TABLE     �   CREATE TABLE public.festival (
    festivalid integer NOT NULL,
    nom character varying(50) NOT NULL,
    "DateFestDebut" timestamp without time zone NOT NULL,
    lieuid integer NOT NULL
);
    DROP TABLE public.festival;
       public         heap    postgres    false            �            1259    21832    fluxchangeaudits    TABLE     �   CREATE TABLE public.fluxchangeaudits (
    changeid integer NOT NULL,
    chansonid integer NOT NULL,
    flux integer NOT NULL,
    datechange timestamp without time zone NOT NULL
);
 $   DROP TABLE public.fluxchangeaudits;
       public         heap    postgres    false            �            1259    21830    fluxchangeaudits_changeid_seq    SEQUENCE     �   ALTER TABLE public.fluxchangeaudits ALTER COLUMN changeid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.fluxchangeaudits_changeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    214            �            1259    21533    genre    TABLE     e   CREATE TABLE public.genre (
    genreid integer NOT NULL,
    nom character varying(100) NOT NULL
);
    DROP TABLE public.genre;
       public         heap    postgres    false            �            1259    21563    studio    TABLE     �   CREATE TABLE public.studio (
    studioid integer NOT NULL,
    nom character varying(50) NOT NULL,
    adresse character varying(100) NOT NULL,
    prop character varying(100) NOT NULL,
    proptel character varying(20) NOT NULL
);
    DROP TABLE public.studio;
       public         heap    postgres    false            �            1259    21715    fullinfoaboutsongs    VIEW       CREATE VIEW public.fullinfoaboutsongs AS
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
 %   DROP VIEW public.fullinfoaboutsongs;
       public          postgres    false    207    207    202    202    200    200    203    205    207    207    203    203    203    205    207            �            1259    21558 
   instrument    TABLE     �   CREATE TABLE public.instrument (
    instrumentid integer NOT NULL,
    nom character varying(100) NOT NULL,
    marque character varying(100) NOT NULL
);
    DROP TABLE public.instrument;
       public         heap    postgres    false            �            1259    21643    instrumentlist    TABLE     �   CREATE TABLE public.instrumentlist (
    instrumentlistid integer NOT NULL,
    instrumentid integer NOT NULL,
    chansonid integer NOT NULL
);
 "   DROP TABLE public.instrumentlist;
       public         heap    postgres    false            �            1259    21568    lieu    TABLE     �   CREATE TABLE public.lieu (
    lieuid integer NOT NULL,
    nom character varying(100) NOT NULL,
    typedezone character varying(100) NOT NULL,
    city character varying(100) NOT NULL,
    country character varying(100) NOT NULL
);
    DROP TABLE public.lieu;
       public         heap    postgres    false                      0    21538    album 
   TABLE DATA                 public          postgres    false    201   �N                 0    21548    artist 
   TABLE DATA                 public          postgres    false    203   �O                 0    21543    band 
   TABLE DATA                 public          postgres    false    202   �P                 0    21583    chanson 
   TABLE DATA                 public          postgres    false    207   �Q                 0    21680    concert 
   TABLE DATA                 public          postgres    false    211   �T                 0    21665    concertchansonlist 
   TABLE DATA                 public          postgres    false    210   =V                 0    21618    festival 
   TABLE DATA                 public          postgres    false    208   �X                 0    21832    fluxchangeaudits 
   TABLE DATA                 public          postgres    false    214   �Y                 0    21533    genre 
   TABLE DATA                 public          postgres    false    200   PZ                 0    21558 
   instrument 
   TABLE DATA                 public          postgres    false    204   �Z                 0    21643    instrumentlist 
   TABLE DATA                 public          postgres    false    209    \                 0    21568    lieu 
   TABLE DATA                 public          postgres    false    206   �^                 0    21563    studio 
   TABLE DATA                 public          postgres    false    205   `       $           0    0    fluxchangeaudits_changeid_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.fluxchangeaudits_changeid_seq', 1, true);
          public          postgres    false    213            j           2606    21542    album album_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.album
    ADD CONSTRAINT album_pkey PRIMARY KEY (albumid);
 :   ALTER TABLE ONLY public.album DROP CONSTRAINT album_pkey;
       public            postgres    false    201            n           2606    21552    artist artist_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.artist
    ADD CONSTRAINT artist_pkey PRIMARY KEY (artistid);
 <   ALTER TABLE ONLY public.artist DROP CONSTRAINT artist_pkey;
       public            postgres    false    203            l           2606    21547    band band_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.band
    ADD CONSTRAINT band_pkey PRIMARY KEY (bandid);
 8   ALTER TABLE ONLY public.band DROP CONSTRAINT band_pkey;
       public            postgres    false    202            w           2606    21587    chanson chanson_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.chanson
    ADD CONSTRAINT chanson_pkey PRIMARY KEY (chansonid);
 >   ALTER TABLE ONLY public.chanson DROP CONSTRAINT chanson_pkey;
       public            postgres    false    207                       2606    21684    concert concert_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.concert
    ADD CONSTRAINT concert_pkey PRIMARY KEY (concertid);
 >   ALTER TABLE ONLY public.concert DROP CONSTRAINT concert_pkey;
       public            postgres    false    211            }           2606    21669 *   concertchansonlist concertchansonlist_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public.concertchansonlist
    ADD CONSTRAINT concertchansonlist_pkey PRIMARY KEY (concertlistid);
 T   ALTER TABLE ONLY public.concertchansonlist DROP CONSTRAINT concertchansonlist_pkey;
       public            postgres    false    210            y           2606    21622    festival festival_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.festival
    ADD CONSTRAINT festival_pkey PRIMARY KEY (festivalid);
 @   ALTER TABLE ONLY public.festival DROP CONSTRAINT festival_pkey;
       public            postgres    false    208            h           2606    21537    genre genre_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.genre
    ADD CONSTRAINT genre_pkey PRIMARY KEY (genreid);
 :   ALTER TABLE ONLY public.genre DROP CONSTRAINT genre_pkey;
       public            postgres    false    200            p           2606    21562    instrument instrument_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.instrument
    ADD CONSTRAINT instrument_pkey PRIMARY KEY (instrumentid);
 D   ALTER TABLE ONLY public.instrument DROP CONSTRAINT instrument_pkey;
       public            postgres    false    204            {           2606    21647 "   instrumentlist instrumentlist_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.instrumentlist
    ADD CONSTRAINT instrumentlist_pkey PRIMARY KEY (instrumentlistid);
 L   ALTER TABLE ONLY public.instrumentlist DROP CONSTRAINT instrumentlist_pkey;
       public            postgres    false    209            u           2606    21572    lieu lieu_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.lieu
    ADD CONSTRAINT lieu_pkey PRIMARY KEY (lieuid);
 8   ALTER TABLE ONLY public.lieu DROP CONSTRAINT lieu_pkey;
       public            postgres    false    206            s           2606    21567    studio studio_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.studio
    ADD CONSTRAINT studio_pkey PRIMARY KEY (studioid);
 <   ALTER TABLE ONLY public.studio DROP CONSTRAINT studio_pkey;
       public            postgres    false    205            q           1259    21844    instrumentindex    INDEX     E   CREATE INDEX instrumentindex ON public.instrument USING btree (nom);
 #   DROP INDEX public.instrumentindex;
       public            postgres    false    204            �           2620    21843    chanson fluxchangetrigger    TRIGGER        CREATE TRIGGER fluxchangetrigger BEFORE UPDATE OF flux ON public.chanson FOR EACH ROW EXECUTE FUNCTION public.fluxchangelog();
 2   DROP TRIGGER fluxchangetrigger ON public.chanson;
       public          postgres    false    207    231    207            �           2606    21593    chanson fk_album    FK CONSTRAINT     t   ALTER TABLE ONLY public.chanson
    ADD CONSTRAINT fk_album FOREIGN KEY (albumid) REFERENCES public.album(albumid);
 :   ALTER TABLE ONLY public.chanson DROP CONSTRAINT fk_album;
       public          postgres    false    201    207    3178            �           2606    21598    chanson fk_artist    FK CONSTRAINT     x   ALTER TABLE ONLY public.chanson
    ADD CONSTRAINT fk_artist FOREIGN KEY (artistid) REFERENCES public.artist(artistid);
 ;   ALTER TABLE ONLY public.chanson DROP CONSTRAINT fk_artist;
       public          postgres    false    3182    203    207            �           2606    21553    artist fk_band    FK CONSTRAINT     o   ALTER TABLE ONLY public.artist
    ADD CONSTRAINT fk_band FOREIGN KEY (bandid) REFERENCES public.band(bandid);
 8   ALTER TABLE ONLY public.artist DROP CONSTRAINT fk_band;
       public          postgres    false    203    3180    202            �           2606    21835 !   fluxchangeaudits fk_changechanson    FK CONSTRAINT     �   ALTER TABLE ONLY public.fluxchangeaudits
    ADD CONSTRAINT fk_changechanson FOREIGN KEY (chansonid) REFERENCES public.chanson(chansonid);
 K   ALTER TABLE ONLY public.fluxchangeaudits DROP CONSTRAINT fk_changechanson;
       public          postgres    false    207    3191    214            �           2606    21670 $   concertchansonlist fk_concertchanson    FK CONSTRAINT     �   ALTER TABLE ONLY public.concertchansonlist
    ADD CONSTRAINT fk_concertchanson FOREIGN KEY (chansonid) REFERENCES public.chanson(chansonid);
 N   ALTER TABLE ONLY public.concertchansonlist DROP CONSTRAINT fk_concertchanson;
       public          postgres    false    210    3191    207            �           2606    21690    concert fk_festconcert    FK CONSTRAINT     �   ALTER TABLE ONLY public.concert
    ADD CONSTRAINT fk_festconcert FOREIGN KEY (festivalid) REFERENCES public.festival(festivalid);
 @   ALTER TABLE ONLY public.concert DROP CONSTRAINT fk_festconcert;
       public          postgres    false    211    208    3193            �           2606    21588    chanson fk_genre    FK CONSTRAINT     t   ALTER TABLE ONLY public.chanson
    ADD CONSTRAINT fk_genre FOREIGN KEY (genreid) REFERENCES public.genre(genreid);
 :   ALTER TABLE ONLY public.chanson DROP CONSTRAINT fk_genre;
       public          postgres    false    200    3176    207            �           2606    21653 #   instrumentlist fk_instrumentchanson    FK CONSTRAINT     �   ALTER TABLE ONLY public.instrumentlist
    ADD CONSTRAINT fk_instrumentchanson FOREIGN KEY (chansonid) REFERENCES public.chanson(chansonid);
 M   ALTER TABLE ONLY public.instrumentlist DROP CONSTRAINT fk_instrumentchanson;
       public          postgres    false    3191    209    207            �           2606    21648 &   instrumentlist fk_instrumentinstrument    FK CONSTRAINT     �   ALTER TABLE ONLY public.instrumentlist
    ADD CONSTRAINT fk_instrumentinstrument FOREIGN KEY (instrumentid) REFERENCES public.instrument(instrumentid);
 P   ALTER TABLE ONLY public.instrumentlist DROP CONSTRAINT fk_instrumentinstrument;
       public          postgres    false    209    204    3184            �           2606    21685    concert fk_lieuconcert    FK CONSTRAINT     w   ALTER TABLE ONLY public.concert
    ADD CONSTRAINT fk_lieuconcert FOREIGN KEY (lieuid) REFERENCES public.lieu(lieuid);
 @   ALTER TABLE ONLY public.concert DROP CONSTRAINT fk_lieuconcert;
       public          postgres    false    211    206    3189            �           2606    21623    festival fk_lieufest    FK CONSTRAINT     u   ALTER TABLE ONLY public.festival
    ADD CONSTRAINT fk_lieufest FOREIGN KEY (lieuid) REFERENCES public.lieu(lieuid);
 >   ALTER TABLE ONLY public.festival DROP CONSTRAINT fk_lieufest;
       public          postgres    false    208    206    3189            �           2606    21608    chanson fk_studio    FK CONSTRAINT     x   ALTER TABLE ONLY public.chanson
    ADD CONSTRAINT fk_studio FOREIGN KEY (studioid) REFERENCES public.studio(studioid);
 ;   ALTER TABLE ONLY public.chanson DROP CONSTRAINT fk_studio;
       public          postgres    false    205    3187    207               �   x����j�@ �{�bn*d��������Q0i�dq���l(y�njJ_ ��0s����T.%d����2�~AS�7X�&���w2��ld������`�Z��Z�����q(`�bX�JBa�o���Z����	[����[�͊�`���I뻇�6�&�%�'f�D0���Ҡ�Uk�I~%TAC���q��	{t_�^��C�����M0�|���Ϲ�v|�nh5N�n�'e�E�4�Ѩ           x����N�0��<���R��4-��
�P 
�&0_�A���N!��s�b����,w�M���N����`i^ܱ��j�|�i��|�Z��5
�cȆ�Boec��F2@�'e,hCTJ-�q�������n�I㌎{0���k�Yg��ʃ�n�<<����"H'U�}~�j](��`qF�mģ��5Q^f��JK�T��A�38�����Y^���k���rr��"o���O�����{Z���(�\hE��
��8��릖`�em�).��܂���         �   x��б�0����H�)��qb �D��ZM#����G�|1i��%����4/�k	i^���7��
���z d�AO&E��\0�RPJ4s���� ���.I� �z�{���@Z�L0�������J1��7;f���4�
U��/ #F�q��ih4o ���&���/���˼����!
���d��	         9  x�͘Mo�H���ucF£�rh+f�բ����V��L3Y��T�!��6�nd�G�[�������a	���v��2���6E��+��-�z1��a]D���zwl��&�<�;�_5�+ʧö]41�#���uX��G�ǻ|�C�W�u��_4�B0�2&2�pǝs�I����}��f���JD��7���^�(���5L�ūߟ�y�1�q�+�8ѧAW�6/b���w�.c*�w�)n��-��q2iIe���~�*��<�J���*WWPR�ha�b��U�U欴L��5ȶ�P�m��}�r��aʥ'�v0���f��o ���d-�5�d sk�tȉ��-�J�5,b�<�g���Ɍs�Yε�����ZH��!嬭�ޗ��?�m�^:f��<��L΍�i�f������|a�QS�n�6B�ڑ.�u"b|��qU��~�,3�c����<7�*Ѫ��p"`ٵ�~E�;,�D]hw��f���9>v�Q7~�#�\'����=�#F���� �}���Hu7�`�`�]���vk��ń��~KH|����q#���BY�d�oRP��bӤȵṕ�4 �yaa���a�AJ)��d�!]�C���%:�{x�'9XaǨ�q�&R� �[�y�#��g���b��RB��?��IDM.7	1�n��F/�B�P�p�9��B�vP��%�����܆>�юzM�+�%��+�*6aզ�-�_�q���BY��EN˓�4An�x�\�0o|�պC����P���������b2�����Lj��
���6�����E�s�SQ�/777?��0�         7  x���Kk�@ ໿bnI�-3��6=��� ���D-ҖV�����n���\��1�5/������އk�Vw��k�|���}�u��onǺ�}]���K�ٷ_���w��P�G�RF2
�(�k�#nB�7�(v�A.�̨P+F`��*�vG��ׂ#�X;�e�إ��q5�qj�<F���]��]-g����Z6�T�]�N��\'.��2�9ɶ�I����a��,���1c16�6�XBE��<L]eg[��ɂ�uX�����ڰ%c��,��V�5�{�����w�Y<�A����	           x���KK\1G��)�TJ�����@�Pm��(t@�R��o���ဂ8'ě�ss=�?�}}t���/��ߟ/����������������ry{w7�����tt����~sy�u�?}�v��n�ѭ�ۏ�@�G9z:���'���C�rt���9-sv�o�9���P9��w?/&;�������Vl�i�r*�_&�������:�·}���k�z�?Ǿ.��nq��)�{, -��9(~�}�g�X0���=G���'	4�B9A�K�+N,
�5'�{��Ѫ㧽�q�9�J���ɷ�����Oڃ9�6aL���b� �6�	��c�`����l�`���S'X�'Zn��Q����s*'���	�Wna����Q��	�rd�!�_,�0~��NSJ����r��!�_����C?*�0ARa����62���V�&h�!L�iN0TC��y;��A��	�r$�&��!���&��!LДC��[a�a9D����r�G�!�o/����g�-�_,�0~����M��	�r�%^�O� ��0AToQ�FRoa����E��	�oa����]��	�z��\�A���W����=@Cҥ����#��2����ݍ��ι@A�e���?Ón�         �   x����
�0�}�bp�B+���\��R���Ok�@4bA����
���p9L�I�]
�&���dR�/�x2	��&�.��Յւi�t�3�[.H��8v�0[��:�B{�$�3�ԛ��I	�=�{H��	)��Aw�����bs����&������}�-%+��e��l$�@����۾Œ�8s�gѣC�QŎ�g��M!r���:O������-�8H�         �   x�%�Q�0E���M�)۷!iOA#��L�q�� �����p���겂ɫ��1m��_�vӫwk7,3����a��3m��:�����uY���/������z�;-�@i��D*�8���H(e�2�����~x�<��S,�         �   x���v
Q���W((M��L�KO�+JU� S�):
y���
a�>���
�:
�A���
ŕ��W�^��YX���i��I�YF@�\�Rs��1�h�g�	�h6j�K���%��z�<'r�����IM.)��-�� ���_           x����j�0E��
휀)u��誄%)��r��<r�h�'�;�c������#��X��u%�e����b�o����i�	�m&Z0o�b���2/�(�DZ��5ǃ#�ޤac��6?$ş��[xr`P
�3�w�B�q\^m�O�_Pm5�AOoCZ^�27r2q�ׁ9S�N=���{&`|;x���؂�� ���Q8�ݙ���3Ē:P�>�e��@!&!��2��?`����L�bg�O�헨N����ޕ���Hf�=篇w)I>?���         l  x����jQ��~�Y&`�H������PRh���$PC��y���L(}�oi/t�W�ӑd��o�<L������/����������ty9�/�����O���7�ǟ�O�_��������������S�Ov�qw@�{�w,~��	��#~�◈_��5�W,~����#~�⏈?��6��S��6Al�&�����q$�P6�e���l��8�M@G�	i�v1��.���͘9�]L;Ǵ�i�v1�Ӿ0mh�B �s0�#�,��gG���b�d�����<�� �U(�%p�zK�B�'��X9�!���Yy�:[� v�#�`�������r���5�xK`םE489�L��'�&��./Twt-ՃUب��F�P��FIqI\�(�K5r�S"�֪��P`CT�K�Ż%����	��
������IMJ���΀�:oP��~8��-���nҜ�U�Ҡ�5�4gp���pm#��{-)���2�Z�<s44��\�h-��@�F����'��i7��2O�\��v�+y]�1�j�����׭��jRozM� ݻ&D�>�S7CT�[�a�s��N�k@R"8�G�{���lH��xLE��S�r	�bЫJ�g�Z�v��Q�P         b  x��SMO1��+�$`���M	$���4v�K?4�?��O��.��\��y�u�k2Kǋ%$���~�dv�$y��U��.z઒}h�d�Ua՞����LW�:�=h�KEFĎL{����0���q�~:t��bi�ݻVҔ���=D��B�<��ʬ�E��n�F���9�F���m�[Bg�?Z	�*Vo���Ѩ�ˀ<	Os^�ڮApD2���me��>�W;a!�!�9���HΏ��������~I���Asn��&:��J�!��B�4o��������q��Z�K�������X�AB˥7;��.b�QH�ҝ��-&h�Ȍ��Y��ID��/~#         {  x���Ms�0���{j�)�X�%��ɡdB&@��ѫ��`$F����2i��қ��}v�j'�b�x���q�vY���m�-\޺����ʩ�Q�9�;<��/�9�pAp� ����xX�ҺJ���s\,�PH�%L�ѥ������r�R�j0�!��8�Jn�Z�Z�ƚ0�B�b�N�(��/�Mzˀa�[[��wk���#~EP�u���g�`��[J�9�S�h0��r-Uc��>�S�."Þ�c0�;�e}��
��M�T��	�O�V���(]��W�*��]��O�$b$M(�H�eN0���qy�$�QPϾ�D�Z��@���+��6r+��p#��1S1$)a$�br�d��rw�6�<b
���]�aaeuJ�	�k]�������8",F9���K-0��x�.�N��DFi��^.��[�p�)�;q���9�s��`]ཆ�Vx_r� ��gY�/�0��u�����^¢^���juBҔ��0!�p���f�_�4�"��#'_��ߺ��_�R��e ��Y�{>�)�w��kk�p'�͗^��1�#:��+zz���Z:8�͍.��渗PB3��n����X6��}e�f���F�e�n%���K@P�x!@��8�����(     