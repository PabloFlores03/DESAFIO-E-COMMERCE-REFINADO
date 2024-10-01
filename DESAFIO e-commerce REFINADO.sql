-- DESAFIO E-commerce 

create database ecommerce;
use ecommerce;

-- criar tabela cliente
create table clients(
		idClient int auto_increment primary key,
        Fname varchar(10),
        Minit char(3),
        Lname varchar(20),
        CPF char(11) not null,
        Address varchar(255),
        constraint unique_cpf_client unique (CPF)
);

alter table clients auto_increment=1;

-- size = dimensão do produto
create table product(
		idProduct int auto_increment primary key,
        Pname varchar(255) not null,
        classification_kids bool default false,
        category enum('Eletrônico','Vestimenta','Brinquedos','Alimentos','Móveis') not null,
        avaliação float default 0,
        size varchar(10)
);

alter table product auto_increment=1;

-- para ser continuado no desafio: termine de implementar a tabela e crie a conexão com as tabelas necessárias
-- além disso, reflita essa modificação no diagrama de esquema relacional
-- criar constraints relacionadas ao pagamento
	-- Adicionada a constraint 
    
create table payments(
	idclient int,
    idPayment int,
    typePayment enum('Boleto','Cartão','Dois cartões'),
    limitAvailable float,
    primary key(idClient, idPayment)
);
alter table payments
	add constraint fk_payments foreign key (idPayment) references clients(idClient);

Desc payments;
Desc clients;

-- criar tabela pedido
-- drop table orders;
create table orders(
	idOrder int auto_increment primary key,
    idOrderClient int,
    orderStatus enum('Cancelado','Confirmado','Em processamento') default 'Em processamento',
    orderDescription varchar(255),
    sendValue float default 10,
    paymentCash boolean default false, 
    constraint fk_ordes_client foreign key (idOrderClient) references clients(idClient)
			on update cascade
);
alter table orders auto_increment=1;

desc orders;

-- criar tabela estoque
create table productStorage(
	idProdStorage int auto_increment primary key,
    storageLocation varchar(255),
    quantity int default 0
);
alter table productStorage auto_increment=1;


-- criar tabela fornecedor
create table supplier(
	idSupplier int auto_increment primary key,
    SocialName varchar(255) not null,
    CNPJ char(15) not null,
    contact char(11) not null,
    constraint unique_supplier unique (CNPJ)
);
alter table supplier auto_increment=1;

desc supplier;

-- criar tabela vendedor
create table seller(
	idSeller int auto_increment primary key,
    SocialName varchar(255) not null,
    AbstName varchar(255),
    CNPJ char(15),
    CPF char(9),
    location varchar(255),
    contact char(11) not null,
    constraint unique_cnpj_seller unique (CNPJ),
    constraint unique_cpf_seller unique (CPF)
);

alter table seller auto_increment=1;


-- tabelas de relacionamentos M:N

create table productSeller(
	idPseller int,
    idPproduct int,
    prodQuantity int default 1,
    primary key (idPseller, idPproduct),
    constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
    constraint fk_product_product foreign key (idPproduct) references product(idProduct)
);

desc productSeller;

create table productOrder(
	idPOproduct int,
    idPOorder int,
    poQuantity int default 1,
    poStatus enum('Disponível', 'Sem estoque') default 'Disponível',
    primary key (idPOproduct, idPOorder),
    constraint fk_productorder_product foreign key (idPOproduct) references product(idProduct),
    constraint fk_productorder_order foreign key (idPOorder) references orders(idOrder)

);

create table storageLocation(
	idLproduct int,
    idLstorage int,
    location varchar(255) not null,
    primary key (idLproduct, idLstorage),
    constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct),
    constraint fk_storage_location_storage foreign key (idLstorage) references productStorage(idProdStorage)
);

create table productSupplier(
	idPsSupplier int,
    idPsProduct int,
    quantity int not null,
    primary key (idPsSupplier, idPsProduct),
    constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier(idSupplier),
    constraint fk_product_supplier_prodcut foreign key (idPsProduct) references product(idProduct)
);

desc productSupplier;
use information_schema;
desc referential_constraints;
select * from referential_constraints where constraint_schema = 'ecommerce';


-- inserção de dados e queries
use ecommerce;

show tables;
-- idClient, Fname, Minit, Lname, CPF, Address
insert into Clients (Fname, Minit, Lname, CPF, Address) 
	   values('Maria','M','Silva', 12346789, 'rua silva de prata 29, Carangola - Cidade das flores'),
		     ('Matheus','O','Pimentel', 987654321,'rua alemeda 289, Centro - Cidade das flores'),
			 ('Ricardo','F','Silva', 45678913,'avenida alemeda vinha 1009, Centro - Cidade das flores'),
			 ('Julia','S','França', 789123456,'rua lareijras 861, Centro - Cidade das flores'),
			 ('Roberta','G','Assis', 98745631,'avenidade koller 19, Centro - Cidade das flores'),
			 ('Isabela','M','Cruz', 654789123,'rua alemeda das flores 28, Centro - Cidade das flores');


-- idProduct, Pname, classification_kids boolean, category('Eletrônico','Vestimenta','Brinquedos','Alimentos','Móveis'), avaliação, size
insert into product (Pname, classification_kids, category, avaliação, size) values
							  ('Fone de ouvido',false,'Eletrônico','4',null),
                              ('Barbie Elsa',true,'Brinquedos','3',null),
                              ('Body Carters',true,'Vestimenta','5',null),
                              ('Microfone Vedo - Youtuber',False,'Eletrônico','4',null),
                              ('Sofá retrátil',False,'Móveis','3','3x57x80'),
                              ('Farinha de arroz',False,'Alimentos','2',null),
                              ('Fire Stick Amazon',False,'Eletrônico','3',null);

select * from clients;
select * from product;
-- idOrder, idOrderClient, orderStatus, orderDescription, sendValue, paymentCash

delete from orders where idOrderClient in  (1,2,3,4);
insert into orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash) values 
							 (1, default,'compra via aplicativo',null,1),
                             (2,default,'compra via aplicativo',50,0),
                             (3,'Confirmado',null,null,1),
                             (4,default,'compra via web site',150,0);

-- idPOproduct, idPOorder, poQuantity, poStatus
select * from orders;
insert into productOrder (idPOproduct, idPOorder, poQuantity, poStatus) values
						 (1,1,2,null),
                         (2,1,1,null),
                         (3,2,1,null);

-- storageLocation,quantity
insert into productStorage (storageLocation,quantity) values 
							('Rio de Janeiro',1000),
                            ('Rio de Janeiro',500),
                            ('São Paulo',10),
                            ('São Paulo',100),
                            ('São Paulo',10),
                            ('Brasília',60);

-- idLproduct, idLstorage, location
insert into storageLocation (idLproduct, idLstorage, location) values
						 (1,2,'RJ'),
                         (2,6,'GO');

-- idSupplier, SocialName, CNPJ, contact
insert into supplier (SocialName, CNPJ, contact) values 
							('Almeida e filhos', 123456789123456,'21985474'),
                            ('Eletrônicos Silva',854519649143457,'21985484'),
                            ('Eletrônicos Valma', 934567893934695,'21975474');
                            
select * from supplier;
-- idPsSupplier, idPsProduct, quantity
insert into productSupplier (idPsSupplier, idPsProduct, quantity) values
						 (1,1,500),
                         (1,2,400),
                         (2,4,633),
                         (3,3,5),
                         (2,5,10);

-- idSeller, SocialName, AbstName, CNPJ, CPF, location, contact
insert into seller (SocialName, AbstName, CNPJ, CPF, location, contact) values 
						('Tech eletronics', null, 123456789456321, null, 'Rio de Janeiro', 219946287),
					    ('Botique Durgas',null,null,123456783,'Rio de Janeiro', 219567895),
						('Kids World',null,456789123654485,null,'São Paulo', 1198657484);

select * from seller;
-- idPseller, idPproduct, prodQuantity
insert into productSeller (idPseller, idPproduct, prodQuantity) values 
						 (1,6,80),
                         (2,7,10);

select * from productSeller;

select count(*) from clients;
select * from clients c, orders o where c.idClient = idOrderClient;

-- especificando os atributos recuperados --
select Fname,Lname, idOrder, orderStatus from clients c, orders o where c.idClient = idOrderClient;

-- pra deixar a query de cima mais visual, podemos concatenar -- 
select concat(Fname,' ',Lname) as Client, idOrder as Request, orderStatus as Status from clients c, orders o where c.idClient = idOrderClient;

insert into orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash) values 
							 (2, default,'compra via aplicativo',null,1);
                             
select count(*) from clients c, orders o 
			where c.idClient = idOrderClient;


-- recuperação de pedido com produto associado
select * from clients c inner join orders o ON c.idClient = o.idOrderClient
                inner join productOrder p on p.idPOorder = o.idOrder;
        
-- Recuperar quantos pedidos foram realizados pelos clientes?
select c.idClient, Fname, count(*) as Number_of_orders 
	from clients c 
		inner join orders o 
			ON c.idClient = o.idOrderClient
	group by idClient; 


-- recuperação de pedido com produto associado
Select * from clients c
	inner join orders o
		on c.idClient = o.idOrderClient 
	inner join productOrder p 
		on p.idPOorder = o.idOrder;


-- ABAIXO TABELAS CRIADAS E DADOS PERSISTIDOS -- 
-- Cliente PJ -- 
create table clientsPJ(
		idClientPJ int auto_increment primary key,
        SocialnamePJ varchar(100),
        CNPJ_PJ char(14) not null,
        AddressPJ varchar(255),
        phonePJ varchar(45),
        constraint unique_cnpj_clientsPJ unique (CNPJ_PJ)
);

insert into clientsPJ (SocialnamePJ, CNPJ_PJ, AddressPJ, phonePJ) values 
						('Tech eletronics Brasil', 12345670000102, 'AV quatro Bairro Mathias Velho Canoas RS', 5134666851),
					    ('Botique Durgas Brasil',12345670000103, 'AV Dois Bairro Mathias Velho Canoas RS', 5134666852),
						('Kids World Brasil',12345670000104, 'AV tres Bairro Mathias Velho Canoas RS', 5134666853);


-- Pode ser Pessoa Juridica -- 
create table PSPessoaJuridica(
	idPJClient_Cliente int,
    idPJClientePJ int,
    primary key (idPJClient_Cliente, idPJClientePJ),
    constraint fk_PSPessoa_Juridica foreign key (idPJClient_Cliente) references clients(idClient),
    constraint fk_pj_clientsPJ foreign key (idPJClientePJ) references clientsPJ(idClientPJ)
);
insert into PSPessoaJuridica (idPJClient_Cliente, idPJClientePJ) values
						 (1,1),
                         (2,2),
                         (3,3);                      
                         
-- Cliente PF --
create table clientsPF(
		idClientPF int auto_increment primary key,
        namePF varchar(65),
        CPFPF char(11) not null,
        AddressPF varchar(255),
        PhonePF varchar(45),
        constraint unique_cpfPF_clientsPF unique (CPFPF)
);
insert into clientsPF (namePF, CPFPF, AddressPF, PhonePF) values 
						('Cristiane Flores', 83554190065, 'AV dez Bairro Mathias Velho Canoas RS', 5134668574),
					    ('Juliana Peruca',83554190170, 'AV onze Bairro Mathias Velho Canoas RS', 5134668744),
						('Jandira Flores',83541855542, 'AV cinco Bairro Mathias Velho Canoas RS', 5134669942);

 -- Pode Ser Pessoa Física --
create table PSPessoaFisica(
	idPFClient_Cliente int,
    idPFClientePF int,
    primary key (idPFClient_Cliente, idPFClientePF),
    constraint fk_PSpessoa_Fisica foreign key (idPFClient_Cliente) references clients(idClient),
    constraint fk_pf_clientsPF foreign key (idPFClientePF) references clientsPF(idClientPF)
);
insert into PSPessoaFisica (idPFClient_Cliente, idPFClientePF) values
						 (1,1),
                         (2,2),
                         (3,3);   

-- Entrega --
create table Delivery(
	idDelivery int,
    StatusDelivery ENUM('entregue', 'pendente'),
    primary key (idDelivery),
    constraint fk_delivery_PF foreign key (idDelivery) references clientsPF(idClientPF),
    constraint fk_delivery_PJ foreign key (idDelivery) references clientsPJ(idClientPJ)
);
insert into Delivery (idDelivery, StatusDelivery) values 
							 (1,'entregue'),
                             (2,'entregue'),
                             (3,'pendente');
alter table Delivery
	add Tracking_Code VARCHAR(35);
  
  
-- ABAIXO QUERIES CRIADAS APÓS A INSERÇÃO DAS NOVAS TABELAS E DADOS -- 		
show tables;
Desc Delivery;
Desc clientsPF;

Select * from Delivery;

-- Todos as entregas para PF 
Select * from Delivery
	inner join clientsPF
		where idDelivery = idClientPF;
        
-- Somente pedidos PF "pendentes"       
Select * from Delivery
	inner join clientsPF
		where idDelivery = idClientPF
        and StatusDelivery = 'pendente';
  
-- Somente Status de entrega e ordenado por nome social
Select d.StatusDelivery, pj.SocialnamePJ
	from Delivery d
		inner join clientsPJ pj
			on d.idDelivery = pj.idClientPJ
            order by SocialnamePJ;
                        
Desc clients; 
Desc orders;
Select * from clients;

-- Trazer clientes e pedidos
  Select c.Fname, o.idOrderClient  
	from clients c
		inner join orders o
    on c.idClient = o.idOrderClient;
    
-- Quais cliente tem mais de um pedido ?     
Select c.Fname, o.idOrderClient
	from clients c
		inner join orders o
    on c.idClient = o.idOrderClient
    Group by idOrderClient 
    Having Count(*) > 1;
    
 
    
-- Objetivo:
                -- [Relembrando] Aplique o mapeamento para o  cenário:
					'Mapeamento aplicado'
                -- “Refine o modelo apresentado acrescentando os seguintes pontos”
					'Refinamento realizado'
                -- Cliente PJ e PF – Uma conta pode ser PJ ou PF, mas não pode ter as duas informações;
					'Adicionado as tabelas clientsPJ e clientsPF'
				-- Pagamento – Pode ter cadastrado mais de uma forma de pagamento;
					'ok'
				-- Entrega – Possui status e código de rastreio;
					'Adicionado status e código de rastreio'

