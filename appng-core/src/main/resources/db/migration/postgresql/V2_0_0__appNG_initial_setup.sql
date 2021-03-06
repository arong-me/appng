create table application (
 id int4 generated by default as identity,
 appng_version varchar(64),
 application_version varchar(64),
 description varchar(8192),
 displayName varchar(64),
 fileBased boolean not null,
 hidden boolean not null,
 longDescription text,
 name varchar(255),
 privileged boolean,
 snapshot boolean not null,
 time_stamp varchar(64),
 version timestamp,
 primary key (id)
);

create table authgroup (
 id int4 generated by default as identity,
 default_admin boolean,
 description varchar(8192),
 name varchar(255),
 version timestamp,
 primary key (id)
);

create table authgroup_role (
 authgroup_id int4 not null,
 role_id int4 not null,
 primary key (authgroup_id, role_id)
);

create table database_connection (
 id int4 generated by default as identity,
 active boolean not null,
 description varchar(255),
 driver_class varchar(255),
 jdbc_url varchar(255),
 managed boolean not null,
 max_connections int4,
 min_connections int4,
 name varchar(255),
 password oid,
 type varchar(255),
 username varchar(255),
 validation_query varchar(255),
 version timestamp,
 site_id int4,
 primary key (id)
);

create table permission (
 id int4 generated by default as identity,
 description varchar(8192),
 name varchar(255),
 version timestamp,
 application_id int4,
 primary key (id)
);

create table platform_event (
 id int4 generated by default as identity,
 application varchar(255),
 context varchar(255),
 created timestamp,
 event varchar(255),
 hostName varchar(255),
 origin varchar(255),
 requestId varchar(255),
 sessionId varchar(255),
 ev_type varchar(255),
 ev_user varchar(255),
 primary key (id)
);

create table property (
 name varchar(255) not null,
 value varchar(255),
 blobValue oid,
 clobValue text,
 defaultValue varchar(255),
 description varchar(1024),
 mandatory boolean not null,
 version timestamp,
 primary key (name)
);

create table repository (
 id int4 generated by default as identity,
 accepted_certs oid,
 active boolean not null,
 description varchar(8192),
 digest varchar(255),
 name varchar(255),
 published boolean not null,
 remote_repository_name varchar(64),
 mode varchar(255),
 type varchar(255),
 strict boolean not null,
 uri bytea,
 version timestamp,
 primary key (id)
);

create table resource (
 id int4 generated by default as identity,
 bytes oid,
 checksum varchar(255),
 description varchar(8192),
 name varchar(255),
 type varchar(255),
 version timestamp,
 application_id int4,
 primary key (id)
);

create table role (
 id int4 generated by default as identity,
 description varchar(8192),
 name varchar(255),
 version timestamp,
 application_id int4,
 primary key (id)
);


create table role_permission (
 role_id int4 not null,
 permissions_id int4 not null,
 primary key (role_id, permissions_id)
);


create table site (
 id int4 generated by default as identity,
 active boolean not null,
 create_repository boolean,
 description varchar(8192),
 domain varchar(255),
 host varchar(255),
 name varchar(255),
 version timestamp,
 primary key (id)
);

create table site_application (
 application_id int4 not null,
 site_id int4 not null,
 active boolean not null,
 deletion_mark boolean,
 reload_required boolean,
 connection_id int4,
 primary key (application_id, site_id)
);

create table sites_granted (
 application_id int4 not null,
 site_id int4 not null,
 granted_site_id int4 not null,
 primary key (application_id, site_id, granted_site_id)
);

create table subject (
 id int4 generated by default as identity,
 description varchar(8192),
 digest varchar(255),
 email varchar(255),
 language varchar(255),
 name varchar(255),
 realname varchar(255),
 salt varchar(255),
 timezone varchar(255),
 type varchar(255),
 version timestamp,
 primary key (id)
);

create table subject_authgroup (
 subject_Id int4 not null,
 group_id int4 not null
);

create table template (
 id int4 generated by default as identity,
 appng_version varchar(255),
 description varchar(255),
 displayName varchar(255),
 long_desc varchar(255),
 name varchar(255),
 template_version varchar(255),
 timestamp varchar(255),
 tpl_type varchar(255),
 version timestamp,
 primary key (id)
);

create table template_resource (
 id int4 generated by default as identity,
 bytes oid,
 checksum varchar(255),
 file_version timestamp,
 name varchar(255),
 version timestamp,
 template_id int4,
 primary key (id)
);

alter table application 
add constraint UK_lspnba25gpku3nx3oecprrx8c unique (name);

alter table authgroup 
add constraint UK_hng9ojpn9gcumrchsw1gqwpa3 unique (name);

alter table repository 
add constraint UK_pbnisjkw01y5ole425crs0ra6 unique (name);

alter table site 
add constraint UK_qsgk5cjl6wt1xvhdeqymoymqb unique (domain);

alter table site 
add constraint UK_nnbksm3ee42ted5jwjv82ld8 unique (host);

alter table site 
add constraint UK_f9iil6uu8d9ohutpr2irlpvio unique (name);

alter table subject 
add constraint UK_p1jgir6qcpmqnxt4a8105wsot unique (name);

alter table authgroup_role 
add constraint FKb9vanycq8blatrv0cygmo4ys 
foreign key (role_id) 
references role;

alter table authgroup_role 
add constraint FKrcn022l06aob7yh4i0pocmyfw 
foreign key (authgroup_id) 
references authgroup;

alter table database_connection 
add constraint FK2nc6v72wsqqkm08g6esvl56qa 
foreign key (site_id) 
references site;

alter table permission 
add constraint FKqx6yod2u5o379ea6ilb9320pf 
foreign key (application_id) 
references application;

alter table resource 
add constraint FKao8gqbsc5pjonvob97v06wdfh 
foreign key (application_id) 
references application;

alter table role 
add constraint FK2n86cvour8hpl69i8t5qq139u 
foreign key (application_id) 
references application;

alter table role_permission 
add constraint FKsidab0lpqi82o4o15bwde2c5f 
foreign key (permissions_id) 
references permission;

alter table role_permission 
add constraint FKa6jx8n8xkesmjmv6jqug6bg68 
foreign key (role_id) 
references role;

alter table site_application 
add constraint FKfidgrdtxu15bc7fakr83aln2d 
foreign key (application_id) 
references application;

alter table site_application 
add constraint FKqd6qo05h21mxnh9xw8piia2sv 
foreign key (connection_id) 
references database_connection;

alter table site_application 
add constraint FK471twt4o8anj8n4pic9r2c3ld 
foreign key (site_id) 
references site;

alter table sites_granted 
add constraint FKbmo1w3an2hajxekhl31138r9i 
foreign key (granted_site_id) 
references site;

alter table sites_granted 
add constraint FK70e3j7mp3imtb4x5llus087hh 
foreign key (application_id, site_id) 
references site_application;

alter table subject_authgroup 
add constraint FK1h3gxc3kkurxb2ywgd8lsiygg 
foreign key (group_id) 
references authgroup;

alter table subject_authgroup 
add constraint FKo4thj02w2sqac23qqgnauygej 
foreign key (subject_Id) 
references subject;

alter table template_resource 
add constraint FK__TEMPLATE_RESOURCE__TEMPLATE_ID 
foreign key (template_id) 
references template;

insert into authgroup (name,description,default_admin,version) values ('Administrators','appNG Administrators group',true,now());

