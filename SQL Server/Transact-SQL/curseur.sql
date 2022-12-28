/*
 * **************						Les curseurs										****************
 	Les curseurs sont des objects permettant de parcourir les tableaux, c'est leur principale interet. Prenons le 
 	language SQL, comme son nom l'indique son objectif est d'envoye des requetes a la base de donnees et recupere
 	les resultats, ces resultats peuvent etre sous fomre de table. Dans certain situation, on aimerait effectue des
 	operation speciales sur chacune des ligne de la table retourne, la porte de SQL n'atteint pas la, donc en ceci 
 	est important les curseur, il nous permette de parcourir les tables ligne par ligne.
 	
 	 Il y a plusieur type de curseur chacun a son importance selon l'application
 	 les curseurs statique : Affiche les enregistrements 
 	 les curseurs Forward_only : On peux facilement deviner son role. Il parcous une table dans une seule sens
 	 les curseur keyset : Ils sont controlé par des clés ou des identifiant unique 
 	 les curseur dynamique
 	 
 	 									Les etapes d'utilisations des curseurs 
 	 les curseurs sont utilisé de cette manière :
 	 	Declaration du curseur : ce reserve une espace pour le curseur a etre utilisé car ceux-ci sont des variable
 	 	ouveriteur du curseur 
 	 	usage du curseur
 	 	fermeture du curseur
 	 	suppression de l'espace alloué au curseur
 * */

create database Curs;
use Curs;

CREATE TABLE Produit(
num_prod int  Primary key,
libelle varchar(20),
pu_prod int,
qte_stock int ,
s_min int ,
s_max int 
);

create table Commande(
num_cmd int Primary Key,
date_cmd date ,
);

CREATE TABLE Ligne_Commande(
num_prod int foreign key (num_prod) references Produit(num_prod),
num_cmd int foreign key (num_cmd) references Commande(num_cmd),
qte_cmdee int ,
Primary Key(num_prod,num_cmd)
);

INSERT into Produit(num_prod, libelle, pu_prod, qte_stock, s_min, s_max) VALUES (1, N'produit7', 10000, 8, 5, 50);
INSERT into Produit(num_prod, libelle, pu_prod, qte_stock, s_min, s_max) VALUES (2, N'produit8', 100000, 8, 5, 50);
INSERT into Produit(num_prod, libelle, pu_prod, qte_stock, s_min, s_max) VALUES (3, N'produit9', 1000, 8, 5, 50);
INSERT into Produit(num_prod, libelle, pu_prod, qte_stock, s_min, s_max) VALUES (4, N'produit10', 60, 8, 5, 50);
INSERT into Produit(num_prod, libelle, pu_prod, qte_stock, s_min, s_max) VALUES (5, N'produit11', 68, 8, 4, 52);
INSERT into Produit(num_prod, libelle, pu_prod, qte_stock, s_min, s_max) VALUES (6, N'produit12', 70, 18, 5, 25);

INSERT into commande (num_cmd, date_cmd) VALUES (7, '2017-01-02');
INSERT into commande (num_cmd, date_cmd) VALUES (8, '2017-03-10');
INSERT into commande (num_cmd, date_cmd) VALUES (9, '2017-12-01');
INSERT into commande (num_cmd, date_cmd) VALUES (10, '2017-12-12');
INSERT into commande (num_cmd, date_cmd) VALUES (11, '2017-01-03');
INSERT into commande (num_cmd, date_cmd) VALUES (12, '2017-03-30');

INSERT into ligne_commande (num_prod, num_cmd, qte_cmdee) VALUES (1, 7, 20);
INSERT into ligne_commande (num_prod, num_cmd, qte_cmdee) VALUES (2, 8, 55);
INSERT into ligne_commande (num_prod, num_cmd, qte_cmdee) VALUES (3, 9, 26);
INSERT into ligne_commande (num_prod, num_cmd, qte_cmdee) VALUES (4, 10, 22);
INSERT into ligne_commande (num_prod, num_cmd, qte_cmdee) VALUES (5, 11, 20);
INSERT into ligne_commande (num_prod, num_cmd, qte_cmdee) VALUES (6, 12, 1);

/* creation du curseur du la table ligne de commande */

Declare @a int, @b datetime, @c decimal
Declare C1 cursor for select C.num_cmd, date_cmd, sum(pu_prod*qte_cmdee)
From Commande C, Produit P, Ligne_Commande LC
WHERE C.num_cmd = LC.num_cmd and LC.num_prod = P.num_prod group by C.num_cmd, date_cmd

OPEN C1
Fetch Next from C1 into @a,@b,@c 
While @@fetch_status = 0 
		Begin
		 Print 'Commande N° : ' + convert(varchar,@a) + ' effectuée le : ' + convert(varchar,@b) 
		 Select num_prod from ligne_commande where num_cmd=@a 
		 Print 'Son montant est : ' + convert(varchar,@c) 
		 Fetch Next from C1 into @a,@b,@c 
		 End 

Close C1 
Deallocate C1

select * FROM  dbo.Ligne_Commande;

