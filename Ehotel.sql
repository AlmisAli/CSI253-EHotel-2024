PGDMP      ,                |           EHotel    16.1    16.1 J    k           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            l           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            m           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            n           1262    25400    EHotel    DATABASE     |   CREATE DATABASE "EHotel" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_Canada.1252';
    DROP DATABASE "EHotel";
                postgres    false            �            1255    25401    archive_location_function()    FUNCTION     �  CREATE FUNCTION public.archive_location_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    room_price DECIMAL(10, 2);
    room_type VARCHAR(255);
    room_capacity INT;
    room_extensible BOOLEAN;
    room_problem VARCHAR(255);
    room_view VARCHAR(255);
BEGIN
    -- Get room information
    SELECT price, type, capacity, extensible, problem, view
    INTO room_price, room_type, room_capacity, room_extensible, room_problem, room_view
    FROM Room
    WHERE room_number = NEW.room_number;
    
    -- Insert into archive_location
    INSERT INTO archive_location (a_location_id, start_date, end_date, status, room_number, price, type, capacity, view, extensible, problem, number_people, total_amount, location_id)
    VALUES (NEW.a_location_id, NEW.start_date, NEW.end_date, NEW.status, NEW.room_number, room_price, room_type, room_capacity, room_view, room_extensible, room_problem, NEW.number_people, NEW.total_amount, NEW.location_id);
    
    RETURN NEW;
END;
$$;
 2   DROP FUNCTION public.archive_location_function();
       public          postgres    false            �            1255    25402    archive_reservation_function()    FUNCTION     �  CREATE FUNCTION public.archive_reservation_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    room_price DECIMAL(10, 2);
    room_type VARCHAR(255);
    room_capacity INT;
    room_extensible BOOLEAN;
    room_problem VARCHAR(255);
    room_view VARCHAR(255);
BEGIN
    -- Get room information
    SELECT price, type, capacity, extensible, problem, view
    INTO room_price, room_type, room_capacity, room_extensible, room_problem, room_view
    FROM Room
    WHERE room_number = NEW.room_number;
    
    -- Insert into archive_location
    INSERT INTO archive_location (a_reservation_id, start_date, end_date, status, room_number, price, type, capacity, view, extensible, problem, number_people, reservation_id)
    VALUES (NEW.a_reservation_id, NEW.start_date, NEW.end_date, NEW.status, NEW.room_number, room_price, room_type, room_capacity, room_view, room_extensible, room_problem, NEW.number_people, NEW.reservation_id);
    
    RETURN NEW;
END;
$$;
 5   DROP FUNCTION public.archive_reservation_function();
       public          postgres    false            �            1259    25403    archive_location    TABLE     V  CREATE TABLE public.archive_location (
    a_location_id integer NOT NULL,
    start_date date,
    end_date date,
    status character varying(255),
    room_number integer,
    price integer,
    type character varying(255),
    capacity integer,
    view character varying(255),
    extensible character varying(255),
    problem character varying(255),
    number_people integer,
    total_amount integer,
    location_id integer,
    CONSTRAINT check_date_debut_fin_location_archived CHECK ((start_date <= end_date)),
    CONSTRAINT check_id_a_location_positive CHECK ((a_location_id > 0))
);
 $   DROP TABLE public.archive_location;
       public         heap    postgres    false            �            1259    25410    archive_reservation    TABLE     �  CREATE TABLE public.archive_reservation (
    a_reservation_id integer NOT NULL,
    start_date date,
    end_date date,
    status character varying(255),
    room_number integer,
    price integer,
    type character varying(255),
    capacity integer,
    view character varying(255),
    extensible character varying(255),
    problem character varying(255),
    number_people integer,
    reservation_id integer,
    CONSTRAINT check_id_a_reservation_positive CHECK ((a_reservation_id > 0))
);
 '   DROP TABLE public.archive_reservation;
       public         heap    postgres    false            �            1259    25416    client    TABLE     �   CREATE TABLE public.client (
    nas character varying(20) NOT NULL,
    name character varying(255) NOT NULL,
    address character varying(255),
    date_e date
);
    DROP TABLE public.client;
       public         heap    postgres    false            �            1259    25421    email    TABLE     �   CREATE TABLE public.email (
    address character varying(255) NOT NULL,
    reciever character varying(255),
    name character varying(255),
    hotel_id integer
);
    DROP TABLE public.email;
       public         heap    postgres    false            �            1259    25426    employee    TABLE     �   CREATE TABLE public.employee (
    nas character varying(20) NOT NULL,
    name character varying(255) NOT NULL,
    address character varying(255),
    hotel_id integer,
    nas_manager character varying(20)
);
    DROP TABLE public.employee;
       public         heap    postgres    false            �            1259    25431    hotel    TABLE     >  CREATE TABLE public.hotel (
    hotel_id integer NOT NULL,
    name character varying(255) NOT NULL,
    address character varying(255) NOT NULL,
    n_room integer,
    stars integer NOT NULL,
    chain_name character varying(255) NOT NULL,
    CONSTRAINT check_stars_range CHECK (((stars >= 1) AND (stars <= 5)))
);
    DROP TABLE public.hotel;
       public         heap    postgres    false            �            1259    25437    hotel_chain    TABLE     �   CREATE TABLE public.hotel_chain (
    name character varying(255) NOT NULL,
    n_hotel integer,
    address character varying(255) NOT NULL
);
    DROP TABLE public.hotel_chain;
       public         heap    postgres    false            �            1259    25442    location    TABLE     �  CREATE TABLE public.location (
    location_id integer NOT NULL,
    start_date date,
    end_date date,
    total_amount integer,
    number_people integer,
    nas_e character varying(20),
    nas_c character varying(20),
    a_location_id integer,
    room_number integer,
    hotel_id integer,
    CONSTRAINT check_date_start_end_location CHECK ((start_date <= end_date)),
    CONSTRAINT check_id_location_positive CHECK ((location_id > 0))
);
    DROP TABLE public.location;
       public         heap    postgres    false            �            1259    25447    manager    TABLE     /  CREATE TABLE public.manager (
    nas character varying(20) NOT NULL,
    name character varying(255) NOT NULL,
    address character varying(255),
    email character varying(255),
    telephone integer,
    hotel_id integer,
    CONSTRAINT check_email_format CHECK (((email)::text ~~ '%@%'::text))
);
    DROP TABLE public.manager;
       public         heap    postgres    false            �            1259    25453    reservation    TABLE     �  CREATE TABLE public.reservation (
    reservation_id integer NOT NULL,
    start_date date,
    end_date date,
    status character varying(255),
    number_people integer,
    nas_e character varying(20),
    nas_c character varying(20),
    a_reservation_id integer,
    location_id integer,
    room_number integer,
    hotel_id integer,
    CONSTRAINT check_id_reservation_positive CHECK ((reservation_id > 0))
);
    DROP TABLE public.reservation;
       public         heap    postgres    false            �            1259    25457    role    TABLE     �   CREATE TABLE public.role (
    role_id integer NOT NULL,
    title character varying(255) NOT NULL,
    description character varying(255) NOT NULL,
    nas character varying(20),
    CONSTRAINT check_id_role_positive CHECK ((role_id > 0))
);
    DROP TABLE public.role;
       public         heap    postgres    false            �            1259    25463    room    TABLE       CREATE TABLE public.room (
    room_number integer NOT NULL,
    price numeric(10,2),
    type character varying(50),
    capacity integer,
    extensible character varying(255),
    problem character varying(255),
    commodity character varying(255),
    hotel_id integer NOT NULL,
    view character varying(20),
    CONSTRAINT check_capacity_range CHECK (((capacity >= 0) AND (capacity <= 10))),
    CONSTRAINT check_price_positive CHECK (((price > (0)::numeric) AND (price IS NOT NULL))),
    CONSTRAINT check_room_number_positive CHECK (((room_number > 0) AND (room_number IS NOT NULL))),
    CONSTRAINT check_vue_values CHECK (((view)::text = ANY (ARRAY[('Mer'::character varying)::text, ('Montagne'::character varying)::text, ('Autre'::character varying)::text])))
);
    DROP TABLE public.room;
       public         heap    postgres    false            �            1259    25472 	   telephone    TABLE     �   CREATE TABLE public.telephone (
    number character varying(20) NOT NULL,
    reciever integer,
    hotel_id integer,
    chain_name character varying(255)
);
    DROP TABLE public.telephone;
       public         heap    postgres    false            �            1259    25624    view_hotelrooms_capacity    VIEW     �   CREATE VIEW public.view_hotelrooms_capacity AS
 SELECT h.hotel_id,
    h.name,
    sum(c.capacity) AS total_capacity
   FROM (public.hotel h
     JOIN public.room c ON ((h.hotel_id = c.hotel_id)))
  GROUP BY h.hotel_id, h.name;
 +   DROP VIEW public.view_hotelrooms_capacity;
       public          postgres    false    220    226    226    220            �            1259    25479    view_totalrooms_by_zone    VIEW     �   CREATE VIEW public.view_totalrooms_by_zone AS
 SELECT address,
    sum(n_room) AS total_rooms
   FROM public.hotel
  GROUP BY address;
 *   DROP VIEW public.view_totalrooms_by_zone;
       public          postgres    false    220    220            \          0    25403    archive_location 
   TABLE DATA           �   COPY public.archive_location (a_location_id, start_date, end_date, status, room_number, price, type, capacity, view, extensible, problem, number_people, total_amount, location_id) FROM stdin;
    public          postgres    false    215   n       ]          0    25410    archive_reservation 
   TABLE DATA           �   COPY public.archive_reservation (a_reservation_id, start_date, end_date, status, room_number, price, type, capacity, view, extensible, problem, number_people, reservation_id) FROM stdin;
    public          postgres    false    216    n       ^          0    25416    client 
   TABLE DATA           <   COPY public.client (nas, name, address, date_e) FROM stdin;
    public          postgres    false    217   =n       _          0    25421    email 
   TABLE DATA           B   COPY public.email (address, reciever, name, hotel_id) FROM stdin;
    public          postgres    false    218   �n       `          0    25426    employee 
   TABLE DATA           M   COPY public.employee (nas, name, address, hotel_id, nas_manager) FROM stdin;
    public          postgres    false    219   �n       a          0    25431    hotel 
   TABLE DATA           S   COPY public.hotel (hotel_id, name, address, n_room, stars, chain_name) FROM stdin;
    public          postgres    false    220   �n       b          0    25437    hotel_chain 
   TABLE DATA           =   COPY public.hotel_chain (name, n_hotel, address) FROM stdin;
    public          postgres    false    221   7p       c          0    25442    location 
   TABLE DATA           �   COPY public.location (location_id, start_date, end_date, total_amount, number_people, nas_e, nas_c, a_location_id, room_number, hotel_id) FROM stdin;
    public          postgres    false    222   �p       d          0    25447    manager 
   TABLE DATA           Q   COPY public.manager (nas, name, address, email, telephone, hotel_id) FROM stdin;
    public          postgres    false    223   �p       e          0    25453    reservation 
   TABLE DATA           �   COPY public.reservation (reservation_id, start_date, end_date, status, number_people, nas_e, nas_c, a_reservation_id, location_id, room_number, hotel_id) FROM stdin;
    public          postgres    false    224   �p       f          0    25457    role 
   TABLE DATA           @   COPY public.role (role_id, title, description, nas) FROM stdin;
    public          postgres    false    225   q       g          0    25463    room 
   TABLE DATA           r   COPY public.room (room_number, price, type, capacity, extensible, problem, commodity, hotel_id, view) FROM stdin;
    public          postgres    false    226   )q       h          0    25472 	   telephone 
   TABLE DATA           K   COPY public.telephone (number, reciever, hotel_id, chain_name) FROM stdin;
    public          postgres    false    227   Ct       �           2606    25484 &   archive_location archive_location_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public.archive_location
    ADD CONSTRAINT archive_location_pkey PRIMARY KEY (a_location_id);
 P   ALTER TABLE ONLY public.archive_location DROP CONSTRAINT archive_location_pkey;
       public            postgres    false    215            �           2606    25486 ,   archive_reservation archive_reservation_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.archive_reservation
    ADD CONSTRAINT archive_reservation_pkey PRIMARY KEY (a_reservation_id);
 V   ALTER TABLE ONLY public.archive_reservation DROP CONSTRAINT archive_reservation_pkey;
       public            postgres    false    216            �           2606    25488    client client_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_pkey PRIMARY KEY (nas);
 <   ALTER TABLE ONLY public.client DROP CONSTRAINT client_pkey;
       public            postgres    false    217            �           2606    25490    email email_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.email
    ADD CONSTRAINT email_pkey PRIMARY KEY (address);
 :   ALTER TABLE ONLY public.email DROP CONSTRAINT email_pkey;
       public            postgres    false    218            �           2606    25492    employee employee_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (nas);
 @   ALTER TABLE ONLY public.employee DROP CONSTRAINT employee_pkey;
       public            postgres    false    219            �           2606    25494    hotel_chain hotel_chain_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.hotel_chain
    ADD CONSTRAINT hotel_chain_pkey PRIMARY KEY (name);
 F   ALTER TABLE ONLY public.hotel_chain DROP CONSTRAINT hotel_chain_pkey;
       public            postgres    false    221            �           2606    25496    hotel hotel_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.hotel
    ADD CONSTRAINT hotel_pkey PRIMARY KEY (hotel_id);
 :   ALTER TABLE ONLY public.hotel DROP CONSTRAINT hotel_pkey;
       public            postgres    false    220            �           2606    25498    location location_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.location
    ADD CONSTRAINT location_pkey PRIMARY KEY (location_id);
 @   ALTER TABLE ONLY public.location DROP CONSTRAINT location_pkey;
       public            postgres    false    222            �           2606    25500    manager manager_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.manager
    ADD CONSTRAINT manager_pkey PRIMARY KEY (nas);
 >   ALTER TABLE ONLY public.manager DROP CONSTRAINT manager_pkey;
       public            postgres    false    223            �           2606    25502    reservation reservation_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_pkey PRIMARY KEY (reservation_id);
 F   ALTER TABLE ONLY public.reservation DROP CONSTRAINT reservation_pkey;
       public            postgres    false    224            �           2606    25504    role role_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_pkey PRIMARY KEY (role_id);
 8   ALTER TABLE ONLY public.role DROP CONSTRAINT role_pkey;
       public            postgres    false    225            �           2606    25506    room room_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.room
    ADD CONSTRAINT room_pkey PRIMARY KEY (room_number, hotel_id);
 8   ALTER TABLE ONLY public.room DROP CONSTRAINT room_pkey;
       public            postgres    false    226    226            �           2606    25508    telephone telephone_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.telephone
    ADD CONSTRAINT telephone_pkey PRIMARY KEY (number);
 B   ALTER TABLE ONLY public.telephone DROP CONSTRAINT telephone_pkey;
       public            postgres    false    227            �           1259    25509    index_hotel_id    INDEX     D   CREATE INDEX index_hotel_id ON public.hotel USING btree (hotel_id);
 "   DROP INDEX public.index_hotel_id;
       public            postgres    false    220            �           1259    25510    index_room_number    INDEX     I   CREATE INDEX index_room_number ON public.room USING btree (room_number);
 %   DROP INDEX public.index_room_number;
       public            postgres    false    226            �           1259    25511    index_stars    INDEX     >   CREATE INDEX index_stars ON public.hotel USING btree (stars);
    DROP INDEX public.index_stars;
       public            postgres    false    220            �           2620    25512 !   location archive_location_trigger    TRIGGER     �   CREATE TRIGGER archive_location_trigger AFTER INSERT ON public.location FOR EACH ROW EXECUTE FUNCTION public.archive_location_function();
 :   DROP TRIGGER archive_location_trigger ON public.location;
       public          postgres    false    222    230            �           2620    25513 '   reservation archive_reservation_trigger    TRIGGER     �   CREATE TRIGGER archive_reservation_trigger AFTER INSERT ON public.reservation FOR EACH ROW EXECUTE FUNCTION public.archive_reservation_function();
 @   DROP TRIGGER archive_reservation_trigger ON public.reservation;
       public          postgres    false    231    224            �           2606    25514 2   archive_location archive_location_location_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.archive_location
    ADD CONSTRAINT archive_location_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.location(location_id);
 \   ALTER TABLE ONLY public.archive_location DROP CONSTRAINT archive_location_location_id_fkey;
       public          postgres    false    222    4775    215            �           2606    25519 ,   archive_reservation areservation_reservation    FK CONSTRAINT     �   ALTER TABLE ONLY public.archive_reservation
    ADD CONSTRAINT areservation_reservation FOREIGN KEY (reservation_id) REFERENCES public.reservation(reservation_id);
 V   ALTER TABLE ONLY public.archive_reservation DROP CONSTRAINT areservation_reservation;
       public          postgres    false    224    216    4779            �           2606    25524    email email_hotel_id_fkey    FK CONSTRAINT        ALTER TABLE ONLY public.email
    ADD CONSTRAINT email_hotel_id_fkey FOREIGN KEY (hotel_id) REFERENCES public.hotel(hotel_id);
 C   ALTER TABLE ONLY public.email DROP CONSTRAINT email_hotel_id_fkey;
       public          postgres    false    218    4769    220            �           2606    25529    email email_name_fkey    FK CONSTRAINT     y   ALTER TABLE ONLY public.email
    ADD CONSTRAINT email_name_fkey FOREIGN KEY (name) REFERENCES public.hotel_chain(name);
 ?   ALTER TABLE ONLY public.email DROP CONSTRAINT email_name_fkey;
       public          postgres    false    4773    221    218            �           2606    25534    employee employee_hotel_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_hotel_id_fkey FOREIGN KEY (hotel_id) REFERENCES public.hotel(hotel_id);
 I   ALTER TABLE ONLY public.employee DROP CONSTRAINT employee_hotel_id_fkey;
       public          postgres    false    219    4769    220            �           2606    25539 "   employee employee_nas_manager_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_nas_manager_fkey FOREIGN KEY (nas_manager) REFERENCES public.manager(nas);
 L   ALTER TABLE ONLY public.employee DROP CONSTRAINT employee_nas_manager_fkey;
       public          postgres    false    219    223    4777            �           2606    25544 $   location fk_archivelocation_location    FK CONSTRAINT     �   ALTER TABLE ONLY public.location
    ADD CONSTRAINT fk_archivelocation_location FOREIGN KEY (a_location_id) REFERENCES public.archive_location(a_location_id);
 N   ALTER TABLE ONLY public.location DROP CONSTRAINT fk_archivelocation_location;
       public          postgres    false    215    222    4759            �           2606    25549    reservation fk_reservationroom    FK CONSTRAINT     �   ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT fk_reservationroom FOREIGN KEY (room_number, hotel_id) REFERENCES public.room(room_number, hotel_id);
 H   ALTER TABLE ONLY public.reservation DROP CONSTRAINT fk_reservationroom;
       public          postgres    false    224    224    4784    226    226            �           2606    25554    location fk_reservationroom    FK CONSTRAINT     �   ALTER TABLE ONLY public.location
    ADD CONSTRAINT fk_reservationroom FOREIGN KEY (room_number, hotel_id) REFERENCES public.room(room_number, hotel_id);
 E   ALTER TABLE ONLY public.location DROP CONSTRAINT fk_reservationroom;
       public          postgres    false    222    222    4784    226    226            �           2606    25559    hotel hotel_chain_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.hotel
    ADD CONSTRAINT hotel_chain_name_fkey FOREIGN KEY (chain_name) REFERENCES public.hotel_chain(name);
 E   ALTER TABLE ONLY public.hotel DROP CONSTRAINT hotel_chain_name_fkey;
       public          postgres    false    220    4773    221            �           2606    25564    role hotel_nas_fkey    FK CONSTRAINT     q   ALTER TABLE ONLY public.role
    ADD CONSTRAINT hotel_nas_fkey FOREIGN KEY (nas) REFERENCES public.manager(nas);
 =   ALTER TABLE ONLY public.role DROP CONSTRAINT hotel_nas_fkey;
       public          postgres    false    225    4777    223            �           2606    25569    location location_nas_c_fkey    FK CONSTRAINT     {   ALTER TABLE ONLY public.location
    ADD CONSTRAINT location_nas_c_fkey FOREIGN KEY (nas_c) REFERENCES public.client(nas);
 F   ALTER TABLE ONLY public.location DROP CONSTRAINT location_nas_c_fkey;
       public          postgres    false    222    217    4763            �           2606    25574    location location_nas_e_fkey    FK CONSTRAINT     }   ALTER TABLE ONLY public.location
    ADD CONSTRAINT location_nas_e_fkey FOREIGN KEY (nas_e) REFERENCES public.employee(nas);
 F   ALTER TABLE ONLY public.location DROP CONSTRAINT location_nas_e_fkey;
       public          postgres    false    222    4767    219            �           2606    25579    manager manager_hotel_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.manager
    ADD CONSTRAINT manager_hotel_id_fkey FOREIGN KEY (hotel_id) REFERENCES public.hotel(hotel_id);
 G   ALTER TABLE ONLY public.manager DROP CONSTRAINT manager_hotel_id_fkey;
       public          postgres    false    220    223    4769            �           2606    25584 -   reservation reservation_a_reservation_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_a_reservation_id_fkey FOREIGN KEY (a_reservation_id) REFERENCES public.archive_reservation(a_reservation_id);
 W   ALTER TABLE ONLY public.reservation DROP CONSTRAINT reservation_a_reservation_id_fkey;
       public          postgres    false    224    216    4761            �           2606    25589 (   reservation reservation_location_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.location(location_id);
 R   ALTER TABLE ONLY public.reservation DROP CONSTRAINT reservation_location_id_fkey;
       public          postgres    false    224    4775    222            �           2606    25594 "   reservation reservation_nas_c_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_nas_c_fkey FOREIGN KEY (nas_c) REFERENCES public.client(nas);
 L   ALTER TABLE ONLY public.reservation DROP CONSTRAINT reservation_nas_c_fkey;
       public          postgres    false    4763    217    224            �           2606    25599     reservation reservation_nas_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_nas_fkey FOREIGN KEY (nas_e) REFERENCES public.employee(nas);
 J   ALTER TABLE ONLY public.reservation DROP CONSTRAINT reservation_nas_fkey;
       public          postgres    false    224    4767    219            �           2606    25604    role role_nas_fkey    FK CONSTRAINT     q   ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_nas_fkey FOREIGN KEY (nas) REFERENCES public.employee(nas);
 <   ALTER TABLE ONLY public.role DROP CONSTRAINT role_nas_fkey;
       public          postgres    false    225    4767    219            �           2606    25609    room room_hotel_id_fkey    FK CONSTRAINT     }   ALTER TABLE ONLY public.room
    ADD CONSTRAINT room_hotel_id_fkey FOREIGN KEY (hotel_id) REFERENCES public.hotel(hotel_id);
 A   ALTER TABLE ONLY public.room DROP CONSTRAINT room_hotel_id_fkey;
       public          postgres    false    226    220    4769            �           2606    25614 #   telephone telephone_chain_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.telephone
    ADD CONSTRAINT telephone_chain_name_fkey FOREIGN KEY (chain_name) REFERENCES public.hotel_chain(name);
 M   ALTER TABLE ONLY public.telephone DROP CONSTRAINT telephone_chain_name_fkey;
       public          postgres    false    221    4773    227            �           2606    25619 !   telephone telephone_hotel_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.telephone
    ADD CONSTRAINT telephone_hotel_id_fkey FOREIGN KEY (hotel_id) REFERENCES public.hotel(hotel_id);
 K   ALTER TABLE ONLY public.telephone DROP CONSTRAINT telephone_hotel_id_fkey;
       public          postgres    false    227    4769    220            \      x������ � �      ]      x������ � �      ^   I   x�3�����Sp�O�442V(N-N�MU(.)JM-�4202�50�56�2�,-(�DRd�e��B�!W� ��q      _      x������ � �      `   '   x�3�t���,�4612VH)J�̲T�? ����� ��      a   =  x�m��N�0��u�~Oq�l�HAHL�nT	�(I���D����Y�S|�����O�����;�V�.Tq7�Cw�b��R#����`�ɬg!�Q�����FP����d����q�l�����4�4q_�<m0���ͳ����~�[;�aK^�Nǃۤ��[�����[�_���[�_�̀[�o�n�-g�K�gP��`��l�ʮ��Q��QԢr�
e���f	�"�jQ�P*�4��0<�n����/�F�rfP��5�V�Z�+c�B�r�Q��	T-gu��G7�w�?X�_��*��F��Q=�`�
"آ� �
UpV��/#���      b   n   x�.I,�)�P��/I�)��4THLJVH)�,K��ONM��L-WJ-�/*�!ɻ�����&�)x��K�%%��$V"�F���/�+I���/P��OIOEW���� V�3       c      x������ � �      d      x������ � �      e      x������ � �      f      x������ � �      g   
  x����N�P����S���Ȳ��hE�TT6l��ZDIeDy��Ц]��Λ�s�_�d9�1Ī<-��m춫nX�q��p�5\����?Y��.�.�0C���0s�7������0r�_����n�ι�����2�ێ��6�XV!������C:���-������n�/����4�a?y�b��ԧ��܏�c��<���o�N��*��j^�u��n��ϹUɀ�W�����n?M�ǽWC�؍�����-���s3=��wE�	j$��`F��R$��hF��R�$EJj�dFJf�$E��H��2#Uf�J�TK�j5RmF��H���"5j�ƌԘ�)R+Ej�H��5#�R��ak|g�ſHq:���#��﹕i!E��T�eL�4Mz�������]��V*ʥ�[*��4{Gh� ��[
n)��Z)ʥ薢[JSxLZ�$�Jn���(+�T%���R�[J�x��R�\�vK�n)��J5r��-ո�4��V+�ʥZ�T��x5�G��zt�5�C3:d��5:\�C3:4�C6:\��5:����!����ѡ����ѡ��!����ѡ����ѡ��!����ѡ����ѡ��!����ѡ����ѡ���)������ѩ������ѩ���)������,��)������ѩ������ѩ���)������ѩ������ѩ���)������ѩ������ѩ���)������ѓf�$=�FO�яܞ�f�߆�_H      h      x������ � �     