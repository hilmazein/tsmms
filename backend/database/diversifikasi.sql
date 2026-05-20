--
-- PostgreSQL database dump
--

\restrict tp4s7CtW0c4hmCtuCotrLWQlfdstTH0Djt7tS4jkHUHMKCtcNpsvPPVVQcAx2bb

-- Dumped from database version 17.9
-- Dumped by pg_dump version 17.9

-- Started on 2026-05-18 09:10:58

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2 (class 3079 OID 49173)
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- TOC entry 5074 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- TOC entry 239 (class 1255 OID 16467)
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 235 (class 1259 OID 49156)
-- Name: activity_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.activity_logs (
    id integer NOT NULL,
    "time" timestamp without time zone DEFAULT now() NOT NULL,
    name character varying(255) NOT NULL,
    division character varying(50) NOT NULL,
    action character varying(20) NOT NULL,
    table_name character varying(50) NOT NULL,
    no_data character varying(100) NOT NULL,
    detail text NOT NULL,
    CONSTRAINT activity_logs_action_check CHECK (((action)::text = ANY ((ARRAY['create'::character varying, 'update'::character varying, 'delete'::character varying, 'restore'::character varying])::text[]))),
    CONSTRAINT activity_logs_table_name_check CHECK (((table_name)::text = ANY ((ARRAY['Diversifikasi RM'::character varying, 'Diversifikasi PM'::character varying])::text[])))
);


ALTER TABLE public.activity_logs OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 49155)
-- Name: activity_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.activity_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.activity_logs_id_seq OWNER TO postgres;

--
-- TOC entry 5075 (class 0 OID 0)
-- Dependencies: 234
-- Name: activity_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.activity_logs_id_seq OWNED BY public.activity_logs.id;


--
-- TOC entry 229 (class 1259 OID 32772)
-- Name: diversifikasi_pm; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.diversifikasi_pm (
    id integer NOT NULL,
    nomor_pm character varying(20) NOT NULL,
    revision integer DEFAULT 0 NOT NULL,
    parent_id integer,
    status_project character varying(20) DEFAULT ''::character varying,
    tgl_penerimaan date,
    kode_item character varying(100),
    nama_material character varying(255),
    manufacture character varying(255),
    no_batch_material character varying(100),
    pm_tgl_analisa date,
    pm_tgl_report date,
    pm_hasil_analisa character varying(20) DEFAULT ''::character varying,
    pm_keterangan text,
    trial_kode_produk character varying(100),
    trial_no_batch character varying(100),
    trial_hasil_final character varying(10) DEFAULT ''::character varying,
    link_file_diversifikasi text,
    kesimpulan text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_by character varying(100),
    updated_by character varying(100),
    deleted_at timestamp without time zone,
    deleted_by character varying(255) DEFAULT NULL::character varying,
    CONSTRAINT diversifikasi_pm_pm_hasil_analisa_check CHECK (((pm_hasil_analisa)::text = ANY ((ARRAY['Reject'::character varying, 'Release'::character varying, 'On Progress'::character varying, 'N/A'::character varying, ''::character varying])::text[]))),
    CONSTRAINT diversifikasi_pm_status_project_check CHECK (((status_project)::text = ANY ((ARRAY['Done'::character varying, 'Drop'::character varying, 'On Progress'::character varying, ''::character varying])::text[]))),
    CONSTRAINT diversifikasi_pm_trial_hasil_final_check CHECK (((trial_hasil_final)::text = ANY ((ARRAY['MS'::character varying, 'TMS'::character varying, 'OP'::character varying, 'N/A'::character varying, ''::character varying])::text[])))
);


ALTER TABLE public.diversifikasi_pm OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 32771)
-- Name: diversifikasi_pm_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.diversifikasi_pm_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.diversifikasi_pm_id_seq OWNER TO postgres;

--
-- TOC entry 5076 (class 0 OID 0)
-- Dependencies: 228
-- Name: diversifikasi_pm_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.diversifikasi_pm_id_seq OWNED BY public.diversifikasi_pm.id;


--
-- TOC entry 227 (class 1259 OID 24634)
-- Name: diversifikasi_produk; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.diversifikasi_produk (
    id integer NOT NULL,
    diversifikasi_rm_id integer NOT NULL,
    kode_produk character varying(100),
    produk_tgl_kirim_qc date,
    produk_tgl_keluar_hasil date,
    produk_fisik character varying(10) DEFAULT ''::character varying,
    produk_kimia character varying(10) DEFAULT ''::character varying,
    produk_mikrobiologi character varying(10) DEFAULT ''::character varying,
    produk_sensori character varying(10) DEFAULT ''::character varying,
    produk_cek_karakteristik character varying(10) DEFAULT ''::character varying,
    stabtest_fisik character varying(10) DEFAULT ''::character varying,
    stabtest_kimia character varying(10) DEFAULT ''::character varying,
    stabtest_mikrobiologi character varying(10) DEFAULT ''::character varying,
    stabtest_sensori_dfct character varying(10) DEFAULT ''::character varying,
    stabtest_status character varying(20) DEFAULT ''::character varying,
    keterangan text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT diversifikasi_produk_produk_cek_karakteristik_check CHECK (((produk_cek_karakteristik)::text = ANY ((ARRAY['MS'::character varying, 'TMS'::character varying, 'OP'::character varying, 'N/A'::character varying, ''::character varying])::text[]))),
    CONSTRAINT diversifikasi_produk_produk_fisik_check CHECK (((produk_fisik)::text = ANY ((ARRAY['MS'::character varying, 'TMS'::character varying, 'OP'::character varying, 'N/A'::character varying, ''::character varying])::text[]))),
    CONSTRAINT diversifikasi_produk_produk_kimia_check CHECK (((produk_kimia)::text = ANY ((ARRAY['MS'::character varying, 'TMS'::character varying, 'OP'::character varying, 'N/A'::character varying, ''::character varying])::text[]))),
    CONSTRAINT diversifikasi_produk_produk_mikrobiologi_check CHECK (((produk_mikrobiologi)::text = ANY ((ARRAY['MS'::character varying, 'TMS'::character varying, 'OP'::character varying, 'N/A'::character varying, ''::character varying])::text[]))),
    CONSTRAINT diversifikasi_produk_produk_sensori_check CHECK (((produk_sensori)::text = ANY ((ARRAY['MS'::character varying, 'TMS'::character varying, 'OP'::character varying, 'N/A'::character varying, ''::character varying])::text[]))),
    CONSTRAINT diversifikasi_produk_stabtest_fisik_check CHECK (((stabtest_fisik)::text = ANY ((ARRAY['MS'::character varying, 'TMS'::character varying, 'OP'::character varying, 'N/A'::character varying, ''::character varying])::text[]))),
    CONSTRAINT diversifikasi_produk_stabtest_kimia_check CHECK (((stabtest_kimia)::text = ANY ((ARRAY['MS'::character varying, 'TMS'::character varying, 'OP'::character varying, 'N/A'::character varying, ''::character varying])::text[]))),
    CONSTRAINT diversifikasi_produk_stabtest_mikrobiologi_check CHECK (((stabtest_mikrobiologi)::text = ANY ((ARRAY['MS'::character varying, 'TMS'::character varying, 'OP'::character varying, 'N/A'::character varying, ''::character varying])::text[]))),
    CONSTRAINT diversifikasi_produk_stabtest_sensori_dfct_check CHECK (((stabtest_sensori_dfct)::text = ANY ((ARRAY['MS'::character varying, 'TMS'::character varying, 'OP'::character varying, 'N/A'::character varying, ''::character varying])::text[]))),
    CONSTRAINT diversifikasi_produk_stabtest_status_check CHECK (((stabtest_status)::text = ANY ((ARRAY['Reject'::character varying, 'Release'::character varying, 'On Progress'::character varying, 'N/A'::character varying, ''::character varying])::text[])))
);


ALTER TABLE public.diversifikasi_produk OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 24633)
-- Name: diversifikasi_produk_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.diversifikasi_produk_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.diversifikasi_produk_id_seq OWNER TO postgres;

--
-- TOC entry 5077 (class 0 OID 0)
-- Dependencies: 226
-- Name: diversifikasi_produk_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.diversifikasi_produk_id_seq OWNED BY public.diversifikasi_produk.id;


--
-- TOC entry 231 (class 1259 OID 32795)
-- Name: diversifikasi_produk_pm; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.diversifikasi_produk_pm (
    id integer NOT NULL,
    diversifikasi_pm_id integer NOT NULL,
    kode_produk character varying(100),
    produk_tgl_kirim_qc date,
    produk_tgl_keluar_hasil date,
    evaluasi_as_kemasan character varying(10) DEFAULT ''::character varying,
    produk_fisik character varying(10) DEFAULT ''::character varying,
    produk_kimia character varying(10) DEFAULT ''::character varying,
    produk_mikrobiologi character varying(10) DEFAULT ''::character varying,
    produk_sensori character varying(10) DEFAULT ''::character varying,
    produk_cek_karakteristik character varying(10) DEFAULT ''::character varying,
    stabtest_fisik character varying(10) DEFAULT ''::character varying,
    stabtest_kimia character varying(10) DEFAULT ''::character varying,
    stabtest_mikrobiologi character varying(10) DEFAULT ''::character varying,
    stabtest_sensori_dfct character varying(10) DEFAULT ''::character varying,
    stabtest_keterangan text,
    stabtest_status character varying(20) DEFAULT ''::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT diversifikasi_produk_pm_evaluasi_as_kemasan_check CHECK (((evaluasi_as_kemasan)::text = ANY ((ARRAY['MS'::character varying, 'TMS'::character varying, 'OP'::character varying, 'N/A'::character varying, ''::character varying])::text[]))),
    CONSTRAINT diversifikasi_produk_pm_produk_cek_karakteristik_check CHECK (((produk_cek_karakteristik)::text = ANY ((ARRAY['MS'::character varying, 'TMS'::character varying, 'OP'::character varying, 'N/A'::character varying, ''::character varying])::text[]))),
    CONSTRAINT diversifikasi_produk_pm_produk_fisik_check CHECK (((produk_fisik)::text = ANY ((ARRAY['MS'::character varying, 'TMS'::character varying, 'OP'::character varying, 'N/A'::character varying, ''::character varying])::text[]))),
    CONSTRAINT diversifikasi_produk_pm_produk_kimia_check CHECK (((produk_kimia)::text = ANY ((ARRAY['MS'::character varying, 'TMS'::character varying, 'OP'::character varying, 'N/A'::character varying, ''::character varying])::text[]))),
    CONSTRAINT diversifikasi_produk_pm_produk_mikrobiologi_check CHECK (((produk_mikrobiologi)::text = ANY ((ARRAY['MS'::character varying, 'TMS'::character varying, 'OP'::character varying, 'N/A'::character varying, ''::character varying])::text[]))),
    CONSTRAINT diversifikasi_produk_pm_produk_sensori_check CHECK (((produk_sensori)::text = ANY ((ARRAY['MS'::character varying, 'TMS'::character varying, 'OP'::character varying, 'N/A'::character varying, ''::character varying])::text[]))),
    CONSTRAINT diversifikasi_produk_pm_stabtest_fisik_check CHECK (((stabtest_fisik)::text = ANY ((ARRAY['MS'::character varying, 'TMS'::character varying, 'OP'::character varying, 'N/A'::character varying, ''::character varying])::text[]))),
    CONSTRAINT diversifikasi_produk_pm_stabtest_kimia_check CHECK (((stabtest_kimia)::text = ANY ((ARRAY['MS'::character varying, 'TMS'::character varying, 'OP'::character varying, 'N/A'::character varying, ''::character varying])::text[]))),
    CONSTRAINT diversifikasi_produk_pm_stabtest_mikrobiologi_check CHECK (((stabtest_mikrobiologi)::text = ANY ((ARRAY['MS'::character varying, 'TMS'::character varying, 'OP'::character varying, 'N/A'::character varying, ''::character varying])::text[]))),
    CONSTRAINT diversifikasi_produk_pm_stabtest_sensori_dfct_check CHECK (((stabtest_sensori_dfct)::text = ANY ((ARRAY['MS'::character varying, 'TMS'::character varying, 'OP'::character varying, 'N/A'::character varying, ''::character varying])::text[]))),
    CONSTRAINT diversifikasi_produk_pm_stabtest_status_check CHECK (((stabtest_status)::text = ANY ((ARRAY['Reject'::character varying, 'Release'::character varying, 'On Progress'::character varying, 'N/A'::character varying, ''::character varying])::text[])))
);


ALTER TABLE public.diversifikasi_produk_pm OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 32794)
-- Name: diversifikasi_produk_pm_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.diversifikasi_produk_pm_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.diversifikasi_produk_pm_id_seq OWNER TO postgres;

--
-- TOC entry 5078 (class 0 OID 0)
-- Dependencies: 230
-- Name: diversifikasi_produk_pm_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.diversifikasi_produk_pm_id_seq OWNED BY public.diversifikasi_produk_pm.id;


--
-- TOC entry 225 (class 1259 OID 24592)
-- Name: diversifikasi_rm; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.diversifikasi_rm (
    id integer NOT NULL,
    nomor_rm character varying(20) NOT NULL,
    revision integer DEFAULT 0 NOT NULL,
    parent_id integer,
    status_project character varying(20) DEFAULT ''::character varying,
    tgl_kirim_cpro date,
    tgl_terima_ts date,
    kode_item character varying(100),
    nama_material character varying(255),
    manufacture character varying(255),
    no_batch_material character varying(100),
    perlu_analisa_andev character varying(3) DEFAULT ''::character varying,
    andev_kimia character varying(10) DEFAULT ''::character varying,
    andev_verifikasi_ma character varying(10) DEFAULT ''::character varying,
    andev_status character varying(20) DEFAULT ''::character varying,
    rm_tgl_kirim_qc date,
    rm_tgl_keluar_hasil_analisa date,
    rm_fisik character varying(10) DEFAULT ''::character varying,
    rm_kimia character varying(10) DEFAULT ''::character varying,
    rm_mikrobiologi character varying(10) DEFAULT ''::character varying,
    rm_sensori_material character varying(10) DEFAULT ''::character varying,
    rm_cek_karakteristik character varying(10) DEFAULT ''::character varying,
    rm_status character varying(20) DEFAULT ''::character varying,
    scale_up_kode_produk character varying(100) DEFAULT ''::character varying,
    no_batch_scale_up character varying(100),
    scale_up_status character varying(20) DEFAULT ''::character varying,
    tgl_dilakukan_scale_up date,
    scale_up_tgl_kirim_qc date,
    scale_up_tgl_keluar_hasil_analisa date,
    link_file_diversifikasi text,
    kesimpulan text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_by character varying(100),
    updated_by character varying(100),
    deleted_at timestamp without time zone,
    deleted_by character varying(255) DEFAULT NULL::character varying,
    CONSTRAINT diversifikasi_rm_andev_kimia_check CHECK (((andev_kimia)::text = ANY ((ARRAY['MS'::character varying, 'TMS'::character varying, 'OP'::character varying, 'N/A'::character varying, ''::character varying])::text[]))),
    CONSTRAINT diversifikasi_rm_andev_status_check CHECK (((andev_status)::text = ANY ((ARRAY['Reject'::character varying, 'Release'::character varying, 'On Progress'::character varying, 'N/A'::character varying, ''::character varying])::text[]))),
    CONSTRAINT diversifikasi_rm_andev_verifikasi_ma_check CHECK (((andev_verifikasi_ma)::text = ANY ((ARRAY['MS'::character varying, 'TMS'::character varying, 'OP'::character varying, 'N/A'::character varying, ''::character varying])::text[]))),
    CONSTRAINT diversifikasi_rm_perlu_analisa_andev_check CHECK (((perlu_analisa_andev)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, ''::character varying])::text[]))),
    CONSTRAINT diversifikasi_rm_rm_cek_karakteristik_check CHECK (((rm_cek_karakteristik)::text = ANY ((ARRAY['MS'::character varying, 'TMS'::character varying, 'OP'::character varying, 'N/A'::character varying, ''::character varying])::text[]))),
    CONSTRAINT diversifikasi_rm_rm_fisik_check CHECK (((rm_fisik)::text = ANY ((ARRAY['MS'::character varying, 'TMS'::character varying, 'OP'::character varying, 'N/A'::character varying, ''::character varying])::text[]))),
    CONSTRAINT diversifikasi_rm_rm_kimia_check CHECK (((rm_kimia)::text = ANY ((ARRAY['MS'::character varying, 'TMS'::character varying, 'OP'::character varying, 'N/A'::character varying, ''::character varying])::text[]))),
    CONSTRAINT diversifikasi_rm_rm_mikrobiologi_check CHECK (((rm_mikrobiologi)::text = ANY ((ARRAY['MS'::character varying, 'TMS'::character varying, 'OP'::character varying, 'N/A'::character varying, ''::character varying])::text[]))),
    CONSTRAINT diversifikasi_rm_rm_sensori_material_check CHECK (((rm_sensori_material)::text = ANY ((ARRAY['MS'::character varying, 'TMS'::character varying, 'OP'::character varying, 'N/A'::character varying, ''::character varying])::text[]))),
    CONSTRAINT diversifikasi_rm_rm_status_check CHECK (((rm_status)::text = ANY ((ARRAY['Reject'::character varying, 'Release'::character varying, 'On Progress'::character varying, 'N/A'::character varying, ''::character varying])::text[]))),
    CONSTRAINT diversifikasi_rm_scale_up_status_check CHECK (((scale_up_status)::text = ANY ((ARRAY['Reject'::character varying, 'Release'::character varying, 'On Progress'::character varying, 'N/A'::character varying, ''::character varying])::text[]))),
    CONSTRAINT diversifikasi_rm_status_project_check CHECK (((status_project)::text = ANY ((ARRAY['Done'::character varying, 'Drop'::character varying, 'On Progress'::character varying, ''::character varying])::text[])))
);


ALTER TABLE public.diversifikasi_rm OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 24591)
-- Name: diversifikasi_rm_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.diversifikasi_rm_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.diversifikasi_rm_id_seq OWNER TO postgres;

--
-- TOC entry 5079 (class 0 OID 0)
-- Dependencies: 224
-- Name: diversifikasi_rm_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.diversifikasi_rm_id_seq OWNED BY public.diversifikasi_rm.id;


--
-- TOC entry 219 (class 1259 OID 16437)
-- Name: master_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.master_items (
    id integer NOT NULL,
    kode_item character varying(100),
    nama_material character varying(255),
    manufacture character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.master_items OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16436)
-- Name: master_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.master_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.master_items_id_seq OWNER TO postgres;

--
-- TOC entry 5080 (class 0 OID 0)
-- Dependencies: 218
-- Name: master_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.master_items_id_seq OWNED BY public.master_items.id;


--
-- TOC entry 233 (class 1259 OID 32840)
-- Name: master_items_pm; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.master_items_pm (
    id integer NOT NULL,
    kode_item character varying(100) NOT NULL,
    nama_material character varying(255) NOT NULL,
    manufacture character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.master_items_pm OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 32839)
-- Name: master_items_pm_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.master_items_pm_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.master_items_pm_id_seq OWNER TO postgres;

--
-- TOC entry 5081 (class 0 OID 0)
-- Dependencies: 232
-- Name: master_items_pm_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.master_items_pm_id_seq OWNED BY public.master_items_pm.id;


--
-- TOC entry 223 (class 1259 OID 16544)
-- Name: master_products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.master_products (
    id integer NOT NULL,
    kode_produk character varying(100) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.master_products OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16543)
-- Name: master_products_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.master_products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.master_products_id_seq OWNER TO postgres;

--
-- TOC entry 5082 (class 0 OID 0)
-- Dependencies: 222
-- Name: master_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.master_products_id_seq OWNED BY public.master_products.id;


--
-- TOC entry 236 (class 1259 OID 49280)
-- Name: nomor_pm_counter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nomor_pm_counter (
    prefix text NOT NULL,
    last_counter integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.nomor_pm_counter OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16450)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(500) NOT NULL,
    division character varying(50) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    password_encoded character varying(500) DEFAULT ''::character varying NOT NULL,
    refresh_token text,
    refresh_token_expiry timestamp without time zone,
    last_activity timestamp without time zone,
    CONSTRAINT users_division_check CHECK (((division)::text = ANY ((ARRAY['Admin'::character varying, 'CPro'::character varying, 'QC'::character varying, 'TS'::character varying, 'Andev'::character varying])::text[])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16449)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 5083 (class 0 OID 0)
-- Dependencies: 220
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 4800 (class 2604 OID 49159)
-- Name: activity_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity_logs ALTER COLUMN id SET DEFAULT nextval('public.activity_logs_id_seq'::regclass);


--
-- TOC entry 4775 (class 2604 OID 32775)
-- Name: diversifikasi_pm id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.diversifikasi_pm ALTER COLUMN id SET DEFAULT nextval('public.diversifikasi_pm_id_seq'::regclass);


--
-- TOC entry 4762 (class 2604 OID 24637)
-- Name: diversifikasi_produk id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.diversifikasi_produk ALTER COLUMN id SET DEFAULT nextval('public.diversifikasi_produk_id_seq'::regclass);


--
-- TOC entry 4783 (class 2604 OID 32798)
-- Name: diversifikasi_produk_pm id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.diversifikasi_produk_pm ALTER COLUMN id SET DEFAULT nextval('public.diversifikasi_produk_pm_id_seq'::regclass);


--
-- TOC entry 4744 (class 2604 OID 24595)
-- Name: diversifikasi_rm id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.diversifikasi_rm ALTER COLUMN id SET DEFAULT nextval('public.diversifikasi_rm_id_seq'::regclass);


--
-- TOC entry 4734 (class 2604 OID 16440)
-- Name: master_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.master_items ALTER COLUMN id SET DEFAULT nextval('public.master_items_id_seq'::regclass);


--
-- TOC entry 4797 (class 2604 OID 32843)
-- Name: master_items_pm id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.master_items_pm ALTER COLUMN id SET DEFAULT nextval('public.master_items_pm_id_seq'::regclass);


--
-- TOC entry 4741 (class 2604 OID 16547)
-- Name: master_products id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.master_products ALTER COLUMN id SET DEFAULT nextval('public.master_products_id_seq'::regclass);


--
-- TOC entry 4737 (class 2604 OID 16453)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 4904 (class 2606 OID 49166)
-- Name: activity_logs activity_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity_logs
    ADD CONSTRAINT activity_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 4873 (class 2606 OID 32788)
-- Name: diversifikasi_pm diversifikasi_pm_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.diversifikasi_pm
    ADD CONSTRAINT diversifikasi_pm_pkey PRIMARY KEY (id);


--
-- TOC entry 4871 (class 2606 OID 24663)
-- Name: diversifikasi_produk diversifikasi_produk_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.diversifikasi_produk
    ADD CONSTRAINT diversifikasi_produk_pkey PRIMARY KEY (id);


--
-- TOC entry 4894 (class 2606 OID 32826)
-- Name: diversifikasi_produk_pm diversifikasi_produk_pm_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.diversifikasi_produk_pm
    ADD CONSTRAINT diversifikasi_produk_pm_pkey PRIMARY KEY (id);


--
-- TOC entry 4862 (class 2606 OID 24627)
-- Name: diversifikasi_rm diversifikasi_rm_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.diversifikasi_rm
    ADD CONSTRAINT diversifikasi_rm_pkey PRIMARY KEY (id);


--
-- TOC entry 4844 (class 2606 OID 16448)
-- Name: master_items master_items_kode_item_manufacture_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.master_items
    ADD CONSTRAINT master_items_kode_item_manufacture_key UNIQUE (kode_item, manufacture);


--
-- TOC entry 4846 (class 2606 OID 16446)
-- Name: master_items master_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.master_items
    ADD CONSTRAINT master_items_pkey PRIMARY KEY (id);


--
-- TOC entry 4900 (class 2606 OID 32851)
-- Name: master_items_pm master_items_pm_kode_item_manufacture_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.master_items_pm
    ADD CONSTRAINT master_items_pm_kode_item_manufacture_key UNIQUE (kode_item, manufacture);


--
-- TOC entry 4902 (class 2606 OID 32849)
-- Name: master_items_pm master_items_pm_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.master_items_pm
    ADD CONSTRAINT master_items_pm_pkey PRIMARY KEY (id);


--
-- TOC entry 4858 (class 2606 OID 16553)
-- Name: master_products master_products_kode_item_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.master_products
    ADD CONSTRAINT master_products_kode_item_key UNIQUE (kode_produk);


--
-- TOC entry 4860 (class 2606 OID 16551)
-- Name: master_products master_products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.master_products
    ADD CONSTRAINT master_products_pkey PRIMARY KEY (id);


--
-- TOC entry 4913 (class 2606 OID 49287)
-- Name: nomor_pm_counter nomor_pm_counter_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nomor_pm_counter
    ADD CONSTRAINT nomor_pm_counter_pkey PRIMARY KEY (prefix);


--
-- TOC entry 4892 (class 2606 OID 49279)
-- Name: diversifikasi_pm uq_pm_nomor_revision; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.diversifikasi_pm
    ADD CONSTRAINT uq_pm_nomor_revision UNIQUE (nomor_pm, revision);


--
-- TOC entry 4853 (class 2606 OID 16462)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4855 (class 2606 OID 16460)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4905 (class 1259 OID 49168)
-- Name: idx_activity_logs_action; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_activity_logs_action ON public.activity_logs USING btree (action);


--
-- TOC entry 4906 (class 1259 OID 49267)
-- Name: idx_activity_logs_detail_trgm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_activity_logs_detail_trgm ON public.activity_logs USING gin (detail public.gin_trgm_ops);


--
-- TOC entry 4907 (class 1259 OID 49265)
-- Name: idx_activity_logs_division_trgm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_activity_logs_division_trgm ON public.activity_logs USING gin (division public.gin_trgm_ops);


--
-- TOC entry 4908 (class 1259 OID 49264)
-- Name: idx_activity_logs_name_trgm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_activity_logs_name_trgm ON public.activity_logs USING gin (name public.gin_trgm_ops);


--
-- TOC entry 4909 (class 1259 OID 49266)
-- Name: idx_activity_logs_no_data_trgm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_activity_logs_no_data_trgm ON public.activity_logs USING gin (no_data public.gin_trgm_ops);


--
-- TOC entry 4910 (class 1259 OID 49169)
-- Name: idx_activity_logs_table_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_activity_logs_table_name ON public.activity_logs USING btree (table_name);


--
-- TOC entry 4911 (class 1259 OID 49167)
-- Name: idx_activity_logs_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_activity_logs_time ON public.activity_logs USING btree ("time" DESC);


--
-- TOC entry 4874 (class 1259 OID 32834)
-- Name: idx_div_pm_created; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_div_pm_created ON public.diversifikasi_pm USING btree (created_at DESC);


--
-- TOC entry 4875 (class 1259 OID 32835)
-- Name: idx_div_pm_material; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_div_pm_material ON public.diversifikasi_pm USING btree (nama_material);


--
-- TOC entry 4876 (class 1259 OID 32832)
-- Name: idx_div_pm_nomor; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_div_pm_nomor ON public.diversifikasi_pm USING btree (nomor_pm);


--
-- TOC entry 4877 (class 1259 OID 32833)
-- Name: idx_div_pm_parent; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_div_pm_parent ON public.diversifikasi_pm USING btree (parent_id);


--
-- TOC entry 4895 (class 1259 OID 32836)
-- Name: idx_div_produk_pm_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_div_produk_pm_id ON public.diversifikasi_produk_pm USING btree (diversifikasi_pm_id);


--
-- TOC entry 4878 (class 1259 OID 40987)
-- Name: idx_diversifikasi_pm_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_diversifikasi_pm_deleted_at ON public.diversifikasi_pm USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4879 (class 1259 OID 49272)
-- Name: idx_diversifikasi_pm_list; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_diversifikasi_pm_list ON public.diversifikasi_pm USING btree (id DESC) WHERE ((deleted_at IS NULL) AND (parent_id IS NULL));


--
-- TOC entry 4880 (class 1259 OID 49273)
-- Name: idx_diversifikasi_pm_search; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_diversifikasi_pm_search ON public.diversifikasi_pm USING gin (nomor_pm public.gin_trgm_ops, kode_item public.gin_trgm_ops, nama_material public.gin_trgm_ops, manufacture public.gin_trgm_ops);


--
-- TOC entry 4863 (class 1259 OID 40986)
-- Name: idx_diversifikasi_rm_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_diversifikasi_rm_deleted_at ON public.diversifikasi_rm USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4842 (class 1259 OID 16466)
-- Name: idx_master_items_kode; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_master_items_kode ON public.master_items USING btree (kode_item);


--
-- TOC entry 4897 (class 1259 OID 32852)
-- Name: idx_master_items_pm_kode; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_master_items_pm_kode ON public.master_items_pm USING btree (kode_item);


--
-- TOC entry 4898 (class 1259 OID 32853)
-- Name: idx_master_items_pm_nama; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_master_items_pm_nama ON public.master_items_pm USING btree (nama_material);


--
-- TOC entry 4856 (class 1259 OID 16559)
-- Name: idx_master_products_kode; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_master_products_kode ON public.master_products USING btree (kode_produk);


--
-- TOC entry 4881 (class 1259 OID 57467)
-- Name: idx_pm_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pm_created_at ON public.diversifikasi_pm USING btree (created_at DESC);


--
-- TOC entry 4882 (class 1259 OID 49172)
-- Name: idx_pm_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pm_deleted_at ON public.diversifikasi_pm USING btree (deleted_at DESC) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4883 (class 1259 OID 49263)
-- Name: idx_pm_deleted_by_trgm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pm_deleted_by_trgm ON public.diversifikasi_pm USING gin (deleted_by public.gin_trgm_ops) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4884 (class 1259 OID 49260)
-- Name: idx_pm_kode_item_trgm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pm_kode_item_trgm ON public.diversifikasi_pm USING gin (kode_item public.gin_trgm_ops) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4885 (class 1259 OID 49262)
-- Name: idx_pm_manufacture_trgm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pm_manufacture_trgm ON public.diversifikasi_pm USING gin (manufacture public.gin_trgm_ops) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4886 (class 1259 OID 49261)
-- Name: idx_pm_nama_material_trgm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pm_nama_material_trgm ON public.diversifikasi_pm USING gin (nama_material public.gin_trgm_ops) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4887 (class 1259 OID 49259)
-- Name: idx_pm_nomor_pm_trgm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pm_nomor_pm_trgm ON public.diversifikasi_pm USING gin (nomor_pm public.gin_trgm_ops) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4888 (class 1259 OID 57465)
-- Name: idx_pm_search_kode; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pm_search_kode ON public.diversifikasi_pm USING btree (kode_item);


--
-- TOC entry 4889 (class 1259 OID 57464)
-- Name: idx_pm_search_nomor; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pm_search_nomor ON public.diversifikasi_pm USING btree (nomor_pm);


--
-- TOC entry 4890 (class 1259 OID 57466)
-- Name: idx_pm_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pm_status ON public.diversifikasi_pm USING btree (status_project);


--
-- TOC entry 4896 (class 1259 OID 57468)
-- Name: idx_produk_pm_parent; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_produk_pm_parent ON public.diversifikasi_produk_pm USING btree (diversifikasi_pm_id);


--
-- TOC entry 4864 (class 1259 OID 49171)
-- Name: idx_rm_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rm_deleted_at ON public.diversifikasi_rm USING btree (deleted_at DESC) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4865 (class 1259 OID 49258)
-- Name: idx_rm_deleted_by_trgm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rm_deleted_by_trgm ON public.diversifikasi_rm USING gin (deleted_by public.gin_trgm_ops) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4866 (class 1259 OID 49255)
-- Name: idx_rm_kode_item_trgm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rm_kode_item_trgm ON public.diversifikasi_rm USING gin (kode_item public.gin_trgm_ops) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4867 (class 1259 OID 49257)
-- Name: idx_rm_manufacture_trgm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rm_manufacture_trgm ON public.diversifikasi_rm USING gin (manufacture public.gin_trgm_ops) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4868 (class 1259 OID 49256)
-- Name: idx_rm_nama_material_trgm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rm_nama_material_trgm ON public.diversifikasi_rm USING gin (nama_material public.gin_trgm_ops) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4869 (class 1259 OID 49254)
-- Name: idx_rm_nomor_rm_trgm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rm_nomor_rm_trgm ON public.diversifikasi_rm USING gin (nomor_rm public.gin_trgm_ops) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4847 (class 1259 OID 49268)
-- Name: idx_users_division; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_division ON public.users USING btree (division);


--
-- TOC entry 4848 (class 1259 OID 49271)
-- Name: idx_users_division_trgm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_division_trgm ON public.users USING gin (division public.gin_trgm_ops);


--
-- TOC entry 4849 (class 1259 OID 49270)
-- Name: idx_users_email_trgm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_email_trgm ON public.users USING gin (email public.gin_trgm_ops);


--
-- TOC entry 4850 (class 1259 OID 49269)
-- Name: idx_users_name_trgm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_name_trgm ON public.users USING gin (name public.gin_trgm_ops);


--
-- TOC entry 4851 (class 1259 OID 49170)
-- Name: idx_users_refresh_token; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_refresh_token ON public.users USING btree (refresh_token) WHERE (refresh_token IS NOT NULL);


--
-- TOC entry 4921 (class 2620 OID 32837)
-- Name: diversifikasi_pm update_diversifikasi_pm_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_diversifikasi_pm_updated_at BEFORE UPDATE ON public.diversifikasi_pm FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4922 (class 2620 OID 32838)
-- Name: diversifikasi_produk_pm update_diversifikasi_produk_pm_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_diversifikasi_produk_pm_updated_at BEFORE UPDATE ON public.diversifikasi_produk_pm FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4923 (class 2620 OID 32854)
-- Name: master_items_pm update_master_items_pm_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_master_items_pm_updated_at BEFORE UPDATE ON public.master_items_pm FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4918 (class 2620 OID 16470)
-- Name: master_items update_master_items_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_master_items_updated_at BEFORE UPDATE ON public.master_items FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4920 (class 2620 OID 16562)
-- Name: master_products update_master_products_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_master_products_updated_at BEFORE UPDATE ON public.master_products FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4919 (class 2620 OID 16471)
-- Name: users update_users_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4916 (class 2606 OID 32789)
-- Name: diversifikasi_pm diversifikasi_pm_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.diversifikasi_pm
    ADD CONSTRAINT diversifikasi_pm_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.diversifikasi_pm(id) ON DELETE SET NULL;


--
-- TOC entry 4915 (class 2606 OID 24664)
-- Name: diversifikasi_produk diversifikasi_produk_diversifikasi_rm_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.diversifikasi_produk
    ADD CONSTRAINT diversifikasi_produk_diversifikasi_rm_id_fkey FOREIGN KEY (diversifikasi_rm_id) REFERENCES public.diversifikasi_rm(id) ON DELETE CASCADE;


--
-- TOC entry 4917 (class 2606 OID 32827)
-- Name: diversifikasi_produk_pm diversifikasi_produk_pm_diversifikasi_pm_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.diversifikasi_produk_pm
    ADD CONSTRAINT diversifikasi_produk_pm_diversifikasi_pm_id_fkey FOREIGN KEY (diversifikasi_pm_id) REFERENCES public.diversifikasi_pm(id) ON DELETE CASCADE;


--
-- TOC entry 4914 (class 2606 OID 24628)
-- Name: diversifikasi_rm diversifikasi_rm_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.diversifikasi_rm
    ADD CONSTRAINT diversifikasi_rm_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.diversifikasi_rm(id) ON DELETE SET NULL;


-- Completed on 2026-05-18 09:10:58

--
-- PostgreSQL database dump complete
--

\unrestrict tp4s7CtW0c4hmCtuCotrLWQlfdstTH0Djt7tS4jkHUHMKCtcNpsvPPVVQcAx2bb

