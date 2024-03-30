PGDMP      9                |           Ehotel official    16.1    16.1 H    a           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            b           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            c           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            d           1262    17527    Ehotel official    DATABASE     �   CREATE DATABASE "Ehotel official" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_Canada.1252';
 !   DROP DATABASE "Ehotel official";
                postgres    false            �            1255    17964    archive_location_function()    FUNCTION     �  CREATE FUNCTION public.archive_location_function() RETURNS trigger
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
       public          postgres    false            �            1255    17962    archive_reservation_function()    FUNCTION     �  CREATE FUNCTION public.archive_reservation_function() RETURNS trigger
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
       public          postgres    false            �            1259    17528    archive_location    TABLE     V  CREATE TABLE public.archive_location (
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
       public         heap    postgres    false            �            1259    17531    archive_reservation    TABLE     �  CREATE TABLE public.archive_reservation (
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
       public         heap    postgres    false            �            1259    17534    client    TABLE     �   CREATE TABLE public.client (
    nas character varying(20) NOT NULL,
    name character varying(255) NOT NULL,
    address character varying(255),
    date_e date
);
    DROP TABLE public.client;
       public         heap    postgres    false            �            1259    17537    email    TABLE     �   CREATE TABLE public.email (
    address character varying(255) NOT NULL,
    reciever character varying(255),
    name character varying(255),
    hotel_id integer
);
    DROP TABLE public.email;
       public         heap    postgres    false            �            1259    17540    employee    TABLE     �   CREATE TABLE public.employee (
    nas character varying(20) NOT NULL,
    name character varying(255) NOT NULL,
    address character varying(255),
    hotel_id integer,
    nas_manager character varying(20)
);
    DROP TABLE public.employee;
       public         heap    postgres    false            �            1259    17543    hotel    TABLE     >  CREATE TABLE public.hotel (
    hotel_id integer NOT NULL,
    name character varying(255) NOT NULL,
    address character varying(255) NOT NULL,
    n_room integer,
    stars integer NOT NULL,
    chain_name character varying(255) NOT NULL,
    CONSTRAINT check_stars_range CHECK (((stars >= 1) AND (stars <= 5)))
);
    DROP TABLE public.hotel;
       public         heap    postgres    false            �            1259    17546    hotel_chain    TABLE     �   CREATE TABLE public.hotel_chain (
    name character varying(255) NOT NULL,
    n_hotel integer,
    address character varying(255) NOT NULL
);
    DROP TABLE public.hotel_chain;
       public         heap    postgres    false            �            1259    17549    location    TABLE     �  CREATE TABLE public.location (
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
       public         heap    postgres    false            �            1259    17552    manager    TABLE     /  CREATE TABLE public.manager (
    nas character varying(20) NOT NULL,
    name character varying(255) NOT NULL,
    address character varying(255),
    email character varying(255),
    telephone integer,
    hotel_id integer,
    CONSTRAINT check_email_format CHECK (((email)::text ~~ '%@%'::text))
);
    DROP TABLE public.manager;
       public         heap    postgres    false            �            1259    17555    reservation    TABLE     �  CREATE TABLE public.reservation (
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
       public         heap    postgres    false            �            1259    17558    role    TABLE     �   CREATE TABLE public.role (
    role_id integer NOT NULL,
    title character varying(255) NOT NULL,
    description character varying(255) NOT NULL,
    nas character varying(20),
    CONSTRAINT check_id_role_positive CHECK ((role_id > 0))
);
    DROP TABLE public.role;
       public         heap    postgres    false            �            1259    17561    room    TABLE     �  CREATE TABLE public.room (
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
    CONSTRAINT check_vue_values CHECK (((view)::text = ANY ((ARRAY['Mer'::character varying, 'Montagne'::character varying, 'Autre'::character varying])::text[])))
);
    DROP TABLE public.room;
       public         heap    postgres    false            �            1259    17564 	   telephone    TABLE     �   CREATE TABLE public.telephone (
    number character varying(20) NOT NULL,
    reciever integer,
    hotel_id integer,
    chain_name character varying(255)
);
    DROP TABLE public.telephone;
       public         heap    postgres    false            R          0    17528    archive_location 
   TABLE DATA           �   COPY public.archive_location (a_location_id, start_date, end_date, status, room_number, price, type, capacity, view, extensible, problem, number_people, total_amount, location_id) FROM stdin;
    public          postgres    false    215   k       S          0    17531    archive_reservation 
   TABLE DATA           �   COPY public.archive_reservation (a_reservation_id, start_date, end_date, status, room_number, price, type, capacity, view, extensible, problem, number_people, reservation_id) FROM stdin;
    public          postgres    false    216   %k       T          0    17534    client 
   TABLE DATA           <   COPY public.client (nas, name, address, date_e) FROM stdin;
    public          postgres    false    217   Bk       U          0    17537    email 
   TABLE DATA           B   COPY public.email (address, reciever, name, hotel_id) FROM stdin;
    public          postgres    false    218   _k       V          0    17540    employee 
   TABLE DATA           M   COPY public.employee (nas, name, address, hotel_id, nas_manager) FROM stdin;
    public          postgres    false    219   |k       W          0    17543    hotel 
   TABLE DATA           S   COPY public.hotel (hotel_id, name, address, n_room, stars, chain_name) FROM stdin;
    public          postgres    false    220   �k       X          0    17546    hotel_chain 
   TABLE DATA           =   COPY public.hotel_chain (name, n_hotel, address) FROM stdin;
    public          postgres    false    221   �l       Y          0    17549    location 
   TABLE DATA           �   COPY public.location (location_id, start_date, end_date, total_amount, number_people, nas_e, nas_c, a_location_id, room_number, hotel_id) FROM stdin;
    public          postgres    false    222   dm       Z          0    17552    manager 
   TABLE DATA           Q   COPY public.manager (nas, name, address, email, telephone, hotel_id) FROM stdin;
    public          postgres    false    223   �m       [          0    17555    reservation 
   TABLE DATA           �   COPY public.reservation (reservation_id, start_date, end_date, status, number_people, nas_e, nas_c, a_reservation_id, location_id, room_number, hotel_id) FROM stdin;
    public          postgres    false    224   �m       \          0    17558    role 
   TABLE DATA           @   COPY public.role (role_id, title, description, nas) FROM stdin;
    public          postgres    false    225   �m       ]          0    17561    room 
   TABLE DATA           r   COPY public.room (room_number, price, type, capacity, extensible, problem, commodity, hotel_id, view) FROM stdin;
    public          postgres    false    226   �m       ^          0    17564 	   telephone 
   TABLE DATA           K   COPY public.telephone (number, reciever, hotel_id, chain_name) FROM stdin;
    public          postgres    false    227   �p       �           2606    17568 &   archive_location archive_location_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public.archive_location
    ADD CONSTRAINT archive_location_pkey PRIMARY KEY (a_location_id);
 P   ALTER TABLE ONLY public.archive_location DROP CONSTRAINT archive_location_pkey;
       public            postgres    false    215            �           2606    17570 ,   archive_reservation archive_reservation_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.archive_reservation
    ADD CONSTRAINT archive_reservation_pkey PRIMARY KEY (a_reservation_id);
 V   ALTER TABLE ONLY public.archive_reservation DROP CONSTRAINT archive_reservation_pkey;
       public            postgres    false    216            �           2606    17877    client client_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_pkey PRIMARY KEY (nas);
 <   ALTER TABLE ONLY public.client DROP CONSTRAINT client_pkey;
       public            postgres    false    217            �           2606    17729    email email_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.email
    ADD CONSTRAINT email_pkey PRIMARY KEY (address);
 :   ALTER TABLE ONLY public.email DROP CONSTRAINT email_pkey;
       public            postgres    false    218            �           2606    17838    employee employee_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (nas);
 @   ALTER TABLE ONLY public.employee DROP CONSTRAINT employee_pkey;
       public            postgres    false    219            �           2606    17745    hotel_chain hotel_chain_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.hotel_chain
    ADD CONSTRAINT hotel_chain_pkey PRIMARY KEY (name);
 F   ALTER TABLE ONLY public.hotel_chain DROP CONSTRAINT hotel_chain_pkey;
       public            postgres    false    221            �           2606    17782    hotel hotel_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.hotel
    ADD CONSTRAINT hotel_pkey PRIMARY KEY (hotel_id);
 :   ALTER TABLE ONLY public.hotel DROP CONSTRAINT hotel_pkey;
       public            postgres    false    220            �           2606    17582    location location_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.location
    ADD CONSTRAINT location_pkey PRIMARY KEY (location_id);
 @   ALTER TABLE ONLY public.location DROP CONSTRAINT location_pkey;
       public            postgres    false    222            �           2606    17924    manager manager_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.manager
    ADD CONSTRAINT manager_pkey PRIMARY KEY (nas);
 >   ALTER TABLE ONLY public.manager DROP CONSTRAINT manager_pkey;
       public            postgres    false    223            �           2606    17586    reservation reservation_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_pkey PRIMARY KEY (reservation_id);
 F   ALTER TABLE ONLY public.reservation DROP CONSTRAINT reservation_pkey;
       public            postgres    false    224            �           2606    17588    role role_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_pkey PRIMARY KEY (role_id);
 8   ALTER TABLE ONLY public.role DROP CONSTRAINT role_pkey;
       public            postgres    false    225            �           2606    17590    room room_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.room
    ADD CONSTRAINT room_pkey PRIMARY KEY (room_number, hotel_id);
 8   ALTER TABLE ONLY public.room DROP CONSTRAINT room_pkey;
       public            postgres    false    226    226            �           2606    17775    telephone telephone_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.telephone
    ADD CONSTRAINT telephone_pkey PRIMARY KEY (number);
 B   ALTER TABLE ONLY public.telephone DROP CONSTRAINT telephone_pkey;
       public            postgres    false    227            �           1259    17968    index_hotel_id    INDEX     D   CREATE INDEX index_hotel_id ON public.hotel USING btree (hotel_id);
 "   DROP INDEX public.index_hotel_id;
       public            postgres    false    220            �           1259    17966    index_room_number    INDEX     I   CREATE INDEX index_room_number ON public.room USING btree (room_number);
 %   DROP INDEX public.index_room_number;
       public            postgres    false    226            �           1259    17969    index_stars    INDEX     >   CREATE INDEX index_stars ON public.hotel USING btree (stars);
    DROP INDEX public.index_stars;
       public            postgres    false    220            �           2620    17965 !   location archive_location_trigger    TRIGGER     �   CREATE TRIGGER archive_location_trigger AFTER INSERT ON public.location FOR EACH ROW EXECUTE FUNCTION public.archive_location_function();
 :   DROP TRIGGER archive_location_trigger ON public.location;
       public          postgres    false    222    229            �           2620    17963 '   reservation archive_reservation_trigger    TRIGGER     �   CREATE TRIGGER archive_reservation_trigger AFTER INSERT ON public.reservation FOR EACH ROW EXECUTE FUNCTION public.archive_reservation_function();
 @   DROP TRIGGER archive_reservation_trigger ON public.reservation;
       public          postgres    false    228    224            �           2606    17593 2   archive_location archive_location_location_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.archive_location
    ADD CONSTRAINT archive_location_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.location(location_id);
 \   ALTER TABLE ONLY public.archive_location DROP CONSTRAINT archive_location_location_id_fkey;
       public          postgres    false    222    4767    215            �           2606    17598 ,   archive_reservation areservation_reservation    FK CONSTRAINT     �   ALTER TABLE ONLY public.archive_reservation
    ADD CONSTRAINT areservation_reservation FOREIGN KEY (reservation_id) REFERENCES public.reservation(reservation_id);
 V   ALTER TABLE ONLY public.archive_reservation DROP CONSTRAINT areservation_reservation;
       public          postgres    false    216    224    4771            �           2606    17783    email email_hotel_id_fkey    FK CONSTRAINT        ALTER TABLE ONLY public.email
    ADD CONSTRAINT email_hotel_id_fkey FOREIGN KEY (hotel_id) REFERENCES public.hotel(hotel_id);
 C   ALTER TABLE ONLY public.email DROP CONSTRAINT email_hotel_id_fkey;
       public          postgres    false    220    4761    218            �           2606    17751    email email_name_fkey    FK CONSTRAINT     y   ALTER TABLE ONLY public.email
    ADD CONSTRAINT email_name_fkey FOREIGN KEY (name) REFERENCES public.hotel_chain(name);
 ?   ALTER TABLE ONLY public.email DROP CONSTRAINT email_name_fkey;
       public          postgres    false    218    4765    221            �           2606    17788    employee employee_hotel_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_hotel_id_fkey FOREIGN KEY (hotel_id) REFERENCES public.hotel(hotel_id);
 I   ALTER TABLE ONLY public.employee DROP CONSTRAINT employee_hotel_id_fkey;
       public          postgres    false    4761    219    220            �           2606    17943 "   employee employee_nas_manager_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_nas_manager_fkey FOREIGN KEY (nas_manager) REFERENCES public.manager(nas);
 L   ALTER TABLE ONLY public.employee DROP CONSTRAINT employee_nas_manager_fkey;
       public          postgres    false    223    219    4769            �           2606    17623 $   location fk_archivelocation_location    FK CONSTRAINT     �   ALTER TABLE ONLY public.location
    ADD CONSTRAINT fk_archivelocation_location FOREIGN KEY (a_location_id) REFERENCES public.archive_location(a_location_id);
 N   ALTER TABLE ONLY public.location DROP CONSTRAINT fk_archivelocation_location;
       public          postgres    false    4751    215    222            �           2606    17628    reservation fk_reservationroom    FK CONSTRAINT     �   ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT fk_reservationroom FOREIGN KEY (room_number, hotel_id) REFERENCES public.room(room_number, hotel_id);
 H   ALTER TABLE ONLY public.reservation DROP CONSTRAINT fk_reservationroom;
       public          postgres    false    224    4776    226    226    224            �           2606    17633    location fk_reservationroom    FK CONSTRAINT     �   ALTER TABLE ONLY public.location
    ADD CONSTRAINT fk_reservationroom FOREIGN KEY (room_number, hotel_id) REFERENCES public.room(room_number, hotel_id);
 E   ALTER TABLE ONLY public.location DROP CONSTRAINT fk_reservationroom;
       public          postgres    false    222    222    4776    226    226            �           2606    17756    hotel hotel_chain_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.hotel
    ADD CONSTRAINT hotel_chain_name_fkey FOREIGN KEY (chain_name) REFERENCES public.hotel_chain(name);
 E   ALTER TABLE ONLY public.hotel DROP CONSTRAINT hotel_chain_name_fkey;
       public          postgres    false    220    4765    221            �           2606    17948    role hotel_nas_fkey    FK CONSTRAINT     q   ALTER TABLE ONLY public.role
    ADD CONSTRAINT hotel_nas_fkey FOREIGN KEY (nas) REFERENCES public.manager(nas);
 =   ALTER TABLE ONLY public.role DROP CONSTRAINT hotel_nas_fkey;
       public          postgres    false    225    223    4769            �           2606    17892    location location_nas_c_fkey    FK CONSTRAINT     {   ALTER TABLE ONLY public.location
    ADD CONSTRAINT location_nas_c_fkey FOREIGN KEY (nas_c) REFERENCES public.client(nas);
 F   ALTER TABLE ONLY public.location DROP CONSTRAINT location_nas_c_fkey;
       public          postgres    false    4755    222    217            �           2606    17859    location location_nas_e_fkey    FK CONSTRAINT     }   ALTER TABLE ONLY public.location
    ADD CONSTRAINT location_nas_e_fkey FOREIGN KEY (nas_e) REFERENCES public.employee(nas);
 F   ALTER TABLE ONLY public.location DROP CONSTRAINT location_nas_e_fkey;
       public          postgres    false    222    4759    219            �           2606    17793    manager manager_hotel_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.manager
    ADD CONSTRAINT manager_hotel_id_fkey FOREIGN KEY (hotel_id) REFERENCES public.hotel(hotel_id);
 G   ALTER TABLE ONLY public.manager DROP CONSTRAINT manager_hotel_id_fkey;
       public          postgres    false    223    4761    220            �           2606    17663 -   reservation reservation_a_reservation_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_a_reservation_id_fkey FOREIGN KEY (a_reservation_id) REFERENCES public.archive_reservation(a_reservation_id);
 W   ALTER TABLE ONLY public.reservation DROP CONSTRAINT reservation_a_reservation_id_fkey;
       public          postgres    false    224    4753    216            �           2606    17668 (   reservation reservation_location_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.location(location_id);
 R   ALTER TABLE ONLY public.reservation DROP CONSTRAINT reservation_location_id_fkey;
       public          postgres    false    224    4767    222            �           2606    17897 "   reservation reservation_nas_c_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_nas_c_fkey FOREIGN KEY (nas_c) REFERENCES public.client(nas);
 L   ALTER TABLE ONLY public.reservation DROP CONSTRAINT reservation_nas_c_fkey;
       public          postgres    false    217    4755    224            �           2606    17869     reservation reservation_nas_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_nas_fkey FOREIGN KEY (nas_e) REFERENCES public.employee(nas);
 J   ALTER TABLE ONLY public.reservation DROP CONSTRAINT reservation_nas_fkey;
       public          postgres    false    4759    224    219            �           2606    17864    role role_nas_fkey    FK CONSTRAINT     q   ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_nas_fkey FOREIGN KEY (nas) REFERENCES public.employee(nas);
 <   ALTER TABLE ONLY public.role DROP CONSTRAINT role_nas_fkey;
       public          postgres    false    219    225    4759            �           2606    17798    room room_hotel_id_fkey    FK CONSTRAINT     }   ALTER TABLE ONLY public.room
    ADD CONSTRAINT room_hotel_id_fkey FOREIGN KEY (hotel_id) REFERENCES public.hotel(hotel_id);
 A   ALTER TABLE ONLY public.room DROP CONSTRAINT room_hotel_id_fkey;
       public          postgres    false    226    4761    220            �           2606    17769 #   telephone telephone_chain_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.telephone
    ADD CONSTRAINT telephone_chain_name_fkey FOREIGN KEY (chain_name) REFERENCES public.hotel_chain(name);
 M   ALTER TABLE ONLY public.telephone DROP CONSTRAINT telephone_chain_name_fkey;
       public          postgres    false    227    4765    221            �           2606    17803 !   telephone telephone_hotel_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.telephone
    ADD CONSTRAINT telephone_hotel_id_fkey FOREIGN KEY (hotel_id) REFERENCES public.hotel(hotel_id);
 K   ALTER TABLE ONLY public.telephone DROP CONSTRAINT telephone_hotel_id_fkey;
       public          postgres    false    227    4761    220            R      x������ � �      S      x������ � �      T      x������ � �      U      x������ � �      V      x������ � �      W   =  x�m��N�0��u�~Oq�l�HAHL�nT	�(I���D����Y�S|�����O�����;�V�.Tq7�Cw�b��R#����`�ɬg!�Q�����FP����d����q�l�����4�4q_�<m0���ͳ����~�[;�aK^�Nǃۤ��[�����[�_���[�_�̀[�o�n�-g�K�gP��`��l�ʮ��Q��QԢr�
e���f	�"�jQ�P*�4��0<�n����/�F�rfP��5�V�Z�+c�B�r�Q��	T-gu��G7�w�?X�_��*��F��Q=�`�
"آ� �
UpV��/#���      X   n   x�.I,�)�P��/I�)��4THLJVH)�,K��ONM��L-WJ-�/*�!ɻ�����&�)x��K�%%��$V"�F���/�+I���/P��OIOEW���� V�3       Y      x������ � �      Z      x������ � �      [      x������ � �      \      x������ � �      ]   
  x����N�P����S���Ȳ��hE�TT6l��ZDIeDy��Ц]��Λ�s�_�d9�1Ī<-��m춫nX�q��p�5\����?Y��.�.�0C���0s�7������0r�_����n�ι�����2�ێ��6�XV!������C:���-������n�/����4�a?y�b��ԧ��܏�c��<���o�N��*��j^�u��n��ϹUɀ�W�����n?M�ǽWC�؍�����-���s3=��wE�	j$��`F��R$��hF��R�$EJj�dFJf�$E��H��2#Uf�J�TK�j5RmF��H���"5j�ƌԘ�)R+Ej�H��5#�R��ak|g�ſHq:���#��﹕i!E��T�eL�4Mz�������]��V*ʥ�[*��4{Gh� ��[
n)��Z)ʥ薢[JSxLZ�$�Jn���(+�T%���R�[J�x��R�\�vK�n)��J5r��-ո�4��V+�ʥZ�T��x5�G��zt�5�C3:d��5:\�C3:4�C6:\��5:����!����ѡ����ѡ��!����ѡ����ѡ��!����ѡ����ѡ��!����ѡ����ѡ���)������ѩ������ѩ���)������,��)������ѩ������ѩ���)������ѩ������ѩ���)������ѩ������ѩ���)������ѓf�$=�FO�яܞ�f�߆�_H      ^      x������ � �     